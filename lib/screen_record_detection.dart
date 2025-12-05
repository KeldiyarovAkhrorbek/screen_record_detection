import 'package:screen_record_detection/screen_record_detection_platform_interface.dart';

export 'screen_record_detection_platform_interface.dart';
export 'screen_record_detection_method_channel.dart';

class ScreenRecordDetector {
  Stream<bool> get onRecordingStateChanged {
    return ScreenRecordDetectionPlatform.instance.onRecordingStateChanged;
  }
}
