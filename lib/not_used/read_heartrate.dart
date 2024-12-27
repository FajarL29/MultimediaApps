import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class HeartRateService {
  final SerialPort _port = SerialPort('COM6'); // Replace with your port
  late SerialPortReader _reader;
  final StreamController<int> _heartRateController =
      StreamController<int>.broadcast();
  String rawData = '';

  HeartRateService();

  // Expose the stream for widgets to listen to
  Stream<int> get heartRateStream => _heartRateController.stream;

  void startListening() {
    try {
      final config = _port.config;
      config.baudRate = 9600; // Replace with your desired baud rate
      _port.config = config;

      if (!_port.openReadWrite()) {
        throw Exception('Failed to open port');
      }

      _reader = SerialPortReader(_port);
      _reader.stream.listen((data) {
        rawData += String.fromCharCodes(data); // Append new data chunk
        processRawData(); // Process complete lines
      });
    } catch (e) {
      print('Error during port setup: $e');
    }
  }

  void processRawData() {
    // Split the data into lines (assuming '\n' is the delimiter)
    final lines = rawData.split('\n');

    // Process all complete lines except the last one (it may be incomplete)
    for (int i = 0; i < lines.length - 1; i++) {
      final line = lines[i].trim(); // Remove any extra whitespace
      final heartRate = int.tryParse(line);

      if (heartRate != null && heartRate > 0 && heartRate < 255) {
        _heartRateController.add(heartRate); // Emit valid heart rate
        print("Heart Rate Stream emitted: $heartRate");
      } else {
        print("Invalid or incomplete data: $line");
      }
    }

    // Retain the last (incomplete) line in rawData
    rawData = lines.last;
  }

  void dispose() {
    _heartRateController.close();
    _port.close();
  }
}
