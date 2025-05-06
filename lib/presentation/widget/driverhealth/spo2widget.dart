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
        padding: const EdgeInsets.all(45.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/spo2.png',
                  width: 150, // Sesuaiin ukuran
                  height: 150,
                  // color: spO2rate < 90 ? Colors.red : Colors.green,
                  
                ),
                const SizedBox(height: 15),

                const Text(
              textAlign: TextAlign.center,
              'SpO2 ''\n''(Oxygen Saturation)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
               
             Text(
                  textAlign: TextAlign.center,
                  '${spO2rate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 35,
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
            
            
          ],
        ),
      ),
    );
  }
}
