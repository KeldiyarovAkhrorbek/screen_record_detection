import Flutter
import UIKit

class ScreenCaptureStreamHandler: NSObject, FlutterStreamHandler {

    private var eventSink: FlutterEventSink?

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenCaptureStatusDidChange),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )

        sendCurrentStatus()

        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        self.eventSink = nil
        return nil
    }

    @objc private func screenCaptureStatusDidChange() {
        sendCurrentStatus()
    }

    private func sendCurrentStatus() {
        let isCaptured = UIScreen.main.isCaptured

        self.eventSink?(isCaptured)
    }
}