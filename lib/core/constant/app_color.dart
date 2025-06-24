import 'package:flutter/material.dart';

abstract class AppStaticColors {
  static const Color primary = Color(0xFF0D0C0C);
  static const Color primaryDark = Color(0xFF216D62);
  static const Color primaryLight = Color(0xFFD6EBE8);
  static const Color secondary = Color(0xFF4CB09F);
  static const Color secondaryLight = Color(0xFFBBDED9);
  static const Color toastColor = Color(0xFF329B8C);
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color lightBlack = Color(0xff333333);
  static const Color lightOrange = Color(0xfffe9654);
  static const Color greyShadowPrimary = Color(0xffD9D9D9);
  static const Color greyShadowSecondary = Color(0xffc5c4c4);
  static const Color grey = Color(0xFFEDEDED);
  static const Color neutral = Color(0xFFF5F5F5);
  static const Color neutralSecondary = Color(0xFFE0E0E0);
  static const Color blue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFF58b9f0);
  static const Color red = Color(0xffff0000);
  static const Color redSecondary = Color(0xFFCB3A31);
  static const Color redLight = Color(0xFFF5D8D6);
  static const LinearGradient primaryIngredientColor = LinearGradient(
    colors: [Color(0xFFd74747), Color(0xFFC11718)],
    stops: [0, 1],
  );
  static const Color green = Color(0xff43936C);
  static const Color transparent = Color(0x1E000000);
  static const Color cardBackground = Color(0xFF171717);
  static const Color cardLineBackground = Color(0xFFC4C4C4);
}
