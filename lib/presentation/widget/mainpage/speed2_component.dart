import 'package:flutter/material.dart';
import 'package:multimedia_apps/core/constant/app_styles.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SpeedDashboard extends StatefulWidget {
  const SpeedDashboard({super.key});

  @override
  State<SpeedDashboard> createState() => _SpeedDashboardState();
}

class _SpeedDashboardState extends State<SpeedDashboard> {
  final double _speed = 120;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage('assets/images/speed_background.jpg'),
                  fit: BoxFit.fill)),
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                startAngle: 130,
                endAngle: 340,
                minimum: 0,
                maximum: 150,
                axisLabelStyle:
                    GaugeTextStyle(color: Colors.white, fontSize: 20),
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0,
                    endValue: 50,
                    sizeUnit: GaugeSizeUnit.logicalPixel,
                    color: AppStaticColors.greyShadowPrimary,
                    startWidth: 10,
                    endWidth: 20,
                  ),
                  GaugeRange(
                      startValue: 50,
                      endValue: 100,
                      color: Colors.orange,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 100,
                      endValue: 150,
                      color: Colors.red,
                      startWidth: 10,
                      endWidth: 10)
                ],
                pointers: <GaugePointer>[NeedlePointer(value: _speed)],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Text('${_speed.toStringAsFixed(0)} KM/H',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      angle: 90,
                      positionFactor: 0.5)
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
