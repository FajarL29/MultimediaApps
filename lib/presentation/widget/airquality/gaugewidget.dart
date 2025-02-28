import 'package:flutter/material.dart';

class GaugeWidget extends StatelessWidget {
  final double aqvalue;
  final String gaugetitle;
  final double maxValue;
  final double minValue;
  final double stdLowValue;
  final double stdMaxValue;

  const GaugeWidget({
    super.key,
    required this.aqvalue,
    required this.gaugetitle,
    required this.maxValue,
    required this.minValue,
    required this.stdLowValue,
    required this.stdMaxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Color(0xFF12A8FF).withOpacity(0.30),
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                const SizedBox(width: 12),
                Text(
                '${aqvalue.toStringAsFixed(1)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              ],
            ),
                                   Text(
                          aqvalue < stdLowValue
                              ? 'Good'
                              : aqvalue < stdMaxValue
                                  ? 'Moderate'
                                  : 'Poor',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: aqvalue < stdLowValue
                                ? Colors.green
                                : aqvalue < stdMaxValue
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                        ),
          ],
        ),
      ),
      );
    
  }
}

// return Card(
//       child: Stack(children: [
//         Container(
//           decoration: const BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(20)),
//           ),
//           child: SfRadialGauge(
//             title: GaugeTitle(
//                 text: gaugetitle, textStyle: TextStyle(color: Colors.white)),
//             enableLoadingAnimation: true,
//             animationDuration: 1500,
//             axes: <RadialAxis>[
//               RadialAxis(
//                 axisLineStyle:
//                     const AxisLineStyle(color: Colors.transparent),
//                 axisLabelStyle: const GaugeTextStyle(color: Colors.white),
//                 minimum: minValue,
//                 maximum: maxValue,
//                 ranges: <GaugeRange>[
//                   GaugeRange(
//                     gradient: const SweepGradient(colors: [
//                       Colors.greenAccent,
//                       Colors.deepOrange,
//                       Colors.red,
//                     ]),
//                     startValue: minValue,
//                     endValue: maxValue,
//                   ),
//                 ],
//                 pointers: <GaugePointer>[
//                   NeedlePointer(
//                     value: aqvalue,
//                     knobStyle: const KnobStyle(color: Colors.amber),
//                   ),
//                 ],
//                 annotations: <GaugeAnnotation>[
//                   GaugeAnnotation(
//                     widget: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           aqvalue.toStringAsFixed(
//                               1), // Format value to 1 decimal place
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Text(
//                           aqvalue < stdLowValue
//                               ? 'Good'
//                               : aqvalue < stdMaxValue
//                                   ? 'Moderate'
//                                   : 'Poor',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: aqvalue < stdLowValue
//                                 ? Colors.green
//                                 : aqvalue < stdMaxValue
//                                     ? Colors.orange
//                                     : Colors.red,
//                           ),
//                         ),
//                       ],
//                     ),
//                     angle: 90,
//                     positionFactor: 0.5,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ]
//       ),
//     );