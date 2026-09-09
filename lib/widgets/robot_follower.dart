import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';

// ─────────────────────────── Section info map ────────────────────────────────

const _sectionInfo = {
  'Dev': (
    icon: '🧑‍💻',
    title: 'Dev Avatar',
    desc: 'Move mouse around!\nThe avatar eyes follow you.',
  ),
  'App': (
    icon: '🚀',
    title: 'Hello!',
    desc: "I'm Amal — Flutter dev\nbuilding beautiful apps.",
  ),
  'About': (
    icon: '👤',
    title: 'About Me',
    desc: 'BCA grad · 6m intern\n+ 1y 3m Flutter experience.',
  ),
  'Skills': (
    icon: '⚡',
    title: 'Skills',
    desc: 'Flutter · Dart · Firebase\nREST APIs · Clean Code.',
  ),
  'Work': (
    icon: '💼',
    title: 'Experience',
    desc: 'Internship + full-time\nshipping production apps.',
  ),
  'Projects': (
    icon: '📦',
    title: 'Projects',
    desc: 'Real apps with AI, maps,\nsensors & speech!',
  ),
  'Contact': (
    icon: '📬',
    title: 'Contact',
    desc: "Let's build something\namazing together!",
  ),
  'Project': (
    icon: '🔍',
    title: 'Project Detail',
    desc: 'Exploring this project.\nSwipe through screenshots!',
  ),
};

// ─────────────────────────── Overlay widget ──────────────────────────────────

/// Global section-aware robot guide with intro placement & smooth 2D glide.
class RobotFollowerOverlay extends StatefulWidget {
  final Widget child;
  final List<GlobalKey> sectionKeys;
  final List<String> sectionNames;
  final bool showOnRight;
  final bool autoStart;

  const RobotFollowerOverlay({
    super.key,
    required this.child,
    required this.sectionKeys,
    required this.sectionNames,
    this.showOnRight = false,
    this.autoStart = false,
  });

  @override
  State<RobotFollowerOverlay> createState() => _RobotFollowerOverlayState();
}

class _RobotFollowerOverlayState extends State<RobotFollowerOverlay>
    with TickerProviderStateMixin {
  // ── Cursor position (for eye tracking) ─────────────────────────────────────
  Offset _cursor = const Offset(400, 400);

  // ── 2D Bot position & target physics ────────────────────────────────────────
  double _botX = 400.0;
  double _botTargetX = 400.0;
  double _botY = 280.0;
  double _botTargetY = 280.0;
  double _botVelocity = 0.0;

  // ── Motion trail ────────────────────────────────────────────────────────────
  final List<double> _trail = [];

  // ── Intro state & Section guide state ──────────────────────────────────────
  late bool _hasStartedGuide;
  String _detectedSection = '';
  bool _bubbleVisible = true;
  String _bubbleSection = 'Dev';
  bool _isFirstLayout = true;

  // ── Animation Controllers ──────────────────────────────────────────────────
  late AnimationController _bubbleCtrl;
  late Animation<double> _bubbleAnim;

  // Single Master Ticker for 60fps smooth rendering
  late AnimationController _animCtrl;

  // Sparkle burst controller
  late AnimationController _sparkleCtrl;

  // Blink state
  bool _isBlinking = false;

  @override
  void initState() {
    super.initState();

    final isProjectDetails = widget.sectionNames.contains('Project');
    _hasStartedGuide = widget.autoStart || isProjectDetails;
    if (_hasStartedGuide && isProjectDetails) {
      _bubbleSection = 'Project';
      _detectedSection = 'Project';
    }

    _bubbleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _bubbleAnim =
        CurvedAnimation(parent: _bubbleCtrl, curve: Curves.easeOutBack);
    _bubbleCtrl.forward();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _sparkleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _animCtrl.addListener(_onTick);
    _scheduleBlink();
  }

  void _onTick() {
    if (!mounted) return;
    final screenW = MediaQuery.of(context).size.width;
    const botW = 74.0;

    // Side position (outside section box)
    final sideX = widget.showOnRight ? screenW - botW - 8 : 8.0;

    // Inside Dev section position (centered near Dev card inside section)
    final insideX = (screenW / 2) + (widget.showOnRight ? -200.0 : 200.0);

    // Initial setup on first frame layout
    if (_isFirstLayout) {
      _isFirstLayout = false;
      _locateDevSectionCenter();
      _botX = _hasStartedGuide ? sideX : insideX;
      _botTargetX = _hasStartedGuide ? sideX : insideX;
    } else {
      _botTargetX = _hasStartedGuide ? sideX : insideX;
    }

    final prevY = _botY;
    final prevX = _botX;

    final diffY = _botTargetY - _botY;
    final diffX = _botTargetX - _botX;

    if (diffY.abs() > 0.05 || diffX.abs() > 0.05) {
      setState(() {
        _botY += diffY * 0.08;
        _botX += diffX * 0.08;
        _botVelocity = _botY - prevY;

        if (_botVelocity.abs() > 0.2 || (_botX - prevX).abs() > 0.2) {
          _trail.add(_botY);
          if (_trail.length > 6) _trail.removeAt(0);
        } else if (_trail.isNotEmpty) {
          _trail.removeAt(0);
        }
      });
    } else if (_botVelocity != 0.0 || _trail.isNotEmpty) {
      setState(() {
        _botVelocity = 0.0;
        if (_trail.isNotEmpty) _trail.removeAt(0);
      });
    }
  }

  void _locateDevSectionCenter() {
    if (widget.sectionKeys.isNotEmpty) {
      final box = widget.sectionKeys.first.currentContext
          ?.findRenderObject() as RenderBox?;
      if (box != null) {
        final sTop = box.localToGlobal(Offset.zero).dy;
        _botTargetY = sTop + box.size.height / 2;
        _botY = _botTargetY;
      }
    }
  }

  void _scheduleBlink() async {
    await Future.delayed(
        Duration(milliseconds: 2200 + math.Random().nextInt(2500)));
    if (!mounted) return;
    setState(() => _isBlinking = true);
    await Future.delayed(const Duration(milliseconds: 110));
    if (!mounted) return;
    setState(() => _isBlinking = false);
    _scheduleBlink();
  }

  void _startGuide() {
    setState(() {
      _hasStartedGuide = true;
    });
    _sparkleCtrl.forward(from: 0);
    _detectSection(_cursor.dy);
  }

  void _onMouseMove(PointerEvent e) {
    _cursor = e.position;
    if (_hasStartedGuide) {
      _detectSection(e.position.dy);
    }
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
      _sparkleCtrl.forward(from: 0);
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
    _animCtrl.dispose();
    _sparkleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final isMobile = screenW < 700;

    const botW = 74.0;
    const botH = 160.0;

    // Eye direction tracking
    final contentCX = screenW / 2;
    final eyeRelX = (contentCX - _botX - botW / 2).clamp(-40.0, 40.0);
    final eyeNX = (eyeRelX / 40.0) * 4.0;
    final eyeRelY = (_cursor.dy - _botY).clamp(-30.0, 30.0);
    final eyeNY = (eyeRelY / 30.0) * 2.5;

    final showBot = !isMobile;
    final bubbleOnRight = _botX < (screenW / 2);

    // Intro vs Normal section info
    final String bubbleIcon;
    final String bubbleTitle;
    final String bubbleDesc;
    final String? actionLabel;
    final VoidCallback? onActionTap;

    if (!_hasStartedGuide) {
      bubbleIcon = '🤖';
      bubbleTitle = 'PERSONAL ASSISTANT';
      bubbleDesc = "Hi! I'm your AI Guide.\nTap below to start the tour!";
      actionLabel = 'START GUIDE ➔';
      onActionTap = _startGuide;
    } else {
      final info = _sectionInfo[_bubbleSection];
      bubbleIcon = info?.icon ?? '🤖';
      bubbleTitle = info?.title ?? '';
      bubbleDesc = info?.desc ?? '';
      actionLabel = null;
      onActionTap = null;
    }

    return MouseRegion(
      onHover: _onMouseMove,
      child: Listener(
        onPointerMove: _onMouseMove,
        child: Stack(
          children: [
            widget.child,

            // ── Motion trail ──────────────────────────────────────────────
            if (showBot && _hasStartedGuide)
              for (int i = 0; i < _trail.length; i++)
                Positioned(
                  left: _botX,
                  top: _trail[i] - botH / 2,
                  width: botW,
                  height: botH,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: (i + 1) / (_trail.length + 1) * 0.16,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: RadialGradient(
                            colors: [
                              AppColors.cyan.withValues(alpha: 0.55),
                              AppColors.cyan.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

            // ── Full-body robot ───────────────────────────────────────────
            if (showBot)
              Positioned(
                left: _botX,
                top: _botY - botH / 2,
                width: botW,
                height: botH,
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _animCtrl,
                    builder: (context, _) {
                      final t = _animCtrl.value;
                      final bob = math.sin(t * math.pi * 4) * 4.5;
                      final antennaWave = math.sin(t * math.pi * 8) * 7.0;
                      final armWave = 0.5 + 0.5 * math.sin(t * math.pi * 6);
                      final mouthTalk = _bubbleVisible
                          ? (0.5 + 0.5 * math.sin(t * math.pi * 14))
                          : 0.0;
                      final lean = (_botVelocity * 0.06).clamp(-0.16, 0.16);

                      return Transform.translate(
                        offset: Offset(0, bob),
                        child: RepaintBoundary(
                          child: CustomPaint(
                            painter: _RobotBodyPainter(
                              eyeNX: eyeNX,
                              eyeNY: eyeNY,
                              isBlinking: _isBlinking,
                              antennaWave: antennaWave,
                              armWave: armWave,
                              t: t,
                              bubbleVisible: _bubbleVisible,
                              faceRight: bubbleOnRight,
                              mouthTalk: mouthTalk,
                              lean: lean,
                              orbitT: (t * 2) % 1.0,
                              sparkleT: _sparkleCtrl.value,
                              hueT: t,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // ── Speech bubble ─────────────────────────────────────────────
            if (showBot && _bubbleVisible)
              Positioned(
                left: bubbleOnRight ? _botX + botW + 6 : null,
                right: bubbleOnRight ? null : screenW - _botX + 6,
                top: _botY - 60,
                child: AnimatedBuilder(
                  animation: _bubbleAnim,
                  builder: (context, _) => Transform.scale(
                    scale: _bubbleAnim.value.clamp(0.0, 1.2),
                    alignment: bubbleOnRight
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: _SpeechBubble(
                      icon: bubbleIcon,
                      title: bubbleTitle,
                      desc: bubbleDesc,
                      actionLabel: actionLabel,
                      onActionTap: onActionTap,
                      tailOnLeft: bubbleOnRight,
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

// ─────────────────────────── Speech bubble ───────────────────────────────────

class _SpeechBubble extends StatefulWidget {
  final String icon, title, desc;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final bool tailOnLeft;

  const _SpeechBubble({
    required this.icon,
    required this.title,
    required this.desc,
    this.actionLabel,
    this.onActionTap,
    required this.tailOnLeft,
  });

  @override
  State<_SpeechBubble> createState() => _SpeechBubbleState();
}

class _SpeechBubbleState extends State<_SpeechBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (context, _) {
        final glow = 0.18 + 0.12 * math.sin(_shimmerCtrl.value * math.pi * 2);
        return Container(
          width: 180,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          decoration: BoxDecoration(
            color: const Color(0xFF071120).withValues(alpha: 0.97),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.cyan.withValues(alpha: 0.6),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: glow),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.85, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) =>
                        Transform.scale(scale: scale, child: child),
                    child: Text(widget.icon,
                        style: const TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.cyan,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                widget.desc,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              if (widget.actionLabel != null && widget.onActionTap != null) ...[
                const SizedBox(height: 10),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: widget.onActionTap,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.cyan.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.cyan,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.actionLabel!,
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.cyan,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────── Full-body robot painter ─────────────────────────

class _RobotBodyPainter extends CustomPainter {
  final double eyeNX, eyeNY, antennaWave, armWave, t;
  final bool isBlinking, bubbleVisible, faceRight;
  final double mouthTalk;
  final double lean;
  final double orbitT;
  final double sparkleT;
  final double hueT;

  const _RobotBodyPainter({
    required this.eyeNX,
    required this.eyeNY,
    required this.isBlinking,
    required this.antennaWave,
    required this.armWave,
    required this.t,
    required this.bubbleVisible,
    required this.faceRight,
    this.mouthTalk = 0.0,
    this.lean = 0.0,
    this.orbitT = 0.0,
    this.sparkleT = 0.0,
    this.hueT = 0.0,
  });

  static const _cyan = Color(0xFF00F5D4);
  static const _pink = Color(0xFFFF2D78);
  static const _yellow = Color(0xFFFFD166);
  static const _dark = Color(0xFF07111F);
  static const _bodyColor = Color(0xFF0D1E30);
  static const _bodyHL = Color(0xFF152840);
  static const _jointColor = Color(0xFF162035);
  static const _footColor = Color(0xFF0A1827);

  Color _driftColor(double hue) {
    final hsl = HSLColor.fromColor(_cyan).withHue(180 + hue * 180);
    return hsl.toColor();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final ambient = _driftColor(math.sin(hueT * math.pi * 2) * 0.5 + 0.5);

    const antennaTipY = 4.0;
    const headCY = 50.0;
    const headR = 26.0;
    const neckTop = headCY + headR - 4;
    const neckBot = neckTop + 14;
    const torsoTop = neckBot - 2;
    const torsoBot = torsoTop + 46;
    const legTop = torsoBot - 2;
    const legBot = legTop + 36;
    const footY = legBot;

    final glowPulse = 0.5 + 0.5 * math.sin(t * math.pi * 2);
    final ballPulse = 0.5 + 0.5 * math.sin(t * math.pi * 4);

    canvas.save();
    canvas.translate(cx, footY);
    canvas.rotate(lean);
    canvas.translate(-cx, -footY);

    // Outer glow
    canvas.drawCircle(
      Offset(cx, headCY),
      headR + 8 + glowPulse * 4,
      Paint()
        ..color = ambient.withValues(alpha: 0.1 + glowPulse * 0.05)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );

    // Orbiting motes
    for (int i = 0; i < 3; i++) {
      final phase = orbitT * math.pi * 2 + i * (math.pi * 2 / 3);
      final radius = headR + 14 + i * 3;
      final mx = cx + math.cos(phase) * radius;
      final my = headCY + math.sin(phase) * radius * 0.55;
      final moteColor = [_cyan, _pink, _yellow][i % 3];
      canvas.drawCircle(
        Offset(mx, my),
        2.2,
        Paint()..color = moteColor.withValues(alpha: 0.75),
      );
    }

    // Sparkle burst
    if (sparkleT > 0 && sparkleT < 1) {
      final burstAlpha = (1 - sparkleT).clamp(0.0, 1.0);
      final burstRadius = headR + sparkleT * 46;
      canvas.drawCircle(
        Offset(cx, headCY),
        burstRadius,
        Paint()
          ..color = _cyan.withValues(alpha: burstAlpha * 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      const sparkCount = 8;
      for (int i = 0; i < sparkCount; i++) {
        final ang = (i / sparkCount) * math.pi * 2;
        final dist = headR + 6 + sparkleT * 40;
        final sx = cx + math.cos(ang) * dist;
        final sy = headCY + math.sin(ang) * dist;
        canvas.drawCircle(
          Offset(sx, sy),
          2.0 * burstAlpha + 0.4,
          Paint()..color = _yellow.withValues(alpha: burstAlpha),
        );
      }
    }

    // Legs
    for (final side in [-1.0, 1.0]) {
      final lx = cx + side * 11;
      final legRect = Rect.fromLTWH(lx - 8, legTop, 16, legBot - legTop);
      canvas.drawRRect(
        RRect.fromRectAndRadius(legRect, const Radius.circular(6)),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bodyColor, _dark],
          ).createShader(legRect),
      );
      canvas.drawCircle(
        Offset(lx, legTop + (legBot - legTop) * 0.42),
        5,
        Paint()..color = _jointColor,
      );
      canvas.drawCircle(
        Offset(lx, legTop + (legBot - legTop) * 0.42),
        5,
        Paint()
          ..color = _cyan.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(lx + side * 3, footY + 5),
          width: 20,
          height: 10,
        ),
        Paint()..color = _footColor,
      );
    }

    // Torso
    final torsoRect = Rect.fromLTWH(cx - 22, torsoTop, 44, torsoBot - torsoTop);
    canvas.drawRRect(
      RRect.fromRectAndRadius(torsoRect, const Radius.circular(9)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_bodyHL, _bodyColor],
        ).createShader(torsoRect),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(torsoRect, const Radius.circular(9)),
      Paint()
        ..color = ambient.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    final chestRect = Rect.fromLTWH(cx - 13, torsoTop + 8, 26, 18);
    canvas.drawRRect(
      RRect.fromRectAndRadius(chestRect, const Radius.circular(4)),
      Paint()..color = _dark,
    );
    for (int d = 0; d < 3; d++) {
      final ledPulse = 0.4 + 0.6 * math.sin(t * math.pi * 4 + d * 1.2);
      canvas.drawCircle(
        Offset(cx - 8 + d * 8.0, torsoTop + 17),
        2.5,
        Paint()..color = [_cyan, _pink, _yellow][d].withValues(alpha: ledPulse),
      );
    }

    // Arms
    final rightSide = faceRight ? 1.0 : -1.0;
    for (final side in [-1.0, 1.0]) {
      final isInwardArm = (side == rightSide) && bubbleVisible;
      final ax = cx + side * 22;

      canvas.save();
      if (isInwardArm) {
        final raiseAngle = -0.9 + armWave * 0.25;
        canvas.translate(ax, torsoTop + 6);
        canvas.rotate(raiseAngle);
        canvas.translate(-ax, -(torsoTop + 6));
      }

      final armRect = Rect.fromLTWH(ax - 7, torsoTop + 4, 14, 36);
      canvas.drawRRect(
        RRect.fromRectAndRadius(armRect, const Radius.circular(6)),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bodyHL, _bodyColor],
          ).createShader(armRect),
      );
      canvas.drawCircle(
        Offset(ax, torsoTop + 4 + 36 + 7),
        7,
        Paint()..color = _jointColor,
      );
      canvas.restore();
    }

    // Neck
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 8, neckTop, 16, neckBot - neckTop),
        const Radius.circular(4),
      ),
      Paint()..color = _bodyColor,
    );

    // Head
    final headRect = Rect.fromCircle(
      center: Offset(cx, headCY),
      radius: headR,
    );
    canvas.drawCircle(
      Offset(cx, headCY),
      headR,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.45),
          radius: 1.0,
          colors: [_bodyHL, _bodyColor],
        ).createShader(headRect),
    );
    canvas.drawCircle(
      Offset(cx, headCY),
      headR,
      Paint()
        ..color = ambient.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Visor
    final visorRect = Rect.fromLTWH(cx - 18, headCY - 11, 36, 22);
    canvas.drawRRect(
      RRect.fromRectAndRadius(visorRect, const Radius.circular(9)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0D2137),
            const Color(0xFF06111E),
          ],
        ).createShader(visorRect),
    );

    // Eyes
    if (!isBlinking) {
      for (final side in [-1.0, 1.0]) {
        final ex = cx + side * 7;
        const ey = headCY;
        canvas.drawCircle(Offset(ex, ey), 6, Paint()..color = _dark);
        final irisCenter = Offset(ex + eyeNX * 0.5, ey + eyeNY * 0.5);
        canvas.drawCircle(
          irisCenter,
          4,
          Paint()
            ..shader = RadialGradient(
              colors: [_cyan, const Color(0xFF008A76)],
            ).createShader(
              Rect.fromCircle(center: irisCenter, radius: 4),
            ),
        );
        canvas.drawCircle(
          Offset(ex + eyeNX, ey + eyeNY),
          2.0,
          Paint()..color = Colors.black,
        );
        canvas.drawCircle(
          Offset(ex + eyeNX - 1.2, ey + eyeNY - 1.2),
          0.9,
          Paint()..color = Colors.white,
        );
      }
    } else {
      for (final side in [-1.0, 1.0]) {
        canvas.drawLine(
          Offset(cx + side * 13, headCY),
          Offset(cx + side * 2, headCY),
          Paint()
            ..color = _cyan.withValues(alpha: 0.8)
            ..strokeWidth = 2.2
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // Mouth
    final mouthOpen = 3 + mouthTalk * 5;
    if (bubbleVisible) {
      final mouthRect = Rect.fromCenter(
        center: Offset(cx, headCY + 12),
        width: 12,
        height: mouthOpen,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(mouthRect, const Radius.circular(3)),
        Paint()..color = _dark,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(mouthRect, const Radius.circular(3)),
        Paint()
          ..color = _cyan.withValues(alpha: 0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    } else {
      final mouthPath = Path()
        ..moveTo(cx - 6, headCY + 11)
        ..quadraticBezierTo(cx, headCY + 14, cx + 6, headCY + 11);
      canvas.drawPath(
        mouthPath,
        Paint()
          ..color = _cyan.withValues(alpha: 0.6)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    // Ear Bolts
    for (final side in [-1.0, 1.0]) {
      final ex = cx + side * headR;
      canvas.drawCircle(Offset(ex, headCY), 5, Paint()..color = _jointColor);
      canvas.drawCircle(
        Offset(ex, headCY),
        2.5,
        Paint()..color = _cyan.withValues(alpha: 0.5 + ballPulse * 0.4),
      );
    }

    // Antenna
    final antennaBase = Offset(cx, headCY - headR + 2);
    final antennaTip = Offset(cx + antennaWave * 0.4, antennaTipY + 4);
    canvas.drawLine(
      antennaBase,
      antennaTip,
      Paint()
        ..color = _cyan.withValues(alpha: 0.65)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      antennaTip,
      5 + ballPulse * 2,
      Paint()
        ..color = _pink.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawCircle(antennaTip, 3, Paint()..color = _pink);

    // Thruster glow
    final thrusterBoost = (lean.abs() * 4).clamp(0.0, 0.25);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, footY + 10),
        width: 40 + thrusterBoost * 20,
        height: 8 + thrusterBoost * 6,
      ),
      Paint()
        ..color = ambient.withValues(alpha: 0.15 + glowPulse * 0.1 + thrusterBoost)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_RobotBodyPainter old) => true;
}