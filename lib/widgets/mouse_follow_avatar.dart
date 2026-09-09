import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/app_colors.dart';

/// A developer avatar whose eyes follow the mouse cursor.
/// Head also tilts slightly toward the cursor for extra life.
class MouseFollowAvatar extends StatefulWidget {
  final double size;

  const MouseFollowAvatar({super.key, this.size = 280});

  @override
  State<MouseFollowAvatar> createState() => _MouseFollowAvatarState();
}

class _MouseFollowAvatarState extends State<MouseFollowAvatar>
    with SingleTickerProviderStateMixin {
  Offset _mousePos = Offset.zero;
  final GlobalKey _key = GlobalKey();

  // Smoothed eye offset
  double _smoothEyeX = 0;
  double _smoothEyeY = 0;
  double _smoothHeadTilt = 0;

  late AnimationController _blinkController;
  bool _isBlinking = false;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scheduleBlink();
  }

  void _scheduleBlink() async {
    await Future.delayed(
      Duration(milliseconds: 2000 + math.Random().nextInt(3000)),
    );
    if (!mounted) return;
    setState(() => _isBlinking = true);
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    setState(() => _isBlinking = false);
    _scheduleBlink();
  }

  void _onMouseMove(PointerEvent event) {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final center = box.localToGlobal(Offset(box.size.width / 2, box.size.height * 0.38));
    final global = event.position;
    setState(() {
      _mousePos = global - center;
    });
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Compute eye direction (clamp to a small radius)
    final dist = _mousePos.distance.clamp(0.0, 300.0);
    final angle = math.atan2(_mousePos.dy, _mousePos.dx);
    final eyeRadius = (dist / 300.0) * 5.0;
    final targetEyeX = math.cos(angle) * eyeRadius;
    final targetEyeY = math.sin(angle) * eyeRadius;

    // Lerp smoothly (instant in build, but fine for mouse tracking)
    _smoothEyeX = _smoothEyeX + (targetEyeX - _smoothEyeX) * 0.25;
    _smoothEyeY = _smoothEyeY + (targetEyeY - _smoothEyeY) * 0.25;

    // Subtle head tilt: -3° to +3°
    final targetTilt = (_mousePos.dx / 400.0).clamp(-1.0, 1.0) * 3.0 * (math.pi / 180);
    _smoothHeadTilt = _smoothHeadTilt + (targetTilt - _smoothHeadTilt) * 0.1;

    return MouseRegion(
      onHover: _onMouseMove,
      child: Listener(
        onPointerMove: _onMouseMove,
        child: SizedBox(
          key: _key,
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _AvatarPainter(
              isDark: isDark,
              eyeOffsetX: _smoothEyeX,
              eyeOffsetY: _smoothEyeY,
              headTilt: _smoothHeadTilt,
              isBlinking: _isBlinking,
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarPainter extends CustomPainter {
  final bool isDark;
  final double eyeOffsetX;
  final double eyeOffsetY;
  final double headTilt;
  final bool isBlinking;

  _AvatarPainter({
    required this.isDark,
    required this.eyeOffsetX,
    required this.eyeOffsetY,
    required this.headTilt,
    required this.isBlinking,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // ── Color palette ──────────────────────────────────────────────
    final skinColor = const Color(0xFFF5C5A3);
    final skinShadow = const Color(0xFFE8A882);
    final hairColor = const Color(0xFF1A1A2E);
    final shirtColor = const Color(0xFF0D1B2A);
    final accentColor = AppColors.cyan;
    final glassFrame = const Color(0xFF2D3748);
    final screenGlow = AppColors.pink.withValues(alpha: 0.15);

    // ── Desk & monitor shadow glow ─────────────────────────────────
    final deskY = cy + size.height * 0.22;

    // Monitor glow
    final glowPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - size.height * 0.05), width: 160, height: 80),
      glowPaint,
    );

    // ── Desk ───────────────────────────────────────────────────────
    final deskPaint = Paint()..color = isDark ? const Color(0xFF1E2A38) : const Color(0xFF2D3748);
    final deskRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - 110, deskY, 220, 18),
      const Radius.circular(4),
    );
    canvas.drawRRect(deskRRect, deskPaint);

    // Desk edge highlight
    final deskEdge = Paint()
      ..color = accentColor.withValues(alpha: 0.25)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(deskRRect, deskEdge);

    // ── Keyboard ───────────────────────────────────────────────────
    final kbPaint = Paint()..color = const Color(0xFF16213E);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 52, deskY - 8, 104, 10),
        const Radius.circular(3),
      ),
      kbPaint,
    );
    // Key rows
    final keyPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.5)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 8; col++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - 49 + col * 12.5, deskY - 6.5 + row * 4, 10, 3),
            const Radius.circular(0.5),
          ),
          keyPaint,
        );
      }
    }

    // ── Monitor ────────────────────────────────────────────────────
    final monitorBase = Paint()..color = const Color(0xFF16213E);
    // Stand
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 5, deskY - 28, 10, 22),
        const Radius.circular(2),
      ),
      monitorBase,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 18, deskY - 9, 36, 4),
        const Radius.circular(2),
      ),
      monitorBase,
    );

    // Screen bezel
    final bezel = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - 68, cy - size.height * 0.42, 136, 90),
      const Radius.circular(6),
    );
    canvas.drawRRect(bezel, Paint()..color = const Color(0xFF0D1B2A));
    canvas.drawRRect(
      bezel,
      Paint()
        ..color = accentColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Screen content glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 62, cy - size.height * 0.40, 124, 78),
        const Radius.circular(3),
      ),
      Paint()..color = screenGlow,
    );

    // Code lines on screen
    final codePaint = Paint()
      ..color = accentColor.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final codePinkPaint = Paint()
      ..color = AppColors.pink.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final screenTop = cy - size.height * 0.38;
    for (int i = 0; i < 6; i++) {
      final lineY = screenTop + i * 10.0;
      final lineW = (i.isEven ? 70.0 : 45.0) + (i % 3) * 12.0;
      final p = i % 3 == 0 ? codePinkPaint : codePaint;
      canvas.drawLine(
        Offset(cx - 55, lineY),
        Offset(cx - 55 + lineW.clamp(0.0, 110.0), lineY),
        p,
      );
    }

    // ── Body / Torso ───────────────────────────────────────────────
    final bodyPaint = Paint()..color = shirtColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 36, cy + size.height * 0.00, 72, 60),
        const Radius.circular(6),
      ),
      bodyPaint,
    );
    // Shirt collar accent stripe
    final stripePaint = Paint()
      ..color = accentColor.withValues(alpha: 0.7)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(cx - 4, cy + size.height * 0.01),
      Offset(cx - 4, cy + size.height * 0.01 + 22),
      stripePaint,
    );
    canvas.drawLine(
      Offset(cx + 4, cy + size.height * 0.01),
      Offset(cx + 4, cy + size.height * 0.01 + 22),
      stripePaint,
    );

    // Arms
    final armPaint = Paint()..color = shirtColor;
    // Left arm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 60, cy + size.height * 0.02, 26, 44),
        const Radius.circular(8),
      ),
      armPaint,
    );
    // Right arm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 34, cy + size.height * 0.02, 26, 44),
        const Radius.circular(8),
      ),
      armPaint,
    );
    // Hands
    canvas.drawCircle(Offset(cx - 47, cy + size.height * 0.09), 9, Paint()..color = skinColor);
    canvas.drawCircle(Offset(cx + 47, cy + size.height * 0.09), 9, Paint()..color = skinColor);

    // ── Head (with subtle mouse-tracking tilt) ──────────────────────
    canvas.save();
    final headCenter = Offset(cx, cy - size.height * 0.10);
    canvas.translate(headCenter.dx, headCenter.dy);
    canvas.rotate(headTilt);
    canvas.translate(-headCenter.dx, -headCenter.dy);

    // Neck
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 10, cy - size.height * 0.03, 20, 20),
        const Radius.circular(4),
      ),
      Paint()..color = skinShadow,
    );

    // Head shape
    final headPaint = Paint()..color = skinColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 44, cy - size.height * 0.28, 88, 90),
        const Radius.circular(28),
      ),
      headPaint,
    );

    // ── Hair ──────────────────────────────────────────────────────
    final hairPaint = Paint()..color = hairColor;
    // Top hair blob
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 44, cy - size.height * 0.28, 88, 44),
        const Radius.circular(28),
      ),
      hairPaint,
    );
    // Side burns
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 44, cy - size.height * 0.22, 12, 28),
        const Radius.circular(6),
      ),
      hairPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 32, cy - size.height * 0.22, 12, 28),
        const Radius.circular(6),
      ),
      hairPaint,
    );

    // ── Glasses frame ─────────────────────────────────────────────
    final glassPaint = Paint()
      ..color = glassFrame
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    // Left lens
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 38, cy - size.height * 0.16, 30, 22),
        const Radius.circular(6),
      ),
      glassPaint,
    );
    // Right lens
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 8, cy - size.height * 0.16, 30, 22),
        const Radius.circular(6),
      ),
      glassPaint,
    );
    // Bridge
    canvas.drawLine(
      Offset(cx - 8, cy - size.height * 0.155),
      Offset(cx + 8, cy - size.height * 0.155),
      glassPaint,
    );

    // ── Eyes (follow mouse) ───────────────────────────────────────
    if (!isBlinking) {
      // Eye whites
      final eyeWhite = Paint()..color = Colors.white;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx - 23, cy - size.height * 0.145), width: 18, height: 14),
        eyeWhite,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx + 23, cy - size.height * 0.145), width: 18, height: 14),
        eyeWhite,
      );

      // Iris (follows mouse)
      final irisPaint = Paint()..color = const Color(0xFF2B6CB0);
      final pupilPaint = Paint()..color = Colors.black;
      final glintPaint = Paint()..color = Colors.white;

      for (final side in [-1.0, 1.0]) {
        final ex = cx + side * 23 + eyeOffsetX;
        final ey = cy - size.height * 0.145 + eyeOffsetY;
        canvas.drawCircle(Offset(ex, ey), 5, irisPaint);
        canvas.drawCircle(Offset(ex, ey), 3, pupilPaint);
        canvas.drawCircle(Offset(ex - 1.5, ey - 1.5), 1.2, glintPaint);
      }
    } else {
      // Blink — draw closed eyelid lines
      final lidPaint = Paint()
        ..color = skinShadow
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(cx - 32, cy - size.height * 0.145),
        Offset(cx - 14, cy - size.height * 0.145),
        lidPaint,
      );
      canvas.drawLine(
        Offset(cx + 14, cy - size.height * 0.145),
        Offset(cx + 32, cy - size.height * 0.145),
        lidPaint,
      );
    }

    // ── Nose ──────────────────────────────────────────────────────
    canvas.drawCircle(
      Offset(cx, cy - size.height * 0.11),
      3,
      Paint()..color = skinShadow,
    );

    // ── Smile ─────────────────────────────────────────────────────
    final smilePaint = Paint()
      ..color = const Color(0xFFB05C5C)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final smilePath = Path();
    smilePath.moveTo(cx - 12, cy - size.height * 0.06);
    smilePath.quadraticBezierTo(cx, cy - size.height * 0.03, cx + 12, cy - size.height * 0.06);
    canvas.drawPath(smilePath, smilePaint);

    // ── Headphones ───────────────────────────────────────────────
    final hpPaint = Paint()
      ..color = const Color(0xFF16213E)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromLTWH(cx - 46, cy - size.height * 0.30, 92, 50),
      math.pi,
      math.pi,
      false,
      hpPaint,
    );
    // Ear cups
    canvas.drawCircle(Offset(cx - 46, cy - size.height * 0.205), 8, Paint()..color = accentColor);
    canvas.drawCircle(Offset(cx + 46, cy - size.height * 0.205), 8, Paint()..color = accentColor);
    // Cup glow
    final cupGlow = Paint()
      ..color = accentColor.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(cx - 46, cy - size.height * 0.205), 8, cupGlow);
    canvas.drawCircle(Offset(cx + 46, cy - size.height * 0.205), 8, cupGlow);

    canvas.restore();

    // ── Floating "< />" label below ───────────────────────────────
    final labelBg = Paint()
      ..color = accentColor.withValues(alpha: 0.1);
    final labelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - 28, deskY + 26, 56, 20),
      const Radius.circular(4),
    );
    canvas.drawRRect(labelRect, labelBg);
    canvas.drawRRect(
      labelRect,
      Paint()
        ..color = accentColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Draw "< />" text manually as lines (no TextPainter needed for decorative)
    final dotPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.8)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    // Left <
    canvas.drawLine(Offset(cx - 20, deskY + 33), Offset(cx - 14, deskY + 37), dotPaint);
    canvas.drawLine(Offset(cx - 14, deskY + 37), Offset(cx - 20, deskY + 41), dotPaint);
    // /
    canvas.drawLine(Offset(cx - 4, deskY + 41), Offset(cx + 4, deskY + 33), dotPaint);
    // >
    canvas.drawLine(Offset(cx + 14, deskY + 33), Offset(cx + 20, deskY + 37), dotPaint);
    canvas.drawLine(Offset(cx + 20, deskY + 37), Offset(cx + 14, deskY + 41), dotPaint);
  }

  @override
  bool shouldRepaint(_AvatarPainter old) =>
      old.eyeOffsetX != eyeOffsetX ||
      old.eyeOffsetY != eyeOffsetY ||
      old.headTilt != headTilt ||
      old.isBlinking != isBlinking ||
      old.isDark != isDark;
}
