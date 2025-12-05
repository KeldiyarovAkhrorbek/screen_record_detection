package com.recording.detection

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel

class ScreenRecordDetectionPlugin : FlutterPlugin, ActivityAware {

    private var eventChannel: EventChannel? = null
    private var streamHandler: ScreenRecordStreamHandler? = null
    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = binding
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        val activity = binding.activity
        val binaryMessenger = flutterPluginBinding.binaryMessenger

        streamHandler = ScreenRecordStreamHandler(activity)
        eventChannel = EventChannel(
            binaryMessenger,
            "com.recording.detection/screen_recording_state"
        )
        eventChannel?.setStreamHandler(streamHandler)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        eventChannel?.setStreamHandler(null)
        eventChannel = null
        streamHandler = null

        secureFlagManager = null
    }
}