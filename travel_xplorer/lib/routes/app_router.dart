import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../screens/destination_detail_screen.dart';
import '../screens/home_shell.dart';
import '../screens/splash_screen.dart';
import '../screens/trip_detail_screen.dart';
import '../screens/trip_form_screen.dart';

/// Named routes used throughout the app.
class AppRoutes {
  AppRoutes._();
  static const splash = '/';
  static const home = '/home';
  static const destination = '/destination';
  static const tripForm = '/trip/new';
  static const tripDetail = '/trip/detail';
}

class AppRouter {
  AppRouter._();

  static Route<dynamic> generate(RouteSettings settings) {
    final Widget page;
    switch (settings.name) {
      case AppRoutes.splash:
        page = const SplashScreen();
        break;
      case AppRoutes.destination:
        page = DestinationDetailScreen(args: settings.arguments as DestinationArgs);
        break;
      case AppRoutes.tripForm:
        page = TripFormScreen(initialDestination: settings.arguments as Destination?);
        break;
      case AppRoutes.tripDetail:
        page = TripDetailScreen(tripId: settings.arguments as String);
        break;
      case AppRoutes.home:
      default:
        page = const HomeShell();
    }

    // Custom page transition: fade + slight upward slide.
    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
