import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_apps/core/service/read_heartrate2.dart';

class HeartRateApp1 extends StatefulWidget {
  @override
  _HeartRateAppState createState() => _HeartRateAppState();
}

class _HeartRateAppState extends State<HeartRateApp1> {
  late HeartRateService2 _heartRateService;

  // Simpan data heart rate terbaru (max 7)
  final List<int> _heartRateData = [];

  @override
  void initState() {
    super.initState();
    _heartRateService = HeartRateService2();
    _heartRateService.startListening();

    // Listen ke stream heart rate
    _heartRateService.heartRateStream.listen((hr) {
      setState(() {
        // Tambah data heart rate terbaru
        _heartRateData.add(hr);

        // Batasi data max 7 (7 hari atau titik grafik)
        if (_heartRateData.length > 7) {
          _heartRateData.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    _heartRateService.dispose();
    super.dispose();
  }

  // Fungsi untuk convert heart rate list ke spots LineChart
  List<FlSpot> _getHeartRateSpots() {
    return List.generate(_heartRateData.length, (index) {
      // X = index, Y = heart rate value
      return FlSpot(index.toDouble(), _heartRateData[index].toDouble());
    });
  }

  Widget _buildLineChart() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(right: 10, bottom: 10, left: 10, top: 10),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < _heartRateData.length) {
                    return Text("Day ${index + 1}", style: TextStyle(color: Colors.white));
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 20,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  return Text("${value.toInt()}", style: TextStyle(color: Colors.white));
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _getHeartRateSpots(),
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF334EAC),
      body: Center(
        child: _buildLineChart(),
      ),
    );
  }
}
