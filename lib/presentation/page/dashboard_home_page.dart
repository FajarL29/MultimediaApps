import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/extension/extension.dart';
import 'package:multimedia_apps/presentation/page/dashboard_utilities_page.dart';

class DashboardHomePage extends StatefulWidget {
  final double height;
  final double width;
  final double parentPadding;
  final StatefulNavigationShell navigationShell;

  const DashboardHomePage({
    super.key,
    required this.navigationShell,
    required this.height,
    required this.width,
    required this.parentPadding,
  });

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // color: Color.fromARGB(255, 8, 3, 26),
        image: DecorationImage(
          image: AssetImage('assets/images/background_head_unit.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          const DashboardUtilitiesPage(),
          SizedBox(
            height: context.deviceHeight,
            width: context.deviceWidth * 0.65,
            child: widget.navigationShell,
          ),
        ],
      ),
    );
  }
}
