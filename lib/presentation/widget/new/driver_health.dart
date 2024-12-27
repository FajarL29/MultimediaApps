import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/constant/app_color.dart';
import 'package:multimedia_apps/core/service/read_heartrate2.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/bloodpressurewidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/heart_line2.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/heart_ratewidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/heartratetablewidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/respiratorywidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/spo2widget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/temperature.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const HeartRateApp());
// }

class HeartRateApp extends StatefulWidget {
  const HeartRateApp({super.key});

  @override
  State<HeartRateApp> createState() => _HeartRateAppState();
}

class _HeartRateAppState extends State<HeartRateApp> {
  late HeartRateService2 _heartRateService;
  double _currentTemperature = 0;
  double _sistole = 0;
  double _diastole = 0;
  int _currentspo2 = 0;
  int _currentRR = 0;

  @override
  void initState() {
    super.initState();
    _heartRateService = HeartRateService2();
    _heartRateService.startListening();

    _heartRateService.bodyTempStream.listen((temperature) {
      setState(() {
        _currentTemperature = temperature;
      });
    });
    _heartRateService.sbpRateStream.listen((sbp) {
      setState(() {
        _sistole = sbp;
      });
    });
    _heartRateService.dbpRateStream.listen((dbp) {
      setState(() {
        _diastole = dbp;
      });
    });
    _heartRateService.respRateStream.listen((currentrr) {
      setState(() {
        _currentRR = currentrr;
      });
    });
    _heartRateService.spO2RateStream.listen((spo2) {
      setState(() {
        _currentspo2 = spo2;
      });
    });
  }

  @override
  void dispose() {
    _heartRateService.dispose();
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
                    "Driver's Health",
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
                    flex: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height - 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: BodyTemperatureWidget(
                                temperature: _currentTemperature,
                                isCelsius: true,
                              ),
                            ),
                            Expanded(child: SpO2Widget(spO2rate: _currentspo2)),
                          ]),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.black,
                                      const Color.fromARGB(255, 19, 3, 143),
                                      Colors.black
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.topRight)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: HeartRateWidget(
                                          heartRateStream: _heartRateService
                                              .heartRateStream)),
                                  Expanded(
                                      child: AnimatedLine2(
                                          heartRateStream: _heartRateService
                                              .heartRateStream)),
                                ]),
                          ),
                          HeartRateTableWidget(
                              heartRateStream:
                                  _heartRateService.heartRateStream)
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                          height: MediaQuery.of(context).size.height - 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            children: [
                              Expanded(
                                  child: RespirationRateWidget(
                                respirationRate: _currentRR,
                              )),
                              Expanded(
                                  child: BloodPressureWidget(
                                systolic: _sistole,
                                diastolic: _diastole,
                              ))
                            ],
                          ))),
                ],
              )),
        ]),
      ),
    );
  }
}
