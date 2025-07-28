import 'dart:async';
import 'package:flutter/material.dart';

class HeartBeatWaveform extends StatefulWidget {
  final Stream<int> heartRateStream;
  final Stream<bool> fingerDetectedStream;
  final Stream<String> fingerModeStream;
  final bool initialFingerDetected;
  final String initialFingerMode;

  const HeartBeatWaveform({
    super.key,
    required this.heartRateStream,
    required this.fingerDetectedStream,
    required this.fingerModeStream,
    required this.initialFingerDetected,
    required this.initialFingerMode,
  });

  @override
  State<HeartBeatWaveform> createState() => _HeartBeatWaveformState();
}

class _HeartBeatWaveformState extends State<HeartBeatWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> _points;
  late StreamSubscription<bool> _fingerDetectedSubscription;
  late StreamSubscription<int> _heartRateSubscription;
  late StreamSubscription<String> _fingerModeSubscription;

  bool _fingerDetected = false;
  String _fingerMode = "NONE";
  int _ecgIndex = 0;

  final int maxPoints = 100;
  final List<double> _ecgPattern = [
    0, 0, 1, 2, 1, 0,
    -3, 10, -6, 2, 0,
    1, 2, 1, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0
  ];

  @override
  void initState() {
    super.initState();

    _points = List.generate(maxPoints, (_) => 0.0);
    _fingerDetected = widget.initialFingerDetected;
    _fingerMode = widget.initialFingerMode;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 30),
    )..addListener(() {
        if (mounted) {
          setState(() {
            _generateECGWaveform();
          });
        }
      });

    _fingerDetectedSubscription = widget.fingerDetectedStream.listen((detected) {
      if (mounted) {
        setState(() {
          _fingerDetected = detected;
          _handleAnimationLogic();
        });
      }
    });

    _fingerModeSubscription = widget.fingerModeStream.listen((mode) {
      if (mounted) {
        setState(() {
          _fingerMode = mode;
          _handleAnimationLogic();
        });
      }
    });

    _heartRateSubscription = widget.heartRateStream.listen((bpm) {
      if (bpm > 30 && bpm < 220) {
        int intervalMs = (60000 / bpm).round();
        int perStep = intervalMs ~/ _ecgPattern.length;
        _controller.duration = Duration(milliseconds: perStep.clamp(10, 100));
      }
    });
  }

  void _handleAnimationLogic() {
    if (_fingerDetected && _fingerMode == "NORMAL") {
      if (!_controller.isAnimating) {
        _controller.repeat(); // Start the animation immediately
      }
    } else {
      _controller.stop();
      _resetWaveform();
    }
  }

  void _generateECGWaveform() {
    if (!_controller.isAnimating) return;

    // Remove the first point to keep the array size constant
    _points.removeAt(0);

    // Add the next point based on the ECG pattern
    _points.add(_ecgPattern[_ecgIndex] * 4); // The multiplier adjusts the wave amplitude

    // Move to the next point in the ECG pattern, looping back when we reach the end
    _ecgIndex = (_ecgIndex + 1) % _ecgPattern.length;
  }

  void _resetWaveform() {
    // Reset waveform when animation stops
    _points = List.generate(maxPoints, (_) => 0.0);
    _ecgIndex = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    _fingerDetectedSubscription.cancel();
    _heartRateSubscription.cancel();
    _fingerModeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: _fingerDetected
          ? (_fingerMode == "BLE"
              ? const Center(
                  child: Text(
                    "Reading Process, Stay Safe",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                )
              : CustomPaint(
                  painter: _WaveformPainter(_points),
                  size: Size.infinite,
                ))
          : const Center(
              child: Text(
                "Please Place Your Finger",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> points;
  _WaveformPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red // Color of ECG wave
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Draw the ECG path based on the points
    for (int i = 0; i < points.length; i++) {
      final x = (i / points.length) * size.width; // Spread points across the width of the canvas
      final y = size.height / 2 - points[i]; // Position Y in the center of the canvas

      if (i == 0) {
        path.moveTo(x, y); // Start the path at the first point
      } else {
        path.lineTo(x, y); // Draw a line to the next point
      }
    }

    // Draw the ECG path on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


// class _WaveformPainter extends CustomPainter {
//   final List<double> points;
//   _WaveformPainter(this.points);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.red
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     final path = Path();
//     for (int i = 0; i < points.length; i++) {
//       final x = (i / points.length) * size.width;
//       final y = size.height / 2 - points[i];
//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }
//     }

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }