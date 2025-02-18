import 'package:flutter/material.dart';

class SpO2Widget extends StatelessWidget {
  final int spO2rate; //
  const SpO2Widget({required this.spO2rate, super.key});

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
              'SpO2' ,  
              
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),
            ),
            const Text(
              textAlign: TextAlign.center,
              
              '(Oxygen Saturation)',
              style: TextStyle(fontSize: 17, ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  color: spO2rate < 90 ? Colors.red : Colors.green,
                  size: 50,
                ),
                const SizedBox(width: 8),
                Text(
                  textAlign: TextAlign.center,
                  '${spO2rate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: spO2rate < 90 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              textAlign: TextAlign.center,
              spO2rate < 90
                  ? 'Low Oxygen Level'
                  : spO2rate < 95
                      ? 'Below Normal'
                      : 'Normal',
              style: TextStyle(
                fontSize: 14,
                color: spO2rate < 90 ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
