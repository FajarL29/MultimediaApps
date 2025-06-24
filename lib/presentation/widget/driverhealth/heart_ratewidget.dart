<<<<<<< HEAD
import 'package:flutter/material.dart';

class HeartRateWidget extends StatefulWidget {
  final Stream<int> heartRateStream; // Stream for real-time heart rate data
  const HeartRateWidget({required this.heartRateStream, super.key});

  @override
  _HeartRateWidgetState createState() => _HeartRateWidgetState();
}

class _HeartRateWidgetState extends State<HeartRateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _currentHeartRate = 0; // Default heart rate
  final Map<DateTime, List<int>> _heartRateHistory = {};
  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Default for 60 BPM
    );


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

        // Adjust animation speed based on heart rate (BPM)
        final duration = Duration(milliseconds: 60000 ~/ _currentHeartRate);
        _animationController.duration = duration;

        if (!_animationController.isAnimating) {
          _animationController.repeat(reverse: true);
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16), // Menambahkan padding 16
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/heartbeat.png',
          width: 90, // Sesuaikan ukuran
          height: 90,
        ),
        const SizedBox(width: 20), // Mengubah height menjadi width untuk jarak horizontal
        Text(
          '$_currentHeartRate BPM',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    ),
  );
}

}
=======
import 'package:flutter/material.dart';

class HeartRateWidget extends StatefulWidget {
  final Stream<int> heartRateStream; // Stream for real-time heart rate data
  const HeartRateWidget({required this.heartRateStream, super.key});

  @override
  _HeartRateWidgetState createState() => _HeartRateWidgetState();
}

class _HeartRateWidgetState extends State<HeartRateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _currentHeartRate = 0; // Default heart rate
  final Map<DateTime, List<int>> _heartRateHistory = {};
  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Default for 60 BPM
    );


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

        // Adjust animation speed based on heart rate (BPM)
        final duration = Duration(milliseconds: 60000 ~/ _currentHeartRate);
        _animationController.duration = duration;

        if (!_animationController.isAnimating) {
          _animationController.repeat(reverse: true);
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16), // Menambahkan padding 16
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/heartbeat.png',
          width: 90, // Sesuaikan ukuran
          height: 90,
        ),
        const SizedBox(width: 20), // Mengubah height menjadi width untuk jarak horizontal
        Text(
          '$_currentHeartRate BPM',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    ),
  );
}

}
>>>>>>> manual-book
