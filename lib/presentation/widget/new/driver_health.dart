import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/constant/app_color.dart';
import 'package:multimedia_apps/core/constant/app_styles.dart';
import 'package:multimedia_apps/core/service/read_heartrate2.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/bloodpressurewidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/heart_beat_waveform.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/heart_ratewidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/heartratetablewidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/respiratorywidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/spo2widget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/temperature.dart';

class HeartRateApp extends StatefulWidget {
  const HeartRateApp({super.key});

  @override
  State<HeartRateApp> createState() => _HeartRateAppState();
}

class _HeartRateAppState extends State<HeartRateApp> with SingleTickerProviderStateMixin {
  late HeartRateService2 _heartRateService;
  double _currentTemperature = 0;
  int _sistole = 0;
  int _diastole = 0;
  int _currentspo2 = 0;
  int _currentRR = 0;
  bool _finger = false;

  bool _hasTemp = false;
  bool _hasSpO2 = false;
  bool _hasBP = false;
  bool _hasRR = false;
  bool _popupShown = false;
  //bool _finger = false;


  // late AnimationController _controller;
  // late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _heartRateService = HeartRateService2();
    _heartRateService.startListening();

    // _controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 5),
    // )..repeat();

    // _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _heartRateService.bodyTempStream.listen((temperature) {
      setState(() {
        _currentTemperature = temperature;
        _hasTemp = true;
      });
      _checkAndShowPopupOnce();
    });

    _heartRateService.sbpRateStream.listen((sbp) {
      setState(() {
        _sistole = sbp;
        _hasBP = true;
      });
      _checkAndShowPopupOnce();
    });

    _heartRateService.dbpRateStream.listen((dbp) {
      setState(() {
        _diastole = dbp;
        _hasBP = true;
      });
      _checkAndShowPopupOnce();
    });

    _heartRateService.respRateStream.listen((rr) {
      setState(() {
        _currentRR = rr;
        _hasRR = true;
      });
      _checkAndShowPopupOnce();
    });

    _heartRateService.spO2RateStream.listen((spo2) {
      setState(() {
        _currentspo2 = spo2;
        _hasSpO2 = true;
      });
      _checkAndShowPopupOnce();
    });
    _heartRateService.fingerDetectedStream.listen((isFingerDetected) {
      setState(() {
        _finger = isFingerDetected;
        print('status $_finger');
        
      });
      // fingerDetectedStream = true;
    });
  }

  @override
  void dispose() {
    _heartRateService.dispose();
    // _controller.dispose();
    super.dispose();
  }

  String getHealthStatus() {
    if (_currentTemperature > 38 ||
        _sistole > 120 ||
        _diastole > 80 ||
        _currentRR > 22 ||
        _currentspo2 < 95) {
      return 'UNHEALTHY';
    }
    return 'HEALTHY';
  }

  // double _calculateProgress() {
  //   int total = 4;
  //   int completed = (_hasTemp ? 1 : 0) +
  //       (_hasBP ? 1 : 0) +
  //       (_hasRR ? 1 : 0) +
  //       (_hasSpO2 ? 1 : 0);
  //   return completed / total;
  // }

 void _checkAndShowPopupOnce() {
  // print('Checking data...');
  // print('Temperature data available: $_hasTemp');
  // print('Blood Pressure data available: $_hasBP');
  // print('Respiratory Rate data available: $_hasRR');
  // print('SpO2 data available: $_hasSpO2');

  if (!_popupShown && _hasTemp && _hasBP && _hasRR && _hasSpO2) {
    _popupShown = true;
    final status = getHealthStatus();
    final message = status == 'HEALTHY'
        ? "All your vital signs are within the safe range."
        : _generateWarningMessage();
    _showAbnormalPopup("Health Check Result: $status", message);
  }
}


  String _generateWarningMessage() {
    List<String> warnings = [];

    if (_currentTemperature > 38) warnings.add("High temperature detected");
    if (_sistole > 120 || _diastole > 80) warnings.add("Abnormal blood pressure");
    if (_currentRR > 22) warnings.add("High respiration rate");
    if (_currentspo2 < 95) warnings.add("Low SpO2 level");

    return warnings.join(", ");
  }

  void _showAbnormalPopup(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(
              title.contains('HEALTHY') ? Icons.check_circle : Icons.warning,
              color: title.contains('HEALTHY') ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _resetTest() {
    setState(() {
      _currentTemperature = 0;
      _sistole = 0;
      _diastole = 0;
      _currentspo2 = 0;
      _currentRR = 0;

      _hasTemp = false;
      _hasBP = false;
      _hasRR = false;
      _hasSpO2 = false;

      _popupShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
   // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Header
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    "Driver's Health",
                    style: TextStyle(
                      fontSize: 24,
                      color: AppStaticColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Heart Rate Section
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF334EAC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'HEART RATE',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: HeartRateWidget(heartRateStream: _heartRateService.heartRateStream),
                        ),
                        Expanded(
                          child: HeartRateTableWidget(heartRateStream: _heartRateService.heartRateStream),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Reset & Progress
          

          // Other Vitals
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(child: BodyTemperatureWidget(temperature: _currentTemperature, isCelsius: true)),
                Expanded(child: SpO2Widget(spO2rate: _currentspo2)),
                Expanded(child: RespirationRateWidget(respirationRate: _currentRR)),
                Expanded(child: BloodPressureWidget(systolic: _sistole, diastolic: _diastole)),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: _resetTest,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text("Reset Check", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: HeartBeatWaveform(heartRateStream: _heartRateService.heartRateStream,
                fingerDetectedStream:_heartRateService.fingerDetectedStream),
              ),
            ),

            ],
          ),
        ],
      ),
    );
  }
}
