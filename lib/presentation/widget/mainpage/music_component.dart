// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multimedia_apps/core/constant/app_color.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MusicComponent extends StatefulWidget {
  const MusicComponent({super.key});

  @override
  State<MusicComponent> createState() => _MusicComponentState();
}

class _MusicComponentState extends State<MusicComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppStaticColors.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Song Name: Indonesia Raya",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Artist: All Indonesian Singer",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              FaIcon(FontAwesomeIcons.music,
                  size: 40, color: AppStaticColors.white)
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10, bottom: 5),
                      child: Text(
                        "2:34",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    LinearPercentIndicator(
                      barRadius: Radius.circular(15),
                      width: 145.0,
                      lineHeight: 10.0,
                      percent: 0.5,
                      backgroundColor: Colors.grey,
                      progressColor: Colors.blue,
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        child: FaIcon(FontAwesomeIcons.backwardStep,
                            size: 25, color: AppStaticColors.white)),
                    SizedBox(width: 15),
                    InkWell(
                        child: FaIcon(
                      FontAwesomeIcons.backward,
                      size: 25,
                      color: AppStaticColors.white,
                    )),
                    SizedBox(width: 15),
                    InkWell(
                      child: FaIcon(FontAwesomeIcons.stop,
                          size: 25, color: AppStaticColors.white),
                    ),
                    SizedBox(width: 15),
                    InkWell(
                        child: FaIcon(FontAwesomeIcons.pause,
                            size: 25, color: AppStaticColors.white)),
                    SizedBox(width: 15),
                    InkWell(
                        child: FaIcon(FontAwesomeIcons.forward,
                            size: 25, color: AppStaticColors.white)),
                    SizedBox(width: 15),
                    InkWell(
                        child: FaIcon(FontAwesomeIcons.forwardStep,
                            size: 25, color: AppStaticColors.white)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
