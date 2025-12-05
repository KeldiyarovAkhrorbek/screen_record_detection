
import 'screen_record_detection_platform_interface.dart';

class ScreenRecordDetection {
  Future<String?> getPlatformVersion() {
    return ScreenRecordDetectionPlatform.instance.getPlatformVersion();
  }
}
