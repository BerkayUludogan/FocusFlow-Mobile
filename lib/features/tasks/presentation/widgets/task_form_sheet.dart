import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focusflow_mobile/product/constants/project_padding.dart';
import 'package:focusflow_mobile/product/constants/widget_sizes.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';

import '../../data/models/task_item.dart';
import '../cubit/tasks_cubit.dart';

Future<void> showTaskFormSheet(
  BuildContext context, {
  required TasksCubit cubit,
  TaskItem? existingTask,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        TaskFormSheet(cubit: cubit, existingTask: existingTask),
  );
}

class TaskFormSheet extends StatefulWidget {
  const TaskFormSheet({required this.cubit, this.existingTask, super.key});

  final TasksCubit cubit;
  final TaskItem? existingTask;

  @override
  State<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<TaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController(
    text: widget.existingTask?.title,
  );
  late final _descriptionController = TextEditingController(
    text: widget.existingTask?.description,
  );
  late final _estimatedPomodoroController = TextEditingController(
    text: (widget.existingTask?.estimatedPomodoroCount ?? 1).toString(),
  );
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _dueDate = widget.existingTask?.dueDateUtc;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _estimatedPomodoroController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.tasksTitleRequired.tr();
    }
    return null;
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null && mounted) {
      // showDatePicker returns a local, non-UTC DateTime at midnight.
      // Serializing that directly omits the 'Z' suffix (Kind=unspecified),
      // which the dueDateUtc backend field rejects/mishandles. Re-anchor
      // the same calendar date at UTC midnight instead of calling
      // .toUtc(), which would shift it into the previous day for any
      // positive UTC offset.
      setState(
        () => _dueDate = DateTime.utc(picked.year, picked.month, picked.day),
      );
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final estimatedPomodoroCount =
        int.tryParse(_estimatedPomodoroController.text) ?? 0;

    if (widget.existingTask != null) {
      widget.cubit.updateTask(
        id: widget.existingTask!.id,
        clientId: widget.existingTask!.clientId,
        title: title,
        description: description.isEmpty ? null : description,
        dueDateUtc: _dueDate,
        estimatedPomodoroCount: estimatedPomodoroCount,
      );
    } else {
      widget.cubit.createTask(
        title: title,
        description: description.isEmpty ? null : description,
        dueDateUtc: _dueDate,
        estimatedPomodoroCount: estimatedPomodoroCount,
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const ProjectPadding.allLarge(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.existingTask != null
                    ? LocaleKeys.tasksEditTask.tr()
                    : LocaleKeys.tasksAddTask.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: WidgetSizes.sectionSpacing),
              TextFormField(
                controller: _titleController,
                validator: _validateTitle,
                decoration: InputDecoration(
                  labelText: LocaleKeys.tasksTitleLabel.tr(),
                ),
              ),
              const SizedBox(height: WidgetSizes.textFieldSpacing),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: LocaleKeys.tasksDescriptionLabel.tr(),
                ),
              ),
              const SizedBox(height: WidgetSizes.textFieldSpacing),
              TextFormField(
                controller: _estimatedPomodoroController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: LocaleKeys.tasksEstimatedPomodoroLabel.tr(),
                ),
              ),
              const SizedBox(height: WidgetSizes.textFieldSpacing),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _dueDate != null
                      ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                      : LocaleKeys.tasksDueDateLabel.tr(),
                ),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: _pickDueDate,
              ),
              const SizedBox(height: WidgetSizes.sectionSpacing),
              ElevatedButton(
                onPressed: _submit,
                child: Text(LocaleKeys.tasksSave.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
