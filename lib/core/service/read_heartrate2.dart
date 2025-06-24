import 'dart:async';
import 'dart:developer';
import 'package:libserialport/libserialport.dart';
import 'package:multimedia_apps/core/service/file_stroge_helper.dart';

class HeartRateService2 {
  late SerialPort _port;
  late SerialPortReader _reader;

  bool _fingerDetected = false;
  String _lastFingerMode = "NONE";
  String _rawBuffer = '';

  bool get currentFingerDetected => _fingerDetected;
  String get currentFingerMode => _lastFingerMode;

  final _heartRateController = StreamController<int>.broadcast();
  final _spO2Controller = StreamController<int>.broadcast();
  final _bodyTempController = StreamController<double>.broadcast();
  final _sbpController = StreamController<int>.broadcast();
  final _dbpController = StreamController<int>.broadcast();
  final _rrController = StreamController<int>.broadcast();
  final _fingerDetectedController = StreamController<bool>.broadcast();
  final _fingerModeController = StreamController<String>.broadcast();

  Stream<int> get heartRateStream => _heartRateController.stream;
  Stream<int> get spO2RateStream => _spO2Controller.stream;
  Stream<double> get bodyTempStream => _bodyTempController.stream;
  Stream<int> get sbpRateStream => _sbpController.stream;
  Stream<int> get dbpRateStream => _dbpController.stream;
  Stream<int> get respRateStream => _rrController.stream;
  Stream<bool> get fingerDetectedStream => _fingerDetectedController.stream;
  Stream<String> get fingerModeStream => _fingerModeController.stream;

  HeartRateService2();

  void startListening() {
    try {
      _port = SerialPort("COM28");
      _port.openReadWrite();

      _port.config = SerialPortConfig()
        ..baudRate = 115200
        ..bits = 8
        ..stopBits = 1
        ..parity = SerialPortParity.none
        ..setFlowControl(SerialPortFlowControl.none);

      _reader = SerialPortReader(_port);
      _reader.stream.listen((data) {
        final chunk = String.fromCharCodes(data);
        _rawBuffer += chunk;
        _processRawData();
      }, onError: (err) {
        log("❌ Serial read error: $err");
      });
    } catch (e, s) {
      log('❌ Error during port setup: $e\n$s');
    }
  }

//   void startListening() {
//   try {
//     final listPort = SerialPort.availablePorts;
//     print('Available Ports: $listPort'); // Debugging

//     for (var port in listPort) {
//       var p = SerialPort(port);
//       print('Checking port: ${p.name}, Serial: ${p.serialNumber}');

//       if (p.serialNumber == '5735016773') {
//         _port = SerialPort(p.name!);
//         p.close();
//         break; // Exit loop once found
//       }
//     }

//     if (_port == null) {
//       print('❌ Error: Serial port not found!');
//       return;
//     }

//     print('✅ Selected Port: ${_port.name}');

//     if (!_port.openReadWrite()) {
//       print('❌ Error: Failed to open port ${_port.name}');
//       return;
//     }

//     print('✅ Port opened successfully.');

//     final config = _port.config;
//     config.baudRate = 115200;
//     _port.config = config;

//     _reader = SerialPortReader(_port);
    
//     // Check if _reader is successfully initialized
//     if (_reader == null) {
//       print('❌ Error: Failed to initialize SerialPortReader.');
//       return;
//     }

//     print('🎧 Listening to stream...');
    
//     _reader.stream.listen((data) {
//       rawData += String.fromCharCodes(data);
//       log('DATA : $rawData');

//       processRawData();
//     }, onError: (error) {
//       print('❌ Stream error: $error');
//     }, onDone: () {
//       print('✅ Stream closed.');
//     });


//   } catch (e) {
//     print('❌ Exception during port setup: $e');
//   }
// }

  void _processRawData() {
    final lines = _rawBuffer.split('\n');

    for (int i = 0; i < lines.length - 1; i++) {
      final line = lines[i].trim();
      if (line.isNotEmpty) _parseLine(line);
    }

    _rawBuffer = lines.last;
  }

  void _parseLine(String lineStr) {
    if (lineStr.contains("Scanning Your Health Condition")) {
      _fingerDetected = true;
      _fingerDetectedController.add(true);

      if (lineStr.contains("BLE")) {
        _lastFingerMode = "BLE";
        _fingerModeController.add("BLE");
        log("🟢 Finger Detected: BLE");
      } else {
        _lastFingerMode = "NORMAL";
        _fingerModeController.add("NORMAL");
        log("🟢 Finger Detected: NORMAL");
      }
      return;
    }

    if (lineStr.contains("Letakkan jari di sensor")) {
      _fingerDetected = false;
      _lastFingerMode = "NONE";
      _fingerDetectedController.add(false);
      _fingerModeController.add("NONE");
      log("🔴 No Finger Detected");
      return;
    }

    final parts = lineStr.split(':');
    if (parts.length < 2) return;

    final key = parts[0].trim();
    final value = parts[1].trim();

    switch (key) {
      case 'BPM':
        final bpm = int.tryParse(value);
        if (_isValid(bpm)) {
          _heartRateController.add(bpm!);
          FileStorageHelper.appendHealthData('${DateTime.now().toIso8601String()} - BPM: $bpm');
          log("❤️ BPM: $bpm");
        }
        break;

      case 'SpO2':
        final spo2 = int.tryParse(value);
        if (_isValid(spo2)) {
          _spO2Controller.add(spo2!);
          log("🫁 SpO2: $spo2");
        }
        break;

      case 'Body Temp':
        final temp = double.tryParse(value);
        if (temp != null) {
          _bodyTempController.add(temp);
          log("🌡️ Body Temp: $temp");
        }
        break;

      case 'SBP':
        final sbp = int.tryParse(value);
        if (_isValid(sbp)) {
          _sbpController.add(sbp!);
          log("🩸 SBP: $sbp");
        }
        break;

      case 'DBP':
        final dbp = int.tryParse(value);
        if (_isValid(dbp)) {
          _dbpController.add(dbp!);
          log("🩸 DBP: $dbp");
        }
        break;

      case 'Respiratory Rate':
        final rr = int.tryParse(value);
        if (_isValid(rr)) {
          _rrController.add(rr!);
          log("🌬️ RR: $rr");
        }
        break;
    }
  }

  bool _isValid(int? value) => value != null && value > 0 && value < 255;

  void dispose() {
    _heartRateController.close();
    _spO2Controller.close();
    _bodyTempController.close();
    _sbpController.close();
    _dbpController.close();
    _rrController.close();
    _fingerDetectedController.close();
    _fingerModeController.close();
    _reader.close();
    _port.close();
  }
}
