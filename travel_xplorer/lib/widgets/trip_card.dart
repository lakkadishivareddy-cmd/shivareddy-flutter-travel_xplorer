import 'package:flutter/material.dart';

import '../models/trip.dart';
import '../utils/formatters.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TripCard({super.key, required this.trip, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final over = trip.spent > trip.budget;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 92,
              decoration: BoxDecoration(gradient: trip.destination.gradient),
              child: Center(
                child: Icon(trip.destination.icon, size: 40, color: Colors.white),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trip.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Delete trip',
                          visualDensity: VisualDensity.compact,
                          onPressed: onDelete,
                          icon: Icon(Icons.delete_outline, color: scheme.error),
                        ),
                      ],
                    ),
                    Text(
                      '${trip.destination.name}  •  ${formatDate(trip.start)} - ${formatDate(trip.end)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(value: trip.progress, minHeight: 6),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${trip.doneCount}/${trip.activities.length} done',
                              style: theme.textTheme.labelMedium),
                          Text(
                            '${formatMoney(trip.spent)} / ${formatMoney(trip.budget)}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: over ? scheme.error : scheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
