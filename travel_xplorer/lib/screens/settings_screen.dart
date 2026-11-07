import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../utils/responsive.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: context.read<SettingsProvider>().userName);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _saveName() {
    if (_formKey.currentState!.validate()) {
      context.read<SettingsProvider>().setUserName(_nameCtrl.text);
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final hPad = Responsive.horizontalPadding(constraints.maxWidth);
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Settings', subtitle: 'Personalise Travel Xplorer'),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Profile',
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 14),
                              AppTextField(
                                label: 'Display name',
                                icon: Icons.person_outline,
                                controller: _nameCtrl,
                                validator: (v) {
                                  final t = (v ?? '').trim();
                                  if (t.isEmpty) return 'Please enter your name';
                                  if (t.length < 2) return 'Name must be at least 2 characters';
                                  if (t.length > 20) return 'Keep it under 20 characters';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              PrimaryButton(label: 'Save', icon: Icons.check, onPressed: _saveName),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Appearance',
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              child: SegmentedButton<ThemeMode>(
                                segments: const [
                                  ButtonSegment(
                                      value: ThemeMode.system,
                                      icon: Icon(Icons.brightness_auto),
                                      label: Text('System')),
                                  ButtonSegment(
                                      value: ThemeMode.light,
                                      icon: Icon(Icons.light_mode),
                                      label: Text('Light')),
                                  ButtonSegment(
                                      value: ThemeMode.dark,
                                      icon: Icon(Icons.dark_mode),
                                      label: Text('Dark')),
                                ],
                                selected: {settings.themeMode},
                                onSelectionChanged: (s) =>
                                    context.read<SettingsProvider>().setThemeMode(s.first),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: const ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text('Travel Xplorer 1.0.0'),
                        subtitle: Text('Travel Planner built with Flutter and Provider'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
