<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/constant/app_color.dart';
import 'package:multimedia_apps/core/constant/app_styles.dart';
import 'package:multimedia_apps/core/service/file_stroge_helper.dart';
import 'package:multimedia_apps/core/service/read_heartrate2.dart';
import 'package:multimedia_apps/main.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/AbnormalPopupDialog.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/bloodpressurewidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/heart_beat_waveform.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/heart_ratewidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/respiratorywidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/spo2widget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/temperature.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/grafik_data.dart';


class HeartRateApp extends StatefulWidget {
  final HeartRateService2 heartRateService;
  
  const HeartRateApp({super.key, required this.heartRateService});

  @override
  State<HeartRateApp> createState() => _HeartRateAppState();
  
}

class _HeartRateAppState extends State<HeartRateApp> with SingleTickerProviderStateMixin {
  final GlobalKey<HeartRateApp1State> _chartKey = GlobalKey<HeartRateApp1State>();
  double _currentTemperature = 0;
  int _sistole = 0;
  int _diastole = 0;
  int _currentspo2 = 0;
  int _currentRR = 0;
  bool finger = false;

  bool _hasTemp = false;
  bool _hasSpO2 = false;
  bool _hasBP = false;
  bool _hasRR = false;
  bool _popupShown = false;

  @override
  void initState() {
    super.initState();

    widget.heartRateService.bodyTempStream.listen((temperature) {
      if (!mounted) return;
      setState(() {
        _currentTemperature = temperature;
        _hasTemp = true;
      });
      _checkAndShowPopupOnce(context);
    });

    widget.heartRateService.sbpRateStream.listen((sbp) {
      if (!mounted) return;
      setState(() {
        _sistole = sbp;
        _hasBP = true;
      });
      _checkAndShowPopupOnce(context);
    });

    widget.heartRateService.dbpRateStream.listen((dbp) {
      if (!mounted) return;
      setState(() {
        _diastole = dbp;
        _hasBP = true;
      });
      _checkAndShowPopupOnce(context);
    });

    widget.heartRateService.respRateStream.listen((rr) {
      if (!mounted) return;
      setState(() {
        _currentRR = rr;
        _hasRR = true;
      });
      _checkAndShowPopupOnce(context);
    });

    widget.heartRateService.spO2RateStream.listen((spo2) {
      if (!mounted) return;
      setState(() {
        _currentspo2 = spo2;
        _hasSpO2 = true;
      });
      _checkAndShowPopupOnce(context);
    });
    widget.heartRateService.fingerDetectedStream.listen((isFingerDetected) {
      if (!mounted) return;
      setState(() {
        finger = isFingerDetected;
        
        
      });
    });
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


void _checkAndShowPopupOnce(context) {
  if (!_popupShown && _hasTemp && _hasBP && _hasRR && _hasSpO2) {
    _popupShown = true;
    final status = getHealthStatus();
    final message = status == 'HEALTHY'
        ? "All your vital signs are within the safe range."
        : _generateWarningMessage();
    showAbnormalPopup(context, "Health Check Result: $status", message);
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
 void showAbnormalPopup(BuildContext context, String title, String message) {
  final isHealthy = title.toUpperCase().contains('HEALTHY');

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AbnormalPopupDialog(
      title: title,
      message: message,
      isHealthy: isHealthy,
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
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
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: HeartRateWidget(heartRateStream: widget.heartRateService.heartRateStream),
                        ),
                        Expanded(
                        child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: HeartRateApp1(key: _chartKey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                child: HeartBeatWaveform(heartRateStream: widget.heartRateService.heartRateStream,
                fingerDetectedStream:widget.heartRateService.fingerDetectedStream, heartRateService: heartRateService, initialFingerDetected: widget.heartRateService.isFingerDetected,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FileStorageHelper.clearHealthData();
                    _chartKey.currentState?.resetChart();
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text("Reset Grafik", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/constant/app_color.dart';
import 'package:multimedia_apps/core/constant/app_styles.dart';
import 'package:multimedia_apps/core/service/file_stroge_helper.dart';
import 'package:multimedia_apps/core/service/read_heartrate2.dart';
import 'package:multimedia_apps/main.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/AbnormalPopupDialog.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/bloodpressurewidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/heart_beat_waveform.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/heart_ratewidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/respiratorywidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/spo2widget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/temperature.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/grafik_data.dart';


class HeartRateApp extends StatefulWidget {
  final HeartRateService2 heartRateService;
  
  const HeartRateApp({super.key, required this.heartRateService});

  @override
  State<HeartRateApp> createState() => _HeartRateAppState();
  
}

class _HeartRateAppState extends State<HeartRateApp> with SingleTickerProviderStateMixin {
  final GlobalKey<HeartRateApp1State> _chartKey = GlobalKey<HeartRateApp1State>();
  double _currentTemperature = 0;
  int _sistole = 0;
  int _diastole = 0;
  int _currentspo2 = 0;
  int _currentRR = 0;
  bool finger = false;

  bool _hasTemp = false;
  bool _hasSpO2 = false;
  bool _hasBP = false;
  bool _hasRR = false;
  bool _popupShown = false;

  @override
  void initState() {
    super.initState();

    widget.heartRateService.bodyTempStream.listen((temperature) {
      if (!mounted) return;
      setState(() {
        _currentTemperature = temperature;
        _hasTemp = true;
      });
      _checkAndShowPopupOnce(context);
    });

    widget.heartRateService.sbpRateStream.listen((sbp) {
      if (!mounted) return;
      setState(() {
        _sistole = sbp;
        _hasBP = true;
      });
      _checkAndShowPopupOnce(context);
    });

    widget.heartRateService.dbpRateStream.listen((dbp) {
      if (!mounted) return;
      setState(() {
        _diastole = dbp;
        _hasBP = true;
      });
      _checkAndShowPopupOnce(context);
    });

    widget.heartRateService.respRateStream.listen((rr) {
      if (!mounted) return;
      setState(() {
        _currentRR = rr;
        _hasRR = true;
      });
      _checkAndShowPopupOnce(context);
    });

    widget.heartRateService.spO2RateStream.listen((spo2) {
      if (!mounted) return;
      setState(() {
        _currentspo2 = spo2;
        _hasSpO2 = true;
      });
      _checkAndShowPopupOnce(context);
    });
    widget.heartRateService.fingerDetectedStream.listen((isFingerDetected) {
      if (!mounted) return;
      setState(() {
        finger = isFingerDetected;
        
        
      });
    });
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


void _checkAndShowPopupOnce(context) {
  if (!_popupShown && _hasTemp && _hasBP && _hasRR && _hasSpO2) {
    _popupShown = true;
    final status = getHealthStatus();
    final message = status == 'HEALTHY'
        ? "All your vital signs are within the safe range."
        : _generateWarningMessage();
    showAbnormalPopup(context, "Health Check Result: $status", message);
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
 void showAbnormalPopup(BuildContext context, String title, String message) {
  final isHealthy = title.toUpperCase().contains('HEALTHY');

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AbnormalPopupDialog(
      title: title,
      message: message,
      isHealthy: isHealthy,
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
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
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: HeartRateWidget(heartRateStream: widget.heartRateService.heartRateStream),
                        ),
                        Expanded(
                        child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: HeartRateApp1(key: _chartKey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                child: HeartBeatWaveform(heartRateStream: widget.heartRateService.heartRateStream,
                fingerDetectedStream:widget.heartRateService.fingerDetectedStream, heartRateService: heartRateService, initialFingerDetected: widget.heartRateService.isFingerDetected,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FileStorageHelper.clearHealthData();
                    _chartKey.currentState?.resetChart();
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text("Reset Grafik", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
>>>>>>> manual-book
