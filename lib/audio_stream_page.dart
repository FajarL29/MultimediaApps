import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String language = "english";
  final String label = "nyalakan lampu";

  Future<void> sendRequest() async {
    final url = Uri.parse(
        "http:// 192.168.100.40:5000/play-sound?language=$language&label=$label");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Response dari server:");
        print(data);
      } else {
        print("Gagal: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("Terjadi error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Client ke Flask')),
        body: Center(
          child: ElevatedButton(
            onPressed: sendRequest,
            child: Text("Kirim ke Server Flask"),
          ),
        ),
      ),
    );
  }
}
