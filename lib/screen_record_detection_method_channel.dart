import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screen_record_detection_platform_interface.dart';

/// An implementation of [ScreenRecordDetectionPlatform] that uses method channels.
class MethodChannelScreenRecordDetection extends ScreenRecordDetectionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('screen_record_detection');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
