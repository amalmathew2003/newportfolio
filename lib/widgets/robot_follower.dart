import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';

/// Section descriptions shown in the speech bubble when bot enters a section.
const _sectionInfo = {
  'Dev': (
    icon: '🧑‍💻',
    title: 'Dev Avatar',
    desc: 'An interactive avatar that\nfollows your mouse!',
  ),
  'App': (
    icon: '🚀',
    title: 'Hero',
    desc: 'Flutter developer building\npolished cross-platform apps.',
  ),
  'About': (
    icon: '👤',
    title: 'About Me',
    desc: 'BCA grad, 6m intern +\n1y 3m professional Flutter dev.',
  ),
  'Skills': (
    icon: '⚡',
    title: 'Skills',
    desc: 'Flutter, Dart, Firebase,\nREST APIs & Clean Architecture.',
  ),
  'Work': (
    icon: '💼',
    title: 'Experience',
    desc: 'Internship + full-time role\nshipping production Flutter apps.',
  ),
  'Projects': (
    icon: '📦',
    title: 'Projects',
    desc: 'Real apps with AI, sensors,\nmaps & speech integration.',
  ),
  'Contact': (
    icon: '📬',
    title: 'Contact',
    desc: "Let's build something\namazing together!",
  ),
};

/// Full-page robot-ball cursor follower.
/// Wraps the entire page content. A glowing orb with robot eyes lags behind
/// the cursor. When the cursor physically moves into a section, a speech bubble
/// appears explaining that section — detected from actual render box bounds.
class RobotFollowerOverlay extends StatefulWidget {
  final Widget child;
  /// Keys for each section widget, in the same order as [sectionNames].
  final List<GlobalKey> sectionKeys;
  /// Display names of each section (must match keys in [_sectionInfo]).
  final List<String> sectionNames;

  const RobotFollowerOverlay({
    super.key,
    required this.child,
    required this.sectionKeys,
    required this.sectionNames,
  });

  @override
  State<RobotFollowerOverlay> createState() => _RobotFollowerOverlayState();
}

class _RobotFollowerOverlayState extends State<RobotFollowerOverlay>
    with TickerProviderStateMixin {
  // Raw cursor position (global)
  Offset _cursor = const Offset(200, 300);
  // Smoothed bot position (lags behind cursor)
  double _botX = 200;
  double _botY = 300;

  // Speech bubble visibility
  bool _bubbleVisible = false;
  String _bubbleSection = '';
  late AnimationController _bubbleCtrl;
  late Animation<double> _bubbleAnim;

  // Bot idle animations
  late AnimationController _idleCtrl;
  bool _isBlinking = false;

  // Antenna wave
  late AnimationController _antennaCtrl;

  // Which section name the cursor is currently physically over
  String _detectedSection = '';

  @override
  void initState() {
    super.initState();

    _bubbleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _bubbleAnim = CurvedAnimation(parent: _bubbleCtrl, curve: Curves.easeOutBack);

    _idleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _idleCtrl.addListener(() => setState(() {}));

    _antennaCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _antennaCtrl.addListener(() => setState(() {}));

    _scheduleBlink();
  }

  void _scheduleBlink() async {
    await Future.delayed(
      Duration(milliseconds: 1800 + math.Random().nextInt(2400)),
    );
    if (!mounted) return;
    setState(() => _isBlinking = true);
    await Future.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    setState(() => _isBlinking = false);
    _scheduleBlink();
  }

  /// Detect which section the cursor Y is physically inside.
  void _detectSectionAtCursor(double cursorY) {
    String found = '';
    for (int i = 0; i < widget.sectionKeys.length; i++) {
      final box = widget.sectionKeys[i].currentContext
          ?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final sectionTop = box.localToGlobal(Offset.zero).dy;
      final sectionBottom = sectionTop + box.size.height;
      if (cursorY >= sectionTop && cursorY <= sectionBottom) {
        found = widget.sectionNames[i];
        // Don't break — keep last match (bottom-most wins for overlapping)
      }
    }
    if (found != _detectedSection) {
      _detectedSection = found;
      _updateBubble(found);
    }
  }

  void _updateBubble(String section) {
    final info = _sectionInfo[section];
    if (info != null) {
      setState(() => _bubbleSection = section);
      _bubbleCtrl.forward(from: 0);
      setState(() => _bubbleVisible = true);
    } else {
      _bubbleCtrl.reverse().then((_) {
        if (mounted) setState(() => _bubbleVisible = false);
      });
    }
  }

  void _onMouseMove(PointerEvent e) {
    setState(() {
      _cursor = e.position;
      // Lerp bot toward cursor (lag factor 0.12 = feels physical)
      _botX += (_cursor.dx + 28 - _botX) * 0.12;
      _botY += (_cursor.dy + 8 - _botY) * 0.12;
    });
    // Detect which section the cursor is physically inside (by Y)
    _detectSectionAtCursor(e.position.dy);
  }

  @override
  void dispose() {
    _bubbleCtrl.dispose();
    _idleCtrl.dispose();
    _antennaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Eye direction: look toward cursor from bot center
    final eyeDx = (_cursor.dx - _botX).clamp(-30.0, 30.0);
    final eyeDy = (_cursor.dy - _botY).clamp(-30.0, 30.0);
    final eyeDist = math.sqrt(eyeDx * eyeDx + eyeDy * eyeDy).clamp(1.0, 30.0);
    final eyeNX = eyeDx / eyeDist * 3.0; // normalized pupil offset (max 3px)
    final eyeNY = eyeDy / eyeDist * 3.0;

    // Bob
    final bob = math.sin(_idleCtrl.value * math.pi * 2) * 4.0;
    final antennaWave = math.sin(_antennaCtrl.value * math.pi) * 6.0;

    // Speech bubble position: to the left if bot is on the right half
    final screenW = MediaQuery.of(context).size.width;
    final bubbleOnLeft = _botX > screenW / 2;

    final info = _sectionInfo[_bubbleSection];

    return MouseRegion(
      onHover: _onMouseMove,
      child: Listener(
        onPointerMove: _onMouseMove,
        child: Stack(
          children: [
            // ── Page content ────────────────────────────────────────────
            widget.child,

            // ── Robot bot ───────────────────────────────────────────────
            Positioned(
              left: _botX - 28,
              top: _botY + bob - 28,
              child: IgnorePointer(
                child: SizedBox(
                  width: 56,
                  height: 70,
                  child: CustomPaint(
                    painter: _RobotPainter(
                      eyeNX: eyeNX,
                      eyeNY: eyeNY,
                      isBlinking: _isBlinking,
                      antennaWave: antennaWave,
                      t: _idleCtrl.value,
                    ),
                  ),
                ),
              ),
            ),

            // ── Speech bubble ────────────────────────────────────────────
            if (_bubbleVisible && info != null)
              Positioned(
                left: bubbleOnLeft ? _botX - 200 : _botX + 34,
                top: _botY + bob - 60,
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _bubbleAnim,
                    builder: (context, _) {
                      return Transform.scale(
                        scale: _bubbleAnim.value,
                        alignment: bubbleOnLeft
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: _SpeechBubble(
                          icon: info.icon,
                          title: info.title,
                          desc: info.desc,
                          pointsLeft: !bubbleOnLeft,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── Speech bubble ───────────────────────────────────

class _SpeechBubble extends StatelessWidget {
  final String icon, title, desc;
  final bool pointsLeft; // tail direction

  const _SpeechBubble({
    required this.icon,
    required this.title,
    required this.desc,
    required this.pointsLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628).withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.cyan.withValues(alpha: 0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.2),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.cyan,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Robot painter ───────────────────────────────────

class _RobotPainter extends CustomPainter {
  final double eyeNX, eyeNY, antennaWave, t;
  final bool isBlinking;

  const _RobotPainter({
    required this.eyeNX,
    required this.eyeNY,
    required this.isBlinking,
    required this.antennaWave,
    required this.t,
  });

  static const _cyan = Color(0xFF00F5D4);
  static const _pink = Color(0xFFFF2D78);
  static const _dark = Color(0xFF0A1628);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 8; // shift down for antenna

    // ── Outer glow ─────────────────────────────────────────────────────────
    final glowPulse = 0.5 + 0.5 * math.sin(t * math.pi * 2);
    final ballPulse = 0.5 + 0.5 * math.sin(t * math.pi * 4);
    canvas.drawCircle(
      Offset(cx, cy),
      26 + glowPulse * 4,
      Paint()
        ..color = _cyan.withValues(alpha: 0.18 + glowPulse * 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );

    // ── Body orb ───────────────────────────────────────────────────────────
    final bodyRect = Rect.fromCircle(center: Offset(cx, cy), radius: 22);
    canvas.drawCircle(
      Offset(cx, cy),
      22,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.4, -0.5),
          radius: 1.0,
          colors: [
            const Color(0xFF162540),
            _dark,
          ],
        ).createShader(bodyRect),
    );

    // Body border
    canvas.drawCircle(
      Offset(cx, cy),
      22,
      Paint()
        ..color = _cyan.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // ── Visor/face plate ───────────────────────────────────────────────────
    final visorRect = Rect.fromLTWH(cx - 14, cy - 10, 28, 20);
    canvas.drawRRect(
      RRect.fromRectAndRadius(visorRect, const Radius.circular(8)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0D2137),
            const Color(0xFF061522),
          ],
        ).createShader(visorRect),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(visorRect, const Radius.circular(8)),
      Paint()
        ..color = _cyan.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // ── Eyes ───────────────────────────────────────────────────────────────
    if (!isBlinking) {
      for (final side in [-1.0, 1.0]) {
        final ex = cx + side * 6;
        final eyeCenter = Offset(ex, cy - 1);

        // Eye socket
        canvas.drawCircle(
          eyeCenter,
          5.5,
          Paint()..color = const Color(0xFF0A1E32),
        );
        // Iris
        canvas.drawCircle(
          Offset(ex + eyeNX * 0.6, cy - 1 + eyeNY * 0.6),
          3.5,
          Paint()
            ..shader = RadialGradient(
              colors: [_cyan, const Color(0xFF008A78)],
            ).createShader(
              Rect.fromCircle(
                center: Offset(ex + eyeNX * 0.6, cy - 1 + eyeNY * 0.6),
                radius: 3.5,
              ),
            ),
        );
        // Pupil
        canvas.drawCircle(
          Offset(ex + eyeNX, cy - 1 + eyeNY),
          1.8,
          Paint()..color = Colors.black,
        );
        // Glint
        canvas.drawCircle(
          Offset(ex + eyeNX - 1, cy - 1 + eyeNY - 1),
          0.8,
          Paint()..color = Colors.white,
        );
        // Eye glow ring
        canvas.drawCircle(
          eyeCenter,
          5.5,
          Paint()
            ..color = _cyan.withValues(alpha: 0.15)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
    } else {
      // Blink — two short lines
      for (final side in [-1.0, 1.0]) {
        canvas.drawLine(
          Offset(cx + side * 9.5, cy - 1),
          Offset(cx + side * 2.5, cy - 1),
          Paint()
            ..color = _cyan.withValues(alpha: 0.7)
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // Mouth — small arc that changes with section
    final mouthPath = Path()
      ..moveTo(cx - 5, cy + 7)
      ..quadraticBezierTo(cx, cy + 10, cx + 5, cy + 7);
    canvas.drawPath(
      mouthPath,
      Paint()
        ..color = _cyan.withValues(alpha: 0.65)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // ── Antenna ────────────────────────────────────────────────────────────
    final antennaBase = Offset(cx, cy - 22);
    final antennaTip = Offset(cx + antennaWave * 0.5, cy - 22 - 14);
    canvas.drawLine(
      antennaBase,
      antennaTip,
      Paint()
        ..color = _cyan.withValues(alpha: 0.7)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
    // Antenna ball glow
    canvas.drawCircle(
      antennaTip,
      4 + ballPulse * 2,
      Paint()
        ..color = _pink.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawCircle(
      antennaTip,
      2.5,
      Paint()..color = _pink,
    );

    // ── Side ears / bolts ──────────────────────────────────────────────────
    for (final side in [-1.0, 1.0]) {
      canvas.drawCircle(
        Offset(cx + side * 21, cy),
        4,
        Paint()..color = const Color(0xFF162540),
      );
      canvas.drawCircle(
        Offset(cx + side * 21, cy),
        4,
        Paint()
          ..color = _cyan.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      // Ear pulse
      canvas.drawCircle(
        Offset(cx + side * 21, cy),
        2,
        Paint()..color = _cyan.withValues(alpha: 0.5 + ballPulse * 0.4),
      );
    }

    // ── Bottom thruster glow ───────────────────────────────────────────────
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy + 22),
        width: 16,
        height: 6,
      ),
      Paint()
        ..color = _cyan.withValues(alpha: 0.25 + glowPulse * 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
  }

  @override
  bool shouldRepaint(_RobotPainter old) => true;
}
