import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/destination.dart';
import '../providers/trip_provider.dart';
import '../routes/app_router.dart';
import '../utils/formatters.dart';

/// Card built with Stack: gradient background, rating chip, favourite button
/// and a text overlay. The background is a Hero for a shared-element transition.
class DestinationCard extends StatelessWidget {
  final Destination destination;
  final String heroTag;

  const DestinationCard({super.key, required this.destination, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final d = destination;
    final isFav = context.select<TripProvider, bool>((p) => p.isFavorite(d.id));

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.destination,
          arguments: DestinationArgs(d, heroTag),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: heroTag,
              child: Container(
                decoration: BoxDecoration(gradient: d.gradient),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Transform.translate(
                    offset: const Offset(24, 20),
                    child: Icon(d.icon, size: 150, color: Colors.white.withOpacity(0.18)),
                  ),
                ),
              ),
            ),
            // dark fade for text legibility
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
                    stops: const [0.45, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(d.rating.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                tooltip: isFav ? 'Remove from favourites' : 'Add to favourites',
                onPressed: () => context.read<TripProvider>().toggleFavorite(d.id),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(isFav),
                    color: isFav ? Colors.redAccent : Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    d.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.place, size: 14, color: Colors.white70),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          d.country,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                      Text(
                        '${formatMoney(d.pricePerDay)}/day',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
