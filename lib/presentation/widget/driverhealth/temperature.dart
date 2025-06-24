<<<<<<< HEAD
import 'package:flutter/material.dart';

class BodyTemperatureWidget extends StatelessWidget {
  final double temperature; // Body temperature in Celsius
  final bool isCelsius; // Flag to toggle Celsius/Fahrenheit

  const BodyTemperatureWidget({
    required this.temperature,
    this.isCelsius = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double displayTemp =
        isCelsius ? temperature : (temperature * 9 / 5) + 32;
    final String unit = isCelsius ? '°C' : '°F';
    final bool fever = temperature >= 37.5; // Fever threshold in Celsius

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: Color(0xFF213371).withOpacity(0.75), // Warna background jadi hitam
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/temp.png', // Path gambar dari assets
                  width: 150, // Sesuaiin ukuran
                  height: 150,
                  // color: fever ? Colors.red : Colors.white, // Biar warnanya tetap dinamis
                  //colorBlendMode: BlendMode.srcIn, // Buat nge-blend warna
                ),
                const SizedBox(height: 15),

                const Text(
              textAlign: TextAlign.center,
              'Body''\n'' Temperature',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),

            
           Text(
                  textAlign: TextAlign.center,
                  '${displayTemp.toStringAsFixed(1)}$unit',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: fever ? Colors.red : Colors.white,
                  ),
                ),
            const SizedBox(height: 8),

            Text(
              textAlign: TextAlign.center,
              fever ? 'Fever Detected' : 'Normal Temperature',
              style: TextStyle(
                fontSize: 14,
                color: fever ? Colors.red : Colors.grey,
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
=======
import 'package:flutter/material.dart';

class BodyTemperatureWidget extends StatelessWidget {
  final double temperature; // Body temperature in Celsius
  final bool isCelsius; // Flag to toggle Celsius/Fahrenheit

  const BodyTemperatureWidget({
    required this.temperature,
    this.isCelsius = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double displayTemp =
        isCelsius ? temperature : (temperature * 9 / 5) + 32;
    final String unit = isCelsius ? '°C' : '°F';
    final bool fever = temperature >= 37.5; // Fever threshold in Celsius

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: Color(0xFF213371).withOpacity(0.75), // Warna background jadi hitam
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/temp.png', // Path gambar dari assets
                  width: 150, // Sesuaiin ukuran
                  height: 150,
                  // color: fever ? Colors.red : Colors.white, // Biar warnanya tetap dinamis
                  //colorBlendMode: BlendMode.srcIn, // Buat nge-blend warna
                ),
                const SizedBox(height: 15),

                const Text(
              textAlign: TextAlign.center,
              'Body''\n'' Temperature',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),

            
           Text(
                  textAlign: TextAlign.center,
                  '${displayTemp.toStringAsFixed(1)}$unit',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: fever ? Colors.red : Colors.white,
                  ),
                ),
            const SizedBox(height: 8),

            Text(
              textAlign: TextAlign.center,
              fever ? 'Fever Detected' : 'Normal Temperature',
              style: TextStyle(
                fontSize: 14,
                color: fever ? Colors.red : Colors.grey,
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
>>>>>>> manual-book
