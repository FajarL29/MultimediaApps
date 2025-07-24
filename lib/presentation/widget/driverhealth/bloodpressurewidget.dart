import 'package:flutter/material.dart';

class BloodPressureWidget extends StatelessWidget {
  final int systolic;   // mmHg
  final int diastolic;  // mmHg

  const BloodPressureWidget({
    required this.systolic,
    required this.diastolic,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDataAvailable = systolic > 0 && diastolic > 0;
    final bool isHigh = systolic > 130 || diastolic > 80;

    final String bpText = isDataAvailable ? '$systolic/$diastolic' : '---/---';
    final String statusText = !isDataAvailable
        ? 'No Data'
        : isHigh
            ? 'High Blood Pressure'
            : 'Normal';

    final Color valueColor = !isDataAvailable
        ? Colors.grey
        : isHigh
            ? Colors.red
            : Colors.white;

    final Color statusColor = !isDataAvailable
        ? Colors.grey
        : isHigh
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
          children: [
            Image.asset(
              'assets/images/bp.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 15),
            const Text(
              'Blood Pressure',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              bpText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 38,
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
