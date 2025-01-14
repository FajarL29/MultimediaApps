import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serial Port Communication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SerialPortPage(),
    );
  }
}

class SerialPortPage extends StatefulWidget {
  @override
  _SerialPortPageState createState() => _SerialPortPageState();
}

class _SerialPortPageState extends State<SerialPortPage> {
  final SerialPort _port =
      SerialPort('/dev/ttyACM0'); // Replace with actual port
  String _rawData = '';
  String _status = 'Connecting...';

  // Variables to store parsed values
  String _bpm = '';
  String _spo2 = '';
  String _bTemp = '';
  String _esbp = '';
  String _edbp = '';
  String _rRate = '';

  @override
  void initState() {
    super.initState();
    _initializeSerialPort();
  }

  Future<void> _initializeSerialPort() async {
    try {
      if (_port.openReadWrite()) {
        setState(() {
          _status = 'Port opened successfully!';
        });

        var reader = SerialPortReader(_port);
        reader.stream.listen((data) {
          setState(() {
            _rawData +=
                String.fromCharCodes(data); // Append new data to the raw data
            _parseRawData(); // Call the parsing function when new data is received
          });
        });
      } else {
        setState(() {
          _status = 'Failed to open port: ${SerialPort.lastError}';
        });
      }
    } on SerialPortError catch (e) {
      setState(() {
        _status = 'Error: ${e.message}';
      });
    }
  }

  // Function to parse the raw data and extract values
  void _parseRawData() {
    // Split the raw data by '\n' (line breaks)
    final lines = _rawData.split('\n');

    // Process each line to extract the relevant data
    for (String line in lines) {
      if (line.startsWith('BPM:')) {
        _bpm = line.split(':')[1].trim();
      } else if (line.startsWith('SpO2:')) {
        _spo2 = line.split(':')[1].trim();
      } else if (line.startsWith('BTemp:')) {
        _bTemp = line.split(':')[1].trim();
      } else if (line.startsWith('ESBP:')) {
        _esbp = line.split(':')[1].trim();
      } else if (line.startsWith('EDBP:')) {
        _edbp = line.split(':')[1].trim();
      } else if (line.startsWith('RRate:')) {
        _rRate = line.split(':')[1].trim();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _port.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Serial Port Communication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display status message
            Text(
              _status,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display parsed data in containers
            _buildDataContainer('BPM', _bpm),
            _buildDataContainer('SpO2', _spo2),
            _buildDataContainer('BTemp', _bTemp),
            _buildDataContainer('ESBP', _esbp),
            _buildDataContainer('EDBP', _edbp),
            _buildDataContainer('RRate', _rRate),
          ],
        ),
      ),
    );
  }

  // Helper function to build containers for each value
  Widget _buildDataContainer(String label, String value) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Waiting for data...' : value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
