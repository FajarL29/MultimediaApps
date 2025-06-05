import 'package:flutter/material.dart';

class Cardwidget extends StatelessWidget {
  final String
      parameterName; // Name of the parameter (e.g., "Temperature", "Humidity")
  final double value; // Value of the parameter
  final String unit; // Unit of the parameter (e.g., "°C", "%")
  final Widget icon; // Icon to display
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
      color: Color(0xFF12A8FF).withOpacity(0.30),
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
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
            //const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 12),
                Text(
                '${value.toStringAsFixed(1)}$unit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              ],
            ),
            if (alertMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                textAlign: TextAlign.center,
                alertMessage!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
