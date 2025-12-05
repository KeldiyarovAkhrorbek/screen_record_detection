# screen_record_detection

A Flutter plugin that detects **screen recording events in real time** on both Android and iOS.  
Useful for protecting sensitive content, preventing data leakage, and enhancing app security.

---

## ✨ Features

- 🎥 **Real-time screen recording detection** (via stream)
- 📱 Works on **Android** and **iOS**
- ⚡ Simple API — just listen to a stream
- 🔄 Stream updates automatically when recording starts/stops

---

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  screen_record_detection: ^0.0.1
```

Import it:

```dart
import 'package:screen_record_detection/screen_record_detection.dart';
```

---

## 🚀 Usage

Listening to screen recording events:

```dart
final detector = ScreenRecordDetector();

detector.onRecordingStateChanged.listen((isRecording) {
  print("Recording: $isRecording");
});
```

Stream values:
- `true` → screen recording is active
- `false` → no recording is happening

---

## 📱 Example

Below is a complete runnable Flutter example demonstrating how to react to screen recording events using a `StreamBuilder`.

```dart
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
  late Stream<bool> _recordingStream;

  @override
  void initState() {
    super.initState();
    _recordingStream = _detector.onRecordingStateChanged.asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Screen Recording Demo')),
        body: StreamBuilder<bool>(
          stream: _recordingStream,
          builder: (context, snapshot) {
            final isRecording = snapshot.data == true;

            return Center(
              child: Text(
                isRecording
                    ? "Screen is being recorded"
                    : "No recording detected",
                style: const TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

---

## 🔧 Platform Details

### **Android**
- Detects screen recording through native **MediaProjection** callbacks.
- Works on Android 15+ reliably. Because, android it is new feature.
- Supports both wired and wireless recording methods.

### **iOS**
- Uses `UIScreen.captured` to detect capture state.
- Listens for `UIScreen.capturedDidChangeNotification`.
- Works on all modern iOS versions.

---

## ⚠️ Notes

- Some Android devices may require **user permission** for screen recording APIs to activate.
- Detection depends on the platform’s available APIs — results may vary on older OS versions.

---

## 🤝 Contributing

Contributions are welcome!

You can:
- Open issues for bugs or feature requests
- Submit pull requests
- Improve documentation

Your help makes the package better for everyone.

---

## 📬 Support

If you run into issues or want a new feature, please open an issue in the GitHub repository.

---

