import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/constant/app_color.dart';
import 'package:multimedia_apps/core/service/file_stroge_helper.dart';
import 'package:multimedia_apps/core/service/read_heartrate2.dart';
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

class _HeartRateAppState extends State<HeartRateApp> {
  final GlobalKey<HeartRateApp1State> _chartKey = GlobalKey<HeartRateApp1State>();
 final GlobalKey<HeartRateWidgetState> _bpmKey = GlobalKey<HeartRateWidgetState>();

  double _temperature = 0;
  int _spo2 = 0, _sbp = 0, _dbp = 0, _rr = 0;

  bool _hasTemp = false, _hasSpO2 = false, _hasBP = false, _hasRR = false, _popupShown = false;

  @override
  void initState() {
    super.initState();
    final service = widget.heartRateService;

    service.bodyTempStream.listen((v) => _update(() {
      _temperature = v;
      _hasTemp = true;
    }));

    service.spO2RateStream.listen((v) => _update(() {
      _spo2 = v;
      _hasSpO2 = true;
    }));

    service.sbpRateStream.listen((v) => _update(() {
      _sbp = v;
      _hasBP = true;
    }));

    service.dbpRateStream.listen((v) => _update(() {
      _dbp = v;
      _hasBP = true;
    }));

    service.respRateStream.listen((v) => _update(() {
      _rr = v;
      _hasRR = true;
    }));
  }

  void _update(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
    _checkAndShowPopupOnce();
  }

  void _checkAndShowPopupOnce() {
    if (!_popupShown && _hasTemp && _hasBP && _hasRR && _hasSpO2) {
      _popupShown = true;
      final status = _isHealthy() ? "HEALTHY" : "UNHEALTHY";
      final message = status == "HEALTHY"
          ? "All your vital signs are within the safe range."
          : _generateWarnings();
      _showAbnormalPopup(status, message);
    }
  }

  bool _isHealthy() =>
      _temperature <= 38 && _spo2 >= 95 && _sbp <= 120 && _dbp <= 80 && _rr <= 22;

  String _generateWarnings() {
    final warnings = <String>[];
    if (_temperature > 38) warnings.add("High temperature");
    if (_spo2 < 95) warnings.add("Low SpO2");
    if (_sbp > 120 || _dbp > 80) warnings.add("Abnormal blood pressure");
    if (_rr > 22) warnings.add("High respiratory rate");
    return warnings.join(", ");
  }

  void _showAbnormalPopup(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AbnormalPopupDialog(
        title: "Health Check Result: $title",
        message: message,
        isHealthy: title == "HEALTHY",
      ),
    );
  }

  void _resetTest() {
    setState(() {
      _temperature = 0;
      _spo2 = 0;
      _sbp = 0;
      _dbp = 0;
      _rr = 0;
      _hasTemp = _hasSpO2 = _hasBP = _hasRR = _popupShown = false;
    });
    _bpmKey.currentState?.resetBPM();
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.heartRateService;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildHeader(context),
          _buildLivePreview(service),
          _buildVitals(),
          _buildBottomActions(service),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Expanded(
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
    );
  }

  Widget _buildLivePreview(HeartRateService2 service) {
    return Expanded(
      flex: 3,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF334EAC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: HeartRateWidget(
                      key: _bpmKey,
                      heartRateStream: service.heartRateStream,
                      fingerDetectedStream: service.fingerDetectedStream,
                      fingerModeStream: service.fingerModeStream,
                      initialFingerDetected: service.currentFingerDetected,
                      initialFingerMode: service.currentFingerMode,
                    ),
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
    );
  }

  Widget _buildVitals() {
    return Expanded(
      flex: 4,
      child: Row(
        children: [
          Expanded(child: BodyTemperatureWidget(temperature: _temperature, isCelsius: true)),
          Expanded(child: SpO2Widget(spO2rate: _spo2)),
          Expanded(child: RespirationRateWidget(respirationRate: _rr)),
          Expanded(child: BloodPressureWidget(systolic: _sbp, diastolic: _dbp)),
        ],
      ),
    );
  }

  Widget _buildBottomActions(HeartRateService2 service) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionButton("Reset Check", Icons.refresh, _resetTest),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 80,
              child: HeartBeatWaveform(
                heartRateStream: service.heartRateStream,
                fingerDetectedStream: service.fingerDetectedStream,
                fingerModeStream: service.fingerModeStream,
                initialFingerDetected: service.currentFingerDetected,
                initialFingerMode: service.currentFingerMode,
              ),
            ),
          ),
        ),
        _actionButton("Reset Grafik", Icons.refresh, () async {
          await FileStorageHelper.clearHealthData();
          _chartKey.currentState?.resetChart();
        }),
      ],
    );
  }

  Widget _actionButton(String label, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}