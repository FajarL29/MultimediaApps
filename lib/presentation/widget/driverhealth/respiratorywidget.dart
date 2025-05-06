import 'package:flutter/material.dart';

class RespirationRateWidget extends StatelessWidget {
  final int respirationRate; // Respiration rate in breaths per minute

  const RespirationRateWidget({required this.respirationRate, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: Color(0xFF213371).withOpacity(0.75),
      child: Padding(
        padding: const EdgeInsets.all(45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                   'assets/images/lungs.png',
                  width: 150, // Sesuaiin ukuran
                  height: 150,
                  // color: respirationRate < 12 || respirationRate > 20
                  //     ? Colors.red
                  //     : Colors.blue,
                ),
                const SizedBox(height: 15),

                const Text(
              textAlign: TextAlign.center,
              'Respiration''\n''Rate',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),

            Text(
                  textAlign: TextAlign.center,
                  '$respirationRate bpm',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: respirationRate < 12 || respirationRate > 20
                        ? Colors.red
                        : Colors.blue,
                  ),
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
            
            
          ],
        ),
      ),
    );
  }
}
