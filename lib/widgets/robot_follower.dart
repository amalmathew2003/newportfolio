import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────── Dark Cyber Bot Palette (v2) ──────────────────────
// Deep navy armor plating, glassy holographic visor, and glowing multi-hue
// energy accents (cyan / pink / violet / amber) with an animated aurora core.

const _cyan = Color(0xFF00F5D4);
const _cyanDeep = Color(0xFF00B8A0);
const _pink = Color(0xFFFF2D78);
const _violet = Color(0xFF9B6BFF);
const _yellow = Color(0xFFFFD166);

const _dark = Color(0xFF060D18);
const _bodyColor = Color(0xFF0C1B2E);
const _bodyHL = Color(0xFF1B3352);
const _bodyHL2 = Color(0xFF25436A);
const _jointColor = Color(0xFF13233A);
const _footColor = Color(0xFF081422);
const _visorDeep = Color(0xFF04101C);
const _visorHL = Color(0xFF12314F);

// ─────────────────────────── Section info map ────────────────────────────────

const _sectionInfo = {
  'Dev': (
    icon: '🧑‍💻',
    title: 'Dev Avatar',
    desc: 'Interactive dev character.\nEye-tracking active!',
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

/// Ultra-smooth, spring-physics-driven, section-aware dark cyber bot guide.
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
  // ── Cursor position ────────────────────────────────────────────────────────
  Offset _cursor = const Offset(400, 400);

  // ── Bot 2D Position driven via ValueNotifier (Zero-setState lag!) ─────────
  late final ValueNotifier<Offset> _botPosNotifier =
      ValueNotifier(const Offset(400, 280));

  double _botTargetX = 400.0;
  double _botTargetY = 280.0;
  double _botVelocityY = 0.0;
  double _botVelocityX = 0.0;

  // Motion trail (afterimage ghosts) for a lively "attractive" glide feel.
  final List<Offset> _trail = [];

  // ── State flags ─────────────────────────────────────────────────────────────
  late bool _hasStartedGuide;
  String _detectedSection = '';
  bool _bubbleVisible = true;
  String _bubbleSection = 'Dev';
  bool _isFirstLayout = true;
  bool _isBlinking = false;

  // Frame-rate independent spring physics timing.
  final Stopwatch _clock = Stopwatch()..start();
  Duration _lastElapsed = Duration.zero;

  // ── Animation Controllers ──────────────────────────────────────────────────
  late final AnimationController _bubbleCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );
  late final Animation<double> _bubbleAnim =
      CurvedAnimation(parent: _bubbleCtrl, curve: Curves.easeOutBack);

  late final AnimationController _sparkleCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 750),
  );

  // Plays once on first guide start — a friendly greeting wave.
  late final AnimationController _greetCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  // Single continuous master ticker for smooth vector painting
  late final AnimationController _animCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  @override
  void initState() {
    super.initState();

    final isProjectDetails = widget.sectionNames.contains('Project');
    _hasStartedGuide = widget.autoStart || isProjectDetails;
    if (_hasStartedGuide && isProjectDetails) {
      _bubbleSection = 'Project';
      _detectedSection = 'Project';
    }

    _bubbleCtrl.forward();
    if (_hasStartedGuide) _greetCtrl.forward();
    _animCtrl.addListener(_onPhysicsTick);
    _scheduleBlink();
  }

  bool _isRenderBoxReady(RenderBox? box) {
    return box != null && box.attached && box.hasSize && !box.debugNeedsLayout;
  }

  void _onPhysicsTick() {
    if (!mounted) return;
    final screenW = MediaQuery.of(context).size.width;
    const botW = 74.0;

    final sideX = widget.showOnRight ? screenW - botW - 8 : 8.0;
    final insideX = (screenW / 2) + (widget.showOnRight ? -200.0 : 200.0);

    if (_isFirstLayout) {
      _locateDevSectionCenter();
      final box = widget.sectionKeys.isNotEmpty
          ? widget.sectionKeys.first.currentContext?.findRenderObject() as RenderBox?
          : null;
      if (_isRenderBoxReady(box)) {
        _isFirstLayout = false;
        final initX = _hasStartedGuide ? sideX : insideX;
        _botTargetX = initX;
        _botPosNotifier.value = Offset(initX, _botTargetY);
        _lastElapsed = _clock.elapsed;
        return;
      }
    } else {
      _botTargetX = _hasStartedGuide ? sideX : insideX;
    }

    // ── Continuously re-detect active section & update target Y every tick ───
    // Re-evaluates section RenderBoxes on every frame tick so the bot smoothly
    // follows scrolling, expanding panels (e.g. HotReloadDemo), and dynamic content
    // without needing mouse pointer movement.
    _detectSection(_cursor.dy);

    // ── Real, frame-rate independent dt for a buttery-smooth critically
    // damped spring — gives the bot a light, elastic, "alive" glide instead
    // of a flat linear-lerp follow.
    final now = _clock.elapsed;
    var dt = (now - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = now;
    if (dt <= 0 || dt > 0.05) dt = 1 / 60;

    const stiffness = 170.0;
    const damping = 19.0;

    final currPos = _botPosNotifier.value;

    final accX = (_botTargetX - currPos.dx) * stiffness - _botVelocityX * damping;
    final accY = (_botTargetY - currPos.dy) * stiffness - _botVelocityY * damping;

    _botVelocityX += accX * dt;
    _botVelocityY += accY * dt;

    var newX = currPos.dx + _botVelocityX * dt;
    var newY = currPos.dy + _botVelocityY * dt;

    if ((_botTargetX - newX).abs() < 0.5 &&
        (_botTargetY - newY).abs() < 0.5 &&
        _botVelocityX.abs() < 1.0 &&
        _botVelocityY.abs() < 1.0) {
      _botVelocityX = 0;
      _botVelocityY = 0;
      newX = _botTargetX;
      newY = _botTargetY;
    }

    // Track a short afterimage trail while moving with real speed.
    final speed = math.sqrt(_botVelocityX * _botVelocityX + _botVelocityY * _botVelocityY);
    if (speed > 40) {
      _trail.add(Offset(newX, newY));
      if (_trail.length > 5) _trail.removeAt(0);
    } else if (_trail.isNotEmpty) {
      _trail.removeAt(0);
    }

    _botPosNotifier.value = Offset(newX, newY);
  }

  void _locateDevSectionCenter() {
    if (widget.sectionKeys.isNotEmpty) {
      final box = widget.sectionKeys.first.currentContext
          ?.findRenderObject() as RenderBox?;
      if (_isRenderBoxReady(box)) {
        final sTop = box!.localToGlobal(Offset.zero).dy;
        _botTargetY = sTop + box.size.height / 2;
      }
    }
  }

  void _scheduleBlink() async {
    await Future.delayed(
        Duration(milliseconds: 2400 + math.Random().nextInt(2400)));
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
    _greetCtrl.forward(from: 0);
    _detectSection(_cursor.dy);
    _updateBubble(
        _detectedSection.isNotEmpty ? _detectedSection : (widget.sectionNames.isNotEmpty ? widget.sectionNames.first : 'Dev'));
  }

  void _onMouseMove(PointerEvent e) {
    _cursor = e.position;
    if (_hasStartedGuide) {
      _detectSection(e.position.dy);
    }
  }

  void _detectSection(double cursorY) {
    if (widget.sectionKeys.isEmpty) return;

    // The user requested that the bot "don't move still stant the dev section".
    // This means the bot should permanently lock to the Dev section (index 0)
    // and naturally scroll off the screen when the user scrolls down,
    // rather than following them or jumping between sections.
    final devBox = widget.sectionKeys[0].currentContext?.findRenderObject() as RenderBox?;
    if (!_isRenderBoxReady(devBox)) return;

    final sTop = devBox!.localToGlobal(Offset.zero).dy;
    
    // Anchor purely to the Dev section's top + 100px.
    // No clamping to viewport! This ensures it scrolls completely off the top of the screen naturally.
    final anchorY = sTop + 100.0;

    if (_detectedSection != 'Dev') {
      _detectedSection = 'Dev';
      _botTargetY = anchorY;
      _updateBubble('Dev');
    } else {
      if ((_botTargetY - anchorY).abs() > 2.0) {
        _botTargetY = anchorY;
      }
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
    _botPosNotifier.dispose();
    _bubbleCtrl.dispose();
    _sparkleCtrl.dispose();
    _greetCtrl.dispose();
    _animCtrl.dispose();
    _clock.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final isMobile = screenW < 700;

    const botW = 74.0;
    const botH = 160.0;

    final showBot = !isMobile;

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
        // NotificationListener ensures scroll events (trackpad, keyboard,
        // programmatic) also re-run section detection without needing a
        // pointer-move event.
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (_hasStartedGuide) {
              _detectSection(_cursor.dy);
            }
            return false; // let the notification bubble up
          },
          child: Stack(
            children: [
              widget.child,

            // ── Dark Cyber Bot (ValueNotifier driven: Zero setState rebuilds!) ──
            if (showBot)
              ValueListenableBuilder<Offset>(
                valueListenable: _botPosNotifier,
                builder: (context, pos, _) {
                  final bubbleOnRight = pos.dx < (screenW / 2);
                  final contentCX = screenW / 2;
                  final eyeRelX = (contentCX - pos.dx - botW / 2).clamp(-40.0, 40.0);
                  final eyeNX = (eyeRelX / 40.0) * 4.0;
                  final eyeRelY = (_cursor.dy - pos.dy).clamp(-30.0, 30.0);
                  final eyeNY = (eyeRelY / 30.0) * 2.5;

                  final speed = math.sqrt(
                      _botVelocityX * _botVelocityX + _botVelocityY * _botVelocityY);

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Afterimage motion trail — subtle, only visible while gliding fast.
                      if (speed > 40)
                        for (int i = 0; i < _trail.length; i++)
                          Positioned(
                            left: _trail[i].dx,
                            top: _trail[i].dy - botH / 2,
                            width: botW,
                            height: botH,
                            child: IgnorePointer(
                              child: Opacity(
                                opacity: (0.06 * (i + 1) / _trail.length)
                                    .clamp(0.0, 0.18),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        _cyan.withValues(alpha: 0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                      // Robot Suit
                      Positioned(
                        left: pos.dx,
                        top: pos.dy - botH / 2,
                        width: botW,
                        height: botH,
                        child: IgnorePointer(
                          child: AnimatedBuilder(
                            animation: Listenable.merge(
                                [_animCtrl, _sparkleCtrl, _greetCtrl]),
                            builder: (context, _) {
                              final t = _animCtrl.value;
                              final bob = math.sin(t * math.pi * 4) * 4.5;
                              final antennaWave = math.sin(t * math.pi * 8) * 7.0;
                              final armWave = 0.5 + 0.5 * math.sin(t * math.pi * 6);
                              final mouthTalk = _bubbleVisible
                                  ? (0.5 + 0.5 * math.sin(t * math.pi * 14))
                                  : 0.0;
                              final lean =
                                  (_botVelocityY * 0.0018 + _botVelocityX * 0.0009)
                                      .clamp(-0.22, 0.22);
                              final greetWave =
                                  math.sin(_greetCtrl.value * math.pi * 5) *
                                      (1 - _greetCtrl.value);

                              return Transform.translate(
                                offset: Offset(0, bob),
                                child: RepaintBoundary(
                                  child: CustomPaint(
                                    painter: _DarkRobotBodyPainter(
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
                                      speed: speed,
                                      greetWave: greetWave,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Speech Bubble
                      if (_bubbleVisible)
                        Positioned(
                          left: bubbleOnRight ? pos.dx + botW + 6 : null,
                          right: bubbleOnRight ? null : screenW - pos.dx + 6,
                          top: pos.dy - 64,
                          child: IgnorePointer(
                            ignoring: actionLabel == null,
                            child: AnimatedBuilder(
                              animation: _bubbleAnim,
                            builder: (context, _) {
                              final slide = (1 - _bubbleAnim.value.clamp(0.0, 1.0)) *
                                  (bubbleOnRight ? -14 : 14);
                              return Transform.translate(
                                offset: Offset(slide, 0),
                                child: Transform.scale(
                                  scale: _bubbleAnim.value.clamp(0.0, 1.15),
                                  alignment: bubbleOnRight
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Opacity(
                                    opacity: _bubbleAnim.value.clamp(0.0, 1.0),
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
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                  );
                },
              ),
          ],
        ),
        ),
      ),
    );
  }
}

// ─────────────────────────── Speech Bubble ───────────────────────────────────

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
    duration: const Duration(seconds: 3),
  )..repeat();

  bool _hovering = false;

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
        final phase = _shimmerCtrl.value * math.pi * 2;
        final glow = 0.20 + 0.14 * math.sin(phase);
        final sweep = _shimmerCtrl.value; // 0..1 traveling gradient stop

        return CustomPaint(
          painter: _BubbleTailPainter(
            onLeft: widget.tailOnLeft,
            color: _cyan.withValues(alpha: 0.55),
          ),
          child: Container(
            width: 188,
            padding: const EdgeInsets.fromLTRB(13, 11, 13, 13),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0A1626), Color(0xFF071120)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: GradientBoxBorder(
                gradient: SweepGradient(
                  startAngle: 0,
                  endAngle: math.pi * 2,
                  transform: GradientRotation(sweep * math.pi * 2),
                  colors: const [_cyan, _violet, _pink, _yellow, _cyan],
                  stops: const [0.0, 0.3, 0.55, 0.8, 1.0],
                ),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: _cyan.withValues(alpha: glow),
                  blurRadius: 22,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: _violet.withValues(alpha: glow * 0.5),
                  blurRadius: 34,
                  spreadRadius: -4,
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
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.elasticOut,
                      builder: (context, v, child) =>
                          Transform.scale(scale: v, child: child),
                      child:
                          Text(widget.icon, style: const TextStyle(fontSize: 15)),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (r) => const LinearGradient(
                          colors: [_cyan, _violet],
                        ).createShader(r),
                        child: Text(
                          widget.title,
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      _cyan.withValues(alpha: 0.5),
                      Colors.transparent,
                    ]),
                  ),
                ),
                Text(
                  widget.desc,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    height: 1.55,
                    color: Colors.white.withValues(alpha: 0.88),
                  ),
                ),
                if (widget.actionLabel != null && widget.onActionTap != null) ...[
                  const SizedBox(height: 11),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _hovering = true),
                    onExit: (_) => setState(() => _hovering = false),
                    child: GestureDetector(
                      onTap: widget.onActionTap,
                      child: AnimatedScale(
                        scale: _hovering ? 1.03 : 1.0,
                        duration: const Duration(milliseconds: 150),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _hovering
                                  ? [
                                      _cyan.withValues(alpha: 0.32),
                                      _violet.withValues(alpha: 0.28),
                                    ]
                                  : [
                                      _cyan.withValues(alpha: 0.16),
                                      _violet.withValues(alpha: 0.12),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: _cyan.withValues(alpha: _hovering ? 1 : 0.8),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _cyan.withValues(alpha: _hovering ? 0.45 : 0.28),
                                blurRadius: _hovering ? 14 : 8,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.actionLabel!,
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.9,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Small glowing triangular tail connecting the bubble to the bot.
class _BubbleTailPainter extends CustomPainter {
  final bool onLeft;
  final Color color;
  const _BubbleTailPainter({required this.onLeft, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2);
    final y = 26.0;
    final path = Path();
    if (onLeft) {
      path.moveTo(-6, y);
      path.lineTo(2, y - 6);
      path.lineTo(2, y + 6);
    } else {
      path.moveTo(size.width + 6, y);
      path.lineTo(size.width - 2, y - 6);
      path.lineTo(size.width - 2, y + 6);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BubbleTailPainter oldDelegate) =>
      oldDelegate.onLeft != onLeft || oldDelegate.color != color;
}

/// A lightweight gradient border since [Border] only accepts flat colors.
class GradientBoxBorder extends BoxBorder {
  final Gradient gradient;
  final double width;
  const GradientBoxBorder({required this.gradient, this.width = 1.0});

  @override
  BorderSide get bottom => BorderSide(width: width);
  @override
  BorderSide get top => BorderSide(width: width);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    final rrect = (borderRadius ?? BorderRadius.circular(12))
        .toRRect(rect)
        .deflate(width / 2);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    canvas.drawRRect(rrect, paint);
  }

  @override
  ShapeBorder scale(double t) => this;

  @override
  BoxBorder add(ShapeBorder other, {bool reversed = false}) =>
      super.add(other, reversed: reversed) as BoxBorder? ?? this;
}

// ─────────────────────────── Dark Cyber Robot Vector Painter ─────────────────

class _DarkRobotBodyPainter extends CustomPainter {
  final double eyeNX, eyeNY, antennaWave, armWave, t;
  final bool isBlinking, bubbleVisible, faceRight;
  final double mouthTalk;
  final double lean;
  final double orbitT;
  final double sparkleT;
  final double hueT;
  final double speed;
  final double greetWave;

  const _DarkRobotBodyPainter({
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
    this.speed = 0.0,
    this.greetWave = 0.0,
  });

  Color _driftColor(double hue) {
    final hsl = HSLColor.fromColor(_cyan).withHue(180 + hue * 180);
    return hsl.toColor();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final ambient = _driftColor(math.sin(hueT * math.pi * 2) * 0.5 + 0.5);
    final ambient2 = _driftColor(math.sin(hueT * math.pi * 2 + 1.5) * 0.5 + 0.5);

    const antennaTipY = 2.0;
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
    final corePulse = 0.5 + 0.5 * math.sin(t * math.pi * 3);

    canvas.save();
    canvas.translate(cx, footY);
    canvas.rotate(lean);
    canvas.translate(-cx, -footY);

    // ── Outer Aurora Glow (dual-tone) ───────────────────────────────────────
    final auraPaint1 = Paint()
      ..color = ambient.withValues(alpha: 0.12 + glowPulse * 0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(cx, headCY), headR + 10 + glowPulse * 5, auraPaint1);
    final auraPaint2 = Paint()
      ..color = ambient2.withValues(alpha: 0.08 + glowPulse * 0.04)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(cx, headCY), headR + 20 + glowPulse * 8, auraPaint2);

    // ── Orbiting Motes with soft trailing glow ──────────────────────────────
    for (int i = 0; i < 4; i++) {
      final phase = orbitT * math.pi * 2 + i * (math.pi * 2 / 4);
      final radius = headR + 15 + i * 3;
      final mx = cx + math.cos(phase) * radius;
      final my = headCY + math.sin(phase) * radius * 0.55;
      final moteColor = [_cyan, _pink, _violet, _yellow][i % 4];
      final glowP = Paint()
        ..color = moteColor.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(mx, my), 4, glowP);
      final motePaint = Paint()..color = moteColor.withValues(alpha: 0.85);
      canvas.drawCircle(Offset(mx, my), 2.1, motePaint);
    }

    // ── Sparkle Burst (double ring) ─────────────────────────────────────────
    if (sparkleT > 0 && sparkleT < 1) {
      final burstAlpha = (1 - sparkleT).clamp(0.0, 1.0);
      for (final ring in [0.0, 0.35]) {
        final localT = (sparkleT + ring).clamp(0.0, 1.0);
        final burstRadius = headR + localT * 50;
        final burstPaint = Paint()
          ..color = (ring == 0 ? _cyan : _violet).withValues(alpha: burstAlpha * 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawCircle(Offset(cx, headCY), burstRadius, burstPaint);
      }
    }

    // ── Legs ────────────────────────────────────────────────────────────────
    for (final side in [-1.0, 1.0]) {
      final lx = cx + side * 11;
      final legRect = Rect.fromLTWH(lx - 8, legTop, 16, legBot - legTop);
      final legPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_bodyHL, _bodyColor],
        ).createShader(legRect);
      canvas.drawRRect(RRect.fromRectAndRadius(legRect, const Radius.circular(6)), legPaint);

      // Thin edge highlight for a sleeker plated look.
      final legEdge = Paint()
        ..color = ambient.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      canvas.drawRRect(RRect.fromRectAndRadius(legRect, const Radius.circular(6)), legEdge);

      final kneePaint = Paint()..color = _jointColor;
      canvas.drawCircle(Offset(lx, legTop + (legBot - legTop) * 0.42), 5, kneePaint);
      final kneeDot = Paint()..color = ambient.withValues(alpha: 0.5 + ballPulse * 0.3);
      canvas.drawCircle(Offset(lx, legTop + (legBot - legTop) * 0.42), 1.6, kneeDot);

      final footPaint = Paint()..color = _footColor;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(lx + side * 3, footY + 5), width: 20, height: 10),
        footPaint,
      );
      final footGlow = Paint()
        ..color = ambient.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(lx + side * 3, footY + 5), width: 20, height: 10),
        footGlow,
      );
    }

    // ── Torso ───────────────────────────────────────────────────────────────
    final torsoRect = Rect.fromLTWH(cx - 22, torsoTop, 44, torsoBot - torsoTop);
    final torsoPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_bodyHL2, _bodyHL, _bodyColor],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(torsoRect);
    canvas.drawRRect(RRect.fromRectAndRadius(torsoRect, const Radius.circular(9)), torsoPaint);

    final torsoBorder = Paint()
      ..color = ambient.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRRect(RRect.fromRectAndRadius(torsoRect, const Radius.circular(9)), torsoBorder);

    // Diagonal shimmer sweep across the plating.
    final shimmerX = -22 + ((t * 1.6) % 1.4) * 66;
    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(torsoRect, const Radius.circular(9)));
    final shimmerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.transparent, Colors.white.withValues(alpha: 0.08), Colors.transparent],
      ).createShader(Rect.fromLTWH(cx + shimmerX - 10, torsoTop, 20, torsoBot - torsoTop));
    canvas.drawRect(Rect.fromLTWH(cx - 22, torsoTop, 44, torsoBot - torsoTop), shimmerPaint);
    canvas.restore();

    // Reactor Core (replaces flat chest panel)
    final coreCenter = Offset(cx, torsoTop + 15);
    final coreOuterGlow = Paint()
      ..color = ambient.withValues(alpha: 0.25 + corePulse * 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(coreCenter, 10 + corePulse * 2, coreOuterGlow);

    final corePlate = Paint()..color = _dark;
    canvas.drawCircle(coreCenter, 8.5, corePlate);

    final coreRingPaint = Paint()
      ..color = ambient.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    canvas.drawCircle(coreCenter, 6.5, coreRingPaint);

    final coreCorePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white, ambient, ambient.withValues(alpha: 0.2)],
      ).createShader(Rect.fromCircle(center: coreCenter, radius: 4));
    canvas.drawCircle(coreCenter, 2.6 + corePulse * 0.8, coreCorePaint);

    // Status LEDs beneath the core.
    for (int d = 0; d < 3; d++) {
      final ledPulse = 0.4 + 0.6 * math.sin(t * math.pi * 4 + d * 1.2);
      final ledColor = [_cyan, _pink, _yellow][d];
      final ledGlow = Paint()
        ..color = ledColor.withValues(alpha: ledPulse * 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      final ledCenter = Offset(cx - 8 + d * 8.0, torsoTop + 29);
      canvas.drawCircle(ledCenter, 3.2, ledGlow);
      final ledPaint = Paint()..color = ledColor.withValues(alpha: ledPulse);
      canvas.drawCircle(ledCenter, 2.1, ledPaint);
    }

    // ── Arms ────────────────────────────────────────────────────────────────
    final rightSide = faceRight ? 1.0 : -1.0;
    for (final side in [-1.0, 1.0]) {
      final isInwardArm = (side == rightSide) && bubbleVisible;
      final isGreetArm = (side == rightSide) && greetWave.abs() > 0.001;
      final ax = cx + side * 22;

      canvas.save();
      if (isGreetArm) {
        final waveAngle = -1.3 + greetWave * 0.5;
        canvas.translate(ax, torsoTop + 6);
        canvas.rotate(waveAngle);
        canvas.translate(-ax, -(torsoTop + 6));
      } else if (isInwardArm) {
        final raiseAngle = -0.9 + armWave * 0.25;
        canvas.translate(ax, torsoTop + 6);
        canvas.rotate(raiseAngle);
        canvas.translate(-ax, -(torsoTop + 6));
      }

      final armRect = Rect.fromLTWH(ax - 7, torsoTop + 4, 14, 36);
      final armPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_bodyHL2, _bodyHL, _bodyColor],
        ).createShader(armRect);
      canvas.drawRRect(RRect.fromRectAndRadius(armRect, const Radius.circular(6)), armPaint);

      final armEdge = Paint()
        ..color = ambient.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      canvas.drawRRect(RRect.fromRectAndRadius(armRect, const Radius.circular(6)), armEdge);

      // Shoulder pad accent.
      final shoulderPaint = Paint()..color = _jointColor;
      canvas.drawCircle(Offset(ax, torsoTop + 2), 6.5, shoulderPaint);
      final shoulderDot = Paint()..color = ambient.withValues(alpha: 0.6);
      canvas.drawCircle(Offset(ax, torsoTop + 2), 2.2, shoulderDot);

      final handPaint = Paint()..color = _jointColor;
      canvas.drawCircle(Offset(ax, torsoTop + 4 + 36 + 7), 7, handPaint);
      final handGlow = Paint()..color = ambient.withValues(alpha: 0.35 + ballPulse * 0.2);
      canvas.drawCircle(Offset(ax, torsoTop + 4 + 36 + 7), 2.3, handGlow);
      canvas.restore();
    }

    // ── Neck ────────────────────────────────────────────────────────────────
    final neckPaint = Paint()
      ..shader = LinearGradient(
        colors: [_bodyHL, _bodyColor],
      ).createShader(Rect.fromLTWH(cx - 8, neckTop, 16, neckBot - neckTop));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 8, neckTop, 16, neckBot - neckTop),
        const Radius.circular(4),
      ),
      neckPaint,
    );

    // ── Head & Visor ────────────────────────────────────────────────────────
    final headRect = Rect.fromCircle(center: Offset(cx, headCY), radius: headR);
    final headPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.45),
        radius: 1.0,
        colors: [_bodyHL2, _bodyHL, _bodyColor],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(headRect);
    canvas.drawCircle(Offset(cx, headCY), headR, headPaint);

    final headBorder = Paint()
      ..color = ambient.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(cx, headCY), headR, headBorder);

    // Small vent slits on either side of the head for extra detail.
    for (final side in [-1.0, 1.0]) {
      final ventPaint = Paint()
        ..color = _dark.withValues(alpha: 0.8)
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round;
      for (int i = 0; i < 3; i++) {
        final vy = headCY - 4 + i * 4.0;
        canvas.drawLine(
          Offset(cx + side * (headR - 3), vy),
          Offset(cx + side * (headR - 7), vy),
          ventPaint,
        );
      }
    }

    // Visor (glassy holographic look)
    final visorRect = Rect.fromLTWH(cx - 18, headCY - 11, 36, 22);
    final visorRRect = RRect.fromRectAndRadius(visorRect, const Radius.circular(10));
    final visorPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_visorHL, _visorDeep],
      ).createShader(visorRect);
    canvas.drawRRect(visorRRect, visorPaint);

    canvas.save();
    canvas.clipRRect(visorRRect);
    // Scanline sweep.
    final scanY = headCY - 11 + ((t * 1.3) % 1.0) * 22;
    final scanPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, ambient.withValues(alpha: 0.35), Colors.transparent],
      ).createShader(Rect.fromLTWH(cx - 18, scanY - 4, 36, 8));
    canvas.drawRect(Rect.fromLTWH(cx - 18, scanY - 4, 36, 8), scanPaint);
    canvas.restore();

    final visorBorder = Paint()
      ..color = ambient.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(visorRRect, visorBorder);

    // Eyes
    if (!isBlinking) {
      for (final side in [-1.0, 1.0]) {
        final ex = cx + side * 7;
        const ey = headCY;
        final socketPaint = Paint()..color = _dark;
        canvas.drawCircle(Offset(ex, ey), 6, socketPaint);

        final irisCenter = Offset(ex + eyeNX * 0.5, ey + eyeNY * 0.5);
        final irisGlow = Paint()
          ..color = _cyan.withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(irisCenter, 5, irisGlow);

        final irisPaint = Paint()
          ..shader = RadialGradient(
            colors: [_cyan, _cyanDeep],
          ).createShader(Rect.fromCircle(center: irisCenter, radius: 4));
        canvas.drawCircle(irisCenter, 4, irisPaint);

        final pupilPaint = Paint()..color = Colors.black;
        canvas.drawCircle(Offset(ex + eyeNX, ey + eyeNY), 2.0, pupilPaint);

        final glintPaint = Paint()..color = Colors.white;
        canvas.drawCircle(Offset(ex + eyeNX - 1.2, ey + eyeNY - 1.2), 0.9, glintPaint);
      }
    } else {
      for (final side in [-1.0, 1.0]) {
        final blinkPaint = Paint()
          ..color = _cyan.withValues(alpha: 0.8)
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(cx + side * 13, headCY), Offset(cx + side * 2, headCY), blinkPaint);
      }
    }

    // Mouth
    final mouthOpen = 3 + mouthTalk * 5;
    if (bubbleVisible) {
      final mouthRect = Rect.fromCenter(center: Offset(cx, headCY + 12), width: 12, height: mouthOpen);
      final mouthGlow = Paint()
        ..color = _cyan.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawRRect(RRect.fromRectAndRadius(mouthRect, const Radius.circular(3)), mouthGlow);

      final mouthPaint = Paint()..color = _dark;
      canvas.drawRRect(RRect.fromRectAndRadius(mouthRect, const Radius.circular(3)), mouthPaint);

      final mouthBorder = Paint()
        ..color = _cyan.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRRect(RRect.fromRectAndRadius(mouthRect, const Radius.circular(3)), mouthBorder);
    } else {
      final mouthPath = Path()
        ..moveTo(cx - 6, headCY + 11)
        ..quadraticBezierTo(cx, headCY + 14, cx + 6, headCY + 11);
      final mouthPaint = Paint()
        ..color = _cyan.withValues(alpha: 0.6)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(mouthPath, mouthPaint);
    }

    // Ear Bolts
    for (final side in [-1.0, 1.0]) {
      final ex = cx + side * headR;
      final earPaint = Paint()..color = _jointColor;
      canvas.drawCircle(Offset(ex, headCY), 5, earPaint);

      final earDot = Paint()..color = _cyan.withValues(alpha: 0.5 + ballPulse * 0.4);
      canvas.drawCircle(Offset(ex, headCY), 2.5, earDot);
    }

    // Antenna (two-segment, with glowing trailing sparks)
    final antennaBase = Offset(cx, headCY - headR + 2);
    final antennaMid = Offset(
      cx + antennaWave * 0.22,
      antennaBase.dy - 10,
    );
    final antennaTip = Offset(cx + antennaWave * 0.45, antennaTipY);
    final antennaPaint = Paint()
      ..color = _cyan.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final antennaPath = Path()
      ..moveTo(antennaBase.dx, antennaBase.dy)
      ..quadraticBezierTo(antennaMid.dx, antennaMid.dy, antennaTip.dx, antennaTip.dy);
    canvas.drawPath(antennaPath, antennaPaint);

    // Trailing sparks along the antenna arc.
    for (int i = 1; i <= 2; i++) {
      final f = i / 3.0;
      final sparkPt = Offset(
        antennaBase.dx + (antennaTip.dx - antennaBase.dx) * f,
        antennaBase.dy + (antennaTip.dy - antennaBase.dy) * f,
      );
      final sparkPaint = Paint()
        ..color = _violet.withValues(alpha: 0.4 * (1 - f))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(sparkPt, 1.4, sparkPaint);
    }

    final antennaGlow = Paint()
      ..color = _pink.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(antennaTip, 5.5 + ballPulse * 2.2, antennaGlow);

    final antennaTipPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white, _pink],
      ).createShader(Rect.fromCircle(center: antennaTip, radius: 3.2));
    canvas.drawCircle(antennaTip, 3.2, antennaTipPaint);

    // Thruster Glow (reacts to movement speed for extra life)
    final speedBoost = (speed / 400).clamp(0.0, 0.35);
    final thrusterBoost = ((lean.abs() * 4) + speedBoost).clamp(0.0, 0.45);
    final thrusterPaint = Paint()
      ..color = ambient.withValues(alpha: 0.16 + glowPulse * 0.1 + thrusterBoost * 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, footY + 10),
        width: 40 + thrusterBoost * 26,
        height: 8 + thrusterBoost * 8,
      ),
      thrusterPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_DarkRobotBodyPainter old) => true;
}

// ─────────────────────────── Stationary Inline Bot ───────────────────────────
class StationaryBot extends StatefulWidget {
  final double cursorX;
  final double cursorY;
  final double size;
  const StationaryBot({super.key, required this.cursorX, required this.cursorY, this.size = 90});

  @override
  State<StationaryBot> createState() => _StationaryBotState();
}

class _StationaryBotState extends State<StationaryBot> with TickerProviderStateMixin {
  late AnimationController _animCtrl;
  bool _isBlinking = false;
  late Timer _blinkTimer;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat();
    _scheduleBlink();
  }

  void _scheduleBlink() {
    final delay = 2000 + math.Random().nextInt(4000);
    _blinkTimer = Timer(Duration(milliseconds: delay), () {
      if (!mounted) return;
      setState(() => _isBlinking = true);
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        setState(() => _isBlinking = false);
        _scheduleBlink();
      });
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _blinkTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animCtrl,
        builder: (context, _) {
          final t = _animCtrl.value;
          final bob = math.sin(t * math.pi * 4) * 4.5;
          final antennaWave = math.sin(t * math.pi * 8) * 7.0;
          final armWave = 0.5 + 0.5 * math.sin(t * math.pi * 6);
          
          final screenW = MediaQuery.of(context).size.width;
          final eyeRelX = ((screenW / 2) - widget.cursorX).clamp(-40.0, 40.0);
          final eyeNX = (eyeRelX / 40.0) * 4.0;
          final eyeRelY = (widget.cursorY - 200).clamp(-30.0, 30.0);
          final eyeNY = (eyeRelY / 30.0) * 2.5;

          return Transform.translate(
            offset: Offset(0, bob),
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: 120,
                height: 120,
                child: CustomPaint(
                  painter: _DarkRobotBodyPainter(
                    eyeNX: eyeNX, eyeNY: eyeNY,
                    isBlinking: _isBlinking,
                    antennaWave: antennaWave, armWave: armWave,
                    t: t, bubbleVisible: false, faceRight: false,
                    mouthTalk: 0, lean: 0, orbitT: (t * 2) % 1.0,
                    sparkleT: 0, hueT: t, speed: 0, greetWave: 0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}