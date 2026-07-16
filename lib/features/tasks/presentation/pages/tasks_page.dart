import 'package:flutter/material.dart';

import '../mixins/tasks_view_mixin.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TasksViewMixin {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Tasks'));
  }
}
