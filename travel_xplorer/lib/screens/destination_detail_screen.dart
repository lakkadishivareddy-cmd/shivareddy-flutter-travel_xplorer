import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/destination.dart';
import '../providers/trip_provider.dart';
import '../routes/app_router.dart';
import '../utils/formatters.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_header.dart';

class DestinationDetailScreen extends StatefulWidget {
  final DestinationArgs args;
  const DestinationDetailScreen({super.key, required this.args});

  @override
  State<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> {
  double _days = 5;
  int _people = 2;

  @override
  Widget build(BuildContext context) {
    final d = widget.args.destination;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isFav = context.select<TripProvider, bool>((p) => p.isFavorite(d.id));
    final total = d.pricePerDay * _days.round() * _people;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            backgroundColor: d.colors.first,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                tooltip: 'Favourite',
                onPressed: () => context.read<TripProvider>().toggleFavorite(d.id),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(isFav),
                    color: isFav ? Colors.redAccent : Colors.white,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w800)),
              background: Hero(
                tag: widget.args.heroTag,
                child: Container(
                  decoration: BoxDecoration(gradient: d.gradient),
                  child: Center(
                    child: Icon(d.icon, size: 140, color: Colors.white.withOpacity(0.25)),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(avatar: const Icon(Icons.public, size: 18), label: Text(d.country)),
                          Chip(
                              avatar: const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                              label: Text('${d.rating}')),
                          Chip(
                              avatar: const Icon(Icons.calendar_month, size: 18),
                              label: Text('Best: ${d.bestTime}')),
                          Chip(
                              avatar: const Icon(Icons.payments_outlined, size: 18),
                              label: Text('${formatMoney(d.pricePerDay)}/day')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(d.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
                      const SizedBox(height: 24),
                      const SectionHeader(title: 'Top highlights'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (var i = 0; i < d.highlights.length; i++)
                            FadeSlideIn(
                              index: i,
                              child: Chip(
                                avatar: Icon(Icons.place, size: 18, color: scheme.primary),
                                label: Text(d.highlights[i]),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const SectionHeader(
                        title: 'Cost estimator',
                        subtitle: 'Adjust days and travellers to see a rough budget',
                      ),
                      const SizedBox(height: 12),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Duration: ${_days.round()} days',
                                  style: theme.textTheme.titleSmall),
                              Slider(
                                value: _days,
                                min: 1,
                                max: 14,
                                divisions: 13,
                                label: '${_days.round()} days',
                                onChanged: (v) => setState(() => _days = v),
                              ),
                              Row(
                                children: [
                                  Text('Travellers', style: theme.textTheme.titleSmall),
                                  const Spacer(),
                                  IconButton.filledTonal(
                                    onPressed: _people > 1 ? () => setState(() => _people--) : null,
                                    icon: const Icon(Icons.remove),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: Text('$_people',
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.titleMedium),
                                  ),
                                  IconButton.filledTonal(
                                    onPressed: _people < 10 ? () => setState(() => _people++) : null,
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                              const Divider(height: 28),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Estimated total'),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    transitionBuilder: (c, a) => FadeTransition(
                                      opacity: a,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                                begin: const Offset(0, 0.3), end: Offset.zero)
                                            .animate(a),
                                        child: c,
                                      ),
                                    ),
                                    child: Text(
                                      formatMoney(total),
                                      key: ValueKey(total),
                                      style: theme.textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.w800, color: scheme.primary),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Plan a trip to ${d.name}',
                        icon: Icons.flight_takeoff,
                        expanded: true,
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.tripForm, arguments: d),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
