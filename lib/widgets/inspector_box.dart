import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';

enum SignalAccent { pink, cyan }

/// Flutter DevTools Inspector Container Box
/// - 1.5px dashed hairline border
/// - Top-left widget label tag in IBM Plex Mono (e.g. Hero())
/// - Bottom-right dimension metadata tag (e.g. 1280x720)
/// - Sharp corners (2-3px radius), zero shadows
class InspectorBox extends StatelessWidget {
  final Widget child;
  final String widgetTag;
  final String? dimensionTag;
  final SignalAccent signalAccent;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;

  const InspectorBox({
    super.key,
    required this.child,
    required this.widgetTag,
    this.dimensionTag,
    this.signalAccent = SignalAccent.cyan,
    this.padding = const EdgeInsets.all(24),
    this.margin,
    this.borderRadius = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = signalAccent == SignalAccent.pink ? AppColors.pink : AppColors.cyan;
    final borderColor = AppColors.line(context);
    final cardColor = AppColors.surfaceCard(context);

    final basePadding = padding ?? const EdgeInsets.all(24);
    final effectivePadding = widgetTag.isNotEmpty
        ? basePadding.copyWith(
            top: basePadding.top < 36.0 ? 36.0 : basePadding.top,
          )
        : basePadding;

    return Container(
      margin: margin,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          borderColor: borderColor,
          strokeWidth: 1.5,
          dashWidth: 6.0,
          dashGap: 4.0,
          radius: borderRadius,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Stack(
            children: [
              // Main content
              Padding(
                padding: effectivePadding,
                child: child,
              ),

              // Top-Left Corner Widget Tag
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    border: Border(
                      right: BorderSide(color: accentColor.withValues(alpha: 0.4), width: 1),
                      bottom: BorderSide(color: accentColor.withValues(alpha: 0.4), width: 1),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      bottomRight: Radius.circular(borderRadius),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        (widgetTag.contains('(') || widgetTag.endsWith('()'))
                            ? widgetTag
                            : '$widgetTag()',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                          letterSpacing: 0.5,
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              // Bottom-Right Corner Dimension Tag
              if (dimensionTag != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.line(context),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                      ),
                    ),
                    child: Text(
                      dimensionTag!,
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.dim,
                      ),
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

class _DashedBorderPainter extends CustomPainter {
  final Color borderColor;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;
  final double radius;

  _DashedBorderPainter({
    required this.borderColor,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..color = borderColor
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final dashedPath = Path();

    for (final pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final double len = (distance + dashWidth < pathMetric.length)
            ? dashWidth
            : pathMetric.length - distance;
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + len),
          Offset.zero,
        );
        distance += dashWidth + dashGap;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap ||
        oldDelegate.radius != radius;
  }
}
