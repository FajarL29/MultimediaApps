import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class HeartRateService2 {
  final SerialPort _port =
      SerialPort('/dev/ttyACM1'); // Replace with your port
  late SerialPortReader _reader;
  final StreamController<int> _heartRateController =
      StreamController<int>.broadcast();
  final StreamController<int> _spO2Controller =
      StreamController<int>.broadcast();
  final StreamController<double> _bodyTempController =
      StreamController<double>.broadcast();
  final StreamController<int> _sbpController =
      StreamController<int>.broadcast();
  final StreamController<int> _dbpController =
      StreamController<int>.broadcast();
  final StreamController<int> _rrController = StreamController<int>.broadcast();
  String rawData = '';

  HeartRateService2();

  // Expose the stream for widgets to listen to
  Stream<int> get heartRateStream => _heartRateController.stream;
  Stream<int> get spO2RateStream => _spO2Controller.stream;
  Stream<double> get bodyTempStream => _bodyTempController.stream;
  Stream<int> get sbpRateStream => _sbpController.stream;
  Stream<int> get dbpRateStream => _dbpController.stream;
  Stream<int> get respRateStream => _rrController.stream;

  void startListening() {
    try {
      final config = _port.config;
      config.baudRate = 115200; // Replace with your desired baud rate
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
      final line = lines[i].split(':');
      final String check = line[0].trim();

      switch (check) {
        case 'BPM':
          int? heartRate = int.tryParse(line[1]);
          if (heartRate != null && heartRate > 0 && heartRate < 255) {
            _heartRateController.add(heartRate); // Emit valid heart rate
            print("Heart Rate Stream emitted: $heartRate");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
        case 'SpO2':
          int? spO2 = int.tryParse(line[1]);
          if (spO2 != null) {
            _spO2Controller.add(spO2); // EspO2 heart rate
            print("SPO2 Stream emitted: $spO2");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
        case 'BTemp':
          double? temp = double.tryParse(line[1]);
          if (temp != null) {
            _bodyTempController.add(temp); // EspO2 heart rate
            print("BTemp Stream emitted: $temp");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
        case 'ESBP':
          int? esbp = int.tryParse(line[1]);
          if (esbp != null) {
            _sbpController.add(esbp); // EspO2 heart rate
            print("ESBP Stream emitted: $esbp");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
        case 'EDBP':
          int? edbp = int.tryParse(line[1]);
          if (edbp != null) {
            _dbpController.add(edbp); // EspO2 heart rate
            print("EDBP Stream emitted: $edbp");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;

        case 'RRate':
          int? rrate = int.tryParse(line[1]);
          if (rrate != null) {
            _rrController.add(rrate); // EspO2 heart rate
            print("RRate Stream emitted: $rrate");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
      } // Remove any extra whitespace
    }

    // Retain the last (incomplete) line in rawData
    rawData = lines.last;
  }

  void dispose() {
    _heartRateController.close();
    _spO2Controller.close();
    _bodyTempController.close();
    _sbpController.close();
    _dbpController.close();
    _rrController.close();
    _port.close();
  }
}
