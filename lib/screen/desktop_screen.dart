import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/service/downloadcv.dart';
import 'package:my_portfolio/widgets/gradient_orb.dart';

class DesktopScreen extends StatefulWidget {
  final VoidCallback? onContactTap;
  const DesktopScreen({super.key, this.onContactTap});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen>
    with TickerProviderStateMixin {
  Offset _mousePos = Offset.zero;
  late AnimationController _lineController;

  @override
  void initState() {
    super.initState();
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = AppColors.accent(context);

    return MouseRegion(
      onHover: (event) {
        if (!isMobile) {
          setState(() {
            _mousePos = Offset(
              (event.localPosition.dx - size.width / 2) / (size.width / 2),
              (event.localPosition.dy - size.height / 2) / (size.height / 2),
            );
          });
        }
      },
      child: Container(
        height: size.height,
        width: double.infinity,
        color: AppColors.background(context),
        child: Stack(
          children: [
            // === AMBIENT ORBS ===
            Positioned.fill(
              child: IgnorePointer(
                child: Stack(
                  children: [
                    GradientOrb(
                      size: isMobile ? 350 : 600,
                      alignment: Alignment.topRight,
                      opacity: isDark ? 0.06 : 0.05,
                      duration: const Duration(seconds: 10),
                    ),
                    GradientOrb(
                      size: isMobile ? 250 : 400,
                      alignment: Alignment.bottomLeft,
                      opacity: isDark ? 0.04 : 0.035,
                      duration: const Duration(seconds: 14),
                    ),
                  ],
                ),
              ),
            ),

            // === EDITORIAL BACKDROP TEXT ===
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.18),
                child: Opacity(
                  opacity: isDark ? 0.025 : 0.055,
                  child: Text(
                    'AMAL',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.libreBodoni(
                      fontSize: isMobile ? 80 : size.width * 0.18,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black,
                      letterSpacing: -4,
                    ),
                  ),
                ),
              ),
            ),

            // === LEFT CONTENT ===
            Positioned(
              left: isMobile ? 24 : 100,
              top: size.height * 0.22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section marker
                  FadeInLeft(
                    duration: const Duration(milliseconds: 900),
                    child: Row(
                      children: [
                        AnimatedBuilder(
                          animation: _lineController,
                          builder: (_, __) => Container(
                            width: _lineController.value * 30,
                            height: 1,
                            color: accentColor.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '*01 — PORTFOLIO',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: accentColor.withValues(alpha: 0.5),
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Subtitle
                  FadeInLeft(
                    duration: const Duration(milliseconds: 1000),
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      'FLUTTER DEVELOPER',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6,
                        color: isDark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Main Heading
                  FadeInLeft(
                    duration: const Duration(milliseconds: 1100),
                    delay: const Duration(milliseconds: 200),
                    child: _ShimmerHeader(
                      text: 'AMAL\nMATHEW',
                      style: GoogleFonts.libreBodoni(
                        fontSize: isMobile ? 52 : 118,
                        fontWeight: FontWeight.w900,
                        height: 0.88,
                        color: isDark ? Colors.white : Colors.black,
                        letterSpacing: -3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 52),

                  // CTA Buttons
                  FadeInLeft(
                    duration: const Duration(milliseconds: 1200),
                    delay: const Duration(milliseconds: 400),
                    child: Row(
                      children: [
                        _PremiumButton(
                          text: 'DOWNLOAD CV',
                          isPrimary: true,
                          accentColor: accentColor,
                          onTap: () => downloadCV(context),
                        ),
                        const SizedBox(width: 16),
                        _PremiumButton(
                          text: 'GET IN TOUCH',
                          isPrimary: false,
                          accentColor: accentColor,
                          onTap: widget.onContactTap ?? () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // === PROFILE IMAGE (PARALLAX) ===
            Positioned(
              right: isMobile ? 0 : size.width * 0.04,
              top: size.height * 0.12,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(_mousePos.dx * 18, _mousePos.dy * 18),
                child: FadeIn(
                  duration: const Duration(milliseconds: 1600),
                  delay: const Duration(milliseconds: 300),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer glow ring
                      if (!isMobile)
                        Container(
                          width: size.width * 0.47,
                          height: size.height * 0.73,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: isDark ? 0.06 : 0.04),
                                blurRadius: 120,
                                spreadRadius: 40,
                              ),
                            ],
                          ),
                        ),
                      Container(
                        width: size.width * (isMobile ? 0.9 : 0.46),
                        height: size.height * 0.72,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/images/portfolio2.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // === RIGHT META INFO (DESKTOP) ===
            if (!isMobile)
              Positioned(
                right: 44,
                bottom: 72,
                child: FadeInRight(
                  duration: const Duration(milliseconds: 1100),
                  delay: const Duration(milliseconds: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _MetaItem('STATUS', 'AVAILABLE FOR HIRE', accentColor, isDark),
                      const SizedBox(height: 28),
                      _MetaItem('ROLE', 'FLUTTER DEVELOPER', accentColor, isDark),
                      const SizedBox(height: 28),
                      _MetaItem('BASE', 'KERALA, INDIA', accentColor, isDark),
                    ],
                  ),
                ),
              ),

            // === BOTTOM SCROLL INDICATOR ===
            Positioned(
              bottom: 30,
              left: isMobile ? 24 : 100,
              child: FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 1000),
                child: _ScrollIndicator(isDark: isDark),
              ),
            ),

            // === NOISE OVERLAY ===
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.025,
                  child: CustomPaint(
                    painter: _NoisePainter(
                      color: isDark ? Colors.white : Colors.black,
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

// ─── Meta Item ────────────────────────────────────────────────────────────────

class _MetaItem extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;
  final bool isDark;
  const _MetaItem(this.label, this.value, this.accentColor, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
            color: accentColor.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: isDark ? Colors.white.withValues(alpha: 0.70) : Colors.black.withValues(alpha: 0.70),
          ),
        ),
      ],
    );
  }
}

// ─── Premium Button ───────────────────────────────────────────────────────────

class _PremiumButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final Color accentColor;
  final VoidCallback onTap;

  const _PremiumButton({
    required this.text,
    required this.isPrimary,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<_PremiumButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          transform: _isHovered
              ? (Matrix4.identity()..translate(0, -2.0, 0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_isHovered
                    ? widget.accentColor.withValues(alpha: 0.9)
                    : widget.accentColor)
                : Colors.transparent,
            border: Border.all(
              color: widget.isPrimary
                  ? widget.accentColor
                  : (_isHovered
                      ? widget.accentColor
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.15))),
              width: 1.5,
            ),
            boxShadow: _isHovered && widget.isPrimary
                ? [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                  color: widget.isPrimary
                      ? (isDark ? Colors.black : Colors.white)
                      : (_isHovered
                          ? widget.accentColor
                          : (isDark ? Colors.white.withValues(alpha: 0.54) : Colors.black.withValues(alpha: 0.54))),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                widget.isPrimary
                    ? Icons.download_rounded
                    : Icons.arrow_outward_rounded,
                size: 14,
                color: widget.isPrimary
                    ? (isDark ? Colors.black : Colors.white)
                    : (_isHovered
                        ? widget.accentColor
                        : (isDark ? Colors.white.withValues(alpha: 0.38) : Colors.black.withValues(alpha: 0.38))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shimmer Header ───────────────────────────────────────────────────────────

class _ShimmerHeader extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _ShimmerHeader({required this.text, required this.style});

  @override
  _ShimmerHeaderState createState() => _ShimmerHeaderState();
}

class _ShimmerHeaderState extends State<_ShimmerHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Colors.white,
                      Colors.white.withValues(alpha: 0.55),
                      Colors.white,
                    ]
                  : [
                      Colors.black,
                      Colors.black.withValues(alpha: 0.45),
                      Colors.black,
                    ],
              stops: [
                (_controller.value - 0.35).clamp(0.0, 1.0),
                _controller.value.clamp(0.0, 1.0),
                (_controller.value + 0.35).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style.copyWith(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

// ─── Scroll Indicator ─────────────────────────────────────────────────────────

class _ScrollIndicator extends StatefulWidget {
  final bool isDark;
  const _ScrollIndicator({required this.isDark});

  @override
  State<_ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<_ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isDark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30);
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Row(
          children: [
            Container(
              width: 1,
              height: 30,
              color: color,
            ),
            const SizedBox(width: 12),
            Text(
              'SCROLL',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Noise Painter ────────────────────────────────────────────────────────────

class _NoisePainter extends CustomPainter {
  final Color color;
  _NoisePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    final paint = Paint()..color = color.withValues(alpha: 0.12);
    for (int i = 0; i < 2000; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
