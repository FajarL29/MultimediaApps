import 'package:flutter/material.dart';

class GaugeWidget extends StatelessWidget {
  final double aqvalue;
  final String gaugetitle;
  final double maxValue;
  final double minValue;
  final double stdLowValue;
  final double stdMaxValue;
  final bool isAlert; // Flag to indicate if the value is in alert range
  final String? alertMessage; // Optional message to display in case of alert



  const GaugeWidget({
    super.key,
    required this.aqvalue,
    required this.gaugetitle,
    required this.maxValue,
    required this.minValue,
    required this.stdLowValue,
    required this.stdMaxValue,
    this.isAlert = false,
    this.alertMessage,


  });

  @override
  Widget build(BuildContext context) {
    return Card(
elevation: 4,
      color: Colors.white.withOpacity(0.30),
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              textAlign: TextAlign.center,
              gaugetitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            //const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                const SizedBox(width: 12),
                Text(
                aqvalue.toStringAsFixed(1),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              ],
            ),
            if (alertMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                textAlign: TextAlign.center,
                alertMessage!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ],
        ),
      ),  
    );
  }
}

// child: SfRadialGauge(
            
//             title: GaugeTitle(
//                 text: gaugetitle, textStyle: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
//             enableLoadingAnimation: true,
//             animationDuration: 1500,
//             axes: <RadialAxis>[
//               RadialAxis(
//                 axisLineStyle: AxisLineStyle(color: Colors.black, thickness: 20),
//                 axisLabelStyle: GaugeTextStyle(color: Colors.white),
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
//       ]),