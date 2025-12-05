import 'dart:async';
import 'package:flutter/services.dart';
import 'screen_record_detection_platform_interface.dart';

class MethodChannelScreenRecordDetection extends ScreenRecordDetectionPlatform {
  static const EventChannel _eventChannel = EventChannel(
    'com.recording.detection/screen_recording_state',
  );

  static const MethodChannel _methodChannel = MethodChannel('com.recording.detection/make_secured');

  @override
  Stream<bool> get onRecordingStateChanged {
    return _eventChannel.receiveBroadcastStream().map(
      (dynamic isRecording) => isRecording as bool,
    );
  }

  @override
  Future<void> enableScreenSecurity() async {
    await _methodChannel.invokeMethod('makeSecured', {'enable': true});
  }

  @override
  Future<void> disableScreenSecurity() async {
    await _methodChannel.invokeMethod('makeSecured', {'enable': false});
  }
}
