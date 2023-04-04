package be.weforza.app

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

/**
 * The callback interface for the permission result.
 */
interface PermissionResultCallback {
    fun onPermissionResult(errorCode: String?, errorDescription: String?)
}

/**
 * This class handles requesting permissions.
 */
class PermissionHandler {
    companion object {
        const val PERMISSION_DENIED = "PermissionDenied"
        const val PERMISSION_DENIED_MESSAGE = "The requested permission(s) were denied."

        const val PERMISSION_REQUEST_ONGOING = "PermissionRequestOngoing"
        const val PERMISSION_REQUEST_ONGOING_MESSAGE = "Another permission request is ongoing."

        const val REQUEST_CODE_BLUETOOTH_PERMISSION = 2000
    }

    // The permission listener that will listen for the permission result.
    private var permissionListener: PermissionResultListener? = null

    /**
     * Returns whether the given permissions have been granted already.
     *
     * Returns false if one or more permissions have not been granted yet.
     * Returns true if all permissions were already granted.
     */
    private fun hasPermissions(activity: Activity, permissions: Array<String>): Boolean {
        for(permission in permissions) {
            // Abort with false if a permission was denied.
            if(ContextCompat.checkSelfPermission(activity, permission) == PackageManager.PERMISSION_DENIED) {
                return false
            }
        }

        return true
    }

    /**
     * Handle a request permission result.
     */
    fun onRequestPermissionsResult(
        requestCode: Int,
        grantResults: IntArray
    ) {
        permissionListener?.onRequestPermissionsResult(requestCode, grantResults)
    }

    /**
     * Request a set of permissions.
     *
     * The callback is called with a null errorCode and errorMessage if the permissions were granted.
     * The callback is called with an errorCode and errorMessage if the permissions were not granted.
     * The requestCode is passed to the permission request and is used to finalize the response handling.
     */
    private fun requestPermissions(
        activity: Activity,
        permissions: Array<String>,
        requestCode: Int,
        callback: PermissionResultCallback) {
        if (permissionListener != null) {
            callback.onPermissionResult(
                PERMISSION_REQUEST_ONGOING, PERMISSION_REQUEST_ONGOING_MESSAGE)
            return
        }

        if(hasPermissions(activity, permissions)) {
            // Permissions already exist. Call the callback with success.
            callback.onPermissionResult(null, null)
            return
        }

        permissionListener = PermissionResultListener(
            requestCode,
            object: PermissionResultCallback {
                override fun onPermissionResult(errorCode: String?, errorDescription: String?) {
                    // Unregister the result listener once the response has been received.
                    permissionListener = null
                    callback.onPermissionResult(errorCode, errorDescription)
                }
            })

        ActivityCompat.requestPermissions(
            activity,
            permissions,
            requestCode,
        )
    }

    /**
    * Request the permissions to start a Bluetooth Peripheral scan.
    */
    fun requestBluetoothScanPermission(activity: Activity, callback: PermissionResultCallback) {
        // Without the location permission, the scan does not find devices.
        // Request both types of permission,
        // so that the user can choose between precise and approximate location.
        val locationPermissions = arrayOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION,
        )

        val permissions = if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(
                *locationPermissions,
                Manifest.permission.BLUETOOTH_SCAN,
                Manifest.permission.BLUETOOTH_CONNECT, // To access `BluetoothDevice.name`.
            )
        } else {
            arrayOf(*locationPermissions, Manifest.permission.BLUETOOTH)
        }

        requestPermissions(activity, permissions, REQUEST_CODE_BLUETOOTH_PERMISSION, callback)
    }

    /**
     * Whether the given request code should be handled by the permission delegate.
     */
    fun shouldHandleRequestCode(requestCode: Int): Boolean {
        return when(requestCode) {
            REQUEST_CODE_BLUETOOTH_PERMISSION -> true
            else -> false
        }
    }
}

/**
 * The permission result listener that will accept a permission result.
 */
internal class PermissionResultListener(
    private val expectedRequestCode: Int,
    private val resultHandler: PermissionResultCallback,
) {
    /**
     * Handle a permission request result for the expected request code.
    */
    fun onRequestPermissionsResult(
        requestCode: Int,
        grantResults: IntArray
    ) {
        if (requestCode != expectedRequestCode) {
            return
        }

        // grantResults could be empty if the permissions request with the user is interrupted
        // https://developer.android.com/reference/android/app/Activity#onRequestPermissionsResult(int,%20java.lang.String[],%20int[])
        if(grantResults.isEmpty()) {
            resultHandler.onPermissionResult(
                PermissionHandler.PERMISSION_DENIED, PermissionHandler.PERMISSION_DENIED_MESSAGE)
            return
        }

        for (grantResult in grantResults) {
            if(grantResult != PackageManager.PERMISSION_GRANTED) {
                resultHandler.onPermissionResult(
                    PermissionHandler.PERMISSION_DENIED, PermissionHandler.PERMISSION_DENIED_MESSAGE)
                return
            }
        }

        resultHandler.onPermissionResult(null, null)
    }
}
