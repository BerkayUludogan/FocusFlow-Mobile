import 'package:flutter/material.dart';

final class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF46A302); // canlı, oyunsu yeşil
  static const Color primaryLight = Color(0xFFE8F5D9); // yumuşak mint tint
  static const Color shortBreak = Color(
    0xFF14B8A6,
  ); // teal — kısa mola (primary'den net ayrışıyor)
  static const Color longBreak = Color(
    0xFF3B82F6,
  ); // mavi — uzun mola (değişmedi)
  static const Color background = Color(0xFFFAFAFA); // temiz, nötr açık gri
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color error = Color(0xFFDC2626);
}
