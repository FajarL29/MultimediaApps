import 'package:flutter/material.dart';

class BloodPressureWidget extends StatelessWidget {
  final int systolic; // Systolic pressure (mmHg)
  final int diastolic; // Diastolic pressure (mmHg)

  const BloodPressureWidget({
    required this.systolic,
    required this.diastolic,
    super.key,
  });

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
              'Blood Pressure',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  systolic > 130 || diastolic > 80
                      ? Icons.warning
                      : Icons.favorite,
                  color: systolic > 130 || diastolic > 80
                      ? Colors.red
                      : Colors.green,
                  size: 50,
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      '$systolic/',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: systolic > 130 || diastolic > 80
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      '$diastolic',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: systolic > 130 || diastolic > 80
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              systolic > 130 || diastolic > 80
                  ? 'High Blood Pressure'
                  : 'Normal',
              style: TextStyle(
                fontSize: 14,
                color:
                    systolic > 130 || diastolic > 80 ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
