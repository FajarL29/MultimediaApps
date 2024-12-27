import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/constant/app_color.dart';
import 'package:multimedia_apps/core/service/read_airquality.dart';
import 'package:multimedia_apps/presentation/widget/airquality/air_temp.dart';
import 'package:multimedia_apps/presentation/widget/airquality/co2widget.dart';
import 'package:multimedia_apps/presentation/widget/airquality/cowidget.dart';

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
  late ReadAirquality _airqualityService;
  double _currentco = 0;
  double _currentco2 = 0;
  double _currentpm = 0;
  double _currenttemp = 0;
  double _currento2 = 0;
  double _currenthum = 0;

  @override
  void initState() {
    super.initState();
    _airqualityService = ReadAirquality();
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

    _airqualityService.pmStream.listen((pm) {
      setState(() {
        _currentpm = pm;
      });
    });

    _airqualityService.tempStream.listen((temp) {
      setState(() {
        _currenttemp = temp.toDouble();
      });
    });

    _airqualityService.o2Stream.listen((o2) {
      setState(() {
        _currento2 = o2;
      });
    });

    _airqualityService.humStream.listen((hum) {
      setState(() {
        _currenthum = hum;
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
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AirTemperatureWidget(
                              temperature: _currenttemp,
                              isCelsius: true,
                            ),
                            Co2Widget(cO2rate: 600)
                          ]),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AirTemperatureWidget(
                              temperature: _currenttemp,
                              isCelsius: true,
                            ),
                            CoWidget(cOrate: 600)
                          ]),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AirTemperatureWidget(
                              temperature: _currenttemp,
                              isCelsius: true,
                            ),
                            Co2Widget(cO2rate: 600)
                          ]),
                    ),
                  ),
                ],
              )),
        ]),
      ),
    );
  }
}
