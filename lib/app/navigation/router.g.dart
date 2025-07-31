// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $rootShellRouteData,
      $onboardingRoute,
      $errorRoute,
    ];

RouteBase get $rootShellRouteData => ShellRouteData.$route(
      factory: $RootShellRouteDataExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/home',
          name: 'Home',
          factory: $HomeRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'archive',
              name: 'Archive',
              factory: $ArchiveRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'jar',
              name: 'JarDetail',
              factory: $JarDetailRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/settings',
          name: 'Settings',
          factory: $SettingsRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'feedback',
              name: 'Feedback',
              factory: $FeedbackRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/create',
          name: 'Create',
          factory: $CreateJarRouteExtension._fromState,
        ),
      ],
    );

extension $RootShellRouteDataExtension on RootShellRouteData {
  static RootShellRouteData _fromState(GoRouterState state) =>
      const RootShellRouteData();
}

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ArchiveRouteExtension on ArchiveRoute {
  static ArchiveRoute _fromState(GoRouterState state) => const ArchiveRoute();

  String get location => GoRouteData.$location(
        '/home/archive',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $JarDetailRouteExtension on JarDetailRoute {
  static JarDetailRoute _fromState(GoRouterState state) => JarDetailRoute(
        $extra: state.extra as Jar,
      );

  String get location => GoRouteData.$location(
        '/home/jar',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  String get location => GoRouteData.$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $FeedbackRouteExtension on FeedbackRoute {
  static FeedbackRoute _fromState(GoRouterState state) => const FeedbackRoute();

  String get location => GoRouteData.$location(
        '/settings/feedback',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CreateJarRouteExtension on CreateJarRoute {
  static CreateJarRoute _fromState(GoRouterState state) =>
      const CreateJarRoute();

  String get location => GoRouteData.$location(
        '/create',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingRoute => GoRouteData.$route(
      path: '/onboarding',
      name: 'Onboarding',
      factory: $OnboardingRouteExtension._fromState,
    );

extension $OnboardingRouteExtension on OnboardingRoute {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  String get location => GoRouteData.$location(
        '/onboarding',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $errorRoute => GoRouteData.$route(
      path: '/error',
      name: 'Error',
      factory: $ErrorRouteExtension._fromState,
    );

extension $ErrorRouteExtension on ErrorRoute {
  static ErrorRoute _fromState(GoRouterState state) => const ErrorRoute();

  String get location => GoRouteData.$location(
        '/error',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
