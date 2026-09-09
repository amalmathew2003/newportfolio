import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';

// ─────────────────────────── Section info map ────────────────────────────────

const _sectionInfo = {
  'Dev': (
    icon: '🧑‍💻',
    title: 'Dev Avatar',
    desc: 'Interactive dev character.\nEye-tracking active!',
  ),
  'App': (
    icon: '🚀',
    title: 'Hello World',
    desc: "I'm Amal — Flutter Developer\nbuilding high-performance apps.",
  ),
  'About': (
    icon: '👤',
    title: 'About Me',
    desc: 'BCA graduate · 6-month intern\n+ 1 yr 3 mos Flutter experience.',
  ),
  'Skills': (
    icon: '⚡',
    title: 'Tech Stack',
    desc: 'Flutter · Dart · Firebase\nREST APIs · State Management.',
  ),
  'Work': (
    icon: '💼',
    title: 'Experience',
    desc: 'Internship & full-time roles\nshipping production apps.',
  ),
  'Projects': (
    icon: '📦',
    title: 'Featured Apps',
    desc: 'Production applications featuring\nAI, maps, sensors & audio.',
  ),
  'Contact': (
    icon: '📬',
    title: 'Get In Touch',
    desc: "Open for opportunities!\nLet's connect & collaborate.",
  ),
  'Project': (
    icon: '🔍',
    title: 'Project Detail',
    desc: 'Detailed view & screenshots.\nExplore specs and links!',
  ),
};

// ─────────────────────────── Overlay widget ──────────────────────────────────

/// Global section-aware robot guide with high-fidelity physics & animations.
class RobotFollowerOverlay extends StatefulWidget {
  final Widget child;
  final List<GlobalKey> sectionKeys;
  final List<String> sectionNames;
  final bool showOnRight;

  const RobotFollowerOverlay({
    super.key,
    required this.child,
    required this.sectionKeys,
    required this.sectionNames,
    this.showOnRight = false,
  });

  @override
  State<RobotFollowerOverlay> createState() => _RobotFollowerOverlayState();
}

class _RobotFollowerOverlayState extends State<RobotFollowerOverlay>
    with TickerProviderStateMixin {
  // ── Cursor position (for eye tracking & head tilt) ──────────────────────────
  Offset _cursor = const Offset(400, 400);

  // ── Bot Y & physics lerp with tilt ──────────────────────────────────────────
  double _botY = 400.0;
  double _botTargetY = 400.0;
  double _velocityY = 0.0;
  double _botTilt = 0.0; // Dynamic tilt angle while moving

  // ── Section speech bubble ──────────────────────────────────────────────────
  String _detectedSection = '';
  bool _bubbleVisible = false;
  String _bubbleSection = '';
  late AnimationController _bubbleCtrl;
  late Animation<double> _bubbleAnim;

  // ── Idle & Animation Controllers ───────────────────────────────────────────
  late AnimationController _idleCtrl;
  late AnimationController _antennaCtrl;
  late AnimationController _armCtrl;
  late AnimationController _pulseCtrl;

  bool _isBlinking = false;

  @override
  void initState() {
    super.initState();

    _bubbleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _bubbleAnim =
        CurvedAnimation(parent: _bubbleCtrl, curve: Curves.elasticOut);

    _idleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _idleCtrl.addListener(_onIdleTick);

    _antennaCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _antennaCtrl.addListener(() => setState(() {}));

    _armCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
    _armCtrl.addListener(() => setState(() {}));

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _pulseCtrl.addListener(() => setState(() {}));

    _scheduleBlink();
  }

  void _onIdleTick() {
    // Spring physics for bot Y movement and dynamic body tilt
    final dy = _botTargetY - _botY;
    _velocityY = _velocityY * 0.82 + dy * 0.08;
    
    setState(() {
      _botY += _velocityY;
      // Tilt bot slightly into direction of movement (max 0.15 rad ~ 8.5 deg)
      _botTilt = (_velocityY * 0.025).clamp(-0.15, 0.15);
    });
  }

  void _scheduleBlink() async {
    await Future.delayed(
        Duration(milliseconds: 1800 + math.Random().nextInt(2800)));
    if (!mounted) return;
    setState(() => _isBlinking = true);
    await Future.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    setState(() => _isBlinking = false);
    _scheduleBlink();
  }

  void _onMouseMove(PointerEvent e) {
    setState(() => _cursor = e.position);
    _detectSection(e.position.dy);
  }

  void _detectSection(double cursorY) {
    final viewportH = MediaQuery.of(context).size.height;
    String found = '';
    double foundCenterY = _botTargetY;

    for (int i = 0; i < widget.sectionKeys.length; i++) {
      final box = widget.sectionKeys[i].currentContext
          ?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final sTop = box.localToGlobal(Offset.zero).dy;
      final sBottom = sTop + box.size.height;
      if (cursorY >= sTop && cursorY <= sBottom) {
        found = widget.sectionNames[i];
        final visTop = sTop.clamp(56.0, viewportH - 10);
        final visBot = sBottom.clamp(56.0, viewportH - 10);
        foundCenterY = (visTop + visBot) / 2;
      }
    }

    if (found != _detectedSection) {
      _detectedSection = found;
      _botTargetY = foundCenterY;
      _updateBubble(found);
    } else if (found.isNotEmpty) {
      _botTargetY = foundCenterY;
    }
  }

  void _updateBubble(String section) {
    if (_sectionInfo.containsKey(section)) {
      setState(() => _bubbleSection = section);
      _bubbleCtrl.forward(from: 0);
      setState(() => _bubbleVisible = true);
    } else {
      _bubbleCtrl.reverse().then((_) {
        if (mounted) setState(() => _bubbleVisible = false);
      });
    }
  }

  @override
  void dispose() {
    _bubbleCtrl.dispose();
    _idleCtrl.dispose();
    _antennaCtrl.dispose();
    _armCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final isMobile = screenW < 700;

    const botW = 84.0;
    const botH = 175.0;
    final botX = widget.showOnRight ? screenW - botW - 10 : 10.0;

    // Eye direction tracking
    final contentCX = screenW / 2;
    final eyeRelX = (contentCX - botX - botW / 2).clamp(-40.0, 40.0);
    final eyeNX = (eyeRelX / 40.0) * 4.5;
    final eyeRelY = (_cursor.dy - _botY).clamp(-40.0, 40.0);
    final eyeNY = (eyeRelY / 40.0) * 3.0;

    // Levitation floating oscillation
    final bob = math.sin(_idleCtrl.value * math.pi * 2) * 6.0;
    final antennaWave = math.sin(_antennaCtrl.value * math.pi) * 8.0;
    final armWave = _armCtrl.value;

    final showBot = !isMobile;
    final info = _sectionInfo[_bubbleSection];
    final bubbleOnRight = !widget.showOnRight;

    return MouseRegion(
      onHover: _onMouseMove,
      child: Listener(
        onPointerMove: _onMouseMove,
        child: Stack(
          children: [
            widget.child,

            // ── Full-body robot ───────────────────────────────────────────
            if (showBot)
              Positioned(
                left: botX,
                top: _botY + bob - botH / 2,
                width: botW,
                height: botH,
                child: IgnorePointer(
                  child: Transform.rotate(
                    angle: _botTilt,
                    origin: const Offset(botW / 2, botH / 2),
                    child: CustomPaint(
                      painter: _RobotBodyPainter(
                        eyeNX: eyeNX,
                        eyeNY: eyeNY,
                        isBlinking: _isBlinking,
                        antennaWave: antennaWave,
                        armWave: armWave,
                        t: _idleCtrl.value,
                        pulseT: _pulseCtrl.value,
                        bubbleVisible: _bubbleVisible,
                        faceRight: !widget.showOnRight,
                      ),
                    ),
                  ),
                ),
              ),

            // ── Speech bubble with tech accents ───────────────────────────
            if (showBot && _bubbleVisible && info != null)
              Positioned(
                left: bubbleOnRight ? botX + botW + 8 : null,
                right: bubbleOnRight ? null : screenW - botX + 8,
                top: _botY + bob - 62,
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _bubbleAnim,
                    builder: (context, _) => Transform.scale(
                      scale: _bubbleAnim.value.clamp(0.0, 1.2),
                      alignment: bubbleOnRight
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: _SpeechBubble(
                        icon: info.icon,
                        title: info.title,
                        desc: info.desc,
                        tailOnLeft: bubbleOnRight,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── Tech Speech Bubble ─────────────────────────────

class _SpeechBubble extends StatelessWidget {
  final String icon, title, desc;
  final bool tailOnLeft;

  const _SpeechBubble({
    required this.icon,
    required this.title,
    required this.desc,
    required this.tailOnLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 184,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF06101E).withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cyan.withValues(alpha: 0.6),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.28),
            blurRadius: 20,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with pulse status dot
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 15)),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.cyan,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.cyan,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan,
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 1,
            color: AppColors.cyan.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Full-body robot painter ─────────────────────────

class _RobotBodyPainter extends CustomPainter {
  final double eyeNX, eyeNY, antennaWave, armWave, t, pulseT;
  final bool isBlinking, bubbleVisible, faceRight;

  const _RobotBodyPainter({
    required this.eyeNX,
    required this.eyeNY,
    required this.isBlinking,
    required this.antennaWave,
    required this.armWave,
    required this.t,
    required this.pulseT,
    required this.bubbleVisible,
    required this.faceRight,
  });

  static const _cyan = Color(0xFF00F5D4);
  static const _pink = Color(0xFFFF2D78);
  static const _yellow = Color(0xFFFFD166);
  static const _dark = Color(0xFF050E1A);
  static const _bodyColor = Color(0xFF0C1D2E);
  static const _bodyHL = Color(0xFF162B44);
  static const _jointColor = Color(0xFF1B2E46);
  static const _footColor = Color(0xFF091624);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;

    const antennaTipY = 6.0;
    const headCY = 54.0;
    const headR = 28.0;
    const neckTop = headCY + headR - 4;
    const neckBot = neckTop + 14;
    const torsoTop = neckBot - 2;
    const torsoBot = torsoTop + 50;
    const legTop = torsoBot - 2;
    const legBot = legTop + 38;
    const footY = legBot;

    final glowPulse = 0.5 + 0.5 * math.sin(t * math.pi * 2);
    final ledPulseFast = 0.5 + 0.5 * math.sin(t * math.pi * 6);

    // ── 1. Thruster Jet Flames & Ground Aura ─────────────────────────────
    final flameScale = 0.7 + 0.3 * math.sin(t * math.pi * 8);
    for (final side in [-1.0, 1.0]) {
      final lx = cx + side * 13;
      // Energy Jet Plasma cone under feet
      final jetPath = Path()
        ..moveTo(lx - 5, footY + 5)
        ..lineTo(lx + 5, footY + 5)
        ..lineTo(lx, footY + 22 + flameScale * 8)
        ..close();

      canvas.drawPath(
        jetPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _cyan.withValues(alpha: 0.9),
              _pink.withValues(alpha: 0.6),
              Colors.transparent,
            ],
          ).createShader(jetPath.getBounds())
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }

    // Outer aura glow
    canvas.drawCircle(
      Offset(cx, headCY + 20),
      56 + glowPulse * 6,
      Paint()
        ..color = _cyan.withValues(alpha: 0.08 + glowPulse * 0.04)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
    );

    // ── 2. Legs & Knee Joints ─────────────────────────────────────────────
    for (final side in [-1.0, 1.0]) {
      final lx = cx + side * 13;
      final legRect = Rect.fromLTWH(lx - 8, legTop, 16, legBot - legTop);
      canvas.drawRRect(
        RRect.fromRectAndRadius(legRect, const Radius.circular(6)),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bodyHL, _dark],
          ).createShader(legRect),
      );
      // Leg seam line
      canvas.drawLine(
        Offset(lx, legTop + 4),
        Offset(lx, legBot - 4),
        Paint()
          ..color = _cyan.withValues(alpha: 0.2)
          ..strokeWidth = 1,
      );
      // Knee joint ring
      canvas.drawCircle(
        Offset(lx, legTop + (legBot - legTop) * 0.44),
        5.5,
        Paint()..color = _jointColor,
      );
      canvas.drawCircle(
        Offset(lx, legTop + (legBot - legTop) * 0.44),
        5.5,
        Paint()
          ..color = _cyan.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
      // Feet
      final footRect = Rect.fromCenter(
        center: Offset(lx + side * 3, footY + 4),
        width: 22,
        height: 11,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(footRect, const Radius.circular(5)),
        Paint()..color = _footColor,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(footRect, const Radius.circular(5)),
        Paint()
          ..color = _cyan.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // ── 3. Torso & Equalizer Panel ────────────────────────────────────────
    final torsoRect = Rect.fromLTWH(cx - 24, torsoTop, 48, torsoBot - torsoTop);
    canvas.drawRRect(
      RRect.fromRectAndRadius(torsoRect, const Radius.circular(10)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_bodyHL, _bodyColor, _dark],
        ).createShader(torsoRect),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(torsoRect, const Radius.circular(10)),
      Paint()
        ..color = _cyan.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );

    // Chest Sci-Fi Panel
    final chestRect = Rect.fromLTWH(cx - 15, torsoTop + 9, 30, 22);
    canvas.drawRRect(
      RRect.fromRectAndRadius(chestRect, const Radius.circular(5)),
      Paint()..color = _dark,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(chestRect, const Radius.circular(5)),
      Paint()
        ..color = _cyan.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );

    // Dynamic 5-bar Audio Spectrum Analyzer / Equalizer inside chest
    for (int bar = 0; bar < 5; bar++) {
      final barH = 4 + 11 * (0.5 + 0.5 * math.sin(t * math.pi * 5 + bar * 1.3));
      final bx = cx - 11 + bar * 5.2;
      final by = torsoTop + 26;
      canvas.drawLine(
        Offset(bx, by),
        Offset(bx, by - barH),
        Paint()
          ..color = bar.isEven ? _cyan : _pink
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round,
      );
    }

    // Status LEDs
    for (int d = 0; d < 3; d++) {
      final ledA = 0.4 + 0.6 * math.sin(t * math.pi * 4 + d * 1.5);
      canvas.drawCircle(
        Offset(cx - 9 + d * 9.0, torsoTop + 38),
        2.5,
        Paint()
          ..color = [_cyan, _yellow, _pink][d].withValues(alpha: ledA)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, ledA * 2),
      );
    }

    // ── 4. Arms & Gestures ────────────────────────────────────────────────
    final inwardSide = faceRight ? 1.0 : -1.0;

    for (final side in [-1.0, 1.0]) {
      final isInwardArm = (side == inwardSide) && bubbleVisible;
      final ax = cx + side * 24;

      canvas.save();

      if (isInwardArm) {
        // Raise & wave arm towards bubble
        final waveAngle = -1.0 + armWave * 0.3;
        canvas.translate(ax, torsoTop + 6);
        canvas.rotate(waveAngle);
        canvas.translate(-ax, -(torsoTop + 6));
      } else {
        // Subtle natural body counter-balance sway
        final swayAngle = math.sin(t * math.pi * 2) * 0.08 * side;
        canvas.translate(ax, torsoTop + 6);
        canvas.rotate(swayAngle);
        canvas.translate(-ax, -(torsoTop + 6));
      }

      final armRect = Rect.fromLTWH(ax - 7, torsoTop + 5, 14, 38);
      canvas.drawRRect(
        RRect.fromRectAndRadius(armRect, const Radius.circular(6)),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bodyHL, _bodyColor],
          ).createShader(armRect),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(armRect, const Radius.circular(6)),
        Paint()
          ..color = _cyan.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.9,
      );

      // Hand / Claw
      final handCY = torsoTop + 5 + 38 + 7;
      canvas.drawCircle(
        Offset(ax, handCY),
        7,
        Paint()..color = _jointColor,
      );
      canvas.drawCircle(
        Offset(ax, handCY),
        7,
        Paint()
          ..color = _cyan.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
      // Glowing hand core
      canvas.drawCircle(
        Offset(ax, handCY),
        2.5,
        Paint()..color = _cyan.withValues(alpha: 0.6 + ledPulseFast * 0.4),
      );

      canvas.restore();
    }

    // ── 5. Neck ───────────────────────────────────────────────────────────
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 9, neckTop, 18, neckBot - neckTop),
        const Radius.circular(4),
      ),
      Paint()..color = _bodyColor,
    );
    canvas.drawLine(
      Offset(cx - 7, neckTop + 6),
      Offset(cx + 7, neckTop + 6),
      Paint()
        ..color = _cyan.withValues(alpha: 0.3)
        ..strokeWidth = 1.2,
    );

    // ── 6. Head & Helmet Visor ────────────────────────────────────────────
    final headCenter = Offset(cx, headCY);
    final headRect = Rect.fromCircle(center: headCenter, radius: headR);

    // Head base sphere with radial shader
    canvas.drawCircle(
      headCenter,
      headR,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.45),
          radius: 1.0,
          colors: [_bodyHL, _bodyColor, _dark],
        ).createShader(headRect),
    );

    // Outer glowing rim
    canvas.drawCircle(
      headCenter,
      headR,
      Paint()
        ..color = _cyan.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );

    // Visor Glass
    final visorRect = Rect.fromLTWH(cx - 20, headCY - 12, 40, 24);
    canvas.drawRRect(
      RRect.fromRectAndRadius(visorRect, const Radius.circular(10)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0E2843),
            const Color(0xFF05111E),
          ],
        ).createShader(visorRect),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(visorRect, const Radius.circular(10)),
      Paint()
        ..color = _cyan.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Visor subtle scanlines
    for (double sy = visorRect.top + 3; sy < visorRect.bottom - 2; sy += 4) {
      canvas.drawLine(
        Offset(visorRect.left + 3, sy),
        Offset(visorRect.right - 3, sy),
        Paint()
          ..color = _cyan.withValues(alpha: 0.08)
          ..strokeWidth = 1,
      );
    }

    // ── 7. Eyes & Expressive Eye Tracking ─────────────────────────────────
    if (!isBlinking) {
      for (final side in [-1.0, 1.0]) {
        final ex = cx + side * 8.0;
        const ey = headCY - 1;

        // Eye socket glow
        canvas.drawCircle(Offset(ex, ey), 6.5, Paint()..color = _dark);

        final irisCenter = Offset(ex + eyeNX * 0.55, ey + eyeNY * 0.55);

        // Cyan/Pink Dual Iris Shader
        canvas.drawCircle(
          irisCenter,
          4.5,
          Paint()
            ..shader = RadialGradient(
              colors: [_cyan, const Color(0xFF007A6B)],
            ).createShader(Rect.fromCircle(center: irisCenter, radius: 4.5)),
        );

        // Pupil
        canvas.drawCircle(
          Offset(ex + eyeNX, ey + eyeNY),
          2.2,
          Paint()..color = Colors.black,
        );

        // Glint / Catchlight
        canvas.drawCircle(
          Offset(ex + eyeNX - 1.4, ey + eyeNY - 1.4),
          1.1,
          Paint()..color = Colors.white,
        );

        // Eye ring pulse
        canvas.drawCircle(
          Offset(ex, ey),
          6.5,
          Paint()
            ..color = _cyan.withValues(alpha: 0.2 + glowPulse * 0.15)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
    } else {
      // Expression blink lines (curved happy blink)
      for (final side in [-1.0, 1.0]) {
        final blinkPath = Path()
          ..moveTo(cx + side * 14, headCY - 1)
          ..quadraticBezierTo(
              cx + side * 8, headCY - 4, cx + side * 2, headCY - 1);
        canvas.drawPath(
          blinkPath,
          Paint()
            ..color = _cyan
            ..strokeWidth = 2.4
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // Smiling LED Mouth
    final mouthPath = Path()
      ..moveTo(cx - 7, headCY + 11)
      ..quadraticBezierTo(cx, headCY + 15, cx + 7, headCY + 11);
    canvas.drawPath(
      mouthPath,
      Paint()
        ..color = _cyan.withValues(alpha: 0.75)
        ..strokeWidth = 1.6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Ear Bolts / Side Sensors
    for (final side in [-1.0, 1.0]) {
      final ex = cx + side * headR;
      canvas.drawCircle(Offset(ex, headCY), 5.5, Paint()..color = _jointColor);
      canvas.drawCircle(
        Offset(ex, headCY),
        5.5,
        Paint()
          ..color = _cyan.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      canvas.drawCircle(
        Offset(ex, headCY),
        2.5,
        Paint()..color = _pink.withValues(alpha: 0.6 + ledPulseFast * 0.4),
      );
    }

    // ── 8. Antenna & RF Broadcast Signal Waves ─────────────────────────────
    final antennaBase = Offset(cx, headCY - headR + 2);
    final antennaTip = Offset(cx + antennaWave * 0.5, antennaTipY + 4);

    canvas.drawLine(
      antennaBase,
      antennaTip,
      Paint()
        ..color = _cyan.withValues(alpha: 0.75)
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );

    // Expanding Radio Signal Waves radiating from antenna tip
    final ringRadius = (pulseT * 18.0) % 18.0;
    final ringAlpha = (1.0 - (ringRadius / 18.0)).clamp(0.0, 1.0);
    canvas.drawCircle(
      antennaTip,
      ringRadius,
      Paint()
        ..color = _cyan.withValues(alpha: ringAlpha * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Tip Light Glow
    canvas.drawCircle(
      antennaTip,
      6 + ledPulseFast * 2,
      Paint()
        ..color = _pink.withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(antennaTip, 3.5, Paint()..color = _pink);
    canvas.drawCircle(
      antennaTip,
      1.8,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(_RobotBodyPainter old) => true;
}
