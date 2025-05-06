import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AbnormalPopupDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool isHealthy;

  const AbnormalPopupDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.isHealthy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            isHealthy
                ? 'assets/lottie/success.json'
                : 'assets/lottie/warning.json',
            width: 100,
            height: 100,
            repeat: false,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isHealthy ? Colors.green : Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: isHealthy ? Colors.green : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Text("OK"),
          ),
        ),
      ],
    );
  }
}
