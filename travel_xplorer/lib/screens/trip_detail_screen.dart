import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/trip.dart';
import '../providers/trip_provider.dart';
import '../utils/formatters.dart';
import '../widgets/app_text_field.dart';
import '../widgets/empty_state.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_tile.dart';

class TripDetailScreen extends StatelessWidget {
  final String tripId;
  const TripDetailScreen({super.key, required this.tripId});

  Future<void> _confirmDelete(BuildContext context, Trip trip) async {
    final provider = context.read<TripProvider>();
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete trip?'),
        content: Text('"${trip.title}" will be permanently removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      navigator.pop();
      provider.removeTrip(trip.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = context.watch<TripProvider>().tripById(tripId);

    if (trip == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.search_off,
          title: 'Trip not found',
          message: 'This trip may have been deleted.',
        ),
      );
    }

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final over = trip.spent > trip.budget;
    final perPerson = trip.travellers > 0 ? trip.spent / trip.travellers : 0;

    Widget centered(Widget child) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: child),
          ),
        );

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => showDialog(
          context: context,
          builder: (_) => ChangeNotifierProvider<TripProvider>.value(
            value: context.read<TripProvider>(),
            child: _AddActivityDialog(trip: trip),
          ),
        ),
        icon: const Icon(Icons.add_task),
        label: const Text('Add activity'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: trip.destination.colors.first,
            foregroundColor: Colors.white,
            title: Text(trip.title, overflow: TextOverflow.ellipsis),
            actions: [
              IconButton(
                tooltip: 'Delete trip',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context, trip),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: trip.destination.gradient),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: 30,
                      child: Icon(trip.destination.icon,
                          size: 160, color: Colors.white.withOpacity(0.2)),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 18,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${trip.destination.name}, ${trip.destination.country}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${formatDate(trip.start)} - ${formatDate(trip.end)}  •  ${trip.days} days',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: centered(
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Budget',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700)),
                                Text(
                                  over
                                      ? '${formatMoney(-trip.remaining)} over'
                                      : '${formatMoney(trip.remaining)} left',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: over ? scheme.error : scheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: trip.budgetUsed),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, _) => ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: value,
                                  minHeight: 12,
                                  color: over ? scheme.error : scheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('${formatMoney(trip.spent)} spent of ${formatMoney(trip.budget)}',
                                style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        StatTile(icon: Icons.group, value: '${trip.travellers}', label: 'Travellers'),
                        StatTile(
                            icon: Icons.person,
                            value: formatMoney(perPerson),
                            label: 'Spent per person'),
                        StatTile(
                            icon: Icons.task_alt,
                            value: '${trip.doneCount}/${trip.activities.length}',
                            label: 'Activities done'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const SectionHeader(title: 'Itinerary', subtitle: 'Swipe left to remove an activity'),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => centered(
                FadeSlideIn(
                  index: i,
                  child: _DayCard(trip: trip, dayIndex: i),
                ),
              ),
              childCount: trip.days,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 96)),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final Trip trip;
  final int dayIndex;
  const _DayCard({required this.trip, required this.dayIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final day = trip.dayAt(dayIndex);
    final items = trip.activitiesOn(day);
    final provider = context.read<TripProvider>();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: theme.colorScheme.primaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              'Day ${dayIndex + 1}  •  ${formatShortDate(day)}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Nothing planned yet',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            )
          else
            for (final a in items)
              Dismissible(
                key: ValueKey(a.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: theme.colorScheme.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => provider.removeActivity(trip.id, a.id),
                child: ListTile(
                  leading: Checkbox(
                    value: a.done,
                    onChanged: (_) => provider.toggleActivity(trip.id, a.id),
                  ),
                  title: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: (theme.textTheme.bodyLarge ?? const TextStyle()).copyWith(
                      decoration: a.done ? TextDecoration.lineThrough : TextDecoration.none,
                      color: a.done
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurface,
                    ),
                    child: Text(a.title),
                  ),
                  subtitle: Text(a.time),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (a.cost > 0)
                        Text(formatMoney(a.cost),
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      IconButton(
                        tooltip: 'Remove',
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => provider.removeActivity(trip.id, a.id),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

/// Dialog with a validated form to add an activity to the itinerary.
class _AddActivityDialog extends StatefulWidget {
  final Trip trip;
  const _AddActivityDialog({required this.trip});

  @override
  State<_AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<_AddActivityDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  late DateTime _day = widget.trip.dayAt(0);

  @override
  void dispose() {
    _titleCtrl.dispose();
    _timeCtrl.dispose();
    _costCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) {
      _timeCtrl.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<TripProvider>().addActivity(
          widget.trip.id,
          title: _titleCtrl.text.trim(),
          date: _day,
          time: _timeCtrl.text,
          cost: double.tryParse(_costCtrl.text) ?? 0,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add activity'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                AppTextField(
                  label: 'Activity',
                  hint: 'e.g. Visit the fort',
                  icon: Icons.local_activity_outlined,
                  controller: _titleCtrl,
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (t.isEmpty) return 'Enter an activity name';
                    if (t.length < 3) return 'Use at least 3 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<DateTime>(
                  value: _day,
                  isExpanded: true,
                  decoration: appInputDecoration(context, label: 'Day', icon: Icons.event),
                  items: [
                    for (var i = 0; i < widget.trip.days; i++)
                      DropdownMenuItem(
                        value: widget.trip.dayAt(i),
                        child: Text('Day ${i + 1} - ${formatShortDate(widget.trip.dayAt(i))}'),
                      ),
                  ],
                  onChanged: (v) => setState(() => _day = v ?? _day),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Time',
                  icon: Icons.schedule,
                  controller: _timeCtrl,
                  readOnly: true,
                  onTap: _pickTime,
                  validator: (v) => (v == null || v.isEmpty) ? 'Pick a time' : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Estimated cost (₹) - optional',
                  icon: Icons.payments_outlined,
                  controller: _costCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.isEmpty) return null;
                    final n = double.tryParse(v);
                    if (n == null || n < 0) return 'Enter a valid amount';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}
