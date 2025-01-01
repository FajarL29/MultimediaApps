import 'package:flutter/material.dart';

class Cardwidget extends StatelessWidget {
  final String
      parameterName; // Name of the parameter (e.g., "Temperature", "Humidity")
  final double value; // Value of the parameter
  final String unit; // Unit of the parameter (e.g., "°C", "%")
  final IconData icon; // Icon to display
  final bool isAlert; // Flag to indicate if the value is in alert range
  final String? alertMessage; // Optional message to display in case of alert

  const Cardwidget({
    required this.parameterName,
    required this.value,
    required this.unit,
    required this.icon,
    this.isAlert = false,
    this.alertMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isAlert
                ? [Colors.red.shade100, Colors.red.shade400]
                : [Colors.blue.shade100, Colors.blue.shade400],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              textAlign: TextAlign.center,
              parameterName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 60,
                ),
                const SizedBox(width: 12),
                Text(
                  textAlign: TextAlign.center,
                  '${value.toStringAsFixed(1)}$unit',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            if (alertMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                textAlign: TextAlign.center,
                alertMessage!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
