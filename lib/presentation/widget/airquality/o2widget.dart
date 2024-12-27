import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class O2Widget extends StatelessWidget {
  final double o2rate;

  const O2Widget({required this.o2rate, super.key});

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
              'Oxygen Concentration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset(
                    'assets/images/oxygen',
                    color: o2rate < 90 ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  textAlign: TextAlign.center,
                  '${o2rate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: o2rate < 90 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              textAlign: TextAlign.center,
              o2rate < 90
                  ? 'Low Oxygen Level'
                  : o2rate < 95
                      ? 'Below Normal'
                      : 'Normal',
              style: TextStyle(
                fontSize: 14,
                color: o2rate < 90 ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
