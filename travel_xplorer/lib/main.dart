import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/settings_provider.dart';
import 'providers/trip_provider.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    // Provider: state shared across the whole widget tree.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
      ],
      child: const TravelXplorerApp(),
    ),
  );
}

class TravelXplorerApp extends StatelessWidget {
  const TravelXplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return MaterialApp(
      title: 'Travel Xplorer - Travel Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generate,
    );
  }
}
