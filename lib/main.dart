import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multimedia_apps/core/routing/router.dart';
import 'package:multimedia_apps/core/service/read_heartrate2.dart';
import 'package:window_manager/window_manager.dart';

const Size screenDimension = Size(1920, 1080);
final HeartRateService2 heartRateService = HeartRateService2();
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  heartRateService.startListening();
  final ports = SerialPort.availablePorts;
  ("Available ports: $ports");
  WindowOptions windowOptions = WindowOptions(
    fullScreen: true,
    titleBarStyle: TitleBarStyle.hidden,

  );

  windowManager.waitUntilReadyToShow(windowOptions,() async {
    await windowManager.setFullScreen(true);
    await windowManager.show();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: screenDimension,
      ensureScreenSize: true,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        scrollBehavior: const ScrollBehaviour(),
        routerConfig: goRouter(heartRateService),
      ),
    );
  }
}

class ScrollBehaviour extends MaterialScrollBehavior {
  const ScrollBehaviour();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
