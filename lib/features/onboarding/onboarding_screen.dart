import 'package:echojar/app/navigation/router.dart';
import 'package:flutter/material.dart';
import 'package:echojar/app/database/src/preferences/app_config_manager.dart';
import 'package:echojar/app/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();

  String _language = 'en';

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty;

  void _completeOnboarding() async {
    final config = AppConfigManager();
    await config.setUserName(_nameController.text.trim());
    await config.setLanguage(_language);
    await config.setOnboardingCompleted(true);

    if (!mounted) return;
    context.goNamed('Home');
  }

  void _updateState() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Header(),
                _FieldTitle("Your Name", isRequired: true),
                TextField(
                  controller: _nameController,
                  onChanged: (_) => _updateState(),
                  decoration: const InputDecoration(
                    hintText: "Enter your name",
                    border: OutlineInputBorder(),
                    focusColor: AppColors.primaryLight,
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                _LanguageSelector(
                  selected: _language,
                  onSelect: (lang) {
                    _language = lang;
                    _updateState();
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isFormValid ? _completeOnboarding : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: AppColors.primaryLight,
                      ),
                      icon: const Icon(Icons.check, color: Colors.black,),
                      label: Text("Finish", style: Theme.of(context).textTheme.titleLarge),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text("🎙️ EchoJar", style: Theme.of(context).textTheme.displaySmall),
          Text("Send your voice to the future",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _FieldTitle extends StatelessWidget {
  final String title;
  final bool isRequired;

  const _FieldTitle(this.title, {this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RichText(
        text: TextSpan(
          text: title,
          style: Theme.of(context).textTheme.headlineSmall,
          children: isRequired
              ? [
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            )
          ]
              : [],
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final String selected;
  final void Function(String) onSelect;

  const _LanguageSelector({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldTitle("Language"),
        Row(
          children: [
            ChoiceChip(
              label: const Text("English"),
              selected: selected == 'en',
              selectedColor: AppColors.primaryLight,
              onSelected: (_) => onSelect('en'),
            ),
            const SizedBox(width: 12),
            ChoiceChip(
              label: const Text("Русский"),
              selected: selected == 'ru',
              selectedColor: AppColors.primaryLight,
              onSelected: (_) => onSelect('ru'),
            ),
          ],
        ),
      ],
    );
  }
}