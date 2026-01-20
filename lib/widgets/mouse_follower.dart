import 'package:flutter/material.dart';
import 'dart:math' as math;

class MouseFollower extends StatefulWidget {
  final Widget child;
  const MouseFollower({super.key, required this.child});

  @override
  State<MouseFollower> createState() => _MouseFollowerState();
}

class _MouseFollowerState extends State<MouseFollower>
    with SingleTickerProviderStateMixin {
  Offset? _target;
  Offset? _current;
  final List<Offset> _spine = [];
  late AnimationController _animationController;

  static const int spineLength = 25;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..addListener(() {
            if (_target == null) return;

            setState(() {
              _current ??= _target;
              // Smooth inertia for serpentine movement
              _current = Offset.lerp(_current, _target, 0.2);

              _spine.insert(0, _current!);
              if (_spine.length > spineLength) {
                _spine.removeLast();
              }
            });
          });
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event) {
    _target = event.position;
  }

  double get _speed => _spine.length > 1 ? (_spine[0] - _spine[1]).distance : 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit: (_) {
        setState(() {
          _target = null;
          _current = null;
          _spine.clear();
        });
      },
      child: Stack(
        children: [
          RepaintBoundary(child: widget.child),
          if (_spine.length >= 2)
            IgnorePointer(
              child: CustomPaint(
                size: Size.infinite,
                painter: _DragonPainter(
                  spine: _spine,
                  waveValue: _animationController.value,
                  speed: _speed,
                  color: const Color(0xFF00D2FF),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DragonPainter extends CustomPainter {
  final List<Offset> spine;
  final double waveValue;
  final double speed;
  final Color color;

  _DragonPainter({
    required this.spine,
    required this.waveValue,
    required this.speed,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw body segments from tail to head for proper overlapping
    for (int i = spine.length - 1; i >= 0; i--) {
      final pos = spine[i];
      final progress = i / spine.length;
      final opacity = (1 - progress * 0.7).clamp(0.0, 1.0);
      final scale = (1 - progress * 0.6);

      // Rotation based on movement direction
      double rotation = 0;
      if (i < spine.length - 1) {
        rotation = (spine[i] - spine[i + 1]).direction;
      } else if (i > 0) {
        rotation = (spine[i - 1] - spine[i]).direction;
      }

      // Serpentine wave
      final wave =
          math.sin((waveValue * math.pi * 2) - i * 0.4) * 12 * (1 - progress);

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(rotation + math.pi / 2);
      canvas.translate(wave, 0);

      if (i == 0) {
        _drawHead(canvas, 24 * scale, color, opacity);
      } else if (i == spine.length - 1) {
        _drawTail(canvas, 18 * scale, color, opacity);
      } else {
        _drawBodySegment(canvas, 20 * scale, color, opacity, i % 3 == 0);
      }

      canvas.restore();
    }
  }

  void _drawHead(Canvas canvas, double size, Color color, double opacity) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final headPath = Path()
      ..moveTo(0, -size * 0.8) // Nose
      ..lineTo(size * 0.4, -size * 0.4) // Right cheek
      ..lineTo(size * 0.5, size * 0.2) // Right jaw
      ..lineTo(size * 0.2, size * 0.3) // Right neck
      ..lineTo(-size * 0.2, size * 0.3) // Left neck
      ..lineTo(-size * 0.5, size * 0.2) // Left jaw
      ..lineTo(-size * 0.4, -size * 0.4) // Left cheek
      ..close();

    // Horns
    final hornPath = Path()
      ..moveTo(size * 0.2, -size * 0.2)
      ..lineTo(size * 0.35, -size * 0.7)
      ..moveTo(-size * 0.2, -size * 0.2)
      ..lineTo(-size * 0.35, -size * 0.7);

    canvas.drawPath(headPath, paint);
    canvas.drawPath(headPath, strokePaint);
    canvas.drawPath(hornPath, strokePaint);

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset(-size * 0.15, -size * 0.1), 2, eyePaint);
    canvas.drawCircle(Offset(size * 0.15, -size * 0.1), 2, eyePaint);
  }

  void _drawBodySegment(
    Canvas canvas,
    double size,
    Color color,
    double opacity,
    bool hasFin,
  ) {
    final paint = Paint()
      ..color = color.withOpacity(opacity * 0.6)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Scale/Shield shape
    final path = Path()
      ..moveTo(0, -size / 2)
      ..lineTo(size / 2, 0)
      ..lineTo(0, size / 2)
      ..lineTo(-size / 2, 0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    // Spinal Fin
    if (hasFin) {
      final finPath = Path()
        ..moveTo(0, -size / 4)
        ..lineTo(size / 6, 0)
        ..lineTo(0, size / 4)
        ..close();
      canvas.drawPath(finPath, strokePaint);
    }
  }

  void _drawTail(Canvas canvas, double size, Color color, double opacity) {
    final strokePaint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Spear tip tail
    final path = Path()
      ..moveTo(0, -size / 2)
      ..lineTo(size / 3, size / 2)
      ..lineTo(0, size)
      ..lineTo(-size / 3, size / 2)
      ..close();

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _DragonPainter oldDelegate) {
    return oldDelegate.waveValue != waveValue || oldDelegate.spine != spine;
  }
}
