import 'package:flutter/material.dart';
import 'package:multimedia_apps/core/extension/extension.dart';
import 'package:multimedia_apps/presentation/page/menu_list_component.dart';
import 'package:multimedia_apps/presentation/widget/mainpage/map_components.dart';

class DashboardMenuPage extends StatefulWidget {
  const DashboardMenuPage({
    super.key,
  });

  @override
  State<DashboardMenuPage> createState() => _DashboardMenuPageState();
}

class _DashboardMenuPageState extends State<DashboardMenuPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.deviceWidth * 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            20.heightSpace,
            const MapsComponent(mapsType: MapsType.smallSize),
            20.heightSpace,
            const Expanded(child: MenuListComponent()),
          ],
        ),
      ),
    );
  }
}
