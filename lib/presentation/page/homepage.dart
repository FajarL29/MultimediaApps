import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/routing/router.dart';
import 'package:multimedia_apps/core/service/read_heartrate2.dart';
import 'package:multimedia_apps/main.dart';
import 'package:multimedia_apps/presentation/page/dashboard_home_page.dart';
import 'package:http/http.dart' as http;
import 'package:multimedia_apps/video/screen1.dart';
import 'package:multimedia_apps/video/screen2.dart';
import 'package:pdfrx/pdfrx.dart'; 

class HomePage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final HeartRateService2 heartRateService;

  const HomePage({
    super.key,
    required this.navigationShell,
    required this.heartRateService,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  StreamSubscription<bool>? fingerSub;
  int _currentIndex = 0;
  double parentPadding = 20;
    Timer? timer;

  void _subscribeToFingerDetection() {
  fingerSub?.cancel(); 
  fingerSub = widget.heartRateService.fingerDetectedStream.listen((detected) {
    if (!mounted) return; 
    final location = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .uri
        .toString();
    if (detected && !location.contains("/DriverHealth")) {
      DriverHealthRoute().go(context);
    }
  });
}


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    _subscribeToFingerDetection();
  }

  @override
  void didPopNext() {
    _subscribeToFingerDetection(); 
  }

  // void _onItemTapped(int index) {
  //   if (index == 3) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text('Voice Command'),
  //         content: const Text('Voice Command Dialog Placeholder'),
  //       ),
  //     );
  //   } else {
  //     setState(() {
  //       _currentIndex = index;
  //     });
  //   }
  // }

    void _onItemTapped(int index) {
    if (index == 3) {
      _showPdfDialog(context, 'assets/docs/Yaris.pdf');
    } else if (index == 2) {
Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MyScreen1()),
        );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startPolling();
  }

  void startPolling() {
    timer = Timer.periodic(Duration(seconds: 2), (_) => checkServer());
  }

  Future<void> checkServer() async {
    final response = await http.get(
      Uri.parse("http://192.168.255.153:5000/task?poll=true"),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final label = data['message'] ?? '';

      if (label.contains('buka kap mobil')) {
        timer?.cancel(); // stop polling sebelum navigasi

        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MyScreen1()),
        );

        startPolling(); // polling dimulai ulang setelah kembali
      } else if (label.contains('buka tutup bensin')) {
                timer?.cancel(); // stop polling sebelum navigasi

        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MyScreen2()),
        );

        startPolling(); // polling dimulai ulang setelah kembali
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        return SizedBox(
          height: maxHeight,
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: [
                  DashboardHomePage(
                      navigationShell: widget.navigationShell,
                      height: maxHeight,
                      width: maxWidth,
                      parentPadding: parentPadding,
                    ),
                    const Placeholder(), 
                  ],
                ),
              ),
              BottomNavigationBar(
                selectedFontSize: 0,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.car_rental),
                    label: 'Car',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.location_pin),
                    label: 'Maps',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.library_music),
                    label: 'Music',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.mic),
                    label: 'Voice',
                  ),
                ],
                currentIndex: _currentIndex,
                backgroundColor: Colors.black,
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                onTap: _onItemTapped,
              ),
            ],
          ),
        );
      }),
    );
  }
}


  void _showPdfDialog(BuildContext context, String pdfAssetPath) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.black,
      child: Container(
        width: 800,
        height: 700,
        child: PdfViewer.asset(pdfAssetPath),
      ),
    ),
  );
}
