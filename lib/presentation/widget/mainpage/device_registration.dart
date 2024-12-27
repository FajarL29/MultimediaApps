import 'package:flutter/material.dart';
import 'package:multimedia_apps/core/constant/app_color.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DeviceRegistration extends StatefulWidget {
  const DeviceRegistration({super.key});

  @override
  State<DeviceRegistration> createState() => _DeviceRegistrationState();

  static Future showQRDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 10), () {
          Navigator.of(context).pop(true);
        });
        return const AlertDialog(
          backgroundColor: AppStaticColors.primary,
          title: Center(
            child: Text(
              'Device Registration',
              style: TextStyle(color: AppStaticColors.white),
            ),
          ),
          content: DeviceRegistration(),
        );
      },
    );
  }
}

String licensePlate = "";
String vehicleModel = "";
String vehicleYear = "";
String vehicleColor = "";
String vehicleEngine = "";
String vehicleNo = "MHKA6GJ3JRJ043644";

Map<String, String> getVehicle() {
  return {
    'licensePlate': licensePlate,
    'vehicleModel': vehicleModel,
    'vehicleColor': vehicleColor,
    'vehicleYear': vehicleYear,
    'vehicleEngine': vehicleEngine,
    'vehicleNo': vehicleNo,
  };
}

class _DeviceRegistrationState extends State<DeviceRegistration> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: QrImageView(
            data: getVehicle()['vehicleNo'].toString(),
            version: QrVersions.auto,
            size: 150,
            gapless: false,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Vehicle Information",
            style: TextStyle(
              color: AppStaticColors.white,
              fontSize: 18,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'B 1234 ABC',
                  style: TextStyle(color: AppStaticColors.white),
                ),
                const Text(
                  'Model: Yaris Cross',
                  style: TextStyle(color: AppStaticColors.white),
                ),
                const Text(
                  'Year: 2023',
                  style: TextStyle(color: AppStaticColors.white),
                ),
                const Text(
                  'Color: Red',
                  style: TextStyle(color: AppStaticColors.white),
                ),
                const Text(
                  'Engine Type: Hybrid',
                  style: TextStyle(color: AppStaticColors.white),
                ),
                Text(
                  'Vehicle No: $vehicleNo',
                  style: const TextStyle(color: AppStaticColors.white),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
