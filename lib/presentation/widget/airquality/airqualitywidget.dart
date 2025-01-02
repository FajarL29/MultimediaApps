import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AQGaugeWidget extends StatelessWidget {
  final double aqvalue;
  final String gaugetitle;
  final double maxValue;
  final double minValue;
  final double goodMaxValue;
  final double moderateMaxValue;
  final double seriousMaxValue;

  const AQGaugeWidget({
    super.key,
    required this.aqvalue,
    required this.gaugetitle,
    required this.maxValue,
    required this.minValue,
    required this.goodMaxValue,
    required this.moderateMaxValue,
    required this.seriousMaxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: SfLinearGauge(
          orientation: LinearGaugeOrientation.horizontal,
          minimum: minValue,
          maximum: maxValue,
          interval: maxValue / 4,
          minorTicksPerInterval: 4,
          axisTrackStyle: const LinearAxisTrackStyle(
            thickness: 10,
            edgeStyle: LinearEdgeStyle.bothCurve,
            color: Colors.black,
          ),
          barPointers: <LinearBarPointer>[
            LinearBarPointer(
              value: aqvalue,
              thickness: 20,
              edgeStyle: LinearEdgeStyle.bothCurve,
              color: _getPointerColor(aqvalue),
            ),
          ],
          markerPointers: <LinearMarkerPointer>[
            LinearShapePointer(
              value: aqvalue,
              shapeType: LinearShapePointerType.circle,
              color: _getPointerColor(aqvalue),
              borderColor: Colors.white,
              borderWidth: 2,
            ),
          ],
          ranges: <LinearGaugeRange>[
            LinearGaugeRange(
              startValue: minValue,
              endValue: goodMaxValue,
              color: Colors.green,
              startWidth: 20,
              endWidth: 20,
            ),
            LinearGaugeRange(
              startValue: goodMaxValue,
              endValue: moderateMaxValue,
              color: Colors.orange,
              startWidth: 20,
              endWidth: 20,
            ),
            LinearGaugeRange(
              startValue: moderateMaxValue,
              endValue: seriousMaxValue,
              color: Colors.deepOrange,
              startWidth: 20,
              endWidth: 20,
            ),
            LinearGaugeRange(
              startValue: seriousMaxValue,
              endValue: maxValue,
              color: Colors.red,
              startWidth: 20,
              endWidth: 20,
            ),
          ],
          labelPosition: LinearLabelPosition.inside,
        ),
      ),
    );
  }

  Color _getPointerColor(double value) {
    if (value <= goodMaxValue) {
      return Colors.green;
    } else if (value <= moderateMaxValue) {
      return Colors.orange;
    } else if (value <= seriousMaxValue) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }
}
