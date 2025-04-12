part of 'app_styles.dart';

abstract class TextStyles {
  // This is necessary for smooth fontFamily changes when changing app language,
  // that's because the fontFamily change from the theme have a slight delay.
  static TextStyle _mainStyle(BuildContext context) => const TextStyle(
        fontFamily: FontStyles.familyPoppins,
      );

  static TextStyle _mainStyleCommon() => const TextStyle(
        fontFamily: FontStyles.familyPoppins,
      );

  static TextStyle f28(BuildContext context) => _mainStyle(context).copyWith(
        color: Colors.black,
        fontSize: Sizes.font28,
        fontWeight: FontStyles.fontWeightBlack,
      );

  static TextStyle f20(BuildContext context) => _mainStyle(context).copyWith(
        color: Colors.black,
        fontSize: Sizes.font20,
        fontWeight: FontStyles.fontWeightBlack,
      );

  static TextStyle f18(BuildContext context) => _mainStyle(context).copyWith(
        color: Colors.black,
        fontSize: Sizes.font18,
      );

  static TextStyle f18SemiBold(BuildContext context) =>
      f18(context).copyWith(fontWeight: FontStyles.fontWeightSemiBold);

  static TextStyle f16(BuildContext context) => _mainStyle(context).copyWith(
        color: Colors.black,
        fontSize: Sizes.font16,
        fontWeight: FontWeight.w500,
      );

  static TextStyle f16SemiBold(BuildContext context) =>
      f16(context).copyWith(fontWeight: FontStyles.fontWeightSemiBold);

  static TextStyle f14(BuildContext context) => _mainStyle(context).copyWith(
        color: Colors.black,
        fontSize: Sizes.font14,
        fontWeight: FontWeight.w500,
      );

  static TextStyle f10(BuildContext context) => _mainStyle(context).copyWith(
        color: Colors.black,
        fontSize: Sizes.font10,
        fontWeight: FontWeight.w300,
      );

  static TextStyle f12(BuildContext context) => _mainStyle(context).copyWith(
        color: Colors.black,
        fontSize: Sizes.font12,
        fontWeight: FontWeight.w300,
      );

  static TextStyle titleLarge(Color color) => TextStyle(
      color: color,
      fontSize: Sizes.font18,
      fontFamily: FontStyles.familyPoppins);

  static TextStyle titleMedium(Color color) => TextStyle(
      color: color,
      fontSize: Sizes.font14,
      fontFamily: FontStyles.familyPoppins);

  static TextStyle inputDecorationHint(Color color) => TextStyle(
      color: color,
      fontSize: Sizes.font12,
      fontFamily: FontStyles.familyPoppins);

  static TextStyle inputDecorationError(Color color) => TextStyle(
      color: color,
      fontSize: Sizes.font12,
      fontFamily: FontStyles.familyPoppins);

  static TextStyle navigationLabel(Color color) => TextStyle(
      color: color,
      fontSize: Sizes.font12,
      fontFamily: FontStyles.familyPoppins);

  static TextStyle coloredElevatedButton(BuildContext context) =>
      f16(context).copyWith(
        color: const Color(0xffffffff),
        fontWeight: FontStyles.fontWeightSemiBold,
      );

  static TextStyle dialogTitle(Color color) => TextStyle(
        color: color,
        fontSize: Sizes.font18,
        fontWeight: FontStyles.fontWeightBold,
      );

  static TextStyle dialogContent(Color color) =>
      TextStyle(color: color, fontSize: Sizes.font16);

  static TextStyle cupertinoDialogAction(BuildContext context) =>
      f16SemiBold(context);

  static TextStyle button(Color color) => TextStyle(
        fontFamily: FontStyles.familyPoppins,
        fontSize: Sizes.font14,
        fontWeight: FontWeight.bold,
        color: color,
      );

  static TextStyle f14Common({
    FontWeight? fontWeight,
  }) =>
      _mainStyleCommon().copyWith(
        fontSize: Sizes.font14,
        fontWeight: fontWeight,
      );

  static TextStyle f16Common({
    FontWeight? fontWeight,
  }) =>
      _mainStyleCommon().copyWith(
        fontSize: Sizes.font16,
        fontWeight: fontWeight,
      );

  static TextStyle hint12Common() =>
      _mainStyleCommon().copyWith(fontSize: Sizes.font12);
}
