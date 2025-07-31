part of 'router.dart';

@TypedShellRoute<RootShellRouteData>(
  routes: [
    TypedGoRoute<HomeRoute>(
      path: '/home',
      name: 'Home',
      routes: [
        TypedGoRoute<ArchiveRoute>(
          path: 'archive',
          name: 'Archive',
        ),
        TypedGoRoute<JarDetailRoute>(
          path: 'jar',
          name: 'JarDetail',
        ),
      ],
    ),
    TypedGoRoute<SettingsRoute>(
      path: '/settings',
      name: 'Settings',
      routes: [
        TypedGoRoute<FeedbackRoute>(
          path: 'feedback',
          name: 'Feedback',
        ),
      ]
    ),
    TypedGoRoute<CreateJarRoute>(
      path: '/create',
      name: 'Create',
    ),
  ],
)
class RootShellRouteData extends ShellRouteData {
  const RootShellRouteData();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return RootScreen(navigator: navigator);
  }
}

@TypedGoRoute<OnboardingRoute>(
  path: '/onboarding',
  name: 'Onboarding',
)
class OnboardingRoute extends GoRouteData {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const OnboardingScreen();
}

@TypedGoRoute<ErrorRoute>(
  path: '/error',
  name: 'Error',
)
class ErrorRoute extends GoRouteData {
  const ErrorRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ErrorScreen();
}

class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class ArchiveRoute extends GoRouteData {
  const ArchiveRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ArchiveScreen();
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SettingsScreen();
}

class FeedbackRoute extends GoRouteData {
  const FeedbackRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const FeedbackScreen();
}

class CreateJarRoute extends GoRouteData {
  const CreateJarRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const CreateJarScreen();
}

class JarDetailRoute extends GoRouteData {
  final Jar $extra;

  const JarDetailRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return JarDetailScreen(jar: $extra);
  }
}
