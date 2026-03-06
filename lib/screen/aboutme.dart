import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> with SingleTickerProviderStateMixin {
  bool _visible = false;
  late AnimationController _orbController;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _orbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return VisibilityDetector(
      key: const Key('about-me-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() {
            _visible = true;
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 100,
          vertical: isMobile ? 80 : 120,
        ),
        child: Column(
          children: [
            // Section Header
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: _buildSectionHeader(isMobile),
              ),

            SizedBox(height: isMobile ? 60 : 100),

            // Content
            if (isMobile) _buildMobileLayout() else _buildDesktopLayout(size),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(bool isMobile) {
    return Row(
      children: [
        // Number tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  (Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF00FFA3)
                          : const Color(0xFF96805D))
                      .withValues(alpha: .3),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '01',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF00FFA3)
                  : const Color(0xFF96805D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Line
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF00FFA3)
                          : const Color(0xFF3B82F6))
                      .withValues(alpha: .3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'ABOUT',
          style: Theme.of(context).brightness == Brightness.dark
              ? GoogleFonts.spaceGrotesk(
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white54,
                  letterSpacing: 4,
                )
              : GoogleFonts.playfairDisplay(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111111),
                  letterSpacing: 2,
                ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        if (_visible) _buildProfileOrb(true),
        const SizedBox(height: 50),
        if (_visible) _buildInfoContent(true),
      ],
    );
  }

  Widget _buildDesktopLayout(Size size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left — Profile orb
        if (_visible) _buildProfileOrb(false),
        SizedBox(width: size.width * 0.06),
        // Right — About info
        if (_visible) Expanded(child: _buildInfoContent(false)),
      ],
    );
  }

  Offset _targetMousePosition = Offset.zero;

  Widget _buildProfileOrb(bool isMobile) {
    final imageSize = isMobile ? 200.0 : 280.0;

    return MouseRegion(
      onHover: (event) {
        if (isMobile) return;
        final renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;
        final center = Offset(size.width / 2, size.height / 2);
        setState(() {
          _targetMousePosition = Offset(
            (event.localPosition.dx - center.dx) / (size.width / 2),
            (event.localPosition.dy - center.dy) / (size.height / 2),
          );
        });
      },
      onExit: (_) => setState(() => _targetMousePosition = Offset.zero),
      child: FadeInLeft(
        duration: const Duration(milliseconds: 800),
        child: AnimatedBuilder(
          animation: _orbController,
          builder: (context, child) {
            return TweenAnimationBuilder<Offset>(
              tween: Tween<Offset>(
                begin: Offset.zero,
                end: _targetMousePosition,
              ),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              builder: (context, mousePos, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(-mousePos.dy * 0.15)
                    ..rotateY(mousePos.dx * 0.15),
                  alignment: Alignment.center,
                  child: Container(
                    width: imageSize + 20,
                    height: imageSize + 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color.lerp(
                          (Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF00FFA3)
                                  : const Color(0xFF3B82F6))
                              .withValues(alpha: .2),
                          (Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF8B5CF6)
                                  : const Color(0xFFEC4899))
                              .withValues(alpha: .4),
                          _orbController.value,
                        )!,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.lerp(
                            const Color(0xFF00FFA3).withValues(alpha: .1),
                            const Color(0xFF8B5CF6).withValues(alpha: .2),
                            _orbController.value,
                          )!,
                          blurRadius: 40,
                          spreadRadius: 5,
                          offset: Offset(mousePos.dx * 10, mousePos.dy * 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Moving background glass effect
                        Transform.translate(
                          offset: Offset(mousePos.dx * -15, mousePos.dy * -15),
                          child: Container(
                            width: imageSize - 20,
                            height: imageSize - 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? const Color(0xFF00FFA3)
                                          : const Color(0xFF3B82F6))
                                      .withValues(alpha: .1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Rotating dashed border effect
                        Transform.rotate(
                          angle: _orbController.value * math.pi * 2,
                          child: CustomPaint(
                            size: Size(imageSize + 20, imageSize + 20),
                            painter: _DashedCirclePainter(
                              color:
                                  (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? const Color(0xFF00FFA3)
                                          : const Color(0xFF3B82F6))
                                      .withValues(alpha: .15),
                            ),
                          ),
                        ),
                        // Image
                        Transform.translate(
                          offset: Offset(mousePos.dx * 10, mousePos.dy * 10),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/portfolio.png',
                              width: imageSize,
                              height: imageSize,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: imageSize,
                                  height: imageSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(
                                      0xFF00FFA3,
                                    ).withValues(alpha: .1),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Color(0xFF00FFA3),
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
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoContent(bool isMobile) {
    return FadeInRight(
      duration: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            "Who am I?",
            style: GoogleFonts.spaceGrotesk(
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 24),

          // Bio paragraphs
          _buildBioParagraph(
            "A passionate Flutter developer with a knack for building beautiful, responsive, and high-performance mobile and web applications. I enjoy turning ideas into real, functional apps and creating smooth user experiences.",
            isMobile,
          ),
          const SizedBox(height: 16),
          _buildBioParagraph(
            "With hands-on experience in Flutter, Dart, Provider, Dio, and Firebase, I love exploring new technologies, optimizing code, and solving challenging problems.",
            isMobile,
            opacity: 0.5,
          ),

          const SizedBox(height: 40),

          // Tech Stack Grid
          _buildTechStackGrid(isMobile),
        ],
      ),
    );
  }

  Widget _buildBioParagraph(
    String text,
    bool isMobile, {
    double opacity = 0.6,
  }) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: isMobile ? 14 : 16,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: opacity)
            : const Color(0xFF111111).withValues(alpha: opacity + 0.15),
        height: 1.8,
      ),
      textAlign: isMobile ? TextAlign.center : TextAlign.start,
    );
  }

  Widget _buildTechStackGrid(bool isMobile) {
    final techs = [
      _TechItem('Flutter', const Color(0xFF00FFA3)),
      _TechItem('Dart', const Color(0xFF8B5CF6)),
      _TechItem('Firebase', const Color(0xFFFF006E)),
      _TechItem('Provider', const Color(0xFF00D4FF)),
      _TechItem('Bloc', const Color(0xFFFFC107)),
      _TechItem('UI/UX', const Color(0xFF00D4FF)),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: techs.map((tech) => _TechChip(tech: tech)).toList(),
    );
  }
}

class _TechChip extends StatefulWidget {
  final _TechItem tech;
  const _TechChip({required this.tech});

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.05 : 1.0, _isHovered ? 1.05 : 1.0),
        decoration: BoxDecoration(
          color: widget.tech.color.withValues(alpha: _isHovered ? .12 : .05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.tech.color.withValues(alpha: _isHovered ? .4 : .15),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.tech.color.withValues(alpha: .15),
                    blurRadius: 10,
                    spreadRadius: -2,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: widget.tech.color,
                shape: BoxShape.circle,
                boxShadow: _isHovered
                    ? [BoxShadow(color: widget.tech.color, blurRadius: 4)]
                    : [],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.tech.name,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                color: widget.tech.color,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TechItem {
  final String name;
  final Color color;
  _TechItem(this.name, this.color);
}

// Dashed circle painter for profile orb
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    const dashCount = 40;
    const dashAngle = (2 * math.pi) / dashCount;
    const gapFraction = 0.4;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      final sweepAngle = dashAngle * (1 - gapFraction);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
