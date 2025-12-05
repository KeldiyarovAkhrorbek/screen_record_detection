import 'package:flutter/material.dart';
import 'dart:async';

import 'package:screen_record_detection/screen_record_detection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _detector = ScreenRecordDetector();
  late Stream<bool> _recordingSubscription;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _recordingSubscription = _detector.onRecordingStateChanged
        .asBroadcastStream();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Screen Recording demo')),
        body: StreamBuilder<bool>(
          stream: _recordingSubscription,
          builder: (context, asyncSnapshot) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    asyncSnapshot.data == true
                        ? "Screen is being recorded"
                        : "No recording detected",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
