package com.recording.detection

import android.app.Activity
import android.os.Build
import android.view.WindowManager
import androidx.core.content.ContextCompat
import androidx.core.util.Consumer
import io.flutter.plugin.common.EventChannel

// The handler now needs the Activity reference
class ScreenRecordStreamHandler(
    private val activity: Activity
) : EventChannel.StreamHandler {

    private var sink: EventChannel.EventSink? = null

    // Use the official Android 15 (UPSIDE_DOWN_CAKE) constant for API 35
    private val isAndroid15Plus = Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE

    // Use the official callback for screen recording detection
    private val recordingCallback = Consumer<Int> { state ->
        // The state is either SCREEN_RECORDING_STATE_VISIBLE or SCREEN_RECORDING_STATE_NOT_VISIBLE
        val isRecording = state == WindowManager.SCREEN_RECORDING_STATE_VISIBLE
        sink?.success(isRecording)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events

        if (!isAndroid15Plus) {
            // If Android < 15 → always return false
            sink?.success(false)
            return
        }

        val windowManager = activity.windowManager
        val mainExecutor = ContextCompat.getMainExecutor(activity)

        // Register the correct API listener
        val initialState = windowManager.addScreenRecordingCallback(
            mainExecutor,
            recordingCallback
        )

        // Emit initial state
        val initialIsRecording = initialState == WindowManager.SCREEN_RECORDING_STATE_VISIBLE
        sink?.success(initialIsRecording)
    }

    override fun onCancel(arguments: Any?) {
        if (isAndroid15Plus) {
            // Remove the listener
            activity.windowManager.removeScreenRecordingCallback(recordingCallback)
        }
        sink = null
    }

    // sendCurrentStatus is no longer needed as the status is sent via the callback lifecycle
}