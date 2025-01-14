import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/constant/app_color.dart';
import 'package:multimedia_apps/core/service/read_airquality.dart';
import 'package:multimedia_apps/presentation/widget/airquality/airqualitywidget.dart';
import 'package:multimedia_apps/presentation/widget/airquality/cardwidget.dart';
import 'package:multimedia_apps/presentation/widget/airquality/gaugewidget.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const HeartRateApp());
// }

class AirQualityApp extends StatefulWidget {
  const AirQualityApp({super.key});

  @override
  State<AirQualityApp> createState() => _AirQualityAppState();
}

class _AirQualityAppState extends State<AirQualityApp> {
  late ReadAirQuality _airqualityService;
  double _currentco = 0;
  double _currentco2 = 0;
  double _currentpm25 = 0;
  double _currentpm10 = 0;
  double _currenttemp = 0;
  double _currento2 = 0;
  double _currenthum = 0;

  @override
  void initState() {
    super.initState();
    _airqualityService = ReadAirQuality();
    _airqualityService.startListening();

    _airqualityService.coStream.listen((co) {
      setState(() {
        _currentco = co.toDouble();
      });
    });

    _airqualityService.co2Stream.listen((co2) {
      setState(() {
        _currentco2 = co2.toDouble();
      });
    });

    _airqualityService.pm25Stream.listen((pm25) {
      setState(() {
        _currentpm25 = pm25.toDouble();
      });
    });

    _airqualityService.pm10Stream.listen((pm10) {
      setState(() {
        _currentpm10 = pm10;
      });
    });

    _airqualityService.tempStream.listen((temp) {
      setState(() {
        _currenttemp = temp.toDouble();
      });
    });

    _airqualityService.o2Stream.listen((o2) {
      setState(() {
        _currento2 = o2.toDouble();
      });
    });

    _airqualityService.humStream.listen((hum) {
      setState(() {
        _currenthum = hum.toDouble();
      });
    });
  }

  @override
  void dispose() {
    _airqualityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStaticColors.toastColor,
      body: Container(
        decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.colorBurn,
            gradient: RadialGradient(
                colors: [Colors.black, Colors.blue, Colors.black])),
        child: Column(children: [
          Stack(
            children: [
              Row(children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Air Quality",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 22, color: AppStaticColors.white),
                  ),
                ),
              ]),
              Align(
                alignment: Alignment
                    .centerLeft, // Align the IconButton to the center left
                child: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
          Container(
              decoration: BoxDecoration(
                  gradient: RadialGradient(colors: [
                Colors.black,
                const Color.fromARGB(255, 19, 3, 143),
                Colors.black
              ])),
              child: Row(
                children: [
                  Expanded(
                    child: Cardwidget(
                      parameterName: 'Air Temperature',
                      value: _currenttemp,
                      unit: '°C',
                      icon: Icon(
                        Icons.thermostat,
                        color: Colors.blue,
                      ),
                      isAlert: true,
                      alertMessage: 'normal temperature',
                    ),
                  ),
                  Expanded(
                    child: Cardwidget(
                      parameterName: 'Humidity',
                      value: _currenthum,
                      unit: '%',
                      icon: Icon(
                        Icons.water_drop,
                      ),
                      isAlert: true,
                      //alertMessage: 'High Humidity!',
                    ),
                  ),
                  Expanded(
                    child: Cardwidget(
                      parameterName: 'O2 Level',
                      value: _currento2,
                      unit: '%',
                      icon: Image.asset(
                        "assets/images/oxygen.png",
                        width: 30,
                        color: Colors.blue,
                      ) // Optional: Apply a color tint
                      ,
                      isAlert: true,

                      //alertMessage: 'High Humidity!',

                    ),
                  ),
                ],
              )),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.black26,
                Colors.blue,
                AppStaticColors.lightBlack,
                Colors.blue,
                Colors.black26
              ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: GaugeWidget(
                            aqvalue: _currentco,
                            minValue: 0,
                            maxValue: 25,
                            stdLowValue: 9,
                            stdMaxValue: 15,
                            gaugetitle: 'CO level (ppm)',
                          )),
                      Expanded(
                          flex: 1,
                          child: GaugeWidget(
                            aqvalue: _currentco2,
                            minValue: 0,
                            maxValue: 2500,
                            stdLowValue: 600,
                            stdMaxValue: 1500,
                            gaugetitle: 'CO2 level (ppm)',
                          )),
                      Expanded(
                          flex: 1,
                          child: GaugeWidget(
                            aqvalue: _currentpm25,
                            minValue: 0,
                            maxValue: 40,
                            stdLowValue: 20,
                            stdMaxValue: 35,
                            gaugetitle: 'PM2.5 level (µg/m³)',
                          )),
                      Expanded(
                          flex: 1,
                          child: GaugeWidget(
                            aqvalue: _currentpm10,
                            minValue: 0,
                            maxValue: 40,
                            stdLowValue: 20,
                            stdMaxValue: 35,
                            gaugetitle: 'PM10 level (µg/m³)',
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Expanded(
          //   child: AQGaugeWidget(
          //       aqvalue: 100,
          //       gaugetitle: 'Air Quality ',
          //       maxValue: 1000,
          //       minValue: 0,
          //       goodMaxValue: 60,
          //       moderateMaxValue: 500,
          //       seriousMaxValue: 600),
          // )
        ]),
      ),
    );
  }
}
