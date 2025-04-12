import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  double get deviceWidth => MediaQuery.of(this).size.width;

  double get deviceHeight => MediaQuery.of(this).size.height;

  double get halfDeviceWidth => MediaQuery.of(this).size.width / 2;

  double get halfDeviceHeight => MediaQuery.of(this).size.height / 2;
}

extension WidgetExt on num {
  SizedBox get heightSpace => SizedBox(height: toDouble());

  SizedBox get widthSpace => SizedBox(width: toDouble());
}
