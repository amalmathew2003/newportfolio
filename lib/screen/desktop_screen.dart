import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/service/downloadcv.dart';

class DesktopScreen extends StatefulWidget {
  final VoidCallback? onContactTap;
  const DesktopScreen({super.key, this.onContactTap});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      height: size.height,
      width: double.infinity,
      padding: EdgeInsets.only(
        left: isMobile ? 24 : 100,
        right: isMobile ? 24 : 100,
        top: 70, // clear the nav bar
      ),
      child: Stack(
        children: [
          // Floating geometric shapes
          ..._buildFloatingShapes(size),

          // Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              // Status badge
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: _buildStatusBadge(),
              ),

              SizedBox(height: isMobile ? 20 : 30),

              // Main heading with unique design
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 200),
                child: _buildMainHeading(isMobile),
              ),

              const SizedBox(height: 30),

              // Animated subtitle line
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 500),
                child: _buildSubtitle(isMobile),
              ),

              const SizedBox(height: 40),

              // CTA Buttons
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 700),
                child: _buildCTAButtons(isMobile),
              ),

              const SizedBox(height: 40),

              // Stats row
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 900),
                child: _buildStatsRow(isMobile),
              ),
            ],
          ),

          // Scroll indicator at bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeInUp(
              delay: const Duration(milliseconds: 1500),
              child: _buildScrollIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark
        ? const Color(0xFF00FFA3)
        : const Color(0xFF3B82F6);

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: .05),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: Color.lerp(
                accentColor.withValues(alpha: .2),
                accentColor.withValues(alpha: .5),
                _glowController.value,
              )!,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pulsing dot
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(
                        alpha: 0.3 + (_glowController.value * 0.5),
                      ),
                      blurRadius: 8 + (_glowController.value * 8),
                      spreadRadius: _glowController.value * 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'OPEN TO OPPORTUNITIES',
                style: GoogleFonts.jetBrainsMono(
                  color: isDark
                      ? accentColor
                      : const Color(0xFF2563EB), // Darker blue for visibility
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainHeading(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Line 1 — with monospace accent
        Row(
          mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Text(
              '// ',
              style: GoogleFonts.jetBrainsMono(
                fontSize: isMobile ? 14 : 20,
                color: const Color(0xFF00FFA3).withValues(alpha: .6),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Hello, I\'m',
              style: GoogleFonts.inter(
                fontSize: isMobile ? 14 : 20,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Name — Big, Bold, with gradient
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return LinearGradient(
                  colors: [
                    isDark ? Colors.white : Colors.black87,
                    isDark ? const Color(0xFF00FFA3) : const Color(0xFF3B82F6),
                    isDark ? Colors.white : Colors.black87,
                  ],
                  stops: [0.0, _glowController.value, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              child: Text(
                'AMAL\nMATHEW',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: isMobile ? 60 : 120,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  height: 0.9,
                  letterSpacing: -3,
                ),
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Role with typing cursor effect (reuses glowController)
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            final showCursor = (_glowController.value * 6).floor() % 2 == 0;
            return Row(
              mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
              children: [
                Container(
                  width: 24,
                  height: 2,
                  color: const Color(0xFF8B5CF6),
                  margin: const EdgeInsets.only(right: 12),
                ),
                Text(
                  'Flutter Developer & UI/UX Designer',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: isMobile ? 12 : 16,
                    color: const Color(0xFF8B5CF6),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
                AnimatedOpacity(
                  opacity: showCursor ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    width: 2,
                    height: isMobile ? 14 : 18,
                    color: const Color(0xFF8B5CF6),
                    margin: const EdgeInsets.only(left: 4),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubtitle(bool isMobile) {
    return SizedBox(
      width: isMobile ? double.infinity : 550,
      child: Text(
        'Crafting seamless mobile & web experiences with pixel-perfect precision, fluid animations, and clean architecture.',
        style: GoogleFonts.inter(
          fontSize: isMobile ? 14 : 16,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: .5)
              : Colors.black.withValues(alpha: .6),
          height: 1.8,
          letterSpacing: 0.3,
        ),
        textAlign: isMobile ? TextAlign.center : TextAlign.start,
      ),
    );
  }

  Widget _buildCTAButtons(bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: [
        _NeonButton(
          text: 'DOWNLOAD CV',
          icon: Icons.download_rounded,
          isPrimary: true,
          onTap: () => downloadCV(context),
        ),
        _NeonButton(
          text: 'LET\'S TALK',
          icon: Icons.arrow_outward_rounded,
          isPrimary: false,
          onTap: widget.onContactTap ?? () {},
        ),
      ],
    );
  }

  Widget _buildStatsRow(bool isMobile) {
    return Row(
      mainAxisAlignment: isMobile
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        _StatItem(value: '1+', label: 'Years Exp'),
        Container(
          width: 1,
          height: 40,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: .1)
              : Colors.black.withValues(alpha: .1),
          margin: const EdgeInsets.symmetric(horizontal: 30),
        ),
        _StatItem(value: '5+', label: 'Projects'),
        Container(
          width: 1,
          height: 40,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: .1)
              : Colors.black.withValues(alpha: .1),
          margin: const EdgeInsets.symmetric(horizontal: 30),
        ),
        _StatItem(value: '∞', label: 'Passion'),
      ],
    );
  }

  Widget _buildScrollIndicator() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_floatController.value * math.pi * 2) * 8),
          child: Column(
            children: [
              Text(
                'SCROLL',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white30
                      : Colors.black38,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 1,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white30
                          : Colors.black26,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildFloatingShapes(Size size) {
    return [
      // Rotating ring
      AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Positioned(
            right: size.width * 0.1,
            top: size.height * 0.2,
            child: Transform.rotate(
              angle: _floatController.value * math.pi * 2,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF00FFA3).withValues(alpha: .15),
                    width: 1,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Positioned(
            right: size.width * 0.5,
            top: size.height * 0.2,
            child: Transform.rotate(
              angle: _floatController.value * math.pi * 2,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF00FFA3).withValues(alpha: .15),
                    width: 1,
                  ),
                ),
              ),
            ),
          );
        },
      ),

      // Floating diamond
      AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Positioned(
            right: size.width * 0.25,
            bottom: size.height * 0.25,
            child: Transform.translate(
              offset: Offset(
                0,
                math.sin(_floatController.value * math.pi * 2) * 20,
              ),
              child: Transform.rotate(
                angle: math.pi / 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF8B5CF6).withValues(alpha: .3),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),

      // Small dot cluster
      AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Positioned(
            left: size.width * 0.2,
            top: size.height * 0.15,
            child: Transform.translate(
              offset: Offset(
                math.cos(_floatController.value * math.pi * 2) * 10,
                math.sin(_floatController.value * math.pi * 2) * 15,
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF006E).withValues(alpha: .4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FFA3).withValues(alpha: .3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: .4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Positioned(
            left: size.width * 0.6,
            top: size.height * 0.15,
            child: Transform.translate(
              offset: Offset(
                math.cos(_floatController.value * math.pi * 2) * 10,
                math.sin(_floatController.value * math.pi * 2) * 15,
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF006E).withValues(alpha: .4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FFA3).withValues(alpha: .3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: .4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ];
  }
}

// === Stat Item ===
class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white38
                : Colors.black.withValues(alpha: .6),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

// === Neon Button ===
class _NeonButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _NeonButton({
    required this.text,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<_NeonButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = widget.isPrimary
        ? (isDark ? const Color(0xFF00FFA3) : const Color(0xFF3B82F6))
        : (isDark ? const Color(0xFF8B5CF6) : const Color(0xFFEC4899));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_isHovered ? accentColor : accentColor.withValues(alpha: .1))
                : (_isHovered
                      ? Colors.white.withValues(alpha: .08)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isPrimary
                  ? accentColor.withValues(alpha: _isHovered ? 1.0 : 0.3)
                  : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: _isHovered ? 0.3 : 0.1)
                        : Colors.black.withValues(
                            alpha: _isHovered ? 0.2 : 0.1,
                          )),
              width: 1,
            ),
            boxShadow: _isHovered && widget.isPrimary
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: .3),
                      blurRadius: 20,
                      spreadRadius: -5,
                      offset: const Offset(0, 5),
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
                  color: widget.isPrimary
                      ? (_isHovered
                            ? Theme.of(context).scaffoldBackgroundColor
                            : accentColor)
                      : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 10),
              AnimatedSlide(
                offset: _isHovered ? const Offset(0.15, 0) : Offset.zero,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  widget.icon,
                  color: widget.isPrimary
                      ? (_isHovered
                            ? Theme.of(context).scaffoldBackgroundColor
                            : accentColor)
                      : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
