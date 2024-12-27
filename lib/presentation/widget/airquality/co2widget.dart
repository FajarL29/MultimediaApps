import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Co2Widget extends StatelessWidget {
  final double cO2rate;
  const Co2Widget({super.key, required this.cO2rate});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('CO2 Levels (ppm)', style: TextStyle(color: Colors.white)),
      Container(
        height: 250,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(250),
          color: Colors.black,
        ),
        child: SfRadialGauge(
            enableLoadingAnimation: true,
            animationDuration: 1500,
            axes: <RadialAxis>[
              RadialAxis(
                axisLineStyle:
                    AxisLineStyle(color: Colors.black, thickness: 25),
                axisLabelStyle: GaugeTextStyle(color: Colors.white),
                minimum: 0,
                maximum: 2500,
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0,
                    endValue: 600,
                    color: Colors.green,
                  ),
                  GaugeRange(
                    startValue: 600,
                    endValue: 1500,
                    color: Colors.orange,
                  ),
                  GaugeRange(
                    startValue: 1500,
                    endValue: 2500,
                    color: Colors.red,
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                      value: cO2rate,
                      knobStyle:
                          KnobStyle(color: Colors.amber)) // Example CO value
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cO2rate.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          cO2rate < 600
                              ? 'Good'
                              : cO2rate < 1500
                                  ? 'Moderate'
                                  : 'Poor',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: cO2rate < 600
                                ? Colors.green
                                : cO2rate < 1500
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    angle: 90,
                    positionFactor: 0.5,
                  ),
                ],
              )
            ]),
      )
    ]);
  }
}
