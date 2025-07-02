import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:ffi' as ffi;

import 'package:flutter/material.dart' hide Router;
import 'package:flutter/gestures.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_kit/media_kit.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:window_manager/window_manager.dart';

import 'package:multimedia_apps/core/routing/router.dart';
import 'package:multimedia_apps/core/service/read_heartrate2.dart';

// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_libserialport/flutter_libserialport.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:media_kit/ffi/ffi.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:multimedia_apps/core/routing/router.dart';
// import 'package:multimedia_apps/core/service/read_heartrate2.dart';
// import 'package:window_manager/window_manager.dart';

// import 'dart:ffi' as ffi;

// const Size screenDimension = Size(1920, 1080);
// final HeartRateService2 heartRateService = HeartRateService2();
// final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   MediaKit.ensureInitialized();

//   // ✅ Set locale to C (Linux only)
//   if (!Platform.isWindows) {
//     final setlocale = ffi.DynamicLibrary.open("libc.so.6")
//         .lookupFunction<
//             ffi.Pointer<ffi.Char> Function(ffi.Int32, ffi.Pointer<ffi.Char>),
//             ffi.Pointer<ffi.Char> Function(int, ffi.Pointer<ffi.Char>)
//         >("setlocale");

//     const LC_NUMERIC = 4; // C enum value for LC_NUMERIC
//     final locale = "C".toNativeUtf8().cast<ffi.Char>(); // ✅ FIX: cast ke Pointer<Char>
//   }

//   await windowManager.ensureInitialized();

//   WindowOptions windowOptions = const WindowOptions(
//     fullScreen: true,
//     titleBarStyle: TitleBarStyle.hidden,
//   );

//   windowManager.waitUntilReadyToShow(windowOptions, () async {
//     await windowManager.setFullScreen(true);
//     await windowManager.show();
//   });

//   runApp(const MyApp());
// }

// const Size screenDimension = Size(1920, 1080);
// final HeartRateService2 heartRateService = HeartRateService2();
// final RouteObserver<ModalRoute<void>> routeObserver =
//     RouteObserver<ModalRoute<void>>();

// void main() async {

//   WidgetsFlutterBinding.ensureInitialized();
//   MediaKit.ensureInitialized();
//   await windowManager.ensureInitialized();
//   heartRateService.startListening();
//   final ports = SerialPort.availablePorts;
//   ("Available ports: $ports");
//   WindowOptions windowOptions = WindowOptions(
//     fullScreen: true,
//     titleBarStyle: TitleBarStyle.hidden,
//   );

//   windowManager.waitUntilReadyToShow(windowOptions, () async {
//     await windowManager.setFullScreen(true);
//     await windowManager.show();
//   });
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: screenDimension,
//       ensureScreenSize: true,
//       child: MaterialApp.router(
//         debugShowCheckedModeBanner: false,
//         scrollBehavior: const ScrollBehaviour(),
//         routerConfig: goRouter(heartRateService),
//       ),
//     );
//   }
// }

// class ScrollBehaviour extends MaterialScrollBehavior {
//   const ScrollBehaviour();

//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//         PointerDeviceKind.touch,
//         PointerDeviceKind.mouse,
//       };
// }
final StreamController<Map<String, String>> labelStreamController =
    StreamController.broadcast();

const Size screenDimension = Size(1920, 1080);
final HeartRateService2 heartRateService = HeartRateService2();
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

String? latestLabel;
String? latestLanguage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await windowManager.ensureInitialized();

  heartRateService.startListening();
  final ports = SerialPort.availablePorts;
  print("🔌 Available ports: $ports");

  // Jalankan server Shelf
  _startServer();

  WindowOptions windowOptions = const WindowOptions(
    fullScreen: true,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
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
        routerConfig: goRouter(heartRateService),
      ),
    );
  }
}

// ===================== SERVER FUNCTION ===================== //

// ===================== HTTP SERVER =====================

void _startServer() async {
  final router = Router();

  router.get('/task', (Request request) {
    final label = request.requestedUri.queryParameters['label'];
    final language = request.requestedUri.queryParameters['language'];
    final poll = request.requestedUri.queryParameters['poll'];

    if (poll == 'true') {
      if (latestLabel != null && latestLanguage != null) {
        final result = {'label': latestLabel!, 'language': latestLanguage!};
        latestLabel = null;
        latestLanguage = null;
        return Response.ok(jsonEncode(result),
            headers: {'Content-Type': 'application/json'});
      } else {
        return Response.ok(jsonEncode({'label': '', 'language': ''}),
            headers: {'Content-Type': 'application/json'});
      }
    }

    if (label == null ||
        language == null ||
        label.isEmpty ||
        language.isEmpty) {
      return Response.badRequest(
        body: jsonEncode({
          "status": "error",
          "message": "Parameter 'label' dan 'language' wajib ada"
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    latestLabel = label;
    latestLanguage = language;

    print('🎧 == DATA DITERIMA ==');
    print('🌐 Language: $language');
    print('💡 Label   : $label');

    // Kirim data ke UI melalui stream
    labelStreamController.add({'label': label, 'language': language});

    return Response.ok(
      jsonEncode({
        "status": "success",
        "message": "Label dan bahasa diterima",
        "data": {"label": label, "language": language},
      }),
      headers: {'Content-Type': 'application/json'},
    );
  });

  final staticHandler =
      createStaticHandler('web', defaultDocument: 'index.html');

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(Cascade().add(router).add(staticHandler).handler);

  final server = await serve(handler, InternetAddress.anyIPv4, 5000);
  print('✅ Server listening on http://${server.address.host}:${server.port}');
}
