import 'package:flutter/material.dart';
import 'package:multimedia_apps/core/constant/app_styles.dart';

class SpeedComponentWidget extends StatefulWidget {
  const SpeedComponentWidget({super.key});

  @override
  State<SpeedComponentWidget> createState() => _SpeedComponentWidgetState();
}

class _SpeedComponentWidgetState extends State<SpeedComponentWidget> {
  @override
  Widget build(BuildContext context) {
    double speedValue = 120;
    return Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppStaticColors.cardBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                text: "Speed\n",
                style: TextStyles.f14(context).copyWith(
                  color: AppStaticColors.white,
                  fontSize: 18,
                ),
                children: [
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        speedValue.toString(),
                        style: TextStyles.f20(context).copyWith(
                            color: AppStaticColors.white, fontSize: 56),
                      ),
                    ),
                  ),
                  TextSpan(
                      text: "Km/h",
                      style: TextStyles.f14(context)
                          .copyWith(color: AppStaticColors.white, fontSize: 18))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12, top: 10),
              width: 175,
              height: 5,
              color: AppStaticColors.cardLineBackground,
            )
          ],
        ));
  }
}
