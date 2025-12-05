import 'dart:async';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:screen_record_detection/screen_record_detection_method_channel.dart';

abstract class ScreenRecordDetectionPlatform extends PlatformInterface {
  ScreenRecordDetectionPlatform() : super(token: _token);
  static final Object _token = Object();

  static ScreenRecordDetectionPlatform _instance =
      MethodChannelScreenRecordDetection();

  static ScreenRecordDetectionPlatform get instance => _instance;

  static set instance(ScreenRecordDetectionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<bool> get onRecordingStateChanged {
    throw UnimplementedError(
      'onRecordingStateChanged has not been implemented.',
    );
  }

  Future<void> enableScreenSecurity() {
    throw UnimplementedError(
      'enableScreenSecurity() has not been implemented.',
    );
  }

  Future<void> disableScreenSecurity() {
    throw UnimplementedError(
      'disableScreenSecurity() has not been implemented.',
    );
  }
}
