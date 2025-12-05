import Flutter
import UIKit

// MARK: - Secure Screenshot Extension
extension UIWindow {
    func makeSecure() {
        let secureField = UITextField()
        secureField.isSecureTextEntry = true
        addSubview(secureField)

        secureField.translatesAutoresizingMaskIntoConstraints = false
        secureField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        secureField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        layer.superlayer?.addSublayer(secureField.layer)
        secureField.layer.sublayers?.first?.addSublayer(layer)
    }
}

// MARK: - Plugin
public class ScreenRecordDetectionPlugin: NSObject, FlutterPlugin {

    // MARK: - Secure Manager
    class ScreenManager {
        private var isEnabled = false

        func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
            if call.method == "makeSecured" {
                let enable = (call.arguments as? [String: Any])?["enable"] as? Bool ?? false
                enable ? enableSecureMode() : disableSecureMode()
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        private func enableSecureMode() {
            guard !isEnabled else { return }
            isEnabled = true

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    window.makeSecure()
                }
            }
        }

        private func disableSecureMode() {
            // IMPORTANT:
            // Cannot undo makeSecure() once active — iOS secure text field snapshot block persists.
            // But we allow toggling for API symmetry.
            isEnabled = false
        }
    }

    // MARK: - Recording Stream Handler
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

    // MARK: - Registration
    public static func register(with registrar: FlutterPluginRegistrar) {

        let messenger = registrar.messenger()

        // Activate secure-mode immediately on app start
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.makeSecure()
            }
        }

        // Screen recording stream
        let eventChannel = FlutterEventChannel(
            name: "com.recording.detection/screen_recording_state",
            binaryMessenger: messenger
        )
        eventChannel.setStreamHandler(ScreenCaptureStreamHandler())

        // Secure mode toggle
        let methodChannel = FlutterMethodChannel(
            name: "com.recording.detection/make_secured",
            binaryMessenger: messenger
        )
        let manager = ScreenManager()
        methodChannel.setMethodCallHandler(manager.handle)
    }
}
