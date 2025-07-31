import 'package:echojar/app/database/src/storage/schemes/jar.dart';
import 'package:echojar/common/presentation/error_screen.dart';
import 'package:echojar/features/archive/archive_screen.dart';
import 'package:echojar/features/create-jar/presentation/create_jar_screen.dart';
import 'package:echojar/features/home/jar_detail_screen.dart';
import 'package:echojar/features/home/home_screen.dart';
import 'package:echojar/features/onboarding/onboarding_screen.dart';
import 'package:echojar/features/root/root_screen.dart';
import 'package:echojar/features/settings/feedback_screen.dart';
import 'package:echojar/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

export 'package:go_router/go_router.dart';

part 'router.g.dart';
part 'routes.dart';

/// This line declares a global key variable which is used to access the
/// `NavigatorState` object associated with a widget.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

String? getCurrentPath() {
  if (navigatorKey.currentContext != null) {
    final routerDelegate =
        GoRouter.of(navigatorKey.currentContext!).routerDelegate;
    final lastMatch = routerDelegate.currentConfiguration.last;
    final matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    final location = matchList.uri.toString();
    return location;
  } else {
    return null;
  }
}

/// This function returns a [CustomTransitionPage] widget with default
/// fade animation.
CustomTransitionPage<T> buildPageWithDefaultTransition<T>({
  required GoRouterState state,
  required Widget child,
}) =>
    CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );

/// This function returns a [NoTransitionPage] widget with no animation.
CustomTransitionPage<T> buildPageWithNoTransition<T>({
  required GoRouterState state,
  required Widget child,
}) =>
    NoTransitionPage<T>(
      key: state.pageKey,
      child: child,
    );

/// This function returns a dynamic [Page] widget based on the input parameters.
/// It uses the '[buildPageWithDefaultTransition]' function to create a page
/// with a default [fade animation].
Page<dynamic> Function(GoRouterState state) defaultPageBuilder<T>(
    Widget child,
    ) =>
        (state) => buildPageWithDefaultTransition<T>(
      state: state,
      child: child,
    );

/// [createRouter] is a factory function that creates a [GoRouter] instance
/// with all routes.
GoRouter createRouter({required bool hasSeenIntro}) => GoRouter(
  initialLocation: hasSeenIntro ? const HomeRoute().location : const OnboardingRoute().location,
  navigatorKey: navigatorKey,
  errorBuilder: (_, state) {
    final error = state.matchedLocation;
    print('ERROR $error');
    return const ErrorScreen();
  },
  routes: $appRoutes,
);
