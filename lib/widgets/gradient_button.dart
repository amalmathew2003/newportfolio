import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';

/// Sharp DevTools Inspector Button
/// - 2px radius corners
/// - Solid mist/charcoal primary OR outline secondary with cyan hover shift
/// - Uses IBM Plex Mono / Space Grotesk
/// - NO arrow glyphs (→)
class DevToolsButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;
  final EdgeInsets padding;
  final IconData? icon;

  const DevToolsButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
    this.icon,
  });

  @override
  State<DevToolsButton> createState() => _DevToolsButtonState();
}

class _DevToolsButtonState extends State<DevToolsButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Primary colors
    final primaryBg = isDark ? AppColors.mist : AppColors.charcoal;
    final primaryFg = isDark ? AppColors.ink : AppColors.paperSurface;

    // Secondary colors
    final secondaryBg = _isHovered
        ? AppColors.cyan.withValues(alpha: 0.12)
        : Colors.transparent;
    final secondaryBorder = _isHovered
        ? AppColors.cyan
        : AppColors.line(context);
    final secondaryFg = _isHovered
        ? AppColors.cyan
        : AppColors.primaryText(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.isSecondary ? secondaryBg : primaryBg,
            borderRadius: BorderRadius.circular(2.0),
            border: widget.isSecondary
                ? Border.all(color: secondaryBorder, width: 1.5)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: widget.isSecondary ? secondaryFg : primaryFg,
                  size: 16,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 13,
                  color: widget.isSecondary ? secondaryFg : primaryFg,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Backward compatibility alias
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final double borderRadius;
  final EdgeInsets padding;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.borderRadius = 2.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DevToolsButton(
      text: text,
      onPressed: onPressed,
      padding: padding,
      icon: icon,
    );
  }
}


class GlowingIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final double size;
  final String? tooltip;

  const GlowingIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = AppColors.cyan,
    this.size = 40,
    this.tooltip,
  });

  @override
  State<GlowingIconButton> createState() => _GlowingIconButtonState();
}

class _GlowingIconButtonState extends State<GlowingIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Tooltip(
          message: widget.tooltip ?? '',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              color: _isHovered
                  ? widget.color.withValues(alpha: 0.15)
                  : AppColors.surfaceCard(context),
              border: Border.all(
                color: _isHovered ? widget.color : AppColors.line(context),
                width: 1.5,
              ),
            ),
            child: Icon(
              widget.icon,
              color: _isHovered ? widget.color : AppColors.primaryText(context),
              size: widget.size * 0.45,
            ),
          ),
        ),
      ),
    );
  }
}

