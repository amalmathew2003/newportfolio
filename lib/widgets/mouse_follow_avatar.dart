import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Premium animated developer avatar.
/// Eyes + head follow the mouse. Features orbital particles, glow, monitor
/// with blinking cursor, coffee steam, floating badges, and a breathing bob.
class MouseFollowAvatar extends StatefulWidget {
  final double size;
  final bool isWaving;
  const MouseFollowAvatar({super.key, this.size = 300, this.isWaving = false});

  @override
  State<MouseFollowAvatar> createState() => _MouseFollowAvatarState();
}

class _MouseFollowAvatarState extends State<MouseFollowAvatar>
    with TickerProviderStateMixin {
  Offset _mousePos = Offset.zero;
  final GlobalKey _key = GlobalKey();

  double _smoothEyeX = 0;
  double _smoothEyeY = 0;
  double _smoothHeadTilt = 0;

  late final AnimationController _loopCtrl;
  late final AnimationController _pulseCtrl;
  bool _isBlinking = false;

  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();

    _loopCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _loopCtrl.addListener(() => setState(() {}));

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _particles = List.generate(18, (i) {
      final rng = math.Random(i * 7 + 3);
      return _Particle(
        baseAngle: (i / 18) * math.pi * 2,
        orbitA: 100 + rng.nextDouble() * 48,
        orbitB: 36 + rng.nextDouble() * 18,
        dotSize: 1.4 + rng.nextDouble() * 2.4,
        speed: 0.35 + rng.nextDouble() * 0.55,
        opacity: 0.22 + rng.nextDouble() * 0.5,
        isCyan: i % 3 != 1,
      );
    });

    _scheduleBlink();
  }

  void _scheduleBlink() async {
    await Future.delayed(
      Duration(milliseconds: 2200 + math.Random().nextInt(2800)),
    );
    if (!mounted) return;
    setState(() => _isBlinking = true);
    await Future.delayed(const Duration(milliseconds: 130));
    if (!mounted) return;
    setState(() => _isBlinking = false);
    _scheduleBlink();
  }

  void _onHover(PointerEvent e) {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final s = widget.size;
    final pivot = box.localToGlobal(Offset(s / 2, s * 0.32));
    setState(() => _mousePos = e.position - pivot);
  }

  @override
  void dispose() {
    _loopCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = _loopCtrl.value;

    // Eye tracking
    final dist = _mousePos.distance.clamp(0.0, 500.0);
    final ang = math.atan2(_mousePos.dy, _mousePos.dx);
    final er = (dist / 500.0) * 7.0;
    _smoothEyeX += (math.cos(ang) * er - _smoothEyeX) * 0.18;
    _smoothEyeY += (math.sin(ang) * er - _smoothEyeY) * 0.18;

    // Head tilt
    final tiltTarget =
        (_mousePos.dx / 500.0).clamp(-1.0, 1.0) * 5.0 * (math.pi / 180);
    _smoothHeadTilt += (tiltTarget - _smoothHeadTilt) * 0.08;

    // Floating bob
    final bobY = math.sin(t * math.pi * 2) * 4.5;

    return MouseRegion(
      onHover: _onHover,
      child: Listener(
        onPointerMove: _onHover,
        child: SizedBox(
          key: _key,
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _AvatarPainter(
              isDark: isDark,
              eyeX: _smoothEyeX,
              eyeY: _smoothEyeY,
              headTilt: _smoothHeadTilt,
              isBlinking: _isBlinking,
              isWaving: widget.isWaving,
              t: t,
              bobY: bobY,
              particles: _particles,
              pulseT: _pulseCtrl.value,
            ),
          ),
        ),
      ),
    );
  }
}

class _Particle {
  final double baseAngle, orbitA, orbitB, dotSize, speed, opacity;
  final bool isCyan;
  const _Particle({
    required this.baseAngle,
    required this.orbitA,
    required this.orbitB,
    required this.dotSize,
    required this.speed,
    required this.opacity,
    required this.isCyan,
  });
}

// ─────────────────────────── Painter ────────────────────────────────────────

class _AvatarPainter extends CustomPainter {
  final bool isDark, isBlinking, isWaving;
  final double eyeX, eyeY, headTilt, t, bobY, pulseT;
  final List<_Particle> particles;

  const _AvatarPainter({
    required this.isDark,
    required this.eyeX,
    required this.eyeY,
    required this.headTilt,
    required this.isBlinking,
    required this.isWaving,
    required this.t,
    required this.bobY,
    required this.particles,
    required this.pulseT,
  });

  // ── Palette ──────────────────────────────────────────────────────────────
  static const _cyan = Color(0xFF00F5D4);
  static const _pink = Color(0xFFFF2D78);
  static const _skin = Color(0xFFF4C5A3);
  static const _skinD = Color(0xFFD99070);
  static const _skinM = Color(0xFFEDB78A);
  static const _hair = Color(0xFF1A1D30);
  static const _hairH = Color(0xFF2D3268);
  static const _shirt = Color(0xFF0C1624);
  static const _shirtL = Color(0xFF172132);
  static const _glass = Color(0xFF2C3E50);
  static const _green = Color(0xFF00D26A);
  static const _codeBg = Color(0xFF081422);
  static const _yellow = Color(0xFFFFD166);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final deskY = cy + size.height * 0.245;

    _bg(canvas, cx, cy);
    _pulseRings(canvas, cx, cy);
    _orbitParticles(canvas, cx, cy);
    _monitor(canvas, size, cx, cy);
    _desk(canvas, cx, deskY);
    _keyboard(canvas, cx, deskY);
    _mug(canvas, cx, deskY);
    _body(canvas, size, cx, cy);

    // Head group — tilt + bob
    canvas.save();
    final pivot = Offset(cx, cy - size.height * 0.08 + bobY);
    canvas.translate(pivot.dx, pivot.dy);
    canvas.rotate(headTilt);
    canvas.translate(-pivot.dx, -pivot.dy);
    _head(canvas, size, cx, cy);
    canvas.restore();

    _floatingBadges(canvas, size, cx, cy);
    _cornerLabel(canvas, cx, deskY);
  }

  // ── Background glow ───────────────────────────────────────────────────────
  void _bg(Canvas canvas, double cx, double cy) {
    final pulse = 0.5 + 0.5 * math.sin(t * math.pi * 2);
    canvas.drawCircle(
      Offset(cx - 10, cy - 24),
      110 + pulse * 10,
      Paint()
        ..color = _cyan.withValues(alpha: 0.055 + pulse * 0.015)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 70),
    );
    canvas.drawCircle(
      Offset(cx + 28, cy + 38),
      80 + pulse * 8,
      Paint()
        ..color = _pink.withValues(alpha: 0.04 + pulse * 0.01)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 55),
    );
  }

  // ── Expanding pulse rings ─────────────────────────────────────────────────
  void _pulseRings(Canvas canvas, double cx, double cy) {
    for (int i = 0; i < 3; i++) {
      final tp = (pulseT + i / 3.0) % 1.0;
      final r = 44 + tp * 120;
      final alpha = (1.0 - tp) * 0.14;
      canvas.drawCircle(
        Offset(cx, cy - 14),
        r,
        Paint()
          ..color = _cyan.withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }
  }

  // ── Orbital particles ─────────────────────────────────────────────────────
  void _orbitParticles(Canvas canvas, double cx, double cy) {
    for (final p in particles) {
      final angle = p.baseAngle + t * math.pi * 2 * p.speed;
      final px = cx + math.cos(angle) * p.orbitA;
      final py = cy - 16 + math.sin(angle) * p.orbitB;
      final col = p.isCyan ? _cyan : _pink;
      // glow halo
      canvas.drawCircle(
        Offset(px, py),
        p.dotSize * 3,
        Paint()
          ..color = col.withValues(alpha: p.opacity * 0.28)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      // core
      canvas.drawCircle(
        Offset(px, py),
        p.dotSize,
        Paint()..color = col.withValues(alpha: p.opacity),
      );
    }
  }

  // ── Monitor ───────────────────────────────────────────────────────────────
  void _monitor(Canvas canvas, Size size, double cx, double cy) {
    final monTop = cy - size.height * 0.435;
    final bezelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - 68, monTop, 136, 90),
      const Radius.circular(8),
    );

    // outer glow
    canvas.drawRRect(
      bezelRect.inflate(4),
      Paint()
        ..color = _cyan.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );

    // bezel
    canvas.drawRRect(bezelRect, Paint()..color = const Color(0xFF0A1628));
    canvas.drawRRect(
      bezelRect,
      Paint()
        ..color = _cyan.withValues(alpha: 0.38)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // screen
    final screenRect = Rect.fromLTWH(cx - 62, monTop + 5, 124, 76);
    canvas.drawRect(
      screenRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_codeBg, const Color(0xFF04101E)],
        ).createShader(screenRect),
    );

    _codeLines(canvas, cx, monTop + 8);

    // status LED
    final ledPulse = 0.5 + 0.5 * math.sin(t * math.pi * 6);
    canvas.drawCircle(
      Offset(cx + 57, monTop + 4),
      3.5,
      Paint()..color = _green.withValues(alpha: ledPulse),
    );

    // stand
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 5, monTop + 90, 10, 20),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF16213E),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 22, monTop + 108, 44, 5),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF16213E),
    );
  }

  void _codeLines(Canvas canvas, double cx, double top) {
    final cursor = math.sin(t * math.pi * 7) > 0;
    // line configs: (color, width-fraction, indent)
    final lines = [
      (_pink, 0.50, 0.0),
      (_cyan, 0.72, 0.0),
      (_yellow, 0.38, 12.0),
      (_cyan, 0.60, 12.0),
      (_pink, 0.42, 12.0),
      (const Color(0xFF8EC8E0), 0.78, 0.0),
      (_cyan, 0.32, 12.0),
    ];
    final left = cx - 56.0;
    for (int i = 0; i < lines.length; i++) {
      final ly = top + i * 10.0 + 2;
      final indent = lines[i].$3;
      final w = (lines[i].$2 * 110 - indent).clamp(0.0, 110.0);
      canvas.drawLine(
        Offset(left + indent, ly),
        Offset(left + indent + w, ly),
        Paint()
          ..color = (lines[i].$1).withValues(alpha: 0.65)
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round,
      );
    }
    // blinking cursor
    if (cursor) {
      canvas.drawRect(
        Rect.fromLTWH(left + 12 + 110 * 0.32, top + 6 * 10.0, 1.5, 9),
        Paint()..color = _cyan,
      );
    }
  }

  // ── Desk ─────────────────────────────────────────────────────────────────
  void _desk(Canvas canvas, double cx, double deskY) {
    // shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, deskY + 30), width: 200, height: 22),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );

    final r = Rect.fromLTWH(cx - 114, deskY, 228, 17);
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(4)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF1E2D42), const Color(0xFF111E2D)],
        ).createShader(r),
    );
    // edge highlight
    canvas.drawLine(
      Offset(cx - 114, deskY),
      Offset(cx + 114, deskY),
      Paint()
        ..color = _cyan.withValues(alpha: 0.45)
        ..strokeWidth = 1.0,
    );
  }

  // ── Keyboard ──────────────────────────────────────────────────────────────
  void _keyboard(Canvas canvas, double cx, double deskY) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 56, deskY - 11, 112, 14),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF0E1B2C),
    );
    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 9; col++) {
        final active = math.sin(t * math.pi * 8 + col * 0.9 + row * 1.2) > 0.85;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              cx - 53 + col * 11.8,
              deskY - 9.5 + row * 5,
              9.5,
              3.5,
            ),
            const Radius.circular(1),
          ),
          Paint()
            ..color = active
                ? _cyan.withValues(alpha: 0.55)
                : _cyan.withValues(alpha: 0.13),
        );
      }
    }
  }

  // ── Coffee mug ────────────────────────────────────────────────────────────
  void _mug(Canvas canvas, double cx, double deskY) {
    // mug body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 74, deskY - 19, 19, 19),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF2A1600),
    );
    // mug handle
    canvas.drawArc(
      Rect.fromLTWH(cx + 91, deskY - 15, 10, 10),
      -math.pi / 2,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFF2A1600)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    // coffee surface
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + 83.5, deskY - 19),
        width: 16,
        height: 6,
      ),
      Paint()..color = const Color(0xFF5C3317),
    );
    // steam
    final sf = 0.4 + 0.3 * math.sin(t * math.pi * 5);
    for (int s = 0; s < 2; s++) {
      final sx = cx + 79 + s * 7.0;
      final path = Path()
        ..moveTo(sx, deskY - 20)
        ..quadraticBezierTo(sx + 4, deskY - 29, sx, deskY - 36)
        ..quadraticBezierTo(sx - 4, deskY - 43, sx, deskY - 49);
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withValues(alpha: sf * 0.55)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  // ── Body ──────────────────────────────────────────────────────────────────
  void _body(Canvas canvas, Size size, double cx, double cy) {
    final by = cy + size.height * 0.015 + bobY;

    // torso
    final torsoRect = Rect.fromLTWH(cx - 37, by, 74, 58);
    canvas.drawRRect(
      RRect.fromRectAndRadius(torsoRect, const Radius.circular(8)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_shirtL, _shirt],
        ).createShader(torsoRect),
    );

    // collar V
    final collar = Path()
      ..moveTo(cx - 12, by)
      ..lineTo(cx, by + 20)
      ..lineTo(cx + 12, by);
    canvas.drawPath(collar, Paint()..color = _skinM);

    // shirt accent stripes
    for (int s = 0; s < 2; s++) {
      canvas.drawLine(
        Offset(cx - 5 + s * 10, by + 2),
        Offset(cx - 5 + s * 10, by + 22),
        Paint()
          ..color = _cyan.withValues(alpha: 0.5)
          ..strokeWidth = 2,
      );
    }

    // arms
    for (final side in [-1.0, 1.0]) {
      // ── Waving right arm ──────────────────────────────────────────────────
      if (isWaving && side > 0) {
        // True shoulder center (top-center of right arm rect)
        const shoulderXOffset = 50.0; // cx + 50
        final shoulderX = cx + shoulderXOffset;
        final shoulderY = by + 2.0;

        // Arm points UP-RIGHT: -π = straight up, +0.35 tilts it right
        // Wave oscillation ±0.25 rad (~14°) at 3 Hz
        final waveOsc = math.sin(t * math.pi * 6) * 0.25;
        final armAngle = -math.pi + 0.35 + waveOsc;
        const armLen = 44.0;

        // Rotate arm around shoulder
        canvas.save();
        canvas.translate(shoulderX, shoulderY);
        canvas.rotate(armAngle);

        // Draw upper arm (0,0 is now shoulder, arm goes DOWN in local space)
        final armRect = Rect.fromLTWH(-13, 0, 26, armLen);
        canvas.drawRRect(
          RRect.fromRectAndRadius(armRect, const Radius.circular(10)),
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_shirtL, _shirt],
            ).createShader(armRect),
        );

        // Forearm slight forward bend
        final forearmRect = Rect.fromLTWH(-11, armLen - 4, 22, 30);
        canvas.save();
        canvas.translate(0, armLen);
        canvas.rotate(0.3 + waveOsc * 0.5); // elbow bend + oscillate
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(-11, 0, 22, 30),
            const Radius.circular(8),
          ),
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_shirtL, _shirt],
            ).createShader(forearmRect),
        );

        // Hand at end of forearm
        canvas.drawCircle(
          const Offset(0, 30),
          12,
          Paint()
            ..shader = RadialGradient(
              center: const Alignment(-0.3, -0.3),
              colors: [_skin, _skinD],
            ).createShader(const Rect.fromLTWH(-12, 18, 24, 24)),
        );
        // Palm highlight
        canvas.drawCircle(
          const Offset(-3, 25),
          5,
          Paint()..color = _skin.withValues(alpha: 0.5),
        );
        // Finger stubs (3 small ovals)
        for (int f = 0; f < 3; f++) {
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset(-6.0 + f * 6.0, 18),
              width: 5,
              height: 8,
            ),
            Paint()..color = _skinM,
          );
        }
        canvas.restore(); // forearm
        canvas.restore(); // shoulder

        // ── Compute hand world position for sparkles ──────────────────────
        // After rotating arm by armAngle from (shoulderX, shoulderY),
        // the forearm tip in local space is at (0, armLen).
        // In world: rotate (0, armLen) by armAngle, then add shoulder.
        // Then forearm adds another rotation of +0.3+waveOsc*0.5 at (0, armLen)
        // For sparkle approx, use the arm tip without forearm:
        final handWorldX = shoulderX - armLen * math.sin(armAngle);
        final handWorldY = shoulderY + armLen * math.cos(armAngle);
        final handPos = Offset(handWorldX, handWorldY);

        // Glow halo at hand
        final waveGlow = 0.5 + 0.5 * math.sin(t * math.pi * 8);
        canvas.drawCircle(
          handPos,
          18,
          Paint()
            ..color = _cyan.withValues(alpha: waveGlow * 0.4)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
        );
        canvas.drawCircle(
          handPos,
          6,
          Paint()..color = _yellow.withValues(alpha: waveGlow * 0.6),
        );

        // Spinning star burst at hand
        for (int star = 0; star < 6; star++) {
          final starAngle = (star / 6) * math.pi * 2 + t * math.pi * 4;
          canvas.drawLine(
            handPos,
            Offset(
              handWorldX + math.cos(starAngle) * 14,
              handWorldY + math.sin(starAngle) * 14,
            ),
            Paint()
              ..color = _yellow.withValues(alpha: waveGlow * 0.85)
              ..strokeWidth = 2
              ..strokeCap = StrokeCap.round,
          );
        }
        continue;
      }

      // ── Normal arm ────────────────────────────────────────────────────────
      final armX = side > 0 ? cx + 37 : cx - 63;
      final armRect = Rect.fromLTWH(armX, by + 2, 26, 48);
      canvas.drawRRect(
        RRect.fromRectAndRadius(armRect, const Radius.circular(10)),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_shirtL, _shirt],
          ).createShader(armRect),
      );

      // hand
      final hx = cx + side * 50;
      final hy = by + 46;
      canvas.drawCircle(
        Offset(hx, hy),
        10,
        Paint()
          ..shader = RadialGradient(
            colors: [_skin, _skinD],
          ).createShader(Rect.fromCircle(center: Offset(hx, hy), radius: 10)),
      );
    }
  }

  // ── Head ──────────────────────────────────────────────────────────────────
  void _head(Canvas canvas, Size size, double cx, double cy) {
    final hy = cy - size.height * 0.135 + bobY;

    // neck
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 10, hy + 38, 20, 18),
        const Radius.circular(4),
      ),
      Paint()..color = _skinM,
    );

    // head shape
    final headRect = Rect.fromLTWH(cx - 46, hy - 40, 92, 94);
    canvas.drawRRect(
      RRect.fromRectAndRadius(headRect, const Radius.circular(30)),
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.4),
          radius: 0.9,
          colors: [_skin, _skinD],
        ).createShader(headRect),
    );

    // hair
    final hairRect = Rect.fromLTWH(cx - 46, hy - 40, 92, 52);
    canvas.drawRRect(
      RRect.fromRectAndRadius(hairRect, const Radius.circular(30)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_hairH, _hair],
        ).createShader(hairRect),
    );
    // hair shine
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 16, hy - 37, 24, 7),
        const Radius.circular(4),
      ),
      Paint()..color = _hairH.withValues(alpha: 0.45),
    );
    // sideburns
    for (final side in [-1.0, 1.0]) {
      final sx = side > 0 ? cx + 34 : cx - 46;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(sx, hy - 22, 12, 28),
          const Radius.circular(6),
        ),
        Paint()..color = _hair,
      );
    }

    // ears
    for (final side in [-1.0, 1.0]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + side * 45, hy - 2),
          width: 12,
          height: 17,
        ),
        Paint()..color = _skinM,
      );
    }

    // glasses lens tint
    for (final side in [-1.0, 1.0]) {
      final lx = side > 0 ? cx + 8 : cx - 38;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(lx, hy - 13, 30, 22),
          const Radius.circular(7),
        ),
        Paint()..color = _cyan.withValues(alpha: 0.07),
      );
    }
    // glasses frame
    final gp = Paint()
      ..color = _glass
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    for (final side in [-1.0, 1.0]) {
      final lx = side > 0 ? cx + 8 : cx - 38;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(lx, hy - 13, 30, 22),
          const Radius.circular(7),
        ),
        gp,
      );
    }
    // bridge
    canvas.drawLine(Offset(cx - 8, hy - 7), Offset(cx + 8, hy - 7), gp);
    // temples
    canvas.drawLine(Offset(cx - 38, hy - 5), Offset(cx - 46, hy - 2), gp);
    canvas.drawLine(Offset(cx + 38, hy - 5), Offset(cx + 46, hy - 2), gp);

    // ── eyes ──────────────────────────────────────────────────────────────
    if (!isBlinking) {
      for (final side in [-1.0, 1.0]) {
        final ex = cx + side * 23 + eyeX;
        final ey = hy - 3 + eyeY;
        // white
        canvas.drawOval(
          Rect.fromCenter(center: Offset(ex, ey), width: 19, height: 15),
          Paint()..color = Colors.white,
        );
        // iris
        canvas.drawCircle(
          Offset(ex, ey),
          5.8,
          Paint()
            ..shader =
                RadialGradient(
                  colors: [const Color(0xFF4FA3E0), const Color(0xFF1A5080)],
                ).createShader(
                  Rect.fromCircle(center: Offset(ex, ey), radius: 5.8),
                ),
        );
        // pupil
        canvas.drawCircle(Offset(ex, ey), 3.4, Paint()..color = Colors.black87);
        // glints
        canvas.drawCircle(
          Offset(ex - 1.8, ey - 1.8),
          1.4,
          Paint()..color = Colors.white,
        );
        canvas.drawCircle(
          Offset(ex + 2.2, ey + 1.6),
          0.8,
          Paint()..color = Colors.white.withValues(alpha: 0.55),
        );
        // glow when looking sideways
        if (eyeX.abs() > 2.5) {
          canvas.drawCircle(
            Offset(ex, ey),
            7,
            Paint()
              ..color = _cyan.withValues(alpha: 0.18)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
          );
        }
      }

      // eyebrows
      for (final side in [-1.0, 1.0]) {
        final bx = side > 0 ? cx + 10 : cx - 32;
        // subtle arch tilt with mouse
        final arch = side * headTilt * 4;
        final path = Path()
          ..moveTo(bx, hy - 18 + arch)
          ..quadraticBezierTo(
            bx + 11,
            hy - 21 - arch.abs(),
            bx + 22,
            hy - 18 + arch,
          );
        canvas.drawPath(
          path,
          Paint()
            ..color = _hair
            ..strokeWidth = 3.5
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round,
        );
      }
    } else {
      // blink closed
      for (final side in [-1.0, 1.0]) {
        canvas.drawLine(
          Offset(cx + side * 32, hy - 3),
          Offset(cx + side * 14, hy - 3),
          Paint()
            ..color = _skinD
            ..strokeWidth = 3.2
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // nose
    final np = Path()
      ..moveTo(cx, hy + 7)
      ..lineTo(cx - 4, hy + 15)
      ..lineTo(cx + 4, hy + 15);
    canvas.drawPath(
      np,
      Paint()
        ..color = _skinD
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // smile
    final sp = Path()
      ..moveTo(cx - 14, hy + 22)
      ..quadraticBezierTo(cx, hy + 32, cx + 14, hy + 22);
    canvas.drawPath(
      sp,
      Paint()
        ..color = const Color(0xFFAA5566)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // headphones arc
    canvas.drawArc(
      Rect.fromLTWH(cx - 50, hy - 42, 100, 58),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFF0D1B2E)
        ..strokeWidth = 7
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    // ear cups
    for (final side in [-1.0, 1.0]) {
      final cupC = Offset(cx + side * 50, hy - 13);
      canvas.drawCircle(
        cupC,
        10,
        Paint()
          ..color = _cyan.withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
      canvas.drawCircle(cupC, 10, Paint()..color = _cyan);
      canvas.drawCircle(cupC, 5.5, Paint()..color = const Color(0xFF009E90));
      // cup pulse
      final cp = 0.45 + 0.45 * math.sin(t * math.pi * 2 + side);
      canvas.drawCircle(
        cupC,
        12,
        Paint()
          ..color = _cyan.withValues(alpha: cp * 0.12)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }

    // online badge
    final bp = 0.5 + 0.5 * math.sin(t * math.pi * 4);
    canvas.drawCircle(
      Offset(cx + 37, hy + 34),
      7,
      Paint()
        ..color = _green.withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawCircle(
      Offset(cx + 37, hy + 34),
      4,
      Paint()..color = _green.withValues(alpha: bp),
    );
  }

  // ── Floating tech badges ─────────────────────────────────────────────────
  void _floatingBadges(Canvas canvas, Size size, double cx, double cy) {
    final badges = [
      (cx - 116.0, cy - 38.0, 'Flutter', _cyan),
      (cx + 88.0, cy - 68.0, 'Dart', _pink),
      (cx - 106.0, cy + 46.0, 'Firebase', _yellow),
    ];

    for (int i = 0; i < badges.length; i++) {
      final floatY = math.sin(t * math.pi * 2 + i * 1.3) * 5.5;
      final bx = badges[i].$1;
      final by = badges[i].$2 + floatY;
      final label = badges[i].$3;
      final col = badges[i].$4;

      // connecting dot line to character
      canvas.drawLine(
        Offset(bx, by + 10),
        Offset(cx, cy - 10),
        Paint()
          ..color = col.withValues(alpha: 0.07)
          ..strokeWidth = 0.8,
      );

      // badge glow
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(bx - 26, by - 11, 52, 22),
          const Radius.circular(11),
        ),
        Paint()
          ..color = col.withValues(alpha: 0.12)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );

      // badge fill
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(bx - 26, by - 11, 52, 22),
          const Radius.circular(11),
        ),
        Paint()..color = col.withValues(alpha: 0.09),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(bx - 26, by - 11, 52, 22),
          const Radius.circular(11),
        ),
        Paint()
          ..color = col.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );

      // text
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: col.withValues(alpha: 0.9),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(bx - tp.width / 2, by - tp.height / 2));
    }
  }

  // ── Corner "</>" label under desk ────────────────────────────────────────
  void _cornerLabel(Canvas canvas, double cx, double deskY) {
    final tp = TextPainter(
      text: TextSpan(
        text: '</> amal.dev',
        style: TextStyle(
          color: _cyan.withValues(alpha: 0.55),
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final bw = tp.width + 20;
    final bx = cx - bw / 2;
    final by = deskY + 22;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bx, by, bw, 18),
        const Radius.circular(4),
      ),
      Paint()..color = _cyan.withValues(alpha: 0.07),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bx, by, bw, 18),
        const Radius.circular(4),
      ),
      Paint()
        ..color = _cyan.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    tp.paint(canvas, Offset(cx - tp.width / 2, by + (18 - tp.height) / 2));
  }

  @override
  bool shouldRepaint(_AvatarPainter o) => true;
}
