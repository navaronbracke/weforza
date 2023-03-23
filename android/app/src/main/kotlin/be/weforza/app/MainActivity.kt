package be.weforza.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val methodChannel = "be.weforza.app/methods"

    private val permissionDelegate = PermissionHandler()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannel).setMethodCallHandler {
                call, result ->
            when(call.method) {
                // TODO: move bluetooth calls into bluetooth handler class
                // TODO: return null if not supported
                "isBluetoothEnabled" -> result.notImplemented() // TODO: implement bluetooth on/off
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
                "startScan" -> result.notImplemented() // TODO: implement start scan
                "stopScan" -> result.notImplemented() // TODO: implement stop scan
                else -> result.notImplemented()
            }
        }
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
