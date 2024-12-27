import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedHeartRateWave extends StatefulWidget {
  final Stream<List<double>> heartRateData;

  const AnimatedHeartRateWave({super.key, required this.heartRateData});

  @override
  _AnimatedHeartRateWaveState createState() => _AnimatedHeartRateWaveState();
}

class _AnimatedHeartRateWaveState extends State<AnimatedHeartRateWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<double>>(
      stream: widget.heartRateData,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No Data'),
          );
        }

        final data = snapshot.data!;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: HeartRateWavePainter(data: data),
              child: SizedBox(height: 100, width: double.infinity),
            );
          },
        );
      },
    );
  }
}

class HeartRateWavePainter extends CustomPainter {
  final List<double> data;
  HeartRateWavePainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    final path = Path();
    final spacing = size.width / data.length;

    path.moveTo(0, size.height / 2);

    for (int i = 0; i < data.length; i++) {
      final x = i * spacing;
      final y = (size.height / 2) -
          (data[i] - 60) * (size.height / 180); // Scale between 60-150
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void main() {
  final Stream<List<double>> mockHeartRateStream = Stream.periodic(
    const Duration(milliseconds: 500),
    (_) => List.generate(
      100,
      (index) =>
          60 + Random().nextDouble() * 90, // Generate values between 60-150
    ),
  );

  runApp(MaterialApp(
    title: 'Heart Rate Wave Demo',
    theme: ThemeData.dark(),
    home: Scaffold(
      appBar: AppBar(title: const Text('Heart Rate Wave')),
      body: Center(
        child: AnimatedHeartRateWave(heartRateData: mockHeartRateStream),
      ),
    ),
  ));
}
