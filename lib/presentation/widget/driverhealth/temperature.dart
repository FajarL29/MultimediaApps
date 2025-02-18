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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              textAlign: TextAlign.center,
              'Body Temperature''\n',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.thermostat,
                  color: fever ? Colors.red : Colors.blue,
                  size: 50,
                ),
                const SizedBox(width: 8),
                Text(
                  textAlign: TextAlign.center,
                  '${displayTemp.toStringAsFixed(1)}$unit',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: fever ? Colors.red : Colors.blue,
                  ),
                ),
              ],
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
      ),
    );
  }
}
