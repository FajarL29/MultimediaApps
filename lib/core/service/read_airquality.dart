import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class ReadAirquality {
  late SerialPort _port ;
  late SerialPortReader _reader;
  final StreamController<double> _coController =
      StreamController<double>.broadcast();
  final StreamController<double> _co2Controller =
      StreamController<double>.broadcast();
  final StreamController<double> _pM25Controller =
      StreamController<double>.broadcast();
  final StreamController<double> _pM10Controller =
      StreamController<double>.broadcast();
  final StreamController<double> _tempController =
      StreamController<double>.broadcast();
  final StreamController<double> _o2Controller =
      StreamController<double>.broadcast();
  final StreamController<double> _humController =
      StreamController<double>.broadcast();
  final StreamController<int> _co2RelayController =
      StreamController<int>.broadcast();
  final StreamController<int> _airPurifierRelayController =
      StreamController<int>.broadcast();
  final StreamController<int> _aqiController =
      StreamController<int>.broadcast();
  String rawData = '';

  ReadAirquality();

  // Expose the stream for widgets to listen to
  Stream<double> get coStream => _coController.stream;
  Stream<double> get co2Stream => _co2Controller.stream;
  Stream<double> get pm25Stream => _pM25Controller.stream;
  Stream<double> get pm10Stream => _pM10Controller.stream;
  // Stream<double> get pmStream => _pMController.stream;
  Stream<double> get tempStream => _tempController.stream;
  Stream<double> get o2Stream => _o2Controller.stream;
  Stream<double> get humStream => _humController.stream;
  Stream<int> get co2RelayStatus => _co2RelayController.stream;
  Stream<int> get airPurifierRelayStatus => _airPurifierRelayController.stream;
  Stream<int> get airQualityIndexStatus => _aqiController.stream;


// void startListening() {
//   try {
//     _port = SerialPort("COM10");
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

  void startListening() {
  try {
    final listPort = SerialPort.availablePorts;
    print('Available Ports: $listPort'); // Debugging

    for (var port in listPort) {
      var p = SerialPort(port);
      print('Checking port: ${p.name}, Serial: ${p.serialNumber}');

      if (p.serialNumber == '5629257603') {
        _port = SerialPort(p.name!);
        p.close();
        break; // Exit loop once found
      }
    }

    if (_port == null) {
      print('❌ Error: Serial port not found!');
      return;
    }

    print('✅ Selected Port: ${_port.name}');

    if (!_port.openReadWrite()) {
      print('❌ Error: Failed to open port ${_port.name}');
      return;
    }

    print('✅ Port opened successfully.');

    final config = _port.config;
    config.baudRate = 115200;
    _port.config = config;

    _reader = SerialPortReader(_port);
    
    // Check if _reader is successfully initialized
    if (_reader == null) {
      print('❌ Error: Failed to initialize SerialPortReader.');
      return;
    }

    print('🎧 Listening to stream...');
    
    _reader.stream.listen((data) {
      rawData += String.fromCharCodes(data);
      log('DATA : $rawData');

      processRawData();
    }, onError: (error) {
      print('❌ Stream error: $error');
    }, onDone: () {
      print('✅ Stream closed.');
    });


  } catch (e) {
    print('❌ Exception during port setup: $e');
  }
}


void sendData(Map<String,dynamic> payload ) {
 String jsonString = jsonEncode(payload);

  // Convert the JSON string to bytes (UTF-8 encoding)
  Uint8List bytes = Uint8List.fromList(utf8.encode(jsonString));
  _reader.port.write(
    bytes
  );
  

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
            print("CO Stream emitted: $co");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
        case 'CO2':
          double? co2 = double.tryParse(line[1]);
          if (co2 != null) {
            _co2Controller.add(co2); // EspO2 heart rate
            print("CO2 Stream emitted: $co2");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
        case 'PM25':
          double? pm = double.tryParse(line[1]);
          if (pm != null) {
            _pM25Controller.add(pm); // Emit valid heart rate
            print("PM Stream emitted: $pm");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
          case 'PM10':
          double? pm = double.tryParse(line[1]);
          if (pm != null) {
            _pM10Controller.add(pm); // Emit valid heart rate
            print("PM Stream emitted: $pm");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
        case 'TEMP':
          double? temp = double.tryParse(line[1]);
          if (temp != null) {
            _tempController.add(temp); // EspO2 heart rate
            print("TEMP Stream emitted: $temp");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
        case 'O2':
          double? o2 = double.tryParse(line[1]);
          if (o2 != null) {
            _o2Controller.add(o2); // EspO2 heart rate
            print("O2 Stream emitted: $o2");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;

        case 'HUM':
          double? hum = double.tryParse(line[1]);
          if (hum != null) {
            _humController.add(hum); // EspO2 heart rate
            print("HUM Stream emitted: $hum");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;
        case 'COR':
          int? status = int.tryParse(line[1]);
          if (status != null) {
            _co2RelayController.add(status); // EspO2 heart rate
            print("COR Stream emitted: $status");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;  
              case 'APR':
          int? status = int.tryParse(line[1]);
          if (status != null) {
            _airPurifierRelayController.add(status); // EspO2 heart rate
            print("APR Stream emitted: $status");
          } else {
            print("Invalid or incomplete data: $line");
          }
          break;  
          case 'Air Quality Index' :
          int? status = int.tryParse(line[1]);
          if (status != null) {
            _aqiController.add(status);
            print("AQI Stream emitted :$status");
          } else {
            print("Invalid or incomplete data: $line");
          }
      } // Remove any extra whitespace
    }

    // Retain the last (incomplete) line in rawData
    rawData = lines.last;
  }


  void dispose() {
    _coController.close();
    _co2Controller.close();
    _pM25Controller.close();
    _pM10Controller.close();
    _tempController.close();
    _o2Controller.close();
    _humController.close();
    _co2RelayController.close();
    _airPurifierRelayController.close();
    _aqiController.close();
    _port.close();
    _reader.close();
  }
}