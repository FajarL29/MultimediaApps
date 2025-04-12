import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:multimedia_apps/core/routing/router.dart';
import 'package:multimedia_apps/presentation/page/menu_item_component.dart';
import 'package:multimedia_apps/presentation/widget/mainpage/device_registration.dart';

class MenuListComponent extends StatefulWidget {
  const MenuListComponent({super.key});

  @override
  State<MenuListComponent> createState() => _MenuListState();
}

class _MenuListState extends State<MenuListComponent> {
  @override
  Widget build(BuildContext context) {
    final List<MenuItem> menuItems = [
      MenuItem(
        menuColor: Color(0xFF1A234C),
        menuTitle: "TITAN Apps",
        menuIcon: "assets/images/titan_app.png",
        onTap: () {
            //AccessValidation.showAccessValidation(context);
          DeviceRegistration.showQRDialog(context);
        }
      ),
      MenuItem(
        menuColor: Color(0xFF29DE2D),
        menuTitle: "Phone",
        menuIcon: "assets/images/phone.png",
        onTap: () {
          const PhoneRoute().push(context);
          //BluetoothRoute().push(context);
        },
      ),
      MenuItem(
        menuColor: Color(0xFF334EAC),
        menuTitle: "Bluetooth",
        menuIcon: "assets/images/bluetooth.png",
        onTap: () {
          const BluetoothRoute().push(context);
        },
      ),
      MenuItem(
        menuColor: Color(0xFF232C53),
        menuTitle: "WiFi",
        menuIcon: "assets/images/wifi.png",
        onTap: () {},
      ),
      MenuItem(
        menuColor: Color(0xFFFF00A1),
        menuTitle: "Vehicle Info",
        menuIcon: "assets/images/vehicle_info.png",
        onTap: () {},
      ),
         MenuItem(
        menuColor: Color(0xFFFAC001),
        menuTitle: "Radio",
        menuIcon: "assets/images/radio.png",
        onTap: () {},
      ),
      MenuItem(
        menuColor: Colors.redAccent,
        menuTitle: "Driver's Health",
        menuIcon: "assets/images/heart.png",
        onTap: () {
          const DriverHealthRoute().push(context);
        },
      ),
      MenuItem(
        menuColor: Colors.white,
        menuTitle: "Air Quality",
        menuIcon: "assets/images/airquality.png",
        onTap: () {
          AirQualityRoute().push(context);
        },
      ),
      MenuItem(
          menuColor: Colors.blueGrey,
          menuTitle: "Settings",
          onTap: () {},
          menuIcon: "assets/images/settings.png"),
      MenuItem(
          menuColor: Colors.blueGrey.shade100,
          menuTitle: "Other",
          menuIcon: "assets/images/other_apps.png",
          onTap: () {}),
    ];

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, childAspectRatio: 7 / 7),
      padding: const EdgeInsets.all(5.0),
      itemCount: menuItems.length,
      itemBuilder: (BuildContext context, int index) {
        return MenuItemComponent(
          menuItem: MenuItem(
            menuColor: menuItems[index].menuColor,
            menuTitle: menuItems[index].menuTitle,
            menuIcon: menuItems[index].menuIcon,
            onTap: menuItems[index].onTap,
          ),
        );
      },
    );
  }
}

class SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight
    extends SliverGridDelegate {
  const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight({
    required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.height = 50.0,
  })  : assert(crossAxisCount > 0),
        assert(mainAxisSpacing >= 0),
        assert(crossAxisSpacing >= 0),
        assert(height > 0);

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// The height of the crossAxis.
  final double height;

  bool _debugAssertIsValid() {
    assert(crossAxisCount > 0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    assert(height > 0.0);
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid());
    final double usableCrossAxisExtent =
        constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1);
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final double childMainAxisExtent = height;
    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(
      SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight oldDelegate) {
    return oldDelegate.crossAxisCount != crossAxisCount ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.height != height;
  }
}
