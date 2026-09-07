import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../extensions/context_extensions.dart';

/// Lightweight skeleton placeholder without extra dependencies.
class AppLoadingSkeleton extends StatefulWidget {
  const AppLoadingSkeleton({
    super.key,
    this.height = 16,
    this.width,
    this.borderRadius = AppRadius.md,
  });

  final double height;
  final double? width;
  final double borderRadius;

  @override
  State<AppLoadingSkeleton> createState() => _AppLoadingSkeletonState();
}

class _AppLoadingSkeletonState extends State<AppLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 0.85).animate(_controller),
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}

class AppDashboardSkeleton extends StatelessWidget {
  const AppDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const AppLoadingSkeleton(height: 28, width: 220),
        const SizedBox(height: AppSpacing.xs),
        const AppLoadingSkeleton(height: 16, width: 160),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: const [
            Expanded(child: AppLoadingSkeleton(height: 96)),
            SizedBox(width: AppSpacing.sm),
            Expanded(child: AppLoadingSkeleton(height: 96)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: const [
            Expanded(child: AppLoadingSkeleton(height: 96)),
            SizedBox(width: AppSpacing.sm),
            Expanded(child: AppLoadingSkeleton(height: 96)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const AppLoadingSkeleton(height: 220),
        const SizedBox(height: AppSpacing.lg),
        const AppLoadingSkeleton(height: 120),
      ],
    );
  }
}
