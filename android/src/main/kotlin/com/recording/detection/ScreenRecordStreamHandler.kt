package com.recording.detection

import android.app.Activity
import android.os.Build
import android.view.WindowManager
import androidx.core.content.ContextCompat
import java.util.function.Consumer
import io.flutter.plugin.common.EventChannel

class ScreenRecordStreamHandler(
    private val activity: Activity
) : EventChannel.StreamHandler {

    private var sink: EventChannel.EventSink? = null

    private val isAndroid15Plus = Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE

    private val recordingCallback = Consumer<Int> { state ->
        val isRecording = state == WindowManager.SCREEN_RECORDING_STATE_VISIBLE
        sink?.success(isRecording)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events

        if (!isAndroid15Plus) {
            sink?.success(false)
            return
        }

        val windowManager = activity.windowManager
        val mainExecutor = ContextCompat.getMainExecutor(activity)
        val initialState = windowManager.addScreenRecordingCallback(
            mainExecutor,
            recordingCallback
        )

        val initialIsRecording = initialState == WindowManager.SCREEN_RECORDING_STATE_VISIBLE
        sink?.success(initialIsRecording)
    }

    override fun onCancel(arguments: Any?) {
        if (isAndroid15Plus) {
            activity.windowManager.removeScreenRecordingCallback(recordingCallback)
        }
        sink = null
    }
}