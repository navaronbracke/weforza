package be.weforza.app

import android.bluetooth.BluetoothManager
import android.bluetooth.le.ScanSettings
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val methodChannel = "be.weforza.app/methods"
    private val bluetoothDeviceDiscoveryChannel = "be.weforza.app/bluetooth_device_discovery"
    private val bluetoothStateChannel = "be.weforza.app/bluetooth_state"

    private val bluetoothAdapterDelegate: BluetoothAdapter
    private val permissionDelegate = PermissionHandler()

    init {
        val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        bluetoothAdapterDelegate = BluetoothAdapter(bluetoothManager.adapter,
            BluetoothAdapterStateStreamHandler(this)
        )
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

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
}
