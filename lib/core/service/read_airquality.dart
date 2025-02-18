import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class ReadAirQuality {
  final SerialPort _port = SerialPort('/dev/ttyACM0'); // Replace with your port
  String rawData = '';
  String status = 'Connecting...';

  final StreamController<double> _coController =
      StreamController<double>.broadcast();
  final StreamController<double> _co2Controller =
      StreamController<double>.broadcast();
  final StreamController<double> _pm25Controller =
      StreamController<double>.broadcast();
  final StreamController<double> _pm10Controller =
      StreamController<double>.broadcast();
  final StreamController<double> _tempController =
      StreamController<double>.broadcast();
  final StreamController<double> _o2Controller =
      StreamController<double>.broadcast();
  final StreamController<double> _humController =
      StreamController<double>.broadcast();

  // Expose streams for UI
  Stream<double> get coStream => _coController.stream;
  Stream<double> get co2Stream => _co2Controller.stream;
  Stream<double> get pm25Stream => _pm25Controller.stream;
  Stream<double> get pm10Stream => _pm10Controller.stream;
  Stream<double> get tempStream => _tempController.stream;
  Stream<double> get o2Stream => _o2Controller.stream;
  Stream<double> get humStream => _humController.stream;

  void startListening() {
    try {
      if (_port.openReadWrite()) {
        status = 'Port opened successfully!';
        print(status); // Print status for debugging

        var reader = SerialPortReader(_port);
        reader.stream.listen((data) {
          rawData += String.fromCharCodes(data); // Append new data chunk
          processRawData(); // Process complete lines
        });
      } else {
        status = 'Failed to open port: ${SerialPort.lastError}';
        print(status); // Print error status
      }
    } on SerialPortError catch (e) {
      status = 'Error: ${e.message}';
      print(status); // Print error message
    }
  }

  void processRawData() {
    final lines = rawData.split('\n');

    for (int i = 0; i < lines.length - 1; i++) {
      final lineParts = lines[i].split(':');
      if (lineParts.length < 2) {
        print("Invalid data format: ${lines[i]}");
        continue;
      }

      final String key = lineParts[0].trim();
      final double? value = double.tryParse(lineParts[1].trim());

      if (value == null) {
        print("Invalid or missing value: ${lines[i]}");
        continue;
      }

      switch (key) {
        case 'CO':
          _coController.add(value);
          break;
        case 'CO2':

          _co2Controller.add(value);


          break;
        case 'PM25':
          _pm25Controller.add(value);
          break;
        case 'PM10':
          _pm10Controller.add(value);
          break;
        case 'TEMP':
          _tempController.add(value);
          break;
        case 'O2':
          _o2Controller.add(value);
          break;
        case 'HUM':

          _humController.add(value);


          break;
        default:
          print("Unknown key: $key");
      }
    }

    rawData = lines.last; // Retain incomplete data
  }

  void dispose() {
    _coController.close();
    _co2Controller.close();
    _pm25Controller.close();
    _pm10Controller.close();
    _tempController.close();
    _o2Controller.close();
    _humController.close();
    _port.close();
  }
}
