import 'package:flutter/material.dart';

class SpO2Widget extends StatelessWidget {
  final int spO2rate;

  const SpO2Widget({required this.spO2rate, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDataAvailable = spO2rate > 0;
    final String displayValue = isDataAvailable ? '$spO2rate%' : '---';
    final String statusText = isDataAvailable
        ? (spO2rate < 90
            ? 'Low Oxygen Level'
            : spO2rate < 95
                ? 'Below Normal'
                : 'Normal')
        : 'No Data';

    final Color statusColor = !isDataAvailable
        ? Colors.grey
        : spO2rate < 90
            ? Colors.red
            : Colors.green;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: const Color(0xFF213371).withOpacity(0.75),
      child: Padding(
        padding: const EdgeInsets.all(45.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/spo2.png',
              width: 150,
              height: 150,
              // color: statusColor, // optionally apply color to image
            ),
            const SizedBox(height: 15),
            const Text(
              'SpO2\n(Oxygen Saturation)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              displayValue,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              statusText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}