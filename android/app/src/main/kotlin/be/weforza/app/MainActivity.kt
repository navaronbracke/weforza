package be.weforza.app

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.IntentFilter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val methodChannel = "be.weforza.app/methods"
    private val bluetoothDeviceDiscoveryChannel = "be.weforza.app/bluetooth_device_discovery"
    private val bluetoothStateChannel = "be.weforza.app/bluetooth_state"

    private lateinit var bluetoothAdapterDelegate: BluetoothAdapterDelegate
    private val bluetoothStateStreamHandler = BluetoothAdapterStateStreamHandler()
    private val permissionDelegate = PermissionHandler()

    /**
     * The broadcast receiver that is notified of the Bluetooth adapter's state changes.
     */
    private var bluetoothStateBroadcastReceiver: BluetoothAdapterStateBroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        bluetoothAdapterDelegate = BluetoothAdapterDelegate(
            bluetoothManager.adapter,
            bluetoothStateStreamHandler
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannel).setMethodCallHandler {
                call, result ->
            when(call.method) {
                "getBluetoothAdapterState" -> bluetoothAdapterDelegate.getState(result)
                "isBluetoothOn" -> bluetoothAdapterDelegate.isBluetoothOn(result)
                "requestBluetoothScanPermission" -> permissionDelegate.requestBluetoothScanPermission(
                        this,
                        object: PermissionResultCallback {
                            override fun onPermissionResult(
                                errorCode: String?,
                                errorDescription: String?
                            ) {
                                if(errorCode == null) {
                                    result.success(true)
                                } else {
                                    result.success(false)
                                }
                            }
                        }
                )
                "startBluetoothScan" -> {
                    val options = BluetoothScanOptions(
                        call.argument<Int>("androidScanMode") ?: ScanSettings.SCAN_MODE_BALANCED
                    )

                    bluetoothAdapterDelegate.startBluetoothScan(options, result, this)
                }
                "stopBluetoothScan" -> bluetoothAdapterDelegate.stopBluetoothScan(result, this)
                else -> result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, bluetoothDeviceDiscoveryChannel).setStreamHandler(
            bluetoothAdapterDelegate.deviceDiscoveryStreamHandler
        )

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, bluetoothStateChannel).setStreamHandler(
            bluetoothAdapterDelegate.stateStreamHandler
        )        
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        // If the permission delegate can handle the request code, handle it.
        // Otherwise pass it through.
        when(permissionDelegate.shouldHandleRequestCode(requestCode)) {
            true -> permissionDelegate.onRequestPermissionsResult(requestCode, grantResults)
            false -> super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }

    override fun onResume() {
        super.onResume()

        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        bluetoothStateBroadcastReceiver = BluetoothAdapterStateBroadcastReceiver(
            bluetoothStateStreamHandler::onStateChanged
        )
        registerReceiver(bluetoothStateBroadcastReceiver, filter)
    }

    override fun onPause() {
        if(bluetoothStateBroadcastReceiver != null) {
            unregisterReceiver(bluetoothStateBroadcastReceiver)
        }

        super.onPause()
    }
}
