import 'package:echojar/app/navigation/router.dart';
import 'package:echojar/app/theme/app_colors.dart';
import 'package:echojar/data/data.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _shareApp() {
    SharePlus.instance.share(
      ShareParams(text: shareAppText),
    );
  }

  void _rateApp() async {
    final uri = Uri.parse(appUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      _buildTile(
        context,
        icon: Icons.feedback_outlined,
        label: 'Send Feedback',
        onTap: () => const FeedbackRoute().push(context),
      ),
      _buildTile(
        context,
        icon: Icons.share_outlined,
        label: 'Share App',
        onTap: _shareApp,
      ),
      _buildTile(
        context,
        icon: Icons.star_rate_outlined,
        label: 'Rate App',
        onTap: _rateApp,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Settings', style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tiles.length,
        itemBuilder: (_, i) => tiles[i],
        separatorBuilder: (_, __) => const SizedBox(height: 12),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: Theme.of(context).textTheme.titleMedium),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
