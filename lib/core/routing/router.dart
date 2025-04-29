import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multimedia_apps/core/routing/navigation_route.dart';
import 'package:multimedia_apps/presentation/page/bluetooth.dart';
import 'package:multimedia_apps/presentation/page/dashboard_menu.dart';
import 'package:multimedia_apps/presentation/page/homepage.dart';
import 'package:multimedia_apps/presentation/page/phone_components.dart';
import 'package:multimedia_apps/presentation/widget/new/air_quality.dart';
import 'package:multimedia_apps/presentation/widget/new/driver_health.dart';

final parentNavKey = GlobalKey<NavigatorState>();
final homeMultiNavKey = GlobalKey<NavigatorState>();
final navigationNavKey = GlobalKey<NavigatorState>();

GoRouter goRouter() {
  final router = GoRouter(
    navigatorKey: parentNavKey,
    debugLogDiagnostics: true,
    restorationScopeId: 'router',
    initialLocation: '/',
    routes: $appRoutes,
  );

  return router;
}

List<RouteBase> get $appRoutes => [
      $homeNavRouteData,
    ];

RouteBase get $homeNavRouteData => StatefulShellRouteData.$route(
      restorationScopeId: HomeNavRouteData.$restorationScopeId,
      factory: $HomeNavRouteDataExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          restorationScopeId: CarNavigationBranchData.$restorationScopeId,
          routes: [
            GoRouteData.$route(
              path: '/',
              factory: $CarNavigationRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'music-list',
                  factory: $MusicListRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'bluetooth',
                  factory: $BluetoothRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'phone',
                  factory: $PhoneRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'DriverHealth',
                  factory: $DriverHealthRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'AirQuality',
                  factory: $AirQualityRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    );

extension $HomeNavRouteDataExtension on HomeNavRouteData {
  static HomeNavRouteData _fromState(GoRouterState state) =>
      const HomeNavRouteData();
}

extension $CarNavigationRouteExtension on CarNavigationRoute {
  static CarNavigationRoute _fromState(GoRouterState state) =>
      const CarNavigationRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MusicListRouteExtension on MusicListRoute {
  static MusicListRoute _fromState(GoRouterState state) =>
      const MusicListRoute();

  String get location => GoRouteData.$location(
        '/music-list',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $BluetoothRouteExtension on BluetoothRoute {
  static BluetoothRoute _fromState(GoRouterState state) =>
      const BluetoothRoute();

  String get location => GoRouteData.$location(
        '/bluetooth',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PhoneRouteExtension on PhoneRoute {
  static PhoneRoute _fromState(GoRouterState state) => const PhoneRoute();

  String get location => GoRouteData.$location(
        '/phone',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DriverHealthRouteExtension on DriverHealthRoute {
  static DriverHealthRoute _fromState(GoRouterState state) =>
      const DriverHealthRoute();
  String get location => GoRouteData.$location("/DriverHealth");
  void go(BuildContext context) => context.go(location);
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AirQualityRouteExtension on AirQualityRoute {
  static AirQualityRoute _fromState(GoRouterState state) =>
      const AirQualityRoute();
  String get location => GoRouteData.$location("/AirQuality");
  void go(BuildContext context) => context.go(location);
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

class HomeNavRouteData extends StatefulShellRouteData {
  const HomeNavRouteData();

  @override
  Page<void> pageBuilder(BuildContext context, GoRouterState state,
      StatefulNavigationShell navigationShell) {
    return FadeTransitionPage(
        state.pageKey, HomePage(navigationShell: navigationShell));
  }

  static const String $restorationScopeId = 'home_nav_shell';
}

class CarNavigationBranchData extends StatefulShellBranchData {
  const CarNavigationBranchData();
  static const String $restorationScopeId = 'car_navigation_branch';
}

class CarNavigationRoute extends GoRouteData {
  const CarNavigationRoute();

  static const routes = [
    TypedGoRoute<CarNavigationRoute>(path: CarNavigationRoute.path, routes: [
      TypedGoRoute<MusicListRoute>(path: MusicListRoute.path),
      TypedGoRoute<BluetoothRoute>(path: BluetoothRoute.path),
      TypedGoRoute<PhoneRoute>(path: PhoneRoute.path),
      TypedGoRoute<DriverHealthRoute>(path: DriverHealthRoute.path),
      TypedGoRoute<AirQualityRoute>(path: AirQualityRoute.path)
    ])
  ];

  static const String path = '/';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DashboardMenuPage();
}

class DriverHealthRoute extends GoRouteData {
  const DriverHealthRoute();
  static const String path = "DriverHealth";
  @override
  Widget build(BuildContext context, GoRouterState state) => HeartRateApp();
}

class AirQualityRoute extends GoRouteData {
  const AirQualityRoute();
  static const String path = "AirQuality";
  @override
  Widget build(BuildContext context, GoRouterState state) => AirQualityApp();
}

class MusicListRoute extends GoRouteData {
  const MusicListRoute();

  static const String path = 'music-list';
  @override
  Widget build(BuildContext context, GoRouterState state) => Container();
}

class BluetoothRoute extends GoRouteData {
  const BluetoothRoute();

  static const String path = 'bluetooth';
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BluetoothPage();
}

class PhoneRoute extends GoRouteData {
  const PhoneRoute();

  static const String path = 'phone';
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PhoneComponent();
}