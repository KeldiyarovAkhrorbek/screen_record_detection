import Flutter
import UIKit

public class ScreenRecordDetectionPlugin: NSObject, FlutterPlugin {

    class ScreenManager {
        private var blurView: UIVisualEffectView?

        func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
            if call.method == "makeSecured" {
                let enable = (call.arguments as? [String: Any])?["enable"] as? Bool ?? false

                if enable {
                    addBlur()
                } else {
                    removeBlur()
                }

                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        private func addBlur() {
            guard blurView == nil else { return }
            guard let window = UIApplication.shared.windows.first else { return }

            let blur = UIBlurEffect(style: .light)
            let view = UIVisualEffectView(effect: blur)
            view.frame = window.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            window.addSubview(view)
            blurView = view
        }

        private func removeBlur() {
            blurView?.removeFromSuperview()
            blurView = nil
        }
    }

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

        let eventChannel = FlutterEventChannel(
            name: "com.recording.detection/screen_recording_state",
            binaryMessenger: messenger
        )
        eventChannel.setStreamHandler(ScreenCaptureStreamHandler())

        let methodChannel = FlutterMethodChannel(
            name: "com.recording.detection/make_secured",
            binaryMessenger: messenger
        )
        let manager = ScreenManager()
        methodChannel.setMethodCallHandler(manager.handle)
    }
}
