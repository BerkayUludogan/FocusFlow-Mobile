import 'dart:math';

import 'package:flutter/material.dart';
import 'package:focusflow_mobile/product/constants/widget_sizes.dart';
import 'package:focusflow_mobile/product/theme/app_colors.dart';
import 'package:focusflow_mobile/product/utils/duration_formatter.dart';

class NeonTimerDial extends StatefulWidget {
  const NeonTimerDial({
    required this.progress,
    required this.isRunning,
    this.isPaused = false,
    required this.color,
    required this.remainingSeconds,
    required this.phaseLabel,
    required this.phaseIcon,
    required this.activityLabel,
    this.size = WidgetSizes.timerCircleSize,
    super.key,
  });

  final double progress;
  final bool isRunning;
  final bool isPaused;
  final Color color;
  final int remainingSeconds;
  final String phaseLabel;
  final IconData phaseIcon;
  final String activityLabel;
  final double size;

  @override
  State<NeonTimerDial> createState() => _NeonTimerDialState();
}

class _NeonTimerDialState extends State<NeonTimerDial>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  late Animation<double> _progressAnimation;

  // Drives the ripple's horizontal motion only — just runs while the
  // session is active so the surface doesn't feel static.
  late final AnimationController _waveController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  );

  // Smoothly glides the water level from one authoritative per-second
  // `progress` sample to the next over exactly that same 1-second window.
  // Since progress is linear in time, this piecewise-linear interpolation
  // reconstructs the true countdown line exactly — no drift, no restarts,
  // and (unlike sampling `progress` directly) no jerky per-second jumps.
  late final AnimationController _waveLevelController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  late Animation<double> _waveLevelAnimation;

  @override
  void initState() {
    super.initState();
    final start = widget.progress.clamp(0.0, 1.0);
    _progressAnimation = AlwaysStoppedAnimation(start);
    _waveLevelAnimation = AlwaysStoppedAnimation(start);
    if (widget.isRunning) {
      _startContinuousDescent(from: start);
      _waveController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant NeonTimerDial oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isRunning != oldWidget.isRunning) {
      if (widget.isRunning) {
        _waveController.repeat();
      } else {
        _waveController.stop();
      }
    }

    if (!widget.isRunning) {
      final target = widget.progress.clamp(0.0, 1.0);
      if (widget.isPaused && _controller.isAnimating) {
        // Genuine pause mid-flight: freeze exactly where the ring visually
        // is, instead of snapping to the coarser integer-second state.
        final current = _progressAnimation.value;
        _controller.stop();
        setState(() => _progressAnimation = AlwaysStoppedAnimation(current));
      } else {
        // Cancelled/completed (or a fresh idle session) — always snap to
        // the target, even mid-animation. Relying on `isAnimating` here
        // used to freeze the ring in place on cancel/finish instead of
        // resetting it, since those transitions look identical to a pause
        // (isRunning: true -> false) from this widget's point of view.
        _controller.stop();
        if (_progressAnimation.value != target) {
          setState(() => _progressAnimation = AlwaysStoppedAnimation(target));
        }
      }
      _waveLevelController.stop();
      setState(() => _waveLevelAnimation = AlwaysStoppedAnimation(target));
      return;
    }

    if (!oldWidget.isRunning) {
      // Just started or resumed: run a single continuous real-time descent
      // for the rest of the segment instead of restarting a short glide on
      // every tick. The countdown digits and this animation are both
      // driven by the same wall clock (see TimerCubit's segment-start
      // anchoring), so the ring lands exactly on the digit's position the
      // instant it changes — no per-second lag, no stutter.
      _startContinuousDescent(from: _progressAnimation.value);
      _startWaveLevelGlide(to: widget.progress.clamp(0.0, 1.0));
      return;
    }

    // Already running: the descent started at the last start/resume is
    // still driving the ring. Only step in if it has drifted from the
    // authoritative state by more than a single tick's worth of progress
    // — e.g. the ticker was suspended while the app was backgrounded.
    final expected = widget.progress.clamp(0.0, 1.0);
    if ((_progressAnimation.value - expected).abs() > 0.01) {
      _startContinuousDescent(from: expected);
    }

    if (oldWidget.progress != widget.progress) {
      _startWaveLevelGlide(to: expected);
    }
  }

  void _startWaveLevelGlide({required double to}) {
    _waveLevelAnimation = Tween<double>(
      begin: _waveLevelAnimation.value,
      end: to,
    ).animate(CurvedAnimation(parent: _waveLevelController, curve: Curves.linear));
    _waveLevelController
      ..stop()
      ..value = 0
      ..forward();
  }

  void _startContinuousDescent({required double from}) {
    _progressAnimation = Tween<double>(begin: from, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    _controller
      ..duration = Duration(seconds: widget.remainingSeconds)
      ..stop()
      ..value = 0
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _waveController.dispose();
    _waveLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.size / WidgetSizes.timerCircleSize;
    final strokeWidth = WidgetSizes.timerCircleStrokeWidth * scale;
    final radius = widget.size / 2 - strokeWidth / 2;
    final dotSize = 16 * scale;
    final color = widget.color;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final animatedProgress = _progressAnimation.value;
        final angle = -pi / 2 - animatedProgress * 2 * pi;
        final dotCenter = Offset(
          widget.size / 2 + radius * cos(angle),
          widget.size / 2 + radius * sin(angle),
        );

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CustomPaint(
                    painter: _SolidRingPainter(
                      progress: animatedProgress,
                      color: color,
                      strokeWidth: strokeWidth,
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: Listenable.merge([
                              _waveController,
                              _waveLevelController,
                            ]),
                            builder: (context, _) {
                              return CustomPaint(
                                painter: _WavePainter(
                                  color: color,
                                  phase: _waveController.value,
                                  // Glides between authoritative per-second
                                  // progress samples (see
                                  // _startWaveLevelGlide) instead of either
                                  // jumping in per-second steps or drifting
                                  // with the ring's independently-corrected
                                  // animation — so it's both smooth and
                                  // exactly in sync with the countdown.
                                  progress: _waveLevelAnimation.value,
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, -0.15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 48 * scale,
                                height: 48 * scale,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  widget.phaseIcon,
                                  color: color,
                                  size: 24 * scale,
                                ),
                              ),
                              SizedBox(height: 12 * scale),
                              Text(
                                formatDuration(widget.remainingSeconds),
                                style: TextStyle(
                                  fontSize: 60 * scale,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4 * scale),
                              Text(
                                '•  ${widget.phaseLabel}  •',
                                style: TextStyle(
                                  fontSize: 17 * scale,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                              SizedBox(height: 10 * scale),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12 * scale,
                                  vertical: 6 * scale,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      widget.phaseIcon,
                                      size: 13 * scale,
                                      color: color,
                                    ),
                                    SizedBox(width: 5 * scale),
                                    Text(
                                      widget.activityLabel,
                                      style: TextStyle(
                                        fontSize: 12 * scale,
                                        fontWeight: FontWeight.w600,
                                        color: color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: dotCenter.dx - dotSize / 2,
                top: dotCenter.dy - dotSize / 2,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Colors.white, color],
                      stops: const [0.15, 1.0],
                    ),
                    border: Border.all(
                      color: AppColors.surface,
                      width: 3 * scale,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.55),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.45),
                        blurRadius: 20,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.color,
    required this.phase,
    required this.progress,
  });

  final Color color;
  final double phase;
  // Fraction of time remaining (1.0 = full, 0.0 = empty), used to drop the
  // water level from top to bottom as the session drains.
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const topLevel = 0.03;
    // Just past 1.0 so the ClipOval fully hides the wave once progress
    // reaches 0 — the circle's bottom edge only touches size.height at its
    // exact center, so a baseline sitting at exactly 1.0 would still leave
    // a hairline peeking through. Keep this close to 1.0 though: the
    // circle narrows fast near its bottom tip, so anything much larger
    // (e.g. 1.15) makes the wave visually vanish while a large chunk of
    // real time is still left on the clock — reads as "finishing early"
    // even though the underlying progress value is accurate.
    const bottomLevel = 1.02;
    final baseline =
        size.height * (topLevel + (bottomLevel - topLevel) * (1 - progress));
    final amplitude = size.height * 0.03;
    final cycle = phase * 2 * pi;

    Path buildWave({
      required double phaseOffset,
      required double heightOffset,
    }) {
      final path = Path()..moveTo(0, size.height)..lineTo(0, baseline + heightOffset);
      for (var x = 0.0; x <= size.width; x += 4) {
        final y =
            baseline +
            heightOffset +
            amplitude * sin((x / size.width * 2 * pi) + cycle + phaseOffset);
        path.lineTo(x, y);
      }
      path
        ..lineTo(size.width, size.height)
        ..close();
      return path;
    }

    canvas.drawPath(
      buildWave(phaseOffset: pi, heightOffset: 6),
      Paint()..color = color.withValues(alpha: 0.16),
    );
    canvas.drawPath(
      buildWave(phaseOffset: 0, heightOffset: 0),
      Paint()..color = color.withValues(alpha: 0.26),
    );
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.color != color ||
        oldDelegate.progress != progress;
  }
}

class _SolidRingPainter extends CustomPainter {
  _SolidRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, 0, 2 * pi, false, trackPaint);

    // Starts at the top and sweeps counter-clockwise (negative angle):
    // top -> left -> bottom -> right, as requested.
    final sweepAngle = -progress * 2 * pi;

    // Soft glow beneath the crisp progress arc.
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 1.6
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * (25 / 430));
    canvas.drawArc(rect, -pi / 2, sweepAngle, false, glowPaint);

    final progressPaint = Paint()
      ..shader = SweepGradient(
        transform: const GradientRotation(-pi / 2),
        colors: [color.withValues(alpha: 0.55), color],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -pi / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _SolidRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
