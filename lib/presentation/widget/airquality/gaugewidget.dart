import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugeWidget extends StatefulWidget {
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
  State<GaugeWidget> createState() => _GaugeWidgetState();
}

class _GaugeWidgetState extends State<GaugeWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Text(widget.gaugetitle,
            style: TextStyle(color: Colors.white, fontSize: 20)),
        Container(
          // height: double.infinity,
          // width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
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
                  minimum: widget.minValue,
                  maximum: widget.maxValue,
                  ranges: <GaugeRange>[
                    GaugeRange(
                      gradient: SweepGradient(colors: [
                        Colors.greenAccent,
                        Colors.deepOrange,
                        Colors.red
                      ]),
                      startValue: widget.minValue,
                      endValue: widget.maxValue,
                    )
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                        value: widget.aqvalue,
                        knobStyle:
                            KnobStyle(color: Colors.amber)) // Example CO value
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.aqvalue.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.aqvalue < widget.stdLowValue
                                ? 'Good'
                                : widget.aqvalue < widget.stdMaxValue
                                    ? 'Moderate'
                                    : 'Poor',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: widget.aqvalue < widget.stdLowValue
                                  ? Colors.green
                                  : widget.aqvalue < widget.stdMaxValue
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
      ]),
    );
  }
}
