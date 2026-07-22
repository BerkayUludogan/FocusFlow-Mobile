import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../product/constants/widget_sizes.dart';
import '../../../../product/theme/app_colors.dart';

/// Mirrors the loaded [TasksPage] body — filter chips, search bar, the
/// "Görevlerim"/sort row, and the task rows themselves — so nothing shifts
/// position once the real content swaps in.
class TaskListSkeleton extends StatelessWidget {
  const TaskListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primaryLight,
      highlightColor: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              child: Row(
                children: [
                  _SkeletonBox(width: 72, height: 40, radius: 24),
                  SizedBox(width: 8),
                  _SkeletonBox(width: 88, height: 40, radius: 24),
                  SizedBox(width: 8),
                  _SkeletonBox(width: 104, height: 40, radius: 24),
                  SizedBox(width: 8),
                  _SkeletonBox(width: 116, height: 40, radius: 24),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: _SkeletonBox(
                  height: WidgetSizes.buttonHeight,
                  radius: 16,
                ),
              ),
              const SizedBox(width: 10),
              const _SkeletonBox(
                width: WidgetSizes.buttonHeight,
                height: WidgetSizes.buttonHeight,
                radius: 14,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SkeletonBox(width: 90, height: 16, radius: 4),
              _SkeletonBox(width: 64, height: 16, radius: 4),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 4),
              itemCount: WidgetSizes.skeletonItemCount,
              itemBuilder: (context, index) =>
                  _SkeletonTaskRow(titleWidth: 120 + (index % 3) * 40),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonTaskRow extends StatelessWidget {
  const _SkeletonTaskRow({required this.titleWidth});

  final double titleWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: Colors.white),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                  color: Colors.white,
                  child: Row(
                    children: [
                      const _SkeletonBox(width: 22, height: 22, radius: 7),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _SkeletonBox(
                              width: titleWidth,
                              height: 16,
                              radius: 4,
                            ),
                            const SizedBox(height: 8),
                            const _SkeletonBox(
                              width: 64,
                              height: 14,
                              radius: 7,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const _SkeletonBox(width: 20, height: 20, radius: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    this.width,
    required this.height,
    required this.radius,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
