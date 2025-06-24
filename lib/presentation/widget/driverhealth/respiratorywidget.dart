import 'package:flutter/material.dart';

class RespirationRateWidget extends StatelessWidget {
  final int respirationRate; // breaths per minute

  const RespirationRateWidget({required this.respirationRate, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDataAvailable = respirationRate > 0;

    final String displayText = isDataAvailable
        ? '$respirationRate bpm'
        : '---';

    final String statusText = !isDataAvailable
        ? 'No Data'
        : respirationRate < 12
            ? 'Below Normal'
            : respirationRate > 20
                ? 'Above Normal'
                : 'Normal';

    final Color valueColor = !isDataAvailable
        ? Colors.grey
        : respirationRate < 12 || respirationRate > 20
            ? Colors.red
            : Colors.blue;

    final Color statusColor = !isDataAvailable
        ? Colors.grey
        : respirationRate < 12 || respirationRate > 20
            ? Colors.red
            : Colors.grey;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: const Color(0xFF213371).withOpacity(0.75),
      child: Padding(
        padding: const EdgeInsets.all(45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/lungs.png',
              width: 150,
              height: 150,
              // color: valueColor,
            ),
            const SizedBox(height: 15),
            const Text(
              'Respiration\nRate',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              displayText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: valueColor,
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