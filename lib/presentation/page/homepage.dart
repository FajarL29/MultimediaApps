import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/routing/router.dart';
import 'package:multimedia_apps/core/service/read_heartrate2.dart';
import 'package:multimedia_apps/main.dart';
import 'package:multimedia_apps/presentation/page/dashboard_home_page.dart'; 

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

  void _onItemTapped(int index) {
    if (index == 3) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Voice Command'),
          content: const Text('Voice Command Dialog Placeholder'),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
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
