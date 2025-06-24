// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedLine2 extends StatefulWidget {
  final Stream<int> heartRateStream;
  const AnimatedLine2({super.key, required this.heartRateStream});

  @override
  State<AnimatedLine2> createState() => _AnimatedLineState();
}

class _AnimatedLineState extends State<AnimatedLine2>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  int _currentHeartRate = 0; // Default heart rate
  final Map<DateTime, List<int>> _heartRateHistory = {};

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    widget.heartRateStream.listen((rate) {
      setState(() {
        final now = DateTime.now();
        final minuteKey =
            DateTime(now.year, now.month, now.day, now.hour, now.minute);

        // Add heart rate to the appropriate minute bucket
        if (!_heartRateHistory.containsKey(minuteKey)) {
          _heartRateHistory[minuteKey] = [];
        }

        _heartRateHistory[minuteKey]?.add(rate);

        // Keep only the last 5 minutes of data
        if (_heartRateHistory.length > 5) {
          _heartRateHistory.remove(_heartRateHistory.keys.first);
        }
        final List<int> allRates =
            _heartRateHistory.values.expand((x) => x).toList();
        final averageBPM = allRates.reduce((a, b) => a + b) ~/ allRates.length;
        _currentHeartRate = averageBPM;

        final duration = Duration(milliseconds: 60000 ~/ _currentHeartRate);
        _controller.duration = duration;

        if (!_controller.isAnimating) {
          _controller.repeat();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(
        progress: _controller.value,
        getColor: (index, progress) {
          return Color.lerp(
              Colors.red.withOpacity(1.0), Colors.green, progress)!;
        },
      ),
      size: const Size(250, 250),
    );
  }
}

class LinePainter extends CustomPainter {
  final double progress;
  final Color Function(int index, double progress) getColor;
  LinePainter({required this.progress, required this.getColor});

  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(70, 150),
      Offset(90, 150),
      Offset(100, 165),
      Offset(110, 140),
      Offset(120, 180),
      Offset(130, 90),
      Offset(140, 160),
      Offset(150, 145),
      Offset(160, 150),
      Offset(180, 150),
    ];

    final totalSegments = points.length - 1;
    final phase = progress * totalSegments;
    final currentSegment = phase.floor();
    final localProgress = phase - currentSegment;

    // Draw completed segments
    for (int i = 0; i < currentSegment; i++) {
      final paint = Paint()
        ..color = getColor(i, 1.0)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw the current segment
    if (currentSegment < totalSegments) {
      final paint = Paint()
        ..color = getColor(currentSegment, localProgress)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      final startPoint = points[currentSegment];
      final endPoint = points[currentSegment + 1];
      final currentPoint = Offset(
        startPoint.dx + (endPoint.dx - startPoint.dx) * localProgress,
        startPoint.dy + (endPoint.dy - startPoint.dy) * localProgress,
      );
      canvas.drawLine(startPoint, currentPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Dynamic Animated Line',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const AnimatedLinePage(),
//     );
//   }
// }

// class AnimatedLinePage extends StatelessWidget {
//   const AnimatedLinePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dynamic Animated Line'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Text(
//               'Dynamic Line Animation',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             AnimatedLine(),
//           ],
//         ),
//       ),
//     );
//   }
// }
