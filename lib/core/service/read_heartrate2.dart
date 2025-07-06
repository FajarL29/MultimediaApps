import 'dart:async';
import 'dart:developer';
import 'package:libserialport/libserialport.dart';
import 'package:multimedia_apps/core/service/file_stroge_helper.dart';

class HeartRateService2 {
  SerialPort? _port;
  SerialPortReader? _reader;

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
      final ports = SerialPort.availablePorts;
      print('🔍 Available Ports: $ports');

      for (var portName in ports) {
        final port = SerialPort(portName);
        print('🔎 Checking port: ${port.name}, Serial: ${port.serialNumber}');

        if (port.serialNumber == '5A46067265') {
          _port = port;
          break;
        }
      }

      if (_port == null) {
        print('❌ Serial port not found!');
        return;
      }

      if (!_port!.openReadWrite()) {
        print('❌ Failed to open port: ${_port!.name}');
        return;
      }

      _port!.config = SerialPortConfig()
        ..baudRate = 115200
        ..bits = 8
        ..stopBits = 1
        ..parity = SerialPortParity.none
        ..setFlowControl(SerialPortFlowControl.none);

      print('✅ Port opened: ${_port!.name}');

      _reader = SerialPortReader(_port!);
      print('🎧 Listening to stream...');

      _reader!.stream.listen(
        (data) {
          _rawBuffer += String.fromCharCodes(data);
          log('📦 Raw Buffer: $_rawBuffer');
          _processRawData();
        },
        onError: (error) => print('❌ Stream error: $error'),
        onDone: () => print('✅ Stream closed.'),
      );
    } catch (e, s) {
      print('❌ Exception: $e\n$s');
    }
  }

  void _processRawData() {
    final lines = _rawBuffer.split('\n');
    for (var i = 0; i < lines.length - 1; i++) {
      final line = lines[i].trim();
      if (line.isNotEmpty) _parseLine(line);
    }
    _rawBuffer = lines.last;
  }

  void _parseLine(String lineStr) {
    if (lineStr.contains("Scanning Your Health Condition") || lineStr.contains("Scanning BLE")) {
      _updateFingerStatus(true, lineStr.contains("BLE") ? "BLE" : "NORMAL");
      return;
    }

    if (lineStr.contains("Letakkan jari di sensor")) {
      _updateFingerStatus(false, "NONE");
      return;
    }

    if (!lineStr.contains(":")) {
      log("❌ Gagal parsing line: $lineStr");
      return;
    }

    final parts = lineStr.split(':');
    if (parts.length < 2) return;

    final key = parts[0].trim();
    final value = parts[1].trim();

    switch (key) {
      case 'BPM':
        _addIntData(value, _heartRateController, '❤️ BPM');
        FileStorageHelper.appendHealthData('${DateTime.now().toIso8601String()} - BPM: $value');
        break;
      case 'SpO2':
        _addIntData(value, _spO2Controller, '🫁 SpO2');
        break;
      case 'Body Temp':
        _addDoubleData(value, _bodyTempController, '🌡️ Body Temp');
        break;
      case 'SBP':
        _addIntData(value, _sbpController, '🩸 SBP');
        break;
      case 'DBP':
        _addIntData(value, _dbpController, '🩸 DBP');
        break;
      case 'Respiratory Rate':
        _addIntData(value, _rrController, '🌬️ RR');
        break;
      default:
        log("⚠️ Unrecognized key: $key");
    }
  }

  void _updateFingerStatus(bool detected, String mode) {
    _fingerDetected = detected;
    _lastFingerMode = mode;
    _fingerDetectedController.add(detected);
    _fingerModeController.add(mode);

    final icon = detected ? "🟢" : "🔴";
    final status = detected ? "Finger Detected" : "No Finger Detected";
    log("$icon $status: $mode");
  }

  void _addIntData(String val, StreamController<int> ctrl, String label) {
    final parsed = int.tryParse(val);
    if (_isValid(parsed)) {
      ctrl.add(parsed!);
      log("$label: $parsed");
    }
  }

  void _addDoubleData(String val, StreamController<double> ctrl, String label) {
    final parsed = double.tryParse(val);
    if (parsed != null) {
      ctrl.add(parsed);
      log("$label: $parsed");
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

    _reader?.close();
    _port?.close();
  }
}
