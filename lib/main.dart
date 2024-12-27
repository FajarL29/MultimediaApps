import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multimedia_apps/core/routing/router.dart';

const Size screenDimension = Size(1920, 1080);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(const HeartRateApp());
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
        scrollBehavior: const ScrollBehaviour(),
        routerConfig: goRouter(),
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
