import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/widgets/inspector_box.dart';
import 'package:my_portfolio/widgets/mouse_follow_avatar.dart';

class AvatarSection extends StatefulWidget {
  const AvatarSection({super.key});

  @override
  State<AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<AvatarSection>
    with TickerProviderStateMixin {
  // ── Mouse sparkle trail ────────────────────────────────────────────────────
  final List<_Sparkle> _sparkles = [];
  final GlobalKey _sectionKey = GlobalKey();
  late final AnimationController _sparkleLoopCtrl;

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

  // ── Skill bars ─────────────────────────────────────────────────────────────
  static const _skills = [
    ('Flutter / Dart', 0.90),
    ('Firebase & REST APIs', 0.80),
    ('State Management', 0.85),
    ('Clean Architecture', 0.78),
    ('UI / UX Design', 0.72),
  ];
  late final AnimationController _barCtrl;

  @override
  void initState() {
    super.initState();

    // Sparkle animation loop
    _sparkleLoopCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();
    _sparkleLoopCtrl.addListener(_updateSparkles);

    // Typewriter
    _typeTimer =
        Timer.periodic(const Duration(milliseconds: 38), _tickTypewriter);
    _cursorTimer =
        Timer.periodic(const Duration(milliseconds: 530), _tickCursor);

    // Skill bars
    _barCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  void _updateSparkles() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (mounted) {
      setState(() {
        _sparkles.removeWhere((s) => now - s.createdAt > 700);
      });
    }
  }

  void _onMouseMove(PointerEvent e) {
    final box =
        _sectionKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(e.position);
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_sparkles.isEmpty ||
        (local - _sparkles.last.localPos).distance > 10) {
      setState(() {
        _sparkles.add(_Sparkle(
          localPos: local,
          createdAt: now,
          isCyan: math.Random().nextBool(),
          size: 2.0 + math.Random().nextDouble() * 3.0,
        ));
      });
    }
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
    _sparkleLoopCtrl.dispose();
    _typeTimer.cancel();
    _cursorTimer.cancel();
    _barCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return MouseRegion(
      onHover: _onMouseMove,
      child: Listener(
        onPointerMove: _onMouseMove,
        child: Container(
          key: _sectionKey,
          width: double.infinity,
          // Full-viewport-height feel
          constraints: BoxConstraints(minHeight: size.height * 0.94),
          color: AppColors.background(context),
          child: Stack(
            children: [
              // ── Animated dot-grid background ───────────────────────────
              Positioned.fill(child: _DotGridPainterWidget()),

              // ── Mouse sparkle trail ────────────────────────────────────
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _SparklePainter(sparkles: _sparkles),
                  ),
                ),
              ),

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
        ),
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
        Expanded(
          flex: 5,
          child: _buildRightPanel(context, isMobile: false),
        ),
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
            border:
                Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
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

        // ── Skill bars ─────────────────────────────────────────────
        AnimatedBuilder(
          animation: _barCtrl,
          builder: (context, _) {
            return Column(
              children: [
                for (final s in _skills) ...[
                  _SkillBar(
                    label: s.$1,
                    value: s.$2 * _barCtrl.value,
                    target: s.$2,
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            );
          },
        ),

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
                onHover: (v) =>
                    setState(() => _hoveredChip = v ? i : -1),
              ),
          ],
        ),

        const SizedBox(height: 24),

        // ── Terminal ───────────────────────────────────────────────
        _TerminalBox(
          text: _termBuffer.toString(),
          showCursor: _showCursor,
        ),

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
    ('Flutter', '2+ yrs'),
    ('Dart', '2+ yrs'),
    ('Firebase', '1+ yr'),
    ('REST APIs', '1+ yr'),
    ('Apps Shipped', '10+'),
  ];
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
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isWaving
                ? AppColors.cyan.withValues(alpha: 0.2)
                : _hovered
                    ? AppColors.cyan.withValues(alpha: 0.15)
                    : AppColors.cyan.withValues(alpha: 0.08),
            border: Border.all(
              color: AppColors.cyan.withValues(
                  alpha: widget.isWaving || _hovered ? 0.8 : 0.35),
              width: widget.isWaving ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: widget.isWaving || _hovered
                ? [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.25),
                      blurRadius: 16,
                    )
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
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isHovered
              ? AppColors.cyan.withValues(alpha: 0.14)
              : AppColors.cyan.withValues(alpha: 0.06),
          border: Border.all(
            color: AppColors.cyan
                .withValues(alpha: isHovered ? 0.55 : 0.2),
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: AppColors.cyan.withValues(alpha: 0.18),
                    blurRadius: 12,
                  )
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

class _SkillBar extends StatelessWidget {
  final String label;
  final double value; // current (animated)
  final double target; // final value (for text)

  const _SkillBar(
      {required this.label, required this.value, required this.target});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.ibmPlexMono(
                fontSize: 11,
                color: AppColors.dim,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              '${(target * 100).toInt()}%',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 11,
                color: AppColors.cyan,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Stack(
            children: [
              // Track
              Container(
                height: 5,
                color: AppColors.cyan.withValues(alpha: 0.1),
              ),
              // Fill
              FractionallySizedBox(
                widthFactor: value,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.cyan, AppColors.pink],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
        decoration:
            BoxDecoration(color: c, shape: BoxShape.circle),
      );
}

// ─────────────────────────── Dot-grid background ─────────────────────────────

class _DotGridPainterWidget extends StatefulWidget {
  @override
  State<_DotGridPainterWidget> createState() =>
      _DotGridPainterWidgetState();
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
  Widget build(BuildContext context) => CustomPaint(
        painter: _DotGridPainter(t: _ctrl.value),
      );
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
            ..color =
                const Color(0xFF00F5D4).withValues(alpha: alpha.clamp(0.0, 1.0)),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => old.t != t;
}

// ─────────────────────────── Sparkle trail ───────────────────────────────────

class _Sparkle {
  final Offset localPos;
  final int createdAt;
  final bool isCyan;
  final double size;
  const _Sparkle({
    required this.localPos,
    required this.createdAt,
    required this.isCyan,
    required this.size,
  });
}

class _SparklePainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  const _SparklePainter({required this.sparkles});

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final s in sparkles) {
      final age = (now - s.createdAt) / 700.0; // 0..1
      final alpha = (1.0 - age).clamp(0.0, 1.0);
      final col = s.isCyan
          ? const Color(0xFF00F5D4)
          : const Color(0xFFFF2D78);

      // Glow
      canvas.drawCircle(
        s.localPos,
        s.size * 3 * (1 - age * 0.5),
        Paint()
          ..color = col.withValues(alpha: alpha * 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      // Core
      canvas.drawCircle(
        s.localPos,
        s.size * (1 - age * 0.6),
        Paint()..color = col.withValues(alpha: alpha * 0.85),
      );
    }
  }

  @override
  bool shouldRepaint(_SparklePainter old) => true;
}
