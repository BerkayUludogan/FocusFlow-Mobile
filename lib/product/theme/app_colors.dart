import 'package:flutter/material.dart';

final class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF3B82F6); // ana marka rengi — mavi
  static const Color primaryLight = Color(0xFFE3EEFF); // yumuşak mavi tint
  static const Color shortBreak = Color(0xFF14B8A6); // teal — kısa mola
  static const Color longBreak = Color(0xFF8B5CF6); // mor — uzun mola
  static const Color background = Color(0xFFFAFAFA); // temiz, nötr açık gri
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color error = Color(0xFFDC2626);

  // Purely cosmetic per-task accent dots (task_list_item.dart) — picked
  // deterministically from the task's id so each task gets a distinct,
  // stable color the moment it's created, without needing a real
  // category field or any extra storage.
  static const List<Color> taskAccentColors = [
    primary,
    Color(0xFF22C55E), // green
    Color(0xFFF97316), // orange
    longBreak, // purple
    Color(0xFFEC4899), // pink
    shortBreak, // teal
  ];

  static Color taskAccentColorFor(String id) {
    return taskAccentColors[id.hashCode.abs() % taskAccentColors.length];
  }
}
