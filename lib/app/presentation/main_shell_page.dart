import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import 'widgets/app_bottom_nav_bar.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isTimerTab = navigationShell.currentIndex == 1;

    return Scaffold(
      extendBodyBehindAppBar: isTimerTab,
      extendBody: isTimerTab,
      appBar: AppBar(
        backgroundColor: isTimerTab ? Colors.transparent : null,
        elevation: isTimerTab ? 0 : null,
        scrolledUnderElevation: isTimerTab ? 0 : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
