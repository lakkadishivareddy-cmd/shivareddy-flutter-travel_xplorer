import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/destinations_data.dart';
import '../providers/settings_provider.dart';
import '../providers/trip_provider.dart';
import '../routes/app_router.dart';
import '../utils/responsive.dart';
import '../widgets/app_text_field.dart';
import '../widgets/category_chip.dart';
import '../widgets/destination_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/fade_slide_in.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trips = context.watch<TripProvider>();
    final name = context.select<SettingsProvider, String>((s) => s.userName);
    final destinations = trips.filteredDestinations;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.tripForm),
        icon: const Icon(Icons.add),
        label: const Text('Plan a trip'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final hPad = Responsive.horizontalPadding(constraints.maxWidth);
          final cols = Responsive.gridColumns(constraints.maxWidth - hPad * 2);
          final ratio = cols == 1 ? 1.6 : 1.2;

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 8),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, $name 👋',
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 4),
                      Text('Where to next?',
                          style: theme.textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Search destinations',
                        hint: 'Try "Bali" or "India"',
                        icon: Icons.search,
                        initialValue: trips.query,
                        onChanged: (v) => context.read<TripProvider>().setQuery(v),
                      ),
                      const SizedBox(height: 14),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final c in kCategories)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: CategoryChip(
                                  label: c,
                                  selected: trips.category == c,
                                  onTap: () => context.read<TripProvider>().setCategory(c),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              if (destinations.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    icon: Icons.search_off,
                    title: 'No destinations found',
                    message: 'Try a different search term or category.',
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 96),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: ratio,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => FadeSlideIn(
                        index: i,
                        child: DestinationCard(
                          destination: destinations[i],
                          heroTag: 'explore-${destinations[i].id}',
                        ),
                      ),
                      childCount: destinations.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
