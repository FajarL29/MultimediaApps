import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/service/read_airquality.dart';
import 'package:multimedia_apps/presentation/widget/airquality/airqualitywidget.dart';

class AirQualityApp extends StatefulWidget {
  const AirQualityApp({super.key});

  @override
  State<AirQualityApp> createState() => _AirQualityAppState();
}

class _AirQualityAppState extends State<AirQualityApp> {
  late ReadAirquality _airqualityService;
  bool isO2On = false;
  bool isAirPurifierOn = false;
  double _currentco = 0;
  double _currentco2 = 0;
  double _currentpm25 = 0;
  double _currentpm10 = 0;
  double _currenttemp = 0;
  double _currento2 = 0;
  double _currenthum = 0;
  int _currentCor = 0;
  int _currentApr = 0;
  int _currentAqi = 0;

  String getAirPurifierStatus() {
    if (_currentco > 9 ||
        _currentco2 > 600 ||
        _currentpm25 > 20 ||
        _currentpm10 > 20) {
      return 'ON';
    }
    return 'OFF';
  }

  String getO2ConcentratorStatus() {
    if (_currento2 < 19) {
      return 'ON';
    }
    return 'OFF';
  }

  void toggleDevice(String deviceType) {
    if (deviceType == 'Air Purifier' || deviceType == 'Both') {
      bool newState = !isAirPurifierOn;
      _airqualityService.sendData({
        'action': newState ? 'turn_on_relay' : 'turn_off_relay',
        'relay_code': '6',
      });
      setState(() {
        isAirPurifierOn = newState;
      });
    }

    if (deviceType == 'O2 Concentrator' || deviceType == 'Both') {
      bool newState = !isO2On;
      _airqualityService.sendData({
        'action': newState ? 'turn_on_relay' : 'turn_off_relay',
        'relay_code': '5',
      });
      setState(() {
        isO2On = newState;
      });
    }

    // Optional: logika tambahan jika kedua perangkat aktif
    if (isAirPurifierOn && isO2On) {}
  }

  @override
  void initState() {
    super.initState();
    _airqualityService = ReadAirquality();
    _airqualityService.startListening();

    _airqualityService.coStream.listen((co) {
      setState(() => _currentco = co.toDouble());
    });

    _airqualityService.co2Stream.listen((co2) {
      setState(() => _currentco2 = co2.toDouble());
    });

    _airqualityService.pm25Stream.listen((pm25) {
      setState(() => _currentpm25 = pm25.toDouble());
    });

    _airqualityService.pm10Stream.listen((pm10) {
      setState(() => _currentpm10 = pm10.toDouble());
    });

    _airqualityService.tempStream.listen((temp) {
      setState(() => _currenttemp = temp.toDouble());
    });

    _airqualityService.o2Stream.listen((o2) {
      setState(() => _currento2 = o2.toDouble());
    });

    _airqualityService.humStream.listen((hum) {
      setState(() => _currenthum = hum.toDouble());
    });

    _airqualityService.co2RelayStatus.listen((cor) {
      setState(() => _currentCor = cor);
    });

    _airqualityService.airPurifierRelayStatus.listen((apr) {
      setState(() => _currentApr = apr);
    });

    _airqualityService.airQualityIndexStatus.listen((aqi) {
      setState(() => _currentAqi = aqi);
      //print("status $_currentAqi");
    });
  }

  @override
  void dispose() {
    _airqualityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Header with app bar
                _buildAppBar(),

                const SizedBox(height: 20),

                // Status Dashboard Card
                _buildStatusDashboard(),

                const SizedBox(height: 20),

                // Pollutant Readings Section
                _buildPollutantReadings(),

                const SizedBox(height: 20),

                // Air Quality Gauge
                _buildAirQualityGauge(),

                const SizedBox(height: 20),

                // Device Controls
                _buildDeviceControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 22,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "AIR QUALITY MONITOR",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // Add refresh functionality if needed
            },
            icon: const Icon(
              Icons.refresh_rounded,
              color: Colors.white,
              size: 22,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDashboard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Environment Status",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildEnvironmentCard(
                      "Temperature",
                      "${_currenttemp.toStringAsFixed(1)}°C",
                      "assets/images/airtemp.png",
                      _getTemperatureStatus(),
                      _getTemperatureColor(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEnvironmentCard(
                      "Humidity",
                      "${_currenthum.toStringAsFixed(1)}%",
                      "assets/images/humid.png",
                      _getHumidityStatus(),
                      _getHumidityColor(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEnvironmentCard(
                      "Oxygen",
                      "${_currento2.toStringAsFixed(1)}%",
                      "assets/images/o2.png",
                      _getOxygenStatus(),
                      _getOxygenColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTemperatureStatus() {
    if (_currenttemp < 18) return "Too Cold";
    if (_currenttemp > 25) return "Too Hot";
    return "Normal";
  }

  Color _getTemperatureColor() {
    if (_currenttemp < 18) return Colors.blue;
    if (_currenttemp > 25) return Colors.red;
    return Colors.green;
  }

  String _getHumidityStatus() {
    if (_currenthum < 40) return "Too Dry";
    if (_currenthum > 60) return "Too Humid";
    return "Normal";
  }

  Color _getHumidityColor() {
    if (_currenthum < 40) return Colors.orange;
    if (_currenthum > 60) return Colors.blue;
    return Colors.green;
  }

  String _getOxygenStatus() {
    if (_currento2 < 19) return "Low";
    if (_currento2 > 21) return "High";
    return "Normal";
  }

  Color _getOxygenColor() {
    if (_currento2 < 19) return Colors.red;
    if (_currento2 > 21) return Colors.blue;
    return Colors.green;
  }

  Widget _buildEnvironmentCard(String title, String value, String iconPath,
      String status, Color statusColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(iconPath, width: 20, height: 20),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPollutantReadings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pollutant Readings",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildPollutantCard(
                      "CO",
                      _currentco.toStringAsFixed(1),
                      "ppm",
                      _getPollutantStatus(_currentco, 9))),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildPollutantCard(
                      "CO₂",
                      _currentco2.toStringAsFixed(0),
                      "ppm",
                      _getPollutantStatus(_currentco2, 600))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildPollutantCard(
                      "PM2.5",
                      _currentpm25.toStringAsFixed(1),
                      "μg/m³",
                      _getPollutantStatus(_currentpm25, 20))),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildPollutantCard(
                      "PM10",
                      _currentpm10.toStringAsFixed(1),
                      "μg/m³",
                      _getPollutantStatus(_currentpm10, 20))),
            ],
          ),
        ],
      ),
    );
  }

  PollutantStatus _getPollutantStatus(double value, double threshold) {
    if (value <= threshold * 0.5) {
      return PollutantStatus(Colors.green, "Good");
    } else if (value <= threshold) {
      return PollutantStatus(Colors.yellow, "Fair");
    } else if (value <= threshold * 1.5) {
      return PollutantStatus(Colors.orange, "Poor");
    } else {
      return PollutantStatus(Colors.red, "Bad");
    }
  }

  Widget _buildPollutantCard(
      String title, String value, String unit, PollutantStatus status) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: status.color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: status.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status.message,
              style: TextStyle(
                color: status.color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirQualityGauge() {
    // This is a placeholder for your existing AQGaugeWidget
    // You can style the container if needed
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // const Text(
          //   "Air Quality Index",
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.white,
          //   ),
          // ),
          const SizedBox(height: 16),
          // Use your existing gauge widget here
          AQGaugeWidget(
            aqvalue: _currentAqi,
            gaugetitle: 'Air Quality Index',
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceControls() {
    final bool shouldRecommendPurifier =
        getAirPurifierStatus() == 'ON' && !isAirPurifierOn;
    final bool shouldRecommendO2 = getO2ConcentratorStatus() == 'ON' && !isO2On;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildDeviceControlCard(
            "Air Purifier",
            "assets/images/airpurifier.png",
            isAirPurifierOn,
            shouldRecommendPurifier,
            () => toggleDevice('Air Purifier'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDeviceControlCard(
            "O2 Concentrator",
            "assets/images/o2concentrator.png",
            isO2On,
            shouldRecommendO2,
            () => toggleDevice('O2 Concentrator'),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceControlCard(String title, String iconPath, bool isActive,
      bool isRecommended, VoidCallback onToggle) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isActive
                ? [Color(0xFF40c057), Color(0xFF2b9348)]
                : [Color(0xFF495057), Color(0xFF343a40)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? Color(0xFF40c057).withOpacity(0.3)
                  : Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: isRecommended && !isActive
              ? Border.all(color: Colors.orangeAccent, width: 2)
              : Border.all(color: Colors.transparent),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Image.asset(iconPath, width: 28, height: 28),
                // const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                _buildToggleSwitch(isActive),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status:",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isActive ? "RUNNING" : "STANDBY",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (isRecommended && !isActive)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Colors.orangeAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Recommended: Turn ON",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
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

  Widget _buildToggleSwitch(bool isActive) {
    return Container(
      width: 50,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isActive
            ? Colors.white.withOpacity(0.3)
            : Colors.white.withOpacity(0.1),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            left: isActive ? 24 : 0,
            top: 3,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAbnormalPopup(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

class PollutantStatus {
  final Color color;
  final String message;

  PollutantStatus(this.color, this.message);
}
