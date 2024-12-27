import 'package:flutter/material.dart';

//import '../../../../gen/assets.gen.dart';
//import '../../extensions/extensions.dart';
import 'app_color.dart';
//import 'custom_colors.dart';

export 'app_color.dart';
//export 'app_theme.dart';
//export 'custom_colors.dart';

part 'app_size.dart';

part 'app_text_style.dart';

/// Single source of truth for styling.
///
/// TL;DR: Don't try and create every variant in existence here, just the high level ones (core & duplicates).
///
/// Like most rules, there are exceptions: one-off values that are used nowhere else in the app.
/// There is little point in cluttering up the styling rules with these values, but it’s worth
/// considering if they should be derived from an existing value (for example, padding + 1.0).
/// You should also watch for reuse or duplication of the same semantic values.
/// Those values should likely be added to this global styling ruleset.

abstract class FontStyles {
  static const String familyPoppins = 'Lato';

  static const fontWeightBlack = FontWeight.w900;
  static const fontWeightExtraBold = FontWeight.w800;
  static const fontWeightBold = FontWeight.w700;
  static const fontWeightSemiBold = FontWeight.w600;
  static const fontWeightMedium = FontWeight.w500;
  static const fontWeightNormal = FontWeight.w400;
  static const fontWeightLight = FontWeight.w300;
  static const fontWeightExtraLight = FontWeight.w200;
  static const fontWeightThin = FontWeight.w100;
}

abstract class Borders {
  static const BorderRadius radiusAll15 = BorderRadius.all(Radius.circular(15));
  static const BorderRadius radiusAll12 = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusAll10 = BorderRadius.all(Radius.circular(10));
  static const BorderRadius radiusAll8 = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusAll4 = BorderRadius.all(Radius.circular(4));
  static const BorderRadius radiusAll2 = BorderRadius.all(Radius.circular(2));
  static const BorderRadius radiusAll0 = BorderRadius.zero;

  static const BorderRadius radiusOnlyTop10 = BorderRadius.only(
    topRight: Radius.circular(10),
    topLeft: Radius.circular(10),
  );

  static OutlineInputBorder inputDecorationBorder(Color borderColor,
          [double borderWidth = 0.8]) =>
      OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      );

  static RoundedRectangleBorder commonShapeBorder() =>
      const RoundedRectangleBorder(borderRadius: radiusAll10);

  static RoundedRectangleBorder commonShapeSideBorder(BuildContext context) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          width: 1,
          color: Colors.white,
        ),
      );

  static const Border borderOnlyBottom =
      Border(bottom: BorderSide(color: AppStaticColors.neutralSecondary));

  static Border borderAll({
    Color? color,
    double? width,
  }) =>
      Border.all(color: color ?? AppStaticColors.primary, width: width ?? 1.0);
}

abstract class Shadows {
  static const commonShadow = [
    BoxShadow(
      color: AppStaticColors.transparent,
      blurRadius: 7,
      offset: Offset(0, 3),
      spreadRadius: 0,
    ),
  ];

  static const smallShadow = [
    BoxShadow(
      color: AppStaticColors.transparent,
      blurRadius: 2,
      offset: Offset(0, 1),
      spreadRadius: 0,
    )
  ];
}

abstract class Decorations {
  static const BoxDecoration borderBottom =
      BoxDecoration(border: Borders.borderOnlyBottom);

  static final BoxDecoration borderAll =
      BoxDecoration(border: Borders.borderAll());
}

abstract class Insets {
  static const inputDecorationContentPadding =
      EdgeInsets.symmetric(vertical: 12, horizontal: 12);

  static const spaceAll20 = EdgeInsets.all(Sizes.screenPaddingV20);
  static const spaceAll16 = EdgeInsets.all(Sizes.screenPaddingV16);
  static const spaceAll12 = EdgeInsets.all(Sizes.screenPaddingV12);
  static const spaceAll10 = EdgeInsets.all(Sizes.screenPaddingV10);
  static const spaceAll6 = EdgeInsets.all(Sizes.screenPaddingH6);
  static const spaceAll4 = EdgeInsets.all(Sizes.screenPaddingH4);

  static const spaceV8 = EdgeInsets.symmetric(
    vertical: Sizes.marginV8,
  );

  static const spaceV6 = EdgeInsets.symmetric(
    vertical: Sizes.marginV6,
  );

  static const spaceV4 = EdgeInsets.symmetric(
    vertical: Sizes.marginV4,
  );

  static const spaceH20V8 = EdgeInsets.symmetric(
    vertical: Sizes.marginV8,
    horizontal: Sizes.marginH20,
  );

  static const spaceH6 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH6,
  );

  static const spaceH10 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH10,
  );

  static const spaceH20V10 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH20,
    vertical: Sizes.marginV10,
  );

  static const spaceH6V4 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH6,
    vertical: Sizes.marginV4,
  );

  static const spaceH6V10 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH6,
    vertical: Sizes.marginV10,
  );

  static const spaceH10V12 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH10,
    vertical: Sizes.marginV12,
  );

  static const spaceH10V6 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH10,
    vertical: Sizes.marginV6,
  );

  static const spaceH10V4 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH10,
    vertical: Sizes.marginV4,
  );

  static const spaceH12V4 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH12,
    vertical: Sizes.marginV4,
  );

  static const spaceH12V2 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH12,
    vertical: Sizes.marginV2,
  );

  static const spaceH16 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH16,
  );

  static const spaceH20 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH20,
  );

  static const spaceH24 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH24,
  );

  static const spaceH26V10 = EdgeInsets.symmetric(
      horizontal: Sizes.marginH26, vertical: Sizes.marginV10);

  static const spaceH26V20 = EdgeInsets.symmetric(
      horizontal: Sizes.marginH26, vertical: Sizes.marginV20);

  static const spaceV20 = EdgeInsets.symmetric(
    vertical: Sizes.marginV20,
  );
  static const spaceV10 = EdgeInsets.symmetric(
    vertical: Sizes.marginV10,
  );

  static const spaceH16V20 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH16,
    vertical: Sizes.marginV20,
  );

  static const spaceH16V10 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH16,
    vertical: Sizes.marginV10,
  );

  static const spaceH16V6 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH16,
    vertical: Sizes.marginV6,
  );

  static const spaceH8V4 = EdgeInsets.symmetric(
    horizontal: Sizes.marginH8,
    vertical: Sizes.marginV4,
  );
}
