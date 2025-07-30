import 'package:echojar/app/database/database.dart';
import 'package:echojar/common/services/local_notification_service.dart';
import 'package:echojar/common/utils/toaster.dart';
import 'package:echojar/features/settings/widgets/language_selector.dart';
import 'package:echojar/features/settings/widgets/name_editor.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String? loadedName;
  late String? loadedLanguage;

  String name = '';
  String selectedLanguage = '';

  final _config = AppConfigManager();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    loadedName = await _config.getUserName();
    loadedLanguage = await _config.getLanguage();

    if (!mounted) return;

    setState(() {
      name = loadedName ?? '';
      selectedLanguage = loadedLanguage ?? 'en';
    });
  }

  Future<void> _saveSettings(BuildContext context) async {
    if (!mounted) return;

    if (loadedName != name || loadedLanguage != selectedLanguage) {
      await _config.setUserName(name);
      await _config.setLanguage(selectedLanguage);
      Toaster.showSuccessToast(context, title: 'Settings saved');
    } else {
      Toaster.showErrorToast(context, title: 'Modify settings first');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              NameEditor(
                name: name,
                onChanged: (val) => setState(() => name = val),
              ),
              const SizedBox(height: 16),
              LanguageSelector(
                selected: selectedLanguage,
                onChanged: (val) => setState(() => selectedLanguage = val),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 10,
                ),
                onPressed: () => _saveSettings(context),
                child: Text(
                  'Save Settings',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
