import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'screen_record_detection_method_channel.dart';

abstract class ScreenRecordDetectionPlatform extends PlatformInterface {
  /// Constructs a ScreenRecordDetectionPlatform.
  ScreenRecordDetectionPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenRecordDetectionPlatform _instance = MethodChannelScreenRecordDetection();

  /// The default instance of [ScreenRecordDetectionPlatform] to use.
  ///
  /// Defaults to [MethodChannelScreenRecordDetection].
  static ScreenRecordDetectionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScreenRecordDetectionPlatform] when
  /// they register themselves.
  static set instance(ScreenRecordDetectionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
