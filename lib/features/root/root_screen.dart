import 'package:echojar/app/database/src/preferences/app_config_manager.dart';
import 'package:echojar/app/navigation/router.dart';
import 'package:echojar/app/theme/app_colors.dart';
import 'package:echojar/common/presentation/widgets/hint_card.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class RootScreen extends StatefulWidget {
  final Widget navigator;

  const RootScreen({super.key, required this.navigator});

  static const _tabs = [
    (icon: Icons.home, label: 'Home', name: 'Home'),
    (icon: Icons.add_circle, label: 'Create', name: 'Create'),
    (icon: Icons.settings, label: 'Settings', name: 'Settings'),
  ];

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _createJarKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      final isRootHintShown = await AppConfigManager().isRootHintShown() ?? false;

      if (!isRootHintShown) {
        if (!mounted) return;
        ShowCaseWidget.of(context)
            .startShowCase([_homeKey, _createJarKey]);
        await AppConfigManager().setRootHintShown(true);
      }
    });
    super.initState();
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/create')) return 1;
    if (location.startsWith('/settings')) return 2;
    return 0; // default to Home
  }

  void _onTabTapped(BuildContext context, int index) {
    final tabName = RootScreen._tabs[index].name;
    context.goNamed(tabName);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      body: widget.navigator,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Showcase.withWidget(
                key: _homeKey,
                height: 120,
                width: MediaQuery.of(context).size.width * 0.9,
                targetPadding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                targetBorderRadius: BorderRadius.circular(12),
                container: HintCard(
                  title: "View and manage your memory jars and messages",
                  onNext: () => ShowCaseWidget.of(context).next(),
                  onFinish: () => ShowCaseWidget.of(context).dismiss(),
                ),
                child: _BottomBarItem(
                  icon: Icons.home,
                  label: 'Home',
                  isActive: selectedIndex == 0,
                  onTap: () => _onTabTapped(context, 0),
                ),
              ),
              Showcase.withWidget(
                key: _createJarKey,
                height: 120,
                width: MediaQuery.of(context).size.width * 0.9,
                targetPadding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                targetBorderRadius: BorderRadius.circular(12),
                container: HintCard(
                  title: "Create jars and memos with themes, colors, and schedule",
                  onNext: () => ShowCaseWidget.of(context).next(),
                  onFinish: () => ShowCaseWidget.of(context).dismiss(),
                  isLast: true,
                ),
                child: _BottomBarItem(
                  icon: Icons.add_circle,
                  label: 'Create',
                  isActive: selectedIndex == 1,
                  onTap: () => _onTabTapped(context, 1),
                ),
              ),
              _BottomBarItem(
                icon: Icons.settings,
                label: 'Settings',
                isActive: selectedIndex == 2,
                onTap: () => _onTabTapped(context, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
