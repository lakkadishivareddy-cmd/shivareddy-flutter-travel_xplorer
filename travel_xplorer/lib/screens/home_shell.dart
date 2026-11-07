import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trip_provider.dart';
import '../utils/responsive.dart';
import 'explore_screen.dart';
import 'favorites_screen.dart';
import 'my_trips_screen.dart';
import 'settings_screen.dart';

/// Main navigation shell. Adapts to screen size:
///  - mobile  -> bottom NavigationBar
///  - tablet  -> compact NavigationRail
///  - desktop -> extended NavigationRail with labels
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _pages = <Widget>[
    ExploreScreen(),
    MyTripsScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  static const _labels = ['Explore', 'My Trips', 'Favourites', 'Settings'];
  static const _icons = [
    Icons.explore_outlined,
    Icons.luggage_outlined,
    Icons.favorite_border,
    Icons.settings_outlined,
  ];
  static const _selectedIcons = [
    Icons.explore,
    Icons.luggage,
    Icons.favorite,
    Icons.settings,
  ];

  Widget _icon(int i, {required bool selected, required int favCount}) {
    final icon = Icon(selected ? _selectedIcons[i] : _icons[i]);
    if (i == 2) {
      return Badge(label: Text('$favCount'), isLabelVisible: favCount > 0, child: icon);
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    final type = Responsive.of(context);
    final favCount = context.select<TripProvider, int>((p) => p.favoriteIds.length);
    final body = IndexedStack(index: _index, children: _pages);

    if (type == ScreenType.mobile) {
      return Scaffold(
        body: SafeArea(child: body),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            for (var i = 0; i < _labels.length; i++)
              NavigationDestination(
                icon: _icon(i, selected: false, favCount: favCount),
                selectedIcon: _icon(i, selected: true, favCount: favCount),
                label: _labels[i],
              ),
          ],
        ),
      );
    }

    final extended = type == ScreenType.desktop;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              extended: extended,
              selectedIndex: _index,
              labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
              onDestinationSelected: (i) => setState(() => _index = i),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flight_takeoff, color: Theme.of(context).colorScheme.primary),
                    if (extended) ...[
                      const SizedBox(width: 8),
                      Text('Travel Xplorer',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ],
                ),
              ),
              destinations: [
                for (var i = 0; i < _labels.length; i++)
                  NavigationRailDestination(
                    icon: _icon(i, selected: false, favCount: favCount),
                    selectedIcon: _icon(i, selected: true, favCount: favCount),
                    label: Text(_labels[i]),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
