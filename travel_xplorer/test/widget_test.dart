import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:travel_xplorer/main.dart';
import 'package:travel_xplorer/providers/settings_provider.dart';
import 'package:travel_xplorer/providers/trip_provider.dart';

void main() {
  testWidgets('Splash leads to the Explore screen', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (_) => TripProvider()),
        ],
        child: const TravelXplorerApp(),
      ),
    );
    expect(find.text('Travel Xplorer'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('Where to next?'), findsOneWidget);
  });
}
