import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
    return Center(
      child: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: SfRadialGauge(
            title: GaugeTitle(
                text: gaugetitle, textStyle: TextStyle(color: Colors.white)),
            enableLoadingAnimation: true,
            animationDuration: 1500,
            axes: <RadialAxis>[
              RadialAxis(
                axisLineStyle:
                    const AxisLineStyle(color: Colors.black, thickness: 25),
                axisLabelStyle: const GaugeTextStyle(color: Colors.white),
                minimum: minValue,
                maximum: maxValue,
                ranges: <GaugeRange>[
                  GaugeRange(
                    gradient: const SweepGradient(colors: [
                      Colors.greenAccent,
                      Colors.deepOrange,
                      Colors.red,
                    ]),
                    startValue: minValue,
                    endValue: maxValue,
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: aqvalue,
                    knobStyle: const KnobStyle(color: Colors.amber),
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          aqvalue.toStringAsFixed(
                              1), // Format value to 1 decimal place
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
                    angle: 90,
                    positionFactor: 0.5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
