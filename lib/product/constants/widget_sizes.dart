final class WidgetSizes {
  const WidgetSizes._();

  static const double buttonHeight = 48;
  static const double loginMaxWidth = 420;
  static const double textFieldSpacing = 16;
  static const double sectionSpacing = 24;
  static const double pageTitleSpacing = 32;

  static const double authIconCircleSize = 72;
  static const double authIconSize = 36;
  static const double buttonLoadingIndicatorSize = 22;
  static const double buttonLoadingIndicatorStrokeWidth = 2;

  static const double skeletonLeadingSize = 24;
  static const double skeletonBarHeight = 14;
  static const double skeletonSubtitleHeight = 12;
  static const double skeletonBarRadius = 4;
  static const int skeletonItemCount = 6;

  static const double timerCircleSize = 320;
  static const double timerCircleStrokeWidth = 14;
  static const double timerElementSpacing = 10;

  /// Fixed height reserved for [TimerControls] so switching between the
  /// idle "Start" button and the running action row never resizes the
  /// space above it — the dial would otherwise shift position.
  static const double timerControlsHeight = 104;

  /// Height of the floating [AppBottomNavBar] card itself, excluding the
  /// device's own bottom safe-area inset (add that separately).
  static const double bottomNavBarHeight = 20;
}
