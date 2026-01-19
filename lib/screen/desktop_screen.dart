import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/service/downloadcv.dart';
import 'dart:math' as math;

class DesktopScreen extends StatefulWidget {
  final VoidCallback? onContactTap;
  const DesktopScreen({super.key, this.onContactTap});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      height: size.height,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
      child: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: 100,
            right: 50,
            child: _FloatingShape(
              size: 200,
              color: Colors.blueAccent.withOpacity(0.1),
              duration: 6,
            ),
          ),
          Positioned(
            bottom: 200,
            left: 50,
            child: _FloatingShape(
              size: 150,
              color: Colors.purpleAccent.withOpacity(0.1),
              duration: 8,
            ),
          ),

          // Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              // "Available for work" pill
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00D2FF), // Bright Blue
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF00D2FF),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'AVAILABLE FOR WORK',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Main Headline with Staggered Animation
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'BUILDING',
                  style: GoogleFonts.syne(
                    fontSize: isMobile ? 50 : 120,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 0.9,
                    letterSpacing: -2,
                  ),
                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 400),
                child: AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: const [
                            Colors.white38,
                            Colors.white,
                            Colors.white38,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                          begin: Alignment(
                            -1.0 + (_shimmerController.value * 3),
                            0.0,
                          ),
                          end: Alignment(
                            1.0 + (_shimmerController.value * 3),
                            0.0,
                          ),
                          tileMode: TileMode.clamp,
                        ).createShader(bounds);
                      },
                      child: Text(
                        'DIGITAL',
                        style: GoogleFonts.syne(
                          fontSize: isMobile ? 50 : 120,
                          fontWeight: FontWeight.w800,
                          color:
                              Colors.white, // Color is overridden by ShaderMask
                          height: 0.9,
                          letterSpacing: -2,
                        ),
                        textAlign: isMobile
                            ? TextAlign.center
                            : TextAlign.start,
                      ),
                    );
                  },
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 600),
                child: Text(
                  'EXPERIENCES',
                  style: GoogleFonts.syne(
                    fontSize: isMobile ? 50 : 110,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 0.9,
                    letterSpacing: -2,
                  ),
                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                ),
              ),

              const SizedBox(height: 40),

              // Description & CTA
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 800),
                child: SizedBox(
                  width: isMobile ? double.infinity : 600,
                  child: Column(
                    crossAxisAlignment: isMobile
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I\'m Amal Mathew, a Flutter Developer & UI/UX Designer crafting seamless mobile and web applications with a focus on motion and interaction.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.6,
                        ),
                        textAlign: isMobile
                            ? TextAlign.center
                            : TextAlign.start,
                      ),
                      const SizedBox(height: 40),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: isMobile
                            ? WrapAlignment.center
                            : WrapAlignment.start,
                        children: [
                          _ModernButton(
                            text: 'Download Resume',
                            isFilled: true,
                            onTap: () => downloadCV(context),
                            icon: Icons.download_rounded,
                          ),
                          _ModernButton(
                            text: 'Contact Me',
                            isFilled: false,
                            onTap: widget.onContactTap ?? () {},
                            icon: Icons.arrow_forward_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///===================================ModernButton===================================//

class _ModernButton extends StatefulWidget {
  final String text;
  final bool isFilled;
  final VoidCallback onTap;
  final IconData icon;

  const _ModernButton({
    required this.text,
    required this.isFilled,
    required this.onTap,
    required this.icon,
  });

  @override
  State<_ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<_ModernButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: widget.isFilled
                ? (_isHovered ? const Color(0xFF00D2FF) : Colors.white)
                : (_isHovered
                      ? Colors.white.withOpacity(0.1)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: widget.isFilled
                  ? Colors.transparent
                  : (_isHovered ? Colors.white : Colors.white24),
            ),
            boxShadow: _isHovered && widget.isFilled
                ? [
                    const BoxShadow(
                      color: Color(0xFF00D2FF),
                      blurRadius: 20,
                      spreadRadius: -5,
                      offset: Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text.toUpperCase(),
                style: GoogleFonts.inter(
                  color: widget.isFilled ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSlide(
                offset: _isHovered ? const Offset(0.2, 0) : Offset.zero,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: Icon(
                  widget.icon,
                  color: widget.isFilled ? Colors.black : Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///===================================FloatingShape===================================//

class _FloatingShape extends StatefulWidget {
  final double size;
  final Color color;
  final int duration;

  const _FloatingShape({
    required this.size,
    required this.color,
    required this.duration,
  });

  @override
  State<_FloatingShape> createState() => _FloatingShapeState();
}

class _FloatingShapeState extends State<_FloatingShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_controller.value * 2 * math.pi) * 20),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              boxShadow: [
                BoxShadow(
                  color: widget.color,
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
