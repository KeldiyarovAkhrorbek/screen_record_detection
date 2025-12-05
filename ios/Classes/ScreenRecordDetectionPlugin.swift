import Flutter
import UIKit

public class ScreenRecordDetectionPlugin: NSObject, FlutterPlugin {

    class ScreenCaptureStreamHandler: NSObject, FlutterStreamHandler {
        private var sink: FlutterEventSink?

        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            sink = events
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(captureChanged),
                name: UIScreen.capturedDidChangeNotification,
                object: nil
            )
            captureChanged()
            return nil
        }

        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            sink = nil
            NotificationCenter.default.removeObserver(self)
            return nil
        }

        @objc private func captureChanged() {
            sink?(UIScreen.main.isCaptured)
        }
    }

    public static func register(with registrar: FlutterPluginRegistrar) {

        let messenger = registrar.messenger()

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.makeSecure()
            }
        }

        let eventChannel = FlutterEventChannel(
            name: "com.recording.detection/screen_recording_state",
            binaryMessenger: messenger
        )
        eventChannel.setStreamHandler(ScreenCaptureStreamHandler()
    }
}
