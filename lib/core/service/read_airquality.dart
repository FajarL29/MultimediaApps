import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class ReadAirquality {
  final SerialPort _port =
      SerialPort('COM13'); // Replace with your port
  late SerialPortReader _reader;
  final StreamController<double> _coController =
      StreamController<double>.broadcast();
  final StreamController<double> _co2Controller =
      StreamController<double>.broadcast();
  final StreamController<double> _pMController =
      StreamController<double>.broadcast();
  final StreamController<double> _tempController =
      StreamController<double>.broadcast();
  final StreamController<double> _o2Controller =
      StreamController<double>.broadcast();
  final StreamController<double> _humController =
      StreamController<double>.broadcast();
  String rawData = '';

  ReadAirquality();

  // Expose the stream for widgets to listen to
  Stream<double> get coStream => _coController.stream;
  Stream<double> get co2Stream => _co2Controller.stream;
  Stream<double> get pmStream => _pMController.stream;
  Stream<double> get tempStream => _tempController.stream;
  Stream<double> get o2Stream => _o2Controller.stream;
  Stream<double> get humStream => _humController.stream;

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
        case 'CO':
          double? co = double.tryParse(line[1]);
          if (co != null) {
            _coController.add(co); // Emit valid heart rate
            print("Heart Rate Stream emitted: $co");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
        case 'CO2':
          double? co2 = double.tryParse(line[1]);
          if (co2 != null) {
            _co2Controller.add(co2); // EspO2 heart rate
            print("SPO2 Stream emitted: $co2");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
        case 'PM':
          double? pm = double.tryParse(line[1]);
          if (pm != null) {
            _pMController.add(pm); // Emit valid heart rate
            print("Heart Rate Stream emitted: $pm");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
        case 'TEMP':
          double? temp = double.tryParse(line[1]);
          if (temp != null) {
            _tempController.add(temp); // EspO2 heart rate
            print("SPO2 Stream emitted: $temp");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
        case 'O2':
          double? o2 = double.tryParse(line[1]);
          if (o2 != null) {
            _o2Controller.add(o2); // EspO2 heart rate
            print("SPO2 Stream emitted: $o2");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;

        case 'HUM':
          double? hum = double.tryParse(line[1]);
          if (hum != null) {
            _humController.add(hum); // EspO2 heart rate
            print("SPO2 Stream emitted: $hum");
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
    _coController.close();
    _co2Controller.close();
    _pMController.close();
    _tempController.close();
    _o2Controller.close();
    _humController.close();
    _port.close();
  }
}
