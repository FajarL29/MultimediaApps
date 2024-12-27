import 'package:flutter/material.dart';

class RespirationRateWidget extends StatelessWidget {
  final int respirationRate; // Respiration rate in breaths per minute

  const RespirationRateWidget({required this.respirationRate, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              textAlign: TextAlign.center,
              'Respiration Rate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  respirationRate < 12 || respirationRate > 20
                      ? Icons.warning
                      : Icons.air,
                  color: respirationRate < 12 || respirationRate > 20
                      ? Colors.red
                      : Colors.blue,
                  size: 50,
                ),
                const SizedBox(width: 8),
                Text(
                  textAlign: TextAlign.center,
                  '$respirationRate bpm',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: respirationRate < 12 || respirationRate > 20
                        ? Colors.red
                        : Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              textAlign: TextAlign.center,
              respirationRate < 12
                  ? 'Below Normal'
                  : respirationRate > 20
                      ? 'Above Normal'
                      : 'Normal',
              style: TextStyle(
                fontSize: 14,
                color: respirationRate < 12 || respirationRate > 20
                    ? Colors.red
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
