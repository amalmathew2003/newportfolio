import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Floating ambient orb — soft white/black radial gradient for background depth.
class GradientOrb extends StatefulWidget {
  final double size;
  final Alignment alignment;
  final double opacity;
  final Duration duration;
  final bool animate;

  const GradientOrb({
    super.key,
    this.size = 600,
    this.alignment = Alignment.topRight,
    this.opacity = 0.06,
    this.duration = const Duration(seconds: 8),
    this.animate = true,
  });

  @override
  State<GradientOrb> createState() => _GradientOrbState();
}

class _GradientOrbState extends State<GradientOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orbColor = isDark ? Colors.white : Colors.black;

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, _) {
        return Align(
          alignment: widget.alignment,
          child: Transform.scale(
            scale: widget.animate ? _scaleAnim.value : 1.0,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    orbColor.withValues(alpha: widget.opacity),
                    orbColor.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Subtle floating geometric lines painter for editorial depth.
class GridLinePainter extends CustomPainter {
  final Color color;
  final int lineCount;

  GridLinePainter({required this.color, this.lineCount = 6});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final stepX = size.width / lineCount;
    for (int i = 1; i < lineCount; i++) {
      canvas.drawLine(
        Offset(stepX * i, 0),
        Offset(stepX * i, size.height),
        paint,
      );
    }

    // A diagonal accent line
    final diagPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;
    canvas.drawLine(
      Offset(size.width * 0.65, 0),
      Offset(size.width, size.height * 0.4),
      diagPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Orbiting dot animation for hero section ambient effect.
class OrbitingDots extends StatefulWidget {
  final double radius;
  final Color color;
  final int dotCount;

  const OrbitingDots({
    super.key,
    this.radius = 120,
    required this.color,
    this.dotCount = 3,
  });

  @override
  State<OrbitingDots> createState() => _OrbitingDotsState();
}

class _OrbitingDotsState extends State<OrbitingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return SizedBox(
          width: widget.radius * 2 + 20,
          height: widget.radius * 2 + 20,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(widget.dotCount, (i) {
              final angle = (_ctrl.value * 2 * math.pi) +
                  (i * 2 * math.pi / widget.dotCount);
              final x = widget.radius * math.cos(angle);
              final y = widget.radius * math.sin(angle);
              return Transform.translate(
                offset: Offset(x, y),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: 0.4 + (i * 0.15)),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
