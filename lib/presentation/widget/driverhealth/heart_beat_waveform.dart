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
  late VoidCallback _animationListener;

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
        if (!mounted) return;
        setState(() => _generateECGWaveform());
      });

    _fingerDetectedSubscription =
        widget.fingerDetectedStream.listen((detected) {
      if (!mounted) return;
      setState(() {
        _fingerDetected = detected;
        _handleAnimationLogic();
      });
    });

    _fingerModeSubscription = widget.fingerModeStream.listen((mode) {
      if (!mounted) return;
      setState(() {
        _fingerMode = mode;
        _handleAnimationLogic();
      });
    });

    _heartRateSubscription = widget.heartRateStream.listen((bpm) {
      if (bpm > 30 && bpm < 220) {
        int intervalMs = (60000 / bpm).round();
        int perStep = intervalMs ~/ _ecgPattern.length;
        _controller.duration = Duration(milliseconds: perStep.clamp(10, 100));
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), _handleAnimationLogic);
    });
  }

  void _handleAnimationLogic() {
    if (_fingerDetected && _fingerMode == "NORMAL") {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
      _resetWaveform();
    }
  }

  void _generateECGWaveform() {
    if (!_controller.isAnimating) return;
    _points.removeAt(0);
    _points.add(_ecgPattern[_ecgIndex] * 4);
    _ecgIndex = (_ecgIndex + 1) % _ecgPattern.length;
  }

  void _resetWaveform() {
    _points = List.generate(maxPoints, (_) => 0.0);
    _ecgIndex = 0;
  }

  @override
  void dispose() {
    _controller.removeListener(_animationListener);
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
                    "Proses Reading",
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
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = (i / points.length) * size.width;
      final y = size.height / 2 - points[i];
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}