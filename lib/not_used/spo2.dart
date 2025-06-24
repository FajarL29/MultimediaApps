import 'package:flutter/material.dart';

class SpO2Widget extends StatelessWidget {
  final Stream<int> spO2Stream; // Stream for SpO2 values

  const SpO2Widget({required this.spO2Stream, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: spO2Stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error receiving SpO2 data'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text('No SpO2 data available'),
          );
        }

        final spO2 = snapshot.data!;
        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SpO2 (Oxygen Saturation)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: spO2 < 90 ? Colors.red : Colors.green,
                      size: 50,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${spO2.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: spO2 < 90 ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  spO2 < 90
                      ? 'Low Oxygen Level'
                      : spO2 < 95
                          ? 'Below Normal'
                          : 'Normal',
                  style: TextStyle(
                    fontSize: 14,
                    color: spO2 < 90 ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
