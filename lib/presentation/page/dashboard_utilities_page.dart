<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:multimedia_apps/core/extension/extension.dart';
import 'package:multimedia_apps/presentation/widget/mainpage/speed2_component.dart';
// import 'package:multimedia_apps/presentation/widget/mainpage/speed_component.dart';
import 'package:multimedia_apps/presentation/widget/mainpage/weather_component.dart';

class DashboardUtilitiesPage extends StatefulWidget {
  const DashboardUtilitiesPage({super.key});

  @override
  State<DashboardUtilitiesPage> createState() => _DashboardUtilitiesPageState();
}

class _DashboardUtilitiesPageState extends State<DashboardUtilitiesPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.deviceWidth * 0.3,
      height: context.deviceHeight,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 20.heightSpace,
            // const DateTimeWidget(),
            20.heightSpace,
            const Expanded(flex: 5, child: SpeedDashboard()),
            20.heightSpace,
            const Expanded(flex: 3, child: WeatherComponent()),
          ],
        ),
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:multimedia_apps/core/extension/extension.dart';
import 'package:multimedia_apps/presentation/widget/mainpage/speed2_component.dart';
// import 'package:multimedia_apps/presentation/widget/mainpage/speed_component.dart';
import 'package:multimedia_apps/presentation/widget/mainpage/weather_component.dart';

class DashboardUtilitiesPage extends StatefulWidget {
  const DashboardUtilitiesPage({super.key});

  @override
  State<DashboardUtilitiesPage> createState() => _DashboardUtilitiesPageState();
}

class _DashboardUtilitiesPageState extends State<DashboardUtilitiesPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.deviceWidth * 0.3,
      height: context.deviceHeight,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 20.heightSpace,
            // const DateTimeWidget(),
            20.heightSpace,
            const Expanded(flex: 5, child: SpeedDashboard()),
            20.heightSpace,
            const Expanded(flex: 3, child: WeatherComponent()),
          ],
        ),
      ),
    );
  }
}
>>>>>>> manual-book
