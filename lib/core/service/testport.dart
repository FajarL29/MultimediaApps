import 'package:flutter_libserialport/flutter_libserialport.dart';

void main() {
  final port = SerialPort('/dev/ttyACM0'); // Replace with your actual port name
  String rawData = '';
  try {
    if (port.openReadWrite()) {
      print('Port opened successfully!');
      var reader = SerialPortReader(port);
      reader.stream.listen((data) {
        rawData += String.fromCharCodes(data);
        print(rawData);
      });
    } else {
      print('Failed to open port: ${SerialPort.lastError}');
    }
  } on SerialPortError catch (e) {
    print('Error: ${e.message}');
  }
}
