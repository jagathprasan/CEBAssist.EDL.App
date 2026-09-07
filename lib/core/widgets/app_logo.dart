import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../constants/app_constants.dart';
import '../extensions/context_extensions.dart';

/// Which artwork [AppLogo] should render.
enum AppLogoStyle {
  /// Hex icon + CEBAssist wordmark (`ca-logo-new.png`).
  full,

  /// CEBAssist wordmark only (`logo.png`).
  wordmark,
}

/// Theme-aware application logo with a safe fallback if the asset is missing.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.height = 40,
    this.showWordmark = false,
    this.compact = false,
    this.style,
  });

  final double height;
  final bool showWordmark;
  final bool compact;

  /// Defaults to [AppLogoStyle.wordmark] when [compact] is true.
  final AppLogoStyle? style;

  AppLogoStyle get _resolvedStyle {
    return style ?? (compact ? AppLogoStyle.wordmark : AppLogoStyle.full);
  }

  String get _asset {
    return switch (_resolvedStyle) {
      AppLogoStyle.full => AppConstants.logoFullAsset,
      AppLogoStyle.wordmark => AppConstants.logoWordmarkAsset,
    };
  }

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      _asset,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        return compact
            ? _FallbackMark(size: height)
            : _FallbackWordmark(height: height);
      },
    );

    if (!showWordmark) return logo;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logo,
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppConstants.appFullName,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _FallbackMark extends StatelessWidget {
  const _FallbackMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: AppRadius.borderSm,
      ),
      child: Icon(
        Icons.bolt_rounded,
        color: context.colors.onPrimary,
        size: size * 0.62,
      ),
    );
  }
}

class _FallbackWordmark extends StatelessWidget {
  const _FallbackWordmark({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final fontSize = (height * 0.55).clamp(18.0, 32.0);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.bolt_rounded,
          color: AppBrandColors.logoOrange,
          size: fontSize * 1.15,
        ),
        const SizedBox(width: 4),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'CEB',
                style: TextStyle(
                  color: AppBrandColors.logoGrey,
                  fontWeight: FontWeight.w800,
                  fontSize: fontSize,
                  letterSpacing: -0.6,
                ),
              ),
              TextSpan(
                text: 'Assist',
                style: TextStyle(
                  color: context.isDark
                      ? const Color(0xFF9EC4E0)
                      : AppBrandColors.logoNavy,
                  fontWeight: FontWeight.w800,
                  fontSize: fontSize,
                  letterSpacing: -0.6,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            width: 8,
            height: 8,
            color: AppBrandColors.logoOrange,
          ),
        ),
      ],
    );
  }
}
