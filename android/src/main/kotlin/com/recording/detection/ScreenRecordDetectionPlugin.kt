import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel

class ScreenRecordDetectionPlugin : FlutterPlugin, ActivityAware {

    private var eventChannel: EventChannel? = null
    private var streamHandler: ScreenRecordStreamHandler? = null
    private var binding: FlutterPlugin.FlutterPluginBinding? = null

    // --- FlutterPlugin Implementation ---
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.binding = flutterPluginBinding
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        this.binding = null
    }

    // --- ActivityAware Implementation ---
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        val activity = binding.activity

        // 1. Instantiate the Stream Handler with the Activity
        streamHandler = ScreenRecordStreamHandler(activity)

        // 2. Set up the Event Channel
        eventChannel = EventChannel(
            binding.flutterEngine.dartExecutor.binaryMessenger,
            "com.recording.detection/screen_recording_state" // Must match Dart side
        )
        eventChannel?.setStreamHandler(streamHandler)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity() // Same cleanup logic
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding) // Re-attach listeners
    }

    override fun onDetachedFromActivity() {
        // 3. Clean up the Channel and Handler
        eventChannel?.setStreamHandler(null)
        eventChannel = null
        streamHandler = null
    }
}