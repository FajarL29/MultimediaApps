import 'dart:async';
import 'package:flutter/material.dart';

class HeartRateTableWidget extends StatefulWidget {
  final Stream<int> heartRateStream;

  const HeartRateTableWidget({required this.heartRateStream, super.key});

  @override
  HeartRateTableWidgetState createState() => HeartRateTableWidgetState();
}

class HeartRateTableWidgetState extends State<HeartRateTableWidget> {
  final Map<DateTime, List<int>> _heartRateHistory = {};
  late StreamSubscription<int> _subscription;

  @override
  void initState() {
    super.initState();

    // Listen to the heart rate stream
    _subscription = widget.heartRateStream.listen((heartRate) {
      if (!mounted) return; // Ensure widget is still mounted
      setState(() {
        final now = DateTime.now();
        final minuteKey =
            DateTime(now.year, now.month, now.day, now.hour, now.minute);

        // Add heart rate to the appropriate minute bucket
        if (!_heartRateHistory.containsKey(minuteKey)) {
          _heartRateHistory[minuteKey] = [];
        }

        _heartRateHistory[minuteKey]?.add(heartRate);

        // Keep only the last 5 minutes of data
        if (_heartRateHistory.length > 5) {
          _heartRateHistory.remove(_heartRateHistory.keys.first);
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel(); // Cancel subscription to avoid updates after disposal
    super.dispose();
  }

  // Modular function to calculate statistics
  Map<String, String> calculateStatistics() {
    final List<int> allRates =
        _heartRateHistory.values.expand((x) => x).toList();

    if (allRates.isEmpty) {
      return {
        'max': '-',
        'min': '-',
        'average': '-',
      };
    }

    final maxBPM = allRates.reduce((a, b) => a > b ? a : b);
    final minBPM = allRates.reduce((a, b) => a < b ? a : b);
    final averageBPM =
        (allRates.reduce((a, b) => a + b) / allRates.length).toStringAsFixed(1);

    return {
      'max': maxBPM.toString(),
      'min': minBPM.toString(),
      'average': averageBPM,
    };
  }

  @override
  Widget build(BuildContext context) {
    final stats = calculateStatistics();

    return Center(
      child: Card(
        elevation: 4,
        color: const Color(0xFF334EAC),
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              //const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(child: _buildStatItem('Max BPM', stats['max']!)),
                  Flexible(child: _buildStatItem('Min BPM', stats['min']!)),
                  Flexible(child: _buildStatItem('Average BPM', stats['average']!)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a stat item widget
  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum space
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}