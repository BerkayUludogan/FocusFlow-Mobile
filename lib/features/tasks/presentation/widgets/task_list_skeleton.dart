import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../product/constants/widget_sizes.dart';
import '../../../../product/theme/app_colors.dart';

class TaskListSkeleton extends StatelessWidget {
  const TaskListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primaryLight,
      highlightColor: AppColors.surface,
      child: ListView.builder(
        itemCount: WidgetSizes.skeletonItemCount,
        itemBuilder: (context, index) => ListTile(
          leading: const _SkeletonBox(
            width: WidgetSizes.skeletonLeadingSize,
            height: WidgetSizes.skeletonLeadingSize,
            isCircle: true,
          ),
          title: const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: _SkeletonBox(width: 160, height: WidgetSizes.skeletonBarHeight),
          ),
          subtitle: const _SkeletonBox(
            width: 100,
            height: WidgetSizes.skeletonSubtitleHeight,
          ),
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    this.isCircle = false,
  });

  final double width;
  final double height;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle
            ? null
            : BorderRadius.circular(WidgetSizes.skeletonBarRadius),
      ),
    );
  }
}
