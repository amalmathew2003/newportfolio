import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/widgets/inspector_box.dart';
import 'package:my_portfolio/widgets/mouse_follow_avatar.dart';
import 'package:my_portfolio/widgets/robot_follower.dart';

class AvatarSection extends StatefulWidget {
  const AvatarSection({super.key});

  @override
  State<AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<AvatarSection>
    with TickerProviderStateMixin {
  // ── Waving ─────────────────────────────────────────────────────────────────
  bool _isWaving = false;

  // ── Hover stat chip ────────────────────────────────────────────────────────
  int _hoveredChip = -1;

  // ── Typewriter terminal ────────────────────────────────────────────────────
  static const _termLines = [
    r'> flutter pub get',
    '✓ Packages downloaded',
    r'> flutter run',
    '🚀 Launching on Android...',
    '✓ App compiled in 3.2s',
    '',
    r'> git commit -m "feat: new feature"',
    '[main 4a9f2c] feat: new feature',
    '',
    r'> amal --info',
    'Name   : Amal Mathew',
    'Role   : Flutter Developer',
    'Exp    : 1y 9m total',
    'Stack  : Flutter · Dart · Firebase',
    '',
  ];
  final StringBuffer _termBuffer = StringBuffer();
  int _lineIdx = 0;
  int _charIdx = 0;
  late Timer _typeTimer;
  bool _showCursor = true;
  late Timer _cursorTimer;

  // ── Skills shown in the rotating pill ──────────────────────────────────────
  static const _skills = [
    ('Flutter / Dart', Icons.flutter_dash_rounded),
    ('Firebase & REST APIs', Icons.local_fire_department_rounded),
    ('State Management', Icons.hub_rounded),
    ('Clean Architecture', Icons.architecture_rounded),
    ('UI / UX Design', Icons.brush_rounded),
  ];

  @override
  void initState() {
    super.initState();

    // Typewriter
    _typeTimer = Timer.periodic(
      const Duration(milliseconds: 38),
      _tickTypewriter,
    );
    _cursorTimer = Timer.periodic(
      const Duration(milliseconds: 530),
      _tickCursor,
    );
  }

  void _tickTypewriter(Timer _) {
    if (!mounted) return;
    final line = _termLines[_lineIdx];
    if (_charIdx < line.length) {
      setState(() {
        _termBuffer.write(line[_charIdx]);
        _charIdx++;
      });
    } else {
      setState(() {
        _termBuffer.write('\n');
        _lineIdx = (_lineIdx + 1) % _termLines.length;
        _charIdx = 0;
        // Reset when all lines done
        if (_lineIdx == 0) _termBuffer.clear();
        // Keep only last ~15 lines
        final lines = _termBuffer.toString().split('\n');
        if (lines.length > 15) {
          _termBuffer.clear();
          _termBuffer.write(lines.skip(lines.length - 15).join('\n'));
        }
      });
    }
  }

  void _tickCursor(Timer _) {
    if (mounted) setState(() => _showCursor = !_showCursor);
  }

  Future<void> _triggerWave() async {
    if (_isWaving) return;
    setState(() => _isWaving = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) setState(() => _isWaving = false);
  }

  @override
  void dispose() {
    _typeTimer.cancel();
    _cursorTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      // Full-viewport-height feel
      constraints: BoxConstraints(minHeight: size.height * 0.94),
      color: AppColors.background(context),
      child: Stack(
        children: [
          // ── Animated dot-grid background ───────────────────────────
          Positioned.fill(child: _DotGridPainterWidget()),

          // ── Main content ───────────────────────────────────────────
          Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 48,
                  vertical: isMobile ? 32 : 56,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: InspectorBox(
                      widgetTag: 'InteractiveAvatar',
                      dimensionTag: 'mouse: tracking',
                      signalAccent: SignalAccent.cyan,
                      padding: EdgeInsets.all(isMobile ? 20 : 44),
                      child: isMobile
                          ? _buildMobile(context)
                          : _buildDesktop(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left — big avatar
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MouseFollowAvatar(size: 400, isWaving: _isWaving),
              const SizedBox(height: 20),
              // Wave button
              _WaveButton(isWaving: _isWaving, onTap: _triggerWave),
            ],
          ),
        ),

        const SizedBox(width: 52),

        // Right — interactive panel
        Expanded(flex: 5, child: _buildRightPanel(context, isMobile: false)),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [
        MouseFollowAvatar(size: 280, isWaving: _isWaving),
        const SizedBox(height: 16),
        _WaveButton(isWaving: _isWaving, onTap: _triggerWave),
        const SizedBox(height: 28),
        _buildRightPanel(context, isMobile: true),
      ],
    );
  }

  Widget _buildRightPanel(BuildContext context, {required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Code-style label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.cyan.withValues(alpha: 0.1),
            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            '// move your mouse around ↑  |  tap "Say Hi" below ↓',
            style: GoogleFonts.ibmPlexMono(
              fontSize: isMobile ? 10 : 11,
              color: AppColors.cyan,
            ),
          ),
        ),

        const SizedBox(height: 18),

        // Title
        Text(
          'Meet the\nDeveloper',
          style: GoogleFonts.spaceGrotesk(
            fontSize: isMobile ? 30 : 44,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText(context),
            letterSpacing: -1,
            height: 1.1,
          ),
        ),

        const SizedBox(height: 14),

        Text(
          "That's me — Amal. A Flutter developer who ships polished, production-ready mobile apps and loves clean architecture.",
          style: GoogleFonts.spaceGrotesk(
            fontSize: isMobile ? 14 : 15,
            height: 1.65,
            color: AppColors.dim,
          ),
        ),

        const SizedBox(height: 24),

        // ── Redesigned Skills Pill ──────────────────────────────────────
        _SkillPill(skills: _skills),

        const SizedBox(height: 24),

        // ── Stat chips with hover ──────────────────────────────────
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (int i = 0; i < _chipData.length; i++)
              _HoverChip(
                label: _chipData[i].$1,
                value: _chipData[i].$2,
                isHovered: _hoveredChip == i,
                onHover: (v) => setState(() => _hoveredChip = v ? i : -1),
              ),
          ],
        ),

        const SizedBox(height: 24),

        // ── Terminal ───────────────────────────────────────────────
        _TerminalBox(text: _termBuffer.toString(), showCursor: _showCursor),

        const SizedBox(height: 16),

        // Closing tag
        Text(
          '} // end InteractiveAvatar',
          style: GoogleFonts.ibmPlexMono(
            fontSize: 12,
            color: AppColors.cyan.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  static const _chipData = [
    ('Flutter', '1.5+ yrs'),
    ('Dart', '1.5+ yrs'),
    ('Firebase', '1.5+ yr'),
    ('REST APIs', '1.5+ yr'),
    ('Apps Shipped', '5+'),
  ];
}

// ─────────────────────────── Redesigned Skills Pill ──────────────────────────

/// A capsule with a slow-rotating conic gradient border, a glassy dark
/// interior, and a per-skill icon that crossfades along with the label.
/// No numbers, no progress bar — just a clean, high-polish rotating badge.
class _SkillPill extends StatefulWidget {
  final List<(String, IconData)> skills;
  const _SkillPill({required this.skills});

  @override
  State<_SkillPill> createState() => _SkillPillState();
}

class _SkillPillState extends State<_SkillPill>
    with TickerProviderStateMixin {
  late final AnimationController _borderCtrl;
  late final AnimationController _pulseCtrl;
  int _idx = 0;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _borderCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _timer = Timer.periodic(const Duration(milliseconds: 2600), (_) {
      if (mounted) setState(() => _idx = (_idx + 1) % widget.skills.length);
    });
  }

  @override
  void dispose() {
    _borderCtrl.dispose();
    _pulseCtrl.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skill = widget.skills[_idx];

    return AnimatedBuilder(
      animation: Listenable.merge([_borderCtrl, _pulseCtrl]),
      builder: (context, _) {
        final pulse = _pulseCtrl.value;
        return Container(
          padding: const EdgeInsets.all(1.6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: SweepGradient(
              startAngle: 0,
              endAngle: math.pi * 2,
              transform: GradientRotation(_borderCtrl.value * math.pi * 2),
              colors: const [
                AppColors.cyan,
                Color(0xFF9B6BFF),
                AppColors.pink,
                AppColors.cyan,
              ],
              stops: const [0.0, 0.4, 0.75, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.16 + pulse * 0.12),
                blurRadius: 24,
                spreadRadius: -4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF0A1626).withValues(alpha: 0.95),
                      const Color(0xFF071120).withValues(alpha: 0.98),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _IconBadge(icon: skill.$2, pulse: pulse),
                    const SizedBox(width: 14),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 450),
                        switchInCurve: Curves.easeOutBack,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.35),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: Column(
                          key: ValueKey(_idx),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'CURRENTLY FOCUSED ON',
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 9,
                                color: AppColors.cyan.withValues(alpha: 0.55),
                                letterSpacing: 1.4,
                              ),
                            ),
                            const SizedBox(height: 3),
                            ShaderMask(
                              shaderCallback: (r) => const LinearGradient(
                                colors: [Colors.white, AppColors.cyan],
                              ).createShader(r),
                              child: Text(
                                skill.$1,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Static dot rail — a quiet index indicator, no numbers.
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < widget.skills.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(vertical: 1.5),
                            width: i == _idx ? 5 : 3,
                            height: i == _idx ? 5 : 3,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i == _idx
                                  ? AppColors.cyan
                                  : Colors.white.withValues(alpha: 0.15),
                              boxShadow: i == _idx
                                  ? [
                                      BoxShadow(
                                        color: AppColors.cyan
                                            .withValues(alpha: 0.7),
                                        blurRadius: 5,
                                      ),
                                    ]
                                  : [],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Rounded-square glowing icon badge — replaces the old 3D gyroscope with
/// something that reads instantly and matches the panel/terminal language
/// already used elsewhere in the section.
class _IconBadge extends StatelessWidget {
  final IconData icon;
  final double pulse;
  const _IconBadge({required this.icon, required this.pulse});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cyan.withValues(alpha: 0.18 + pulse * 0.06),
            AppColors.pink.withValues(alpha: 0.10 + pulse * 0.04),
          ],
        ),
        border: Border.all(
          color: AppColors.cyan.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.25 + pulse * 0.2),
            blurRadius: 12,
            spreadRadius: -1,
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, anim) => ScaleTransition(
          scale: anim,
          child: FadeTransition(opacity: anim, child: child),
        ),
        child: Icon(
          icon,
          key: ValueKey(icon),
          color: AppColors.cyan,
          size: 20,
        ),
      ),
    );
  }
}

// ─────────────────────────── Sub-widgets ─────────────────────────────────────

class _WaveButton extends StatefulWidget {
  final bool isWaving;
  final VoidCallback onTap;
  const _WaveButton({required this.isWaving, required this.onTap});

  @override
  State<_WaveButton> createState() => _WaveButtonState();
}

class _WaveButtonState extends State<_WaveButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isWaving
                ? AppColors.cyan.withValues(alpha: 0.2)
                : _hovered
                ? AppColors.cyan.withValues(alpha: 0.15)
                : AppColors.cyan.withValues(alpha: 0.08),
            border: Border.all(
              color: AppColors.cyan.withValues(
                alpha: widget.isWaving || _hovered ? 0.8 : 0.35,
              ),
              width: widget.isWaving ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: widget.isWaving || _hovered
                ? [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.25),
                      blurRadius: 16,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  widget.isWaving ? '👋  Waving...' : '👋  Say Hi',
                  key: ValueKey(widget.isWaving),
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cyan,
                    letterSpacing: 0.5,
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

class _HoverChip extends StatelessWidget {
  final String label, value;
  final bool isHovered;
  final ValueChanged<bool> onHover;

  const _HoverChip({
    required this.label,
    required this.value,
    required this.isHovered,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isHovered
              ? AppColors.cyan.withValues(alpha: 0.14)
              : AppColors.cyan.withValues(alpha: 0.06),
          border: Border.all(
            color: AppColors.cyan.withValues(alpha: isHovered ? 0.55 : 0.2),
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: AppColors.cyan.withValues(alpha: 0.18),
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText(context),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.ibmPlexMono(
                fontSize: 10,
                color: AppColors.cyan,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TerminalBox extends StatelessWidget {
  final String text;
  final bool showCursor;
  const _TerminalBox({required this.text, required this.showCursor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 300),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF060F1A),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Terminal top bar
          Row(
            children: [
              _dot(const Color(0xFFFF5F57)),
              const SizedBox(width: 6),
              _dot(const Color(0xFFFFBD2E)),
              const SizedBox(width: 6),
              _dot(const Color(0xFF28CA41)),
              const SizedBox(width: 10),
              Text(
                'zsh — amal@dev',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 10,
                  color: AppColors.dim.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Terminal text
          RichText(
            text: TextSpan(
              style: GoogleFonts.ibmPlexMono(
                fontSize: 11,
                color: AppColors.cyan.withValues(alpha: 0.75),
                height: 1.6,
              ),
              children: [
                TextSpan(text: text),
                if (showCursor)
                  TextSpan(
                    text: '▌',
                    style: TextStyle(color: AppColors.cyan),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color c) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
  );
}

// ─────────────────────────── Dot-grid background ─────────────────────────────

class _DotGridPainterWidget extends StatefulWidget {
  @override
  State<_DotGridPainterWidget> createState() => _DotGridPainterWidgetState();
}

class _DotGridPainterWidgetState extends State<_DotGridPainterWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _ctrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _DotGridPainter(t: _ctrl.value));
}

class _DotGridPainter extends CustomPainter {
  final double t;
  const _DotGridPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 36.0;
    const dotR = 1.2;
    final rows = (size.height / spacing).ceil() + 1;
    final cols = (size.width / spacing).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final x = c * spacing;
        final y = r * spacing;
        // Wave pulse
        final wave = math.sin(t * math.pi * 2 + (r + c) * 0.4);
        final alpha = 0.04 + wave * 0.03;
        canvas.drawCircle(
          Offset(x, y),
          dotR + wave * 0.5,
          Paint()
            ..color = const Color(
              0xFF00F5D4,
            ).withValues(alpha: alpha.clamp(0.0, 1.0)),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => old.t != t;
}
