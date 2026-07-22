import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow_mobile/features/tasks/data/models/task_item.dart';
import 'package:focusflow_mobile/features/tasks/presentation/widgets/task_list_item.dart';

TaskItem _task({
  required String id,
  required String title,
  DateTime? dueDateUtc,
  int estimatedPomodoroCount = 0,
  int completedPomodoroCount = 0,
  bool isCompleted = false,
}) {
  return TaskItem(
    id: id,
    clientId: id,
    title: title,
    isCompleted: isCompleted,
    dueDateUtc: dueDateUtc,
    estimatedPomodoroCount: estimatedPomodoroCount,
    completedPomodoroCount: completedPomodoroCount,
    createdAtUtc: DateTime.utc(2026, 1, 1),
  );
}

void main() {
  testWidgets('task list item redesign — visual scenarios', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await EasyLocalization.ensureInitialized();
    final now = DateTime.now();

    final tasks = [
      _task(
        id: 'today',
        title: 'Beden Eğitimi',
        dueDateUtc: DateTime.utc(now.year, now.month, now.day),
        estimatedPomodoroCount: 3,
        completedPomodoroCount: 2,
      ),
      _task(
        id: 'tomorrow',
        title: 'Rapor yaz',
        dueDateUtc: DateTime.utc(
          now.year,
          now.month,
          now.day,
        ).add(const Duration(days: 1)),
        estimatedPomodoroCount: 2,
      ),
      _task(
        id: 'weekday',
        title: 'Kitap oku ve notlar al bu uzun başlıkla',
        dueDateUtc: DateTime.utc(
          now.year,
          now.month,
          now.day,
        ).add(const Duration(days: 3)),
        estimatedPomodoroCount: 4,
        completedPomodoroCount: 1,
      ),
      _task(
        id: 'faraway',
        title: 'Proje teslimi',
        dueDateUtc: DateTime.utc(now.year, now.month, now.day + 40),
        estimatedPomodoroCount: 6,
      ),
      _task(
        id: 'no-date-with-sessions',
        title: 'Egzersiz yap',
        estimatedPomodoroCount: 5,
        completedPomodoroCount: 3,
      ),
      _task(id: 'no-date-no-sessions', title: 'Basit bir görev'),
      _task(
        id: 'completed',
        title: 'Tamamlanan görev',
        estimatedPomodoroCount: 3,
        completedPomodoroCount: 3,
        isCompleted: true,
      ),
      _task(
        id: 'overdue',
        title: 'Geciken görev',
        dueDateUtc: DateTime.utc(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: 2)),
        estimatedPomodoroCount: 2,
      ),
      _task(
        id: 'many-sessions',
        title: 'Çok seanslı görev',
        estimatedPomodoroCount: 12,
        completedPomodoroCount: 5,
      ),
    ];

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('tr'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('tr'),
        startLocale: const Locale('tr'),
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: Scaffold(
              backgroundColor: const Color(0xFFFAFAFA),
              body: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: tasks
                      .map(
                        (task) => TaskListItem(
                          task: task,
                          focusDurationMinutes: 25,
                          isFavorite: task.id == 'today',
                          onToggleComplete: () {},
                          onToggleFavorite: () {},
                          onStartFocusSession: () {},
                          onEdit: () {},
                          onDelete: () {},
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('task_list_item_scenarios.png'),
    );
  });
}
