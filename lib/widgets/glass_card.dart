import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/app_colors.dart';

/// Premium glassmorphism card using the black & white editorial system.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;
  final bool isHovered;
  final bool showBorder;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 0,
    this.isHovered = false,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isHovered
                ? AppColors.glassHover(context)
                : AppColors.glass(context),
            borderRadius: BorderRadius.circular(borderRadius),
            border: showBorder
                ? Border.all(
                    color: isHovered
                        ? AppColors.mediumBorder(context, alpha: 0.18)
                        : AppColors.subtleBorder(context, alpha: 0.08),
                    width: isHovered ? 1.5 : 1.0,
                  )
                : null,
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.3 : 0.08,
                      ),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: child,
        ),
      ),
    );
  }
}
