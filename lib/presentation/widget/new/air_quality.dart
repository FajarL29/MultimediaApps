import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/constant/app_color.dart';
import 'package:multimedia_apps/core/service/read_airquality.dart';
import 'package:multimedia_apps/presentation/widget/airquality/air_temp.dart';
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
  late ReadAirquality _airqualityService;
  double _currentco = 0;
  double _currentco2 = 0;
  double _currentpm25 = 0;
  double _currentpm10 = 0;
  double _currenttemp = 0;
  double _currento2 = 0;
  double _currenthum = 0;

  // Methods to determine the status of Air Purifier and O2 Concentrator
  String getAirPurifierStatus() {
    // If any of the parameters are out of the 'good' range, the air purifier should be ON
    if (_currentco > 9 || _currentco2 > 600 || _currentpm25 > 20 || _currentpm10 > 20) {
      return 'ON';
    }
    return 'OFF';
  }

  String getO2ConcentratorStatus() {
    // If oxygen level is too low, the O2 concentrator should be ON
    if (_currento2 < 19) {
      return 'ON';
    }
    return 'OFF';
  }

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

    _airqualityService.pmStream.listen((pm25) {
      setState(() {
        _currentpm25 = pm25.toDouble();
      });
    });

    _airqualityService.pmStream.listen((pm10) {
      setState(() {
        _currentpm25 = pm10;
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
      backgroundColor: Colors.transparent,
      body: Container(
        // decoration: BoxDecoration(
        //   color: Colors.black
        //     ),
        child: Column(children: [
          Stack(
            children: [
              Row(children: [
                
                Expanded(
                  flex: 1,
                  child: 
                  
                  Text(
                    "AIR QUALITY",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 24, color: AppStaticColors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
              Align(
                alignment: Alignment.centerLeft, 
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
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent 
            //      gradient: LinearGradient(colors: [
            //   Colors.black26,
            //   Colors.blue,
            //   AppStaticColors.lightBlack,ss
            //   Colors.blue,
            //   Colors.black26
            // ], begin: Alignment.bottomLeft, end: Alignment.topRight)
            ),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Cardwidget(
                      parameterName: 'Room Temperature',
                      value: _currenttemp,
                      unit: '°c',
                      icon: Icon(
                        Icons.thermostat,
                        color: Colors.white,
                      ),
                      isAlert: true,
                       alertMessage: _currenttemp < 18 ? 'Too Cold' : (_currenttemp > 25 ? 'Too Hot' : 'Normal'),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Cardwidget(
                      parameterName: 'Humidity',
                      value: _currenthum,
                      unit: '%',
                      icon: Icon(
                        Icons.water_drop,
                        color: Colors.white,
                      ),
                      isAlert: true,
                      alertMessage: _currenthum < 40 ? 'Too Dry' :
                       (_currenthum > 60 ? 'Too Humid' : 'Normal'),
                    
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Cardwidget(
                      parameterName: 'Oxygen Level',
                      value: _currento2,
                      unit: '%',
                      icon: Image.asset(
                        "assets/images/oxygen.png",
                        width: 30,
                        color: Colors.white,
                      ),
                      isAlert: true,
                       alertMessage: _currento2 < 19 ? 'Low Oxygen' : (_currento2 > 21 ? 'High Oxygen' : 'Normal'),
                    ),
                  ),
                ],
              )),
            Column(
              children: [
                Row(
                  children: [
                    Flexible(
                     
                        //flex: 1,
                        child: GaugeWidget(
                          aqvalue: _currentco,
                          minValue: 0,
                          maxValue: 25,
                          stdLowValue: 9,
                          stdMaxValue: 15,
                          gaugetitle: 'CO level (ppm)',
                        )),
                    Flexible(
                        //flex: 1,
                        child: GaugeWidget(
                          aqvalue: _currentco2,
                          minValue: 0,
                          maxValue: 2500,
                          stdLowValue: 600,
                          stdMaxValue: 1500,
                          gaugetitle: 'CO2 level (ppm)',
                        )),
                    Flexible(
                        //flex: 1,
                        child: GaugeWidget(
                          aqvalue: _currentpm25,
                          minValue: 0,
                          maxValue: 40,
                          stdLowValue: 20,
                          stdMaxValue: 35,
                          gaugetitle: 'PM2.5 level (µg/m³)',
                        )),
                    Flexible(
                        //flex: 1,
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
                  
                  Text(
                    "Air Quality Condition",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
           SizedBox(height: 10,),
        
          AQGaugeWidget(
            aqvalue: 100,
            gaugetitle: 'Air Quality',
            maxValue: 1000,
            minValue: 0,
            goodMaxValue: 60,
            moderateMaxValue: 500,
            seriousMaxValue: 600,
          ),

           // Adding the status texts for Air Purifier and O2 Concentrator
          Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: getAirPurifierStatus() == 'ON' ? Colors.green : Colors.blue  ,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Air Purifier : ${getAirPurifierStatus()}',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: getO2ConcentratorStatus() == 'ON' ? Colors.green : Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'O2 Concentrator : ${getO2ConcentratorStatus()}',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        ],
        ),  
      ),
    );
  }
}
