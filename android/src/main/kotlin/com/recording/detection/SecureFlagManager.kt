package com.recording.detection

import android.app.Activity
import android.view.WindowManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SecureFlagManager(private val activity: Activity) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "makeSecured" -> {
                val enable = call.argument<Boolean>("enable") ?: false
                setSecureFlag(enable)
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    private fun setSecureFlag(enable: Boolean) {
        activity.runOnUiThread {
            if (enable) {
                activity.window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
            } else {
                activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
            }
        }
    }
}
