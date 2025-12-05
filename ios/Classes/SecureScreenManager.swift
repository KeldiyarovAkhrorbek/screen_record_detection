import Flutter
import UIKit

public class SecureScreenManager: NSObject, FlutterMethodCallHandler {

    private var blurView: UIVisualEffectView?

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
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
