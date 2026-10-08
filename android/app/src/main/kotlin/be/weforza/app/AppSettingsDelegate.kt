package be.weforza.app

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.provider.Settings

class AppSettingsDelegate {
    fun openAppSettings(activity: Activity) {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)

        activity.let {
            intent.data = Uri.fromParts("package", it.packageName, null)
            it.startActivity(intent)
        }
    }

    fun openBluetoothSettings(activity: Activity) {
        try {
            activity.startActivity(Intent(Settings.ACTION_BLUETOOTH_SETTINGS))
        } catch (_: Exception) {
            openAppSettings(activity)
        }
    }
}
