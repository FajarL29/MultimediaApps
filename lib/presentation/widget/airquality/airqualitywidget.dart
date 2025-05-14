import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AQGaugeWidget extends StatelessWidget {
  final int aqvalue;
  final String gaugetitle;

  const AQGaugeWidget({
    super.key,
    required this.aqvalue,
    required this.gaugetitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            gaugetitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SfLinearGauge(
            orientation: LinearGaugeOrientation.horizontal,
            minimum: 0,
            maximum: 200,
            interval: 50,
            minorTicksPerInterval: 4,
            axisTrackStyle: const LinearAxisTrackStyle(
              thickness: 20,
              edgeStyle: LinearEdgeStyle.bothFlat,
              color: Colors.transparent,
            ),
            markerPointers: <LinearMarkerPointer>[
              LinearShapePointer(
                value: aqvalue.toDouble(),
                shapeType: LinearShapePointerType.triangle,
                color: _getPointerColor(aqvalue),
                borderColor: Colors.white,
                borderWidth: 3,
                position: LinearElementPosition.cross,
                width: 40,
                height: 40,
              ),
            ],
            ranges: <LinearGaugeRange>[
              LinearGaugeRange(
                edgeStyle: LinearEdgeStyle.startCurve,
                startValue: 0,
                endValue: 50,
                color: Colors.green,
                startWidth: 45,
                endWidth: 45,
              ),
              LinearGaugeRange(
                startValue: 50,
                endValue: 100,
                color: Colors.orange,
                startWidth: 45,
                endWidth: 45,
              ),
              LinearGaugeRange(
                startValue: 100,
                endValue: 150,
                color: Colors.deepOrange,
                startWidth: 45,
                endWidth: 45,
              ),
              LinearGaugeRange(
                edgeStyle: LinearEdgeStyle.endCurve,
                startValue: 150,
                endValue: 200,
                color: Colors.red,
                startWidth: 45,
                endWidth: 45,
              ),
            ],
            labelPosition: LinearLabelPosition.inside,
            axisLabelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPointerColor(int value) {
    if (value <= 50) {
      return Colors.green;
    } else if (value <= 100) {
      return Colors.orange;
    } else if (value <= 150) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }
}
