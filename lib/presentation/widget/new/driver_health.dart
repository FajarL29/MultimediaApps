import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:multimedia_apps/core/constant/app_color.dart';
import 'package:multimedia_apps/core/service/read_heartrate2.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/bloodpressurewidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/heart_line2.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/heart_ratewidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/heartratetablewidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/respiratorywidget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/spo2widget.dart';
import 'package:multimedia_apps/presentation/widget/driverhealth/temperature.dart';

class HeartRateApp extends StatefulWidget {
  const HeartRateApp({super.key});

  @override
  State<HeartRateApp> createState() => _HeartRateAppState();
}

class _HeartRateAppState extends State<HeartRateApp> {
  late HeartRateService2 _heartRateService;
  double _currentTemperature = 0;
  int _sistole = 0;
  int _diastole = 0;
  int _currentspo2 = 0;
  int _currentRR = 0;

  String getHealthStatus() {
    // If any of the parameters are out of the 'good' range, the air purifier should be ON
    if ( _currentTemperature > 39 || _sistole > 120|| _diastole > 80 || _currentRR > 22 || _currentspo2 > 100) {
      return 'HEALTY';
    }
    return 'UNHEALTHY';
  }

  @override
  void initState() {
    super.initState();
    _heartRateService = HeartRateService2();
    _heartRateService.startListening();

    _heartRateService.bodyTempStream.listen((temperature) {
      setState(() => _currentTemperature = temperature);
    });
    _heartRateService.sbpRateStream.listen((sbp) {
      setState(() => _sistole = sbp);
    });
    _heartRateService.dbpRateStream.listen((dbp) {
      setState(() => _diastole = dbp);
    });
    _heartRateService.respRateStream.listen((currentrr) {
      setState(() => _currentRR = currentrr);
    });
    _heartRateService.spO2RateStream.listen((spo2) {
      setState(() => _currentspo2 = spo2);
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
        decoration: const BoxDecoration(
          gradient: RadialGradient(colors: [Colors.black, Colors.black, Colors.black]),
        ),
        child: Column(
          children: [
            // Header Title & Back Button
            Stack(
              children: [
                Center(
                  child: Text(
                    "Driver's Health",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: AppStaticColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ],
            ),

            // Data Display
            Expanded(
              child: Column(
                children: [
                  // Row 1: Heart Rate Section
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(
                          //   width: 1,
                          //   color: Colors.white
                          // ),
                          gradient: LinearGradient(
                            colors: [Colors.black, Color.fromARGB(255, 8, 0, 62), Colors.black],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        
                        child: Row(
                          children: [
                            SizedBox(
                            width: 200, // Fixed width
                            height: 200,
                              //flex: 1,
                              child: HeartRateWidget(
                                heartRateStream: _heartRateService.heartRateStream,
                              ),
                            ),
                            SizedBox(
                            width: 300, // Fixed width
                            height: 300,
                              //flex: 1,
                              child: 
                               Lottie.asset(
                                'assets/images/heart_animation.json', // Ensure the file is in the assets folder
                                fit: BoxFit.contain, // Adjust as needed
                              ),
                       
                              // AnimatedLine2(
                              //   heartRateStream: _heartRateService.heartRateStream,
                              // ),


                            ),
                            SizedBox(
                            width: 450, // Fixed width
                            height: 200,
                              //flex: 3,
                              child: HeartRateTableWidget(
                                heartRateStream: _heartRateService.heartRateStream,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                Row(
                  children: [
                    SizedBox(
                      width: 245, // Fixed width
                      height: 300,
                      child: BodyTemperatureWidget(
                        temperature: _currentTemperature,
                        isCelsius: true,
                      ),
                    ),
                    SizedBox(
                      width: 245, // Fixed width
                      height: 300,
                      child: SpO2Widget(spO2rate: _currentspo2),
                    ),
                    SizedBox(
                      width: 245, // Fixed width
                      height: 300,
                      child: RespirationRateWidget(
                        respirationRate: _currentRR,
                      ),
                    ),
                    SizedBox(
                      width: 245, // Fixed width
                      height: 300,
                      child: BloodPressureWidget(
                        systolic: _sistole,
                        diastolic: _diastole,
                      ),
                    ),
                  ],
                ),  


                  // Row 2: Other Health Metrics
                 

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 26),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    
                      color: getHealthStatus() == 'ON' ? Colors.blue : Colors.red  ,
                                         
                  ),
                  child: Text(
                    "Health Status  :  ${getHealthStatus()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppStaticColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                )
              ],
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
