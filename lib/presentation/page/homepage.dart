import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/presentation/page/dashboard_home_page.dart';
import 'package:multimedia_apps/presentation/widget/mainpage/map_components.dart';
import 'package:multimedia_apps/presentation/widget/mainpage/voice_command_dialog.dart';
import 'package:multimedia_apps/presentation/widget/new/driver_health.dart';

class HomePage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage({super.key, required this.navigationShell});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double parentPadding = 20;
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    if (index == 3) {
      showVoiceCommandDialog(context);
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
                    //
                    const MapsComponent(),
                  ],
                ),
              ),
              BottomNavigationBar(
                selectedFontSize: 0,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.car_rental),
                    label: 'Car',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.location_pin),
                    label: 'maps',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.library_music),
                    label: 'music',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.mic),
                    label: 'voice command',
                  ),
                ],
                currentIndex: _currentIndex,
                backgroundColor: Colors.black,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.white,
                onTap: _onItemTapped,
              ),
            ],
          ),
        );
      }),
    );
  }
}
