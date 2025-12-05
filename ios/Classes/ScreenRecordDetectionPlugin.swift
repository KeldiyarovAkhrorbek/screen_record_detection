import Flutter
import UIKit

public class ScreenRecordDetectionPlugin: NSObject, FlutterPlugin {

    class ScreenManager {
        private var shieldWindow: UIWindow?

        func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
            if call.method == "makeSecured" {
                let enable = (call.arguments as? [String: Any])?["enable"] as? Bool ?? false
                enable ? enableShield() : disableShield()
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        private func enableShield() {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(showShield),
                name: UIApplication.userDidTakeScreenshotNotification,
                object: nil
            )

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(showShield),
                name: UIScreen.capturedDidChangeNotification,
                object: nil
            )

            if UIScreen.main.isCaptured {
                showShield()
            }
        }

        private func disableShield() {
            NotificationCenter.default.removeObserver(self)
            hideShield()
        }

        @objc private func showShield() {
            if shieldWindow != nil { return }

            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

            let w = UIWindow(windowScene: windowScene)
            w.frame = UIScreen.main.bounds
            w.windowLevel = UIWindow.Level.alert + 2
            w.backgroundColor = .black
            w.isHidden = false

            shieldWindow = w
        }

        private func hideShield() {
            shieldWindow?.isHidden = true
            shieldWindow = nil
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
