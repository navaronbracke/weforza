package be.weforza.app

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodChannel

/**
 * This class represents the Bluetooth adapter implementation.
 */
class BluetoothAdapterDelegate(
    private val bluetoothAdapter: BluetoothAdapter?,
    val stateStreamHandler: BluetoothAdapterStateStreamHandler) {

    val deviceDiscoveryStreamHandler = BluetoothDeviceDiscoveryStreamHandler()

    /**
     * The Bluetooth scan callback for the running scan.
     * If this is not null, a scan is in progress.
     */
    private var bluetoothScanCallback: ScanCallback? = null

    companion object {
        const val BLUETOOTH_SCAN_RESULT_ERROR_CODE = "BLUETOOTH_SCAN_RESULT_ERROR"
        const val BLUETOOTH_SCAN_RESULT_ERROR_MESSAGE = "A scan result returned an error."

        const val BLUETOOTH_UNAUTHORIZED_ERROR_CODE = "BLUETOOTH_UNAUTHORIZED"
        const val BLUETOOTH_UNAUTHORIZED_ERROR_MESSAGE = "Access to Bluetooth was denied."

        const val BLUETOOTH_UNAVAILABLE_ERROR_CODE = "BLUETOOTH_UNAVAILABLE"
        const val BLUETOOTH_UNAVAILABLE_ERROR_MESSAGE = "Bluetooth is not supported on this device."
    }

    private fun buildBluetoothScanSettings(options: BluetoothScanOptions) : ScanSettings {
        val scanModes = mutableSetOf(
            ScanSettings.SCAN_MODE_BALANCED,
            ScanSettings.SCAN_MODE_LOW_LATENCY,
            ScanSettings.SCAN_MODE_LOW_POWER,
        )

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            scanModes.add(ScanSettings.SCAN_MODE_OPPORTUNISTIC)
        }

        val scanMode = if(scanModes.contains(options.scanMode)) {
            options.scanMode
        } else {
            ScanSettings.SCAN_MODE_BALANCED
        }

        var scanSettingsBuilder = ScanSettings.Builder().setScanMode(scanMode)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            scanSettingsBuilder = scanSettingsBuilder.setPhy(ScanSettings.PHY_LE_ALL_SUPPORTED)
                .setLegacy(false)
        }

        return scanSettingsBuilder.build()
    }

    /**
     * Get the current state of the Bluetooth adapter.
     */
    fun getState(result: MethodChannel.Result) {
        if(bluetoothAdapter == null) {
            result.success("unavailable")
            return
        }

        try {
            when(bluetoothAdapter.state) {
                BluetoothAdapter.STATE_OFF -> result.success("off")
                BluetoothAdapter.STATE_ON -> result.success("on")
                BluetoothAdapter.STATE_TURNING_OFF -> result.success("turningOff")
                BluetoothAdapter.STATE_TURNING_ON -> result.success("turningOn")
                else -> result.success("unknown")
            }
        } catch (exception: SecurityException) {
            result.success("unauthorized")
        }
    }

    /**
     * Check if Bluetooth is currently on.
     *
     * Returns true if Bluetooth is currently on.
     * Returns false if Bluetooth is currently off.
     * Returns null otherwise.
     */
    fun isBluetoothOn(result: MethodChannel.Result) {
        if(bluetoothAdapter == null) {
            result.error(BLUETOOTH_UNAVAILABLE_ERROR_CODE, BLUETOOTH_UNAVAILABLE_ERROR_MESSAGE, null)
            return
        }

        try {
            when(bluetoothAdapter.state) {
                BluetoothAdapter.STATE_OFF -> result.success(false)
                BluetoothAdapter.STATE_ON -> result.success(true)
                // Set the pending result if the state is indeterminate.
                BluetoothAdapter.STATE_TURNING_OFF -> stateStreamHandler.setPendingBluetoothStateResult(result)
                BluetoothAdapter.STATE_TURNING_ON -> stateStreamHandler.setPendingBluetoothStateResult(result)
            }
        } catch (exception: SecurityException) {
            result.error(BLUETOOTH_UNAUTHORIZED_ERROR_CODE, BLUETOOTH_UNAUTHORIZED_ERROR_MESSAGE, null)
        }
    }

    /**
     * Start a new Bluetooth scan.
     */
    fun startBluetoothScan(options: BluetoothScanOptions, result: MethodChannel.Result, context: Context) {
        if(bluetoothAdapter == null) {
            result.error(BLUETOOTH_UNAVAILABLE_ERROR_CODE, BLUETOOTH_UNAVAILABLE_ERROR_MESSAGE, null)
            return
        }

        if(bluetoothScanCallback != null) {
            result.success(null)
            return
        }

        val hasScanPermission = if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.BLUETOOTH_SCAN
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            true
        }

        if(hasScanPermission) {
            bluetoothScanCallback = BluetoothScanCallback(deviceDiscoveryStreamHandler::onDeviceFound)

            val filters = listOf<ScanFilter>()

            bluetoothAdapter.bluetoothLeScanner.startScan(filters, buildBluetoothScanSettings(options), bluetoothScanCallback)
            result.success(null)
        } else {
            result.error(BLUETOOTH_UNAUTHORIZED_ERROR_CODE, BLUETOOTH_UNAUTHORIZED_ERROR_MESSAGE, null)
        }
    }

    /**
     * Stop a running Bluetooth device scan.
     */
    fun stopBluetoothScan(result: MethodChannel.Result, context: Context) {
        if(bluetoothAdapter == null) {
            result.error(BLUETOOTH_UNAVAILABLE_ERROR_CODE, BLUETOOTH_UNAVAILABLE_ERROR_MESSAGE, null)
            return
        }

        val bluetoothScanner = bluetoothAdapter.bluetoothLeScanner

        if(bluetoothScanCallback == null) {
            result.success(null)
            return
        }

        // Permission should be granted at this point, since the scan already started.
        // This is just a sanity check to silence the hint for bluetoothScanner.stopScan().
        val hasScanPermission = if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.BLUETOOTH_SCAN
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            true
        }

        if(hasScanPermission) {
            bluetoothScanner.stopScan(bluetoothScanCallback)
            bluetoothScanCallback = null // Clean up the old scan callback along with its settings.
            result.success(null)
        } else {
            result.error(BLUETOOTH_UNAUTHORIZED_ERROR_CODE, BLUETOOTH_UNAUTHORIZED_ERROR_MESSAGE, null)
        }
    }
}

/**
 * This class represents the Bluetooth adapter state change stream handler.
 */
class BluetoothAdapterStateStreamHandler : StreamHandler {
    /**
     * The pending Bluetooth on/off state result.
     *
     * This result is cached when the Bluetooth on/off state is queried on-demand
     * and the state is either [BluetoothAdapter.STATE_TURNING_OFF]
     * or [BluetoothAdapter.STATE_TURNING_ON].
     *
     * It will be resolved with a boolean once [BluetoothAdapter.STATE_ON]
     * or [BluetoothAdapter.STATE_OFF] is the current state.
     * Only one pending Bluetooth state result result can be active at once.
     */
    private var pendingBluetoothIsOnOrOffResult : MethodChannel.Result? = null

    /**
     * The event sink that collects the Bluetooth adapter's state changes.
     */
    private var sink: EventChannel.EventSink? = null

    fun onStateChanged(state: Int) {
        when(state) {
            // Resolve the pending state result if needed.
            BluetoothAdapter.STATE_OFF -> {
                sink?.success("off")
                if(pendingBluetoothIsOnOrOffResult != null) {
                    pendingBluetoothIsOnOrOffResult?.success(false)
                    pendingBluetoothIsOnOrOffResult = null
                }
            }
            BluetoothAdapter.STATE_ON -> {
                sink?.success("on")
                if(pendingBluetoothIsOnOrOffResult != null) {
                    pendingBluetoothIsOnOrOffResult?.success(true)
                    pendingBluetoothIsOnOrOffResult = null
                }
            }
            BluetoothAdapter.STATE_TURNING_OFF -> sink?.success("turningOff")
            BluetoothAdapter.STATE_TURNING_ON -> sink?.success("turningOn")
            else -> sink?.success("unknown")
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }

    /**
     * Set the pending Bluetooth state result.
     */
    fun setPendingBluetoothStateResult(result: MethodChannel.Result) {
        if(pendingBluetoothIsOnOrOffResult == null) {
            pendingBluetoothIsOnOrOffResult = result
        }
    }
}

/**
 * This class represents the BroadcastReceiver for Bluetooth state changes.
 */
class BluetoothAdapterStateBroadcastReceiver(private val onStateChanged: (state: Int) -> Unit) : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if(intent == null || !intent.action.equals(BluetoothAdapter.ACTION_STATE_CHANGED)) {
            return
        }

        val bluetoothAdapterState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE,
            BluetoothAdapter.ERROR)

        onStateChanged(bluetoothAdapterState)
    }
}

/**
 * This class represents the Bluetooth device discovery stream handler.
 */
class BluetoothDeviceDiscoveryStreamHandler : StreamHandler {
    private var sink: EventChannel.EventSink? = null

    fun onDeviceFound(bluetoothDevice: BluetoothDevice) {
        try {
            sink?.success(mapOf(
                "deviceName" to bluetoothDevice.name,
                "deviceId" to bluetoothDevice.address
            ))
        } catch (exception: SecurityException) {
            // If Bluetooth permission is not granted, skip the scan results.
            sink?.error(
                BluetoothAdapterDelegate.BLUETOOTH_SCAN_RESULT_ERROR_CODE,
                exception.message?: BluetoothAdapterDelegate.BLUETOOTH_SCAN_RESULT_ERROR_MESSAGE,
                null)
        }
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }
}

/**
 * This class represents the Bluetooth scan callback for a Bluetooth scan.
 */
private class BluetoothScanCallback(
    private val onDeviceFound: (device: BluetoothDevice) -> Unit) : ScanCallback() {

    override fun onScanResult(callbackType: Int, result: ScanResult?) {
        super.onScanResult(callbackType, result)

        result?.device?.let {
            onDeviceFound(it)
        }
    }
}

/**
 * This class represents the options for a Bluetooth scan.
 */
data class BluetoothScanOptions(val scanMode: Int)