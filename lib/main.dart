import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app/focus_flow_app.dart';
import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/tasks/data/repositories/task_repository.dart';
import 'features/timer/data/repositories/pomodoro_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  const secureStorage = FlutterSecureStorage();

  final tokenStorage = TokenStorage(secureStorage);
  final apiClient = ApiClient(tokenStorage: tokenStorage);

  final authRepository = AuthRepository(
    apiClient: apiClient,
    tokenStorage: tokenStorage,
  );
  final taskRepository = TaskRepository(apiClient: apiClient);
  final pomodoroRepository = PomodoroRepository(apiClient: apiClient);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('tr'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('tr'),
      startLocale: const Locale('tr'),
      child: FocusFlowApp(
        authRepository: authRepository,
        taskRepository: taskRepository,
        pomodoroRepository: pomodoroRepository,
      ),
    ),
  );
}
