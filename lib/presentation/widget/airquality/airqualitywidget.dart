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
          color: Colors.transparent,
        ),
        child: SfLinearGauge(

          
          orientation: LinearGaugeOrientation.horizontal,
          minimum: minValue,
          maximum: maxValue,
          interval: maxValue / 4,
          minorTicksPerInterval: 4,
          axisTrackStyle: const LinearAxisTrackStyle(
            thickness: 20,
            edgeStyle: LinearEdgeStyle.bothFlat,
            //color: Colors.black,
            color: Colors.transparent,
          ),

          
            markerPointers: <LinearMarkerPointer>[
            LinearShapePointer(
              value: 900,
              shapeType: LinearShapePointerType.triangle,
              color: Colors.white,
              borderColor: Colors.white,
              borderWidth: 3,
              position: LinearElementPosition.cross, // Bisa diubah ke inside/middle
              width: 40, // Ukuran lingkaran lebih besar
              height: 40, // Sesuai dengan width agar tetap lingkaran
            ),
          ],

          ranges: <LinearGaugeRange>[
            LinearGaugeRange(
              edgeStyle: LinearEdgeStyle.startCurve,
              startValue: minValue,
              endValue: goodMaxValue,
              color: Colors.green,
              startWidth: 45,
              endWidth: 45,
            ),
            LinearGaugeRange(
              
              startValue: goodMaxValue,
              endValue: moderateMaxValue+2,
              color: Colors.orange,
              startWidth: 45,
              endWidth: 45,
            ),
            LinearGaugeRange(
              startValue: moderateMaxValue,
              endValue: seriousMaxValue+2,
              color: Colors.deepOrange,
              startWidth: 45,
              endWidth: 45,
            ),
            LinearGaugeRange(
              edgeStyle: LinearEdgeStyle.endCurve,
              startValue: seriousMaxValue,
              endValue: maxValue+10,
              color: Colors.red,
              startWidth: 45,
              endWidth: 45,
            ),
          ],
          labelPosition: LinearLabelPosition.inside,
          axisLabelStyle: TextStyle(
            color: Colors.white,  // Mengubah warna label menjadi putih
            fontSize: 18,         // Mengatur ukuran font
            //fontWeight: FontWeight.bold, // Mengatur ketebalan font
          ),
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