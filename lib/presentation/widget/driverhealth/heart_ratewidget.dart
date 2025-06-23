import 'dart:async';
import 'package:flutter/material.dart';

class HeartRateWidget extends StatefulWidget {
  final Stream<int> heartRateStream;
  final Stream<bool> fingerDetectedStream;
  final Stream<String> fingerModeStream;
  final bool initialFingerDetected;
  final String initialFingerMode;

  const HeartRateWidget({
    super.key,
    required this.heartRateStream,
    required this.fingerDetectedStream,
    required this.fingerModeStream,
    required this.initialFingerDetected,
    required this.initialFingerMode,
  });

  @override
  State<HeartRateWidget> createState() => HeartRateWidgetState();
}

class HeartRateWidgetState extends State<HeartRateWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  final Map<DateTime, List<int>> _history = {};
  int _currentHeartRate = 0;

  late StreamSubscription<bool> _fingerSub;
  late StreamSubscription<String> _modeSub;
  late StreamSubscription<int> _bpmSub;

  bool _fingerDetected = false;
  String _fingerMode = "NONE";

  @override
  void initState() {
    super.initState();

    _fingerDetected = widget.initialFingerDetected;
    _fingerMode = widget.initialFingerMode;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (_fingerDetected && _fingerMode == "NORMAL") {
      _controller.repeat(reverse: true);
    }

    _fingerSub = widget.fingerDetectedStream.listen((detected) {
      setState(() {
        _fingerDetected = detected;
        _evaluateAnimation();
      });
    });

    _modeSub = widget.fingerModeStream.listen((mode) {
      setState(() {
        _fingerMode = mode;
        _evaluateAnimation();
      });
    });

    _bpmSub = widget.heartRateStream.listen(_handleHeartRate);
  }

  void _evaluateAnimation() {
    if (_fingerDetected && _fingerMode == "NORMAL") {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      setState(() {
        // _currentHeartRate = 0;
        // _history.clear();
      });
    }
  }

  void resetBPM() {
    setState(() {
      _currentHeartRate=0;
      _history.clear();
    });
    _controller.stop();
  }

  void _handleHeartRate(int rate) {
    final now = DateTime.now();
    final key = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    _history.putIfAbsent(key, () => []).add(rate);

    if (_history.length > 5) {
      _history.remove(_history.keys.first);
    }

    final avg = _calculateAverageBPM();
    setState(() {
      _currentHeartRate = avg;
      if (avg > 0) {
        _controller.duration = Duration(milliseconds: 60000 ~/ avg);
        if (_fingerDetected && _fingerMode == "NORMAL" && !_controller.isAnimating) {
          _controller.repeat(reverse: true);
        }
      }
    });
  }

  int _calculateAverageBPM() {
    final all = _history.values.expand((e) => e).toList();
    if (all.isEmpty) return 0;
    return all.reduce((a, b) => a + b) ~/ all.length;
  }

  @override
  void dispose() {
    _controller.dispose();
    _fingerSub.cancel();
    _modeSub.cancel();
    _bpmSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/images/heartbeat.png',
              width: 90,
              height: 90,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            _currentHeartRate > 0 ? '$_currentHeartRate BPM' : '--- BPM',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      
    );
    
  }
  
}
