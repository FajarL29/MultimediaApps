import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:multimedia_apps/core/constant/app_color.dart';
import 'package:speech_to_text/speech_to_text.dart';

SpeechToText speech = SpeechToText();
bool isListening = false;
String text = '';

Future showVoiceCommandDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.of(context).pop(true);
      });
      return AlertDialog(
        backgroundColor: AppStaticColors.primary,
        title: const Center(
          child: Text(
            'Say Something',
            style: TextStyle(color: AppStaticColors.white),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: 100,
                width: 100,
                child: Lottie.asset('assets/json/recording.json')),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    },
  );
}
