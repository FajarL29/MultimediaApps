import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HeartRateChartWidget extends StatefulWidget {
  final Stream<int> heartRateStream;

  const HeartRateChartWidget({required this.heartRateStream, super.key});

  @override
  _HeartRateChartWidgetState createState() => _HeartRateChartWidgetState();
}

class _HeartRateChartWidgetState extends State<HeartRateChartWidget> {
  final List<HeartRateData> _chartData = [];
  ChartSeriesController? _chartSeriesController;

  @override
  void initState() {
    super.initState();

    // Listen to heart rate stream
    widget.heartRateStream.listen((heartRate) {
      if (_chartSeriesController != null) {
        _addHeartRateData(heartRate);
        // print('test $heartRate');
        String a = DateTime.now().toString();
        print('test $a');
      }
    });
  }

  void _addHeartRateData(int heartRate) {
    final newDataPoint = HeartRateData(DateTime.now(), heartRate);

    // Ensure index safety
    if (_chartData.length > 60) {
      // Remove oldest data point before adding a new one
      _chartSeriesController!.updateDataSource(
        addedDataIndexes: [_chartData.length],
        removedDataIndexes: [0],
      );
      // _chartData.removeAt(0);
    }

    // Add new data point
    _chartData.add(newDataPoint);

    // Update the chart with the new data point
    _chartSeriesController!.updateDataSource(
      addedDataIndexes: [_chartData.length - 1],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Heart Rate Over Time'),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.seconds,
        title: AxisTitle(text: 'Time'),
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(
        borderColor: Colors.red,
        labelStyle: TextStyle(color: Colors.white),
        title: AxisTitle(
            text: 'BPM',
            textStyle:
                TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
        minimum: 50,
        maximum: 150,
      ),
      series: <LineSeries<HeartRateData, DateTime>>[
        LineSeries<HeartRateData, DateTime>(
          color: Colors.redAccent,
          dataSource: _chartData,
          xValueMapper: (HeartRateData data, _) => data.time,
          yValueMapper: (HeartRateData data, _) => data.value,
          onRendererCreated: (ChartSeriesController controller) {
            _chartSeriesController = controller;
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class HeartRateData {
  final DateTime time;
  final int value;

  HeartRateData(this.time, this.value);
}

void tabeldata({required List<Map<DateTime, int>> data}) {
  return print(data);
}
