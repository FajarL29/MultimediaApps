import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_apps/core/service/file_stroge_helper.dart';

class HeartRateApp1 extends StatefulWidget {
  const HeartRateApp1({super.key});

  @override
  HeartRateApp1State createState() => HeartRateApp1State();
}

class HeartRateApp1State extends State<HeartRateApp1> {
  List<FlSpot> _chartData = [];
  List<String> _timeLabels = [];
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _loadDataFromFile();
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _loadDataFromFile();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  void resetChart() {
    setState(() {
      _chartData.clear();
      _timeLabels.clear();
    });
  }

  Future<void> _loadDataFromFile() async {
    final content = await FileStorageHelper.readHealthData();
    final lines = content.split('\n').where((line) => line.trim().isNotEmpty).toList();

    final List<FlSpot> spots = [];
    final List<String> timeLabels = [];

    int index = 0;
    for (final line in lines) {
      try {
        if (line.contains("BPM")) {
          final parts = line.split(' - ');
          if (parts.length != 2) continue;

          final time = DateTime.parse(parts[0]);
          final value = int.parse(parts[1].replaceAll('BPM:', '').trim());

          spots.add(FlSpot(index.toDouble(), value.toDouble()));
          timeLabels.add("${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}");
          index++;
        }
      } catch (e) {
        debugPrint('❌ Gagal parsing line: $line, error: $e');
      }
    }

    const maxPoints = 12;
    if (spots.length > maxPoints) {
      spots.removeRange(0, spots.length - maxPoints);
      timeLabels.removeRange(0, timeLabels.length - maxPoints);
    }

    setState(() {
      _chartData = spots;
      _timeLabels = timeLabels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _chartData.isNotEmpty
        ? AspectRatio(
            aspectRatio: 1.8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 140,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: (_chartData.length > 10) ? 2 : 1,
                        reservedSize: 32,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          return index >= 0 && index < _timeLabels.length
                              ? Transform.rotate(
                                  angle: -0.5,
                                  child: Text(
                                    _timeLabels[index],
                                    style: const TextStyle(color: Colors.white, fontSize: 8),
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, _) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _chartData,
                      isCurved: true,
                      color: Colors.redAccent,
                      barWidth: 2.5,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.redAccent.withOpacity(0.2),
                      ),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  extraLinesData: ExtraLinesData(horizontalLines: [
                    HorizontalLine(
                      y: 100,
                      color: Colors.greenAccent,
                      strokeWidth: 2,
                      dashArray: [8, 4],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 4),
                        style: const TextStyle(color: Colors.greenAccent, fontSize: 10),
                        labelResolver: (_) => 'Normal Max (100)',
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator(color: Colors.white));
  }
}