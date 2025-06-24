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
    final bool isDataAvailable = temperature > 0;

    final double displayTemp = isCelsius
        ? temperature
        : (temperature * 9 / 5) + 32;
    final String unit = isCelsius ? '°C' : '°F';

    final bool fever = temperature >= 37.5;
    final String statusText = !isDataAvailable
        ? 'No Data'
        : fever
            ? 'Fever Detected'
            : 'Normal Temperature';

    final String tempText = isDataAvailable
        ? '${displayTemp.toStringAsFixed(1)}$unit'
        : '---';

    final Color statusColor = !isDataAvailable
        ? Colors.grey
        : fever
            ? Colors.red
            : Colors.white;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: const Color(0xFF213371).withOpacity(0.75),
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/temp.png',
              width: 150,
              height: 150,
              // Optionally, you can color it
              // color: statusColor,
            ),
            const SizedBox(height: 15),
            const Text(
              'Body\nTemperature',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              tempText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              statusText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: statusColor == Colors.white ? Colors.grey : statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}