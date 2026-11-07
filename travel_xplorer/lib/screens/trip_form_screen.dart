import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/destinations_data.dart';
import '../models/destination.dart';
import '../providers/trip_provider.dart';
import '../routes/app_router.dart';
import '../utils/formatters.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

/// Form with validation for creating a trip.
class TripFormScreen extends StatefulWidget {
  final Destination? initialDestination;
  const TripFormScreen({super.key, this.initialDestination});

  @override
  State<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  final _travellersCtrl = TextEditingController(text: '1');

  Destination? _destination;
  DateTime? _start;
  DateTime? _end;
  bool _suggest = true;

  @override
  void initState() {
    super.initState();
    _destination = widget.initialDestination;
    if (_destination != null) _titleCtrl.text = 'Trip to ${_destination!.name}';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _budgetCtrl.dispose();
    _travellersCtrl.dispose();
    super.dispose();
  }

  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final first = isStart ? _today : (_start ?? _today);
    var initial = isStart ? (_start ?? _today) : (_end ?? _start ?? _today);
    if (initial.isBefore(first)) initial = first;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime(_today.year + 3),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _start = picked;
        _startCtrl.text = formatDate(picked);
        if (_end != null && _end!.isBefore(picked)) {
          _end = null;
          _endCtrl.clear();
        }
      } else {
        _end = picked;
        _endCtrl.text = formatDate(picked);
      }
    });
  }

  int? get _tripDays {
    if (_start == null || _end == null) return null;
    return DateTime.utc(_end!.year, _end!.month, _end!.day)
            .difference(DateTime.utc(_start!.year, _start!.month, _start!.day))
            .inDays +
        1;
  }

  /// Rough budget suggestion shown below the budget field.
  int? get _suggestedBudget {
    final days = _tripDays;
    final people = int.tryParse(_travellersCtrl.text);
    if (_destination == null || days == null || people == null || people < 1) return null;
    return _destination!.pricePerDay * days * people;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the highlighted fields')),
      );
      return;
    }
    final id = context.read<TripProvider>().addTrip(
          title: _titleCtrl.text.trim(),
          destination: _destination!,
          start: _start!,
          end: _end!,
          budget: double.parse(_budgetCtrl.text),
          travellers: int.parse(_travellersCtrl.text),
          suggestActivities: _suggest,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trip created!')),
    );
    Navigator.pushReplacementNamed(context, AppRoutes.tripDetail, arguments: id);
  }

  Widget _pair(bool wide, Widget a, Widget b) {
    if (!wide) {
      return Column(children: [a, const SizedBox(height: 16), b]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Expanded(child: a), const SizedBox(width: 16), Expanded(child: b)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestion = _suggestedBudget;

    return Scaffold(
      appBar: AppBar(title: const Text('Plan a trip')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 560;
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Trip details',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Trip name',
                        hint: 'e.g. Summer holiday',
                        icon: Icons.edit_outlined,
                        controller: _titleCtrl,
                        validator: (v) {
                          final t = (v ?? '').trim();
                          if (t.isEmpty) return 'Trip name is required';
                          if (t.length < 3) return 'Use at least 3 characters';
                          if (t.length > 40) return 'Use at most 40 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<Destination>(
                        value: _destination,
                        isExpanded: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: appInputDecoration(context,
                            label: 'Destination', icon: Icons.place_outlined),
                        items: [
                          for (final d in kDestinations)
                            DropdownMenuItem(value: d, child: Text('${d.name}, ${d.country}')),
                        ],
                        validator: (v) => v == null ? 'Please choose a destination' : null,
                        onChanged: (v) => setState(() => _destination = v),
                      ),
                      const SizedBox(height: 16),
                      _pair(
                        wide,
                        AppTextField(
                          label: 'Start date',
                          icon: Icons.event,
                          controller: _startCtrl,
                          readOnly: true,
                          onTap: () => _pickDate(isStart: true),
                          validator: (_) => _start == null ? 'Select a start date' : null,
                        ),
                        AppTextField(
                          label: 'End date',
                          icon: Icons.event_available,
                          controller: _endCtrl,
                          readOnly: true,
                          onTap: () => _pickDate(isStart: false),
                          validator: (_) {
                            if (_end == null) return 'Select an end date';
                            if (_start != null && _end!.isBefore(_start!)) {
                              return 'End date must be after start date';
                            }
                            if ((_tripDays ?? 0) > 30) return 'Trips can be at most 30 days';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _pair(
                        wide,
                        AppTextField(
                          label: 'Travellers',
                          icon: Icons.group_outlined,
                          controller: _travellersCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (_) => setState(() {}),
                          validator: (v) {
                            final n = int.tryParse(v ?? '');
                            if (n == null) return 'Enter a number';
                            if (n < 1 || n > 20) return 'Enter 1 to 20 travellers';
                            return null;
                          },
                        ),
                        AppTextField(
                          label: 'Total budget (₹)',
                          icon: Icons.account_balance_wallet_outlined,
                          controller: _budgetCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (v) {
                            final n = double.tryParse(v ?? '');
                            if (n == null) return 'Enter your budget';
                            if (n <= 0) return 'Budget must be greater than 0';
                            if (n > 100000000) return 'That seems too high';
                            return null;
                          },
                        ),
                      ),
                      if (suggestion != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb_outline, size: 18, color: theme.colorScheme.primary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text('Suggested budget: ${formatMoney(suggestion)}',
                                    style: theme.textTheme.bodyMedium),
                              ),
                              TextButton(
                                onPressed: () => setState(() => _budgetCtrl.text = '$suggestion'),
                                child: const Text('Use this'),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Add suggested activities'),
                        subtitle: const Text('Pre-fill the itinerary with top highlights'),
                        value: _suggest,
                        onChanged: (v) => setState(() => _suggest = v),
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: 'Create trip',
                        icon: Icons.check_circle_outline,
                        expanded: true,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
