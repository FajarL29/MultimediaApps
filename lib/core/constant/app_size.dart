part of 'app_styles.dart';

/// * H = Horizontal
/// * V = Vertical
abstract class Sizes {
  static final double statusBarHeight = MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.single)
      .padding
      .top;

  static final double homeIndicatorHeight = MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.single)
      .viewPadding
      .bottom;

  static const double image300 = 300;
  static const double image200 = 200;
  static const double image100 = 100;
  static const double image50 = 50;

  /// Font Sizes
  /// You can use these directly if you need, but usually there should be a predefined style in TextStyles
  static const double font28 = 28;
  static const double font26 = 26;
  static const double font20 = 20;
  static const double font18 = 18;
  static const double font16 = 16;
  static const double font14 = 14;
  static const double font12 = 12;
  static const double font10 = 10;

  // Icon Sizes
  static const double icon50 = 50;
  static const double icon30 = 30;
  static const double icon26 = 26;
  static const double icon24 = 24;
  static const double icon22 = 22;
  static const double icon20 = 20;
  static const double icon16 = 16;
  static const double icon14 = 14;
  static const double icon12 = 12;
  static const double icon10 = 10;
  static const double icon8 = 8;

  // Screen Padding
  static const double screenPaddingV10 = 10;
  static const double screenPaddingV20 = 20;
  static const double screenPaddingV16 = 16;
  static const double screenPaddingV12 = 12;
  static const double screenPaddingH36 = 36;
  static const double screenPaddingH28 = 28;
  static const double screenPaddingH6 = 6;
  static const double screenPaddingH4 = 4;

  // Widget Margin
  static const double marginV40 = 40;
  static const double marginV32 = 32;
  static const double marginV28 = 28;
  static const double marginV24 = 24;
  static const double marginV20 = 20;
  static const double marginV16 = 16;
  static const double marginV12 = 12;
  static const double marginV10 = 10;
  static const double marginV8 = 8;
  static const double marginV6 = 6;
  static const double marginV4 = 4;
  static const double marginV2 = 2;
  static const double marginH28 = 28;
  static const double marginH26 = 26;
  static const double marginH24 = 24;
  static const double marginH20 = 20;
  static const double marginH16 = 16;
  static const double marginH12 = 12;
  static const double marginH10 = 10;
  static const double marginH8 = 8;
  static const double marginH6 = 6;
  static const double marginH4 = 4;
  static const double marginH2 = 2;

  // Widget Padding
  static const double paddingV20 = 20;
  static const double paddingV16 = 16;
  static const double paddingV14 = 14;
  static const double paddingV12 = 12;
  static const double paddingV10 = 10;
  static const double paddingV8 = 8;
  static const double paddingV4 = 4;
  static const double paddingH24 = 24;
  static const double paddingH20 = 20;
  static const double paddingH14 = 14;
  static const double paddingH12 = 12;
  static const double paddingH10 = 10;
  static const double paddingH8 = 8;
  static const double paddingH4 = 4;

  // Widget Constraints
  static const double defaultScreenWidth = 430;
  static const double defaultScreenHeight = 932;

  static const double maxWidth360 = 360;
  static const double maxWidth130 = 130;

  // Button
  static const double buttonPaddingV14 = 14;
  static const double buttonPaddingV12 = 12;
  static const double buttonPaddingH80 = 80;
  static const double buttonPaddingH34 = 34;
  static const double buttonR24 = 24;
  static const double buttonR4 = 4;

  // Card
  static const double cardR12 = 12;
  static const double cardPaddingV16 = 16;
  static const double cardPaddingH20 = 20;

  // Dialog
  static const double dialogWidth280 = 280;
  static const double dialogR20 = 20;
  static const double dialogR6 = 4;
  static const double dialogPaddingV28 = 28;
  static const double dialogPaddingV20 = 20;
  static const double dialogPaddingH20 = 20;

  // Image
  static const double imageR28 = 28;

  // HomeShell
  static const double appBarHeight56 = 56;
  static const double appBarLeadingWidth = 68;
  static const double appBarElevation = 0;
  static const double drawerWidth240 = 240;
  static const double drawerPaddingV88 = 88;
  static const double drawerPaddingH28 = 28;
  static const double navBarHeight60 = 60;
  static const double navBarIconR22 = 22;
  static const double navBarElevation = 4;

  // Map
  static const double mapSearchBarRadius = 8;
  static const double mapDirectionsInfoTop = 112;

  // TextForm
  static const double textFieldSpace = 10;
}
