import 'package:easy_localization/easy_localization.dart';

import '../localization/locale_keys.dart';

const _weekdayKeys = [
  LocaleKeys.tasksWeekdayMonday,
  LocaleKeys.tasksWeekdayTuesday,
  LocaleKeys.tasksWeekdayWednesday,
  LocaleKeys.tasksWeekdayThursday,
  LocaleKeys.tasksWeekdayFriday,
  LocaleKeys.tasksWeekdaySaturday,
  LocaleKeys.tasksWeekdaySunday,
];

const _monthKeys = [
  LocaleKeys.tasksMonthJan,
  LocaleKeys.tasksMonthFeb,
  LocaleKeys.tasksMonthMar,
  LocaleKeys.tasksMonthApr,
  LocaleKeys.tasksMonthMay,
  LocaleKeys.tasksMonthJun,
  LocaleKeys.tasksMonthJul,
  LocaleKeys.tasksMonthAug,
  LocaleKeys.tasksMonthSep,
  LocaleKeys.tasksMonthOct,
  LocaleKeys.tasksMonthNov,
  LocaleKeys.tasksMonthDec,
];

/// Today → "Bugün", tomorrow → "Yarın", within the next week → weekday
/// name, otherwise → "25 Tem". Past-due dates fall through to the explicit
/// "day month" form so they stay unambiguous next to the overdue styling.
String formatTaskDueDate(DateTime dueDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
  final dayDiff = due.difference(today).inDays;

  if (dayDiff == 0) return LocaleKeys.tasksDueToday.tr();
  if (dayDiff == 1) return LocaleKeys.tasksDueTomorrow.tr();
  if (dayDiff > 1 && dayDiff < 7) return _weekdayKeys[due.weekday - 1].tr();
  return '${due.day} ${_monthKeys[due.month - 1].tr()}';
}

/// Formats a total minute count as "1 sa 40 dk", dropping whichever unit
/// is zero (e.g. "40 dk" or "2 sa").
String formatSessionDuration(int totalMinutes) {
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  final hourUnit = LocaleKeys.tasksHourUnit.tr();
  final minuteUnit = LocaleKeys.tasksMinuteUnit.tr();

  if (hours == 0) return '$minutes $minuteUnit';
  if (minutes == 0) return '$hours $hourUnit';
  return '$hours $hourUnit $minutes $minuteUnit';
}
