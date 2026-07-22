import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../product/theme/app_colors.dart';
import 'widgets/app_bottom_nav_bar.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isTimerTab = navigationShell.currentIndex == 1;
    // Tasks tab renders its own in-body header (title + subtitle + profile
    // icon), so it doesn't need the shell's AppBar at all — showing both
    // would duplicate the profile icon and waste vertical space.
    final isTasksTab = navigationShell.currentIndex == 0;

    return Scaffold(
      extendBodyBehindAppBar: isTimerTab,
      extendBody: isTimerTab,
      appBar: isTasksTab
          ? null
          : AppBar(
              backgroundColor: isTimerTab ? Colors.transparent : null,
              elevation: isTimerTab ? 0 : null,
              scrolledUnderElevation: isTimerTab ? 0 : null,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    // The timer tab's AppBar is transparent over a
                    // photographic backdrop that changes per phase, so the
                    // icon needs its own backing to stay visible against
                    // any of them — same translucent-surface treatment as
                    // the timer controls floating over that backdrop.
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface.withValues(
                        alpha: 0.85,
                      ),
                    ),
                    icon: const Icon(Icons.person_outline),
                    onPressed: () => context.push(AppRoutes.settings),
                  ),
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
