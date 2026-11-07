import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trip_provider.dart';
import '../utils/responsive.dart';
import '../widgets/destination_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/section_header.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<TripProvider>().favoriteDestinations;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final hPad = Responsive.horizontalPadding(constraints.maxWidth);
          final cols = Responsive.gridColumns(constraints.maxWidth - hPad * 2);
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 16),
                sliver: const SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Favourites',
                    subtitle: 'Places you want to visit someday',
                  ),
                ),
              ),
              if (favs.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    icon: Icons.favorite_border,
                    title: 'No favourites yet',
                    message: 'Tap the heart on any destination to save it here.',
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 32),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: cols == 1 ? 1.6 : 1.2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => FadeSlideIn(
                        index: i,
                        child: DestinationCard(
                          destination: favs[i],
                          heroTag: 'fav-${favs[i].id}',
                        ),
                      ),
                      childCount: favs.length,
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
