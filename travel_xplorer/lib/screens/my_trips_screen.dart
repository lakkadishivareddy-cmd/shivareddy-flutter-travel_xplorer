import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/trip.dart';
import '../providers/trip_provider.dart';
import '../routes/app_router.dart';
import '../utils/formatters.dart';
import '../utils/responsive.dart';
import '../widgets/empty_state.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_tile.dart';
import '../widgets/trip_card.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, Trip trip) async {
    final provider = context.read<TripProvider>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete trip?'),
        content: Text('"${trip.title}" and its itinerary will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      provider.removeTrip(trip.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TripProvider>();
    final trips = provider.trips;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: trips.isEmpty
          ? null
          : FloatingActionButton.extended(
        heroTag: null,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.tripForm),
              icon: const Icon(Icons.add),
              label: const Text('New trip'),
            ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final hPad = Responsive.horizontalPadding(constraints.maxWidth);
          final cols = constraints.maxWidth - hPad * 2 >= 760 ? 2 : 1;

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 12),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: 'My Trips',
                        subtitle: 'Plan, track and budget your journeys',
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          StatTile(icon: Icons.luggage, value: '${trips.length}', label: 'Trips planned'),
                          StatTile(icon: Icons.public, value: '${provider.countryCount}', label: 'Countries'),
                          StatTile(
                              icon: Icons.account_balance_wallet,
                              value: formatMoney(provider.totalBudget),
                              label: 'Total budget'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (trips.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    icon: Icons.luggage_outlined,
                    title: 'No trips yet',
                    message: 'Create your first trip and start building an itinerary.',
                    action: PrimaryButton(
                      label: 'Plan a trip',
                      icon: Icons.add,
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.tripForm),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 96),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      mainAxisExtent: 150,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => FadeSlideIn(
                        index: i,
                        child: TripCard(
                          trip: trips[i],
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.tripDetail,
                            arguments: trips[i].id,
                          ),
                          onDelete: () => _confirmDelete(context, trips[i]),
                        ),
                      ),
                      childCount: trips.length,
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
