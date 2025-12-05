import 'package:flutter_test/flutter_test.dart';
import 'package:screen_record_detection/screen_record_detection.dart';
import 'package:screen_record_detection/screen_record_detection_platform_interface.dart';
import 'package:screen_record_detection/screen_record_detection_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScreenRecordDetectionPlatform
    with MockPlatformInterfaceMixin
    implements ScreenRecordDetectionPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ScreenRecordDetectionPlatform initialPlatform = ScreenRecordDetectionPlatform.instance;

  test('$MethodChannelScreenRecordDetection is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScreenRecordDetection>());
  });

  test('getPlatformVersion', () async {
    ScreenRecordDetection screenRecordDetectionPlugin = ScreenRecordDetection();
    MockScreenRecordDetectionPlatform fakePlatform = MockScreenRecordDetectionPlatform();
    ScreenRecordDetectionPlatform.instance = fakePlatform;

    expect(await screenRecordDetectionPlugin.getPlatformVersion(), '42');
  });
}
