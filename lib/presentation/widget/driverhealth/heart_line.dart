// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedLine extends StatefulWidget {
  const AnimatedLine({
    super.key,
  });

  @override
  _AnimatedLineState createState() => _AnimatedLineState();
}

class _AnimatedLineState extends State<AnimatedLine>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late StreamSubscription<int> _durationSubscription;
  final StreamController<int> _durationStream = StreamController<int>();

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a default duration
    _initializeAnimationController(duration: 1);

    // Listen to the duration stream
    _durationSubscription = _durationStream.stream.listen((newDuration) {
      _updateAnimationController(newDuration);
    });

    // Simulate streaming data
    _simulateDurationUpdates();
  }

  void _initializeAnimationController({required int duration}) {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: duration),
    )
      ..addListener(() {
        setState(() {}); // Trigger a rebuild whenever the controller updates
      })
      ..repeat();
  }

  void _updateAnimationController(int newDuration) {
    // Dispose of the old controller
    _controller.dispose();

    // Create a new controller with the updated duration
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: newDuration),
    )
      ..addListener(() {
        setState(() {}); // Trigger a rebuild whenever the controller updates
      })
      ..repeat();
  }

  void _simulateDurationUpdates() {
    // Simulate sending new durations to the stream
    Future.delayed(Duration(seconds: 5), () => _durationStream.add(3));
    Future.delayed(Duration(seconds: 10), () => _durationStream.add(7));
    Future.delayed(Duration(seconds: 15), () => _durationStream.add(2));
  }

  @override
  void dispose() {
    _controller.dispose();
    _durationSubscription.cancel();
    _durationStream.close();
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
