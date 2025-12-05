import Flutter
import UIKit

public class ScreenRecordDetectionPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {

        let messenger = registrar.messenger()

        let eventChannel = FlutterEventChannel(
            name: "com.recording.detection/screen_recording_state",
            binaryMessenger: messenger
        )
        let eventHandler = ScreenCaptureStreamHandler()
        eventChannel.setStreamHandler(eventHandler)

        let methodChannel = FlutterMethodChannel(
            name: "com.recording.detection/make_secured",
            binaryMessenger: messenger
        )
        let methodHandler = SecureScreenManager()
        methodChannel.setMethodCallHandler(methodHandler)

        let instance = ScreenRecordDetectionPlugin()
    }
}