import 'package:go_router/go_router.dart';

import '../../app/presentation/main_shell_page.dart';
import '../../features/stats/presentation/pages/stats_page.dart';
import '../../features/tasks/presentation/pages/tasks_page.dart';
import '../../features/timer/presentation/pages/timer_page.dart';
import 'app_routes.dart';

final StatefulShellRoute appShellRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) =>
      MainShellPage(navigationShell: navigationShell),
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.tasks,
          builder: (context, state) => const TasksPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.timer,
          builder: (context, state) => const TimerPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.stats,
          builder: (context, state) => const StatsPage(),
        ),
      ],
    ),
  ],
);
