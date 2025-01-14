import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class HeartRateService2 {
  final SerialPort _port = SerialPort('/dev/ttyACM0'); // Replace with your port
  String rawData = '';
  String status = 'Connecting...';

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

  // Expose the stream for widgets to listen to
  Stream<int> get heartRateStream => _heartRateController.stream;
  Stream<int> get spO2RateStream => _spO2Controller.stream;
  Stream<double> get bodyTempStream => _bodyTempController.stream;
  Stream<int> get sbpRateStream => _sbpController.stream;
  Stream<int> get dbpRateStream => _dbpController.stream;
  Stream<int> get respRateStream => _rrController.stream;

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
    // Split the data into lines (assuming '\n' is the delimiter)
    final lines = rawData.split('\n');

    // Process all complete lines except the last one (it may be incomplete)
    for (int i = 0; i < lines.length - 1; i++) {
      final line = lines[i].split(':');
      if (line.length < 2) {
        print("Invalid data format: $line");
        continue;
      }

      final String check = line[0].trim();

      switch (check) {
        case 'BPM':
          int? heartRate = int.tryParse(line[1]);
          if (heartRate != null && heartRate > 0 && heartRate < 255) {
            _heartRateController.add(heartRate); // Emit valid heart rate
            print("Heart Rate Stream emitted: $heartRate");
          } else {
            print("Invalid heart rate data: $line");
          }
          break;
        case 'SpO2':
          int? spO2 = int.tryParse(line[1]);
          if (spO2 != null) {
            _spO2Controller.add(spO2); // SpO2 rate
            print("SPO2 Stream emitted: $spO2");
          } else {
            print("Invalid SpO2 data: $line");
          }
          break;
        case 'BTemp':
          double? temp = double.tryParse(line[1]);
          if (temp != null) {
            _bodyTempController.add(temp); // Body temperature
            print("BTemp Stream emitted: $temp");
          } else {
            print("Invalid body temperature data: $line");
          }
          break;
        case 'ESBP':
          int? esbp = int.tryParse(line[1]);
          if (esbp != null) {
            _sbpController.add(esbp); // Systolic blood pressure
            print("ESBP Stream emitted: $esbp");
          } else {
            print("Invalid Systolic BP data: $line");
          }
          break;
        case 'EDBP':
          int? edbp = int.tryParse(line[1]);
          if (edbp != null) {
            _dbpController.add(edbp); // Diastolic blood pressure
            print("EDBP Stream emitted: $edbp");
          } else {
            print("Invalid Diastolic BP data: $line");
          }
          break;

        case 'RRate':
          int? rrate = int.tryParse(line[1]);
          if (rrate != null) {
            _rrController.add(rrate); // Respiration rate
            print("RRate Stream emitted: $rrate");
          } else {
            print("Invalid Respiration rate data: $line");
          }
          break;
        default:
          print("Unknown data type: $line");
          break;
      }
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
    print("Disposed of resources and closed the port");
  }
}
