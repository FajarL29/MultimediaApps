<<<<<<< HEAD
  import 'dart:async';
  //import 'dart:convert';
  //import 'dart:convert';
  import 'dart:developer';
  //import 'dart:typed_data';

  //import 'package:flutter/foundation.dart';
  import 'package:libserialport/libserialport.dart';
  import 'package:multimedia_apps/core/service/file_stroge_helper.dart';

  class HeartRateService2 {

    late SerialPort _port; // Replace with your port
    late SerialPortReader _reader;
    bool fingerDetected = false;
    bool get isFingerDetected => fingerDetected;
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
    final StreamController<int> _rrController =
        StreamController<int>.broadcast();
    final StreamController<bool> fingerDetectedController = 
        StreamController<bool>.broadcast();

    String rawData = '';

    HeartRateService2();

    // Expose the stream for widgets to listen to
    Stream<int> get heartRateStream => _heartRateController.stream;
    Stream<int> get spO2RateStream => _spO2Controller.stream;
    Stream<double> get bodyTempStream => _bodyTempController.stream;
    Stream<int> get sbpRateStream => _sbpController.stream;
    Stream<int> get dbpRateStream => _dbpController.stream;
    Stream<int> get respRateStream => _rrController.stream;
    Stream<bool> get fingerDetectedStream => fingerDetectedController.stream;

    void startListening() {
    try {
      _port = SerialPort("COM25");
      _port.openReadWrite();

      _port.config = SerialPortConfig()
        ..baudRate = 115200
        ..bits = 8
        ..stopBits = 1
        ..parity = SerialPortParity.none
        ..setFlowControl(SerialPortFlowControl.none);

      _reader = SerialPortReader(_port);
      _reader.stream.listen((data) {
        log(String.fromCharCodes(data));
        rawData += String.fromCharCodes(data);
        processRawData();
      });
    } catch (e, s) {
      print('Error during port setup: $e $s');
    }
  }



  //   void startListening() {
  //   try {
  //     SerialPort? tempPort;
  //     final listPort = SerialPort.availablePorts;
  //     for (var port in listPort) {
  //       var p = SerialPort(port);
  //       log('SERIAL : ${p.serialNumber}');
  //       if (p.serialNumber == '5959074742') {
  //         tempPort = SerialPort(p.name!);
  //         p.close();
  //       }
  //     }

  //     if (tempPort == null) {
  //       throw Exception('Port not found');
  //     }

  //     _port = tempPort; // 🔹 Inisialisasi _port se digunakan
  //     _port.openReadWrite();     

  //     _port.config = SerialPortConfig()
  //       ..baudRate = 115200
  //       ..bits = 8
  //       ..stopBits = 1
  //       ..parity = SerialPortParity.none
  //       ..setFlowControl(SerialPortFlowControl.none);

  //     _reader = SerialPortReader(_port);
  //     _reader.stream.listen((data) {
  //       log(String.fromCharCodes(data));
  //       rawData += String.fromCharCodes(data);
  //       processRawData();
  //     });
  //   } catch (e, s) {
  //     if (e.toString() == 'Port not found') {
  //       rawData += Uint8List.fromList(utf8.encode('Port not found')).toString();
  //     }
  //     print('Error during port setup: $e $s');
  //   }
  // }

    void processRawData() {
      // Split the data into lines (assuming '\n' is the delimiter)
      final lines = rawData.split('\n');

      // Process all complete lines except the last one (it may be incomplete)
      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i].split(':');
        final String check = line[0].trim();

        final lineStr = lines[i].trim();
        if (lineStr == "Scanning Your Health Condition") {
          fingerDetected = true;
          print("Jari terdeteksi");
          fingerDetectedController.add(true);
        } else if (lineStr == "Letakkan jari di sensor") {
          fingerDetected = false;
          print("Gaada jari");
          fingerDetectedController.add(false);
        };
        

        switch (check) {
          case 'BPM':
            int? heartRate = int.tryParse(line[1]);
            if (heartRate != null && heartRate > 0 && heartRate < 255) {
              _heartRateController.add(heartRate); 
              final timestamp = DateTime.now().toIso8601String();
              FileStorageHelper.appendHealthData('$timestamp - BPM: $heartRate');
              print('data grafik masuk $timestamp');
              // Emit valid heart rate
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
          case 'Body Temp':
            double? temp = double.tryParse(line[1]);
            if (temp != null) {
              _bodyTempController.add(temp); // EspO2 heart rate
              print("BTemp Stream emitted: $temp");
            } else {
              print("Invalid or incomplete data: $line");
            }
            break;
          case 'SBP':
            int? esbp = int.tryParse(line[1]);
            if (esbp != null) {
              _sbpController.add(esbp); // EspO2 heart rate
              print("ESBP Stream emitted: $esbp");
            } else {
              print("Invalid or incomplete data: $line");
            }
            break;
          case 'DBP':
            int? edbp = int.tryParse(line[1]);
            if (edbp != null) {
              _dbpController.add(edbp); // EspO2 heart rate
              print("EDBP Stream emitted: $edbp");
            } else {
              print("Invalid or incomplete data: $line");
            }
            break;

          case 'Respiratory Rate':
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
      fingerDetectedController.close();
      _port.close();
      _reader.close();
    }
  }
=======
  import 'dart:async';
import 'dart:convert';
  import 'dart:developer';
import 'dart:typed_data';
  import 'package:libserialport/libserialport.dart';
  import 'package:multimedia_apps/core/service/file_stroge_helper.dart';

  class HeartRateService2 {

    late SerialPort _port; 
    late SerialPortReader _reader;
    bool fingerDetected = false;
    bool get isFingerDetected => fingerDetected;
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
    final StreamController<int> _rrController =
        StreamController<int>.broadcast();
    final StreamController<bool> fingerDetectedController = 
        StreamController<bool>.broadcast();

    String rawData = '';

    HeartRateService2();

    Stream<int> get heartRateStream => _heartRateController.stream;
    Stream<int> get spO2RateStream => _spO2Controller.stream;
    Stream<double> get bodyTempStream => _bodyTempController.stream;
    Stream<int> get sbpRateStream => _sbpController.stream;
    Stream<int> get dbpRateStream => _dbpController.stream;
    Stream<int> get respRateStream => _rrController.stream;
    Stream<bool> get fingerDetectedStream => fingerDetectedController.stream;


//----------------------------------------------For in the windows------------------------------------------
  //   void startListening() {
  //   try {
  //     _port = SerialPort("COM25");
  //     _port.openReadWrite();

  //     _port.config = SerialPortConfig()
  //       ..baudRate = 115200
  //       ..bits = 8
  //       ..stopBits = 1
  //       ..parity = SerialPortParity.none
  //       ..setFlowControl(SerialPortFlowControl.none);

  //     _reader = SerialPortReader(_port);
  //     _reader.stream.listen((data) {
  //       log(String.fromCharCodes(data));
  //       rawData += String.fromCharCodes(data);
  //       processRawData();
  //     });
  //   } catch (e, s) {
  //     print('Error during port setup: $e $s');
  //   }
  // }


//----------------------------------------For in the Linux--------------------------------------
    void startListening() {
    try {
      SerialPort? tempPort;
      final listPort = SerialPort.availablePorts;
      for (var port in listPort) {
        var p = SerialPort(port);
        log('SERIAL : ${p.serialNumber}');
        if (p.serialNumber == '5959074742') {
          tempPort = SerialPort(p.name!);
          p.close();
        }
      }

      if (tempPort == null) {
        throw Exception('Port not found');
      }

      _port = tempPort; // 🔹 Inisialisasi _port se digunakan
      _port.openReadWrite();     

      _port.config = SerialPortConfig()
        ..baudRate = 115200
        ..bits = 8
        ..stopBits = 1
        ..parity = SerialPortParity.none
        ..setFlowControl(SerialPortFlowControl.none);

      _reader = SerialPortReader(_port);
      _reader.stream.listen((data) {
        log(String.fromCharCodes(data));
        rawData += String.fromCharCodes(data);
        processRawData();
      });
    } catch (e, s) {
      if (e.toString() == 'Port not found') {
        rawData += Uint8List.fromList(utf8.encode('Port not found')).toString();
      }
      print('Error during port setup: $e $s');
    }
  }

    void processRawData() {
      final lines = rawData.split('\n');
      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i].split(':');
        final String check = line[0].trim();

        final lineStr = lines[i].trim();
        if (lineStr == "Scanning Your Health Condition") {
          fingerDetected = true;
          print("Jari terdeteksi");
          fingerDetectedController.add(true);
        } else if (lineStr == "Letakkan jari di sensor") {
          fingerDetected = false;
          print("Gaada jari");
          fingerDetectedController.add(false);
        };
        

        switch (check) {
          case 'BPM':
            int? heartRate = int.tryParse(line[1]);
            if (heartRate != null && heartRate > 0 && heartRate < 255) {
              _heartRateController.add(heartRate); 
              final timestamp = DateTime.now().toIso8601String();
              FileStorageHelper.appendHealthData('$timestamp - BPM: $heartRate');
              print('data grafik masuk $timestamp');
              // Emit valid heart rate
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
          case 'Body Temp':
            double? temp = double.tryParse(line[1]);
            if (temp != null) {
              _bodyTempController.add(temp); // EspO2 heart rate
              print("BTemp Stream emitted: $temp");
            } else {
              print("Invalid or incomplete data: $line");
            }
            break;
          case 'SBP':
            int? esbp = int.tryParse(line[1]);
            if (esbp != null) {
              _sbpController.add(esbp); // EspO2 heart rate
              print("ESBP Stream emitted: $esbp");
            } else {
              print("Invalid or incomplete data: $line");
            }
            break;
          case 'DBP':
            int? edbp = int.tryParse(line[1]);
            if (edbp != null) {
              _dbpController.add(edbp); // EspO2 heart rate
              print("EDBP Stream emitted: $edbp");
            } else {
              print("Invalid or incomplete data: $line");
            }
            break;

          case 'Respiratory Rate':
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
      fingerDetectedController.close();
      _port.close();
      _reader.close();
    }
  }
>>>>>>> manual-book
