import 'package:flutter/material.dart';

class SpO2Widget extends StatelessWidget {
  final int spO2rate; //
  const SpO2Widget({required this.spO2rate, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: Color(0xFF213371).withOpacity(0.75),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/spo2.png',
                  width: 90, // Sesuaiin ukuran
                  height: 90,
                  // color: spO2rate < 90 ? Colors.red : Colors.green,
                  
                ),
                const SizedBox(height: 8),
               
              ],
            ),
            const Text(
              textAlign: TextAlign.center,
              'SpO2 ''\n''(Oxygen Saturation)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
             Text(
                  textAlign: TextAlign.center,
                  '${spO2rate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: spO2rate < 90 ? Colors.red : Colors.green,
                  ),
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
