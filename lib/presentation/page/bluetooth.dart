import 'package:flutter/material.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/constant/app_color.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStaticColors.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                const Expanded(
                  child: Text(
                    "Bluetooth Settings",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 22, color: AppStaticColors.white),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 15, left: 5, right: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const Expanded(
                      child: Text("Bluetooth",
                          style: TextStyle(
                              fontSize: 16, color: AppStaticColors.white))),
                  GFToggle(
                    onChanged: (selected) {},
                    value: true,
                    enabledThumbColor: Colors.blue,
                    enabledTrackColor: Colors.blue,
                    type: GFToggleType.custom,
                    enabledTextStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            const Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Device Name",
                      style:
                          TextStyle(fontSize: 16, color: AppStaticColors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Bluetooth Name",
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 32,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Expanded(
                    child: Text(
                      "Paired Device",
                      style:
                          TextStyle(fontSize: 16, color: AppStaticColors.white),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 15, left: 5, right: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "Bluetooth $index",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Expanded(
                      child: Text("Available Devices",
                          style: TextStyle(
                              fontSize: 16, color: AppStaticColors.white))),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, left: 5, right: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "New Device $index",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
