import 'package:flutter/material.dart';
import 'package:multimedia_apps/core/constant/app_styles.dart';
import 'package:multimedia_apps/presentation/widget/mainpage/date_time.dart';

class WeatherComponent extends StatefulWidget {
  const WeatherComponent({super.key});

  @override
  State<WeatherComponent> createState() => _WeatherComponentState();
}

class _WeatherComponentState extends State<WeatherComponent> {
  @override
  Widget build(BuildContext context) {
    String location = "Jakarta, Indonesia";
    double temperature = 34;
    String cloudyStatus = "Cloudy";
    String rainyStatus = "Rainy";
    String sunnyStatus = "Sunny";
    bool isCloudy = temperature >= 28 && temperature <= 32;
    bool isRainy = temperature < 28;

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(isCloudy
              ? 'assets/images/weather_cloudy.png'
              : isRainy
                  ? "assets/images/weather_rainy.png"
                  : "assets/images/weather_sunny.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DateTimeWidget(), // Pastikan ini ada di dalam child
            Text(location,
                style: TextStyles.f20(context)
                    .copyWith(color: AppStaticColors.white, fontSize: 20)),
            Text("$temperature °",
                style: TextStyles.f20(context)
                    .copyWith(color: AppStaticColors.white, fontSize: 42)),
            Text(
                isCloudy
                    ? cloudyStatus
                    : isRainy
                        ? rainyStatus
                        : sunnyStatus,
                style: TextStyles.f20(context)
                    .copyWith(color: AppStaticColors.white, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
