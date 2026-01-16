import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:my_portfolio/screen/aboutme.dart';
import 'package:my_portfolio/screen/contactme.dart';
import 'package:my_portfolio/screen/projects_screen.dart';
import 'package:my_portfolio/screen/skills_screen.dart';
import 'desktop_screen.dart';

class PortfolioScrollablePage extends StatefulWidget {
  const PortfolioScrollablePage({super.key});

  @override
  State<PortfolioScrollablePage> createState() =>
      _PortfolioScrollablePageState();
}

class _PortfolioScrollablePageState extends State<PortfolioScrollablePage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  // Aurora Animation Controllers
  late AnimationController _auroraController1;
  late AnimationController _auroraController2;
  late AnimationController _auroraController3;

  @override
  void initState() {
    super.initState();
    _auroraController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _auroraController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
    _auroraController3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _auroraController1.dispose();
    _auroraController2.dispose();
    _auroraController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF030303), // Almost Black
      body: Stack(
        children: [
          // === ELEGANT AURORA BACKGROUND ===

          // Blob 1: Soft Indigo
          AnimatedBuilder(
            animation: _auroraController1,
            builder: (context, child) {
              return Positioned(
                top: -100 + (_auroraController1.value * 50),
                left: -100 + (_auroraController1.value * 20),
                child: Container(
                  width: size.width * 0.8,
                  height: size.height * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF4338ca).withOpacity(0.25),
                        Colors.transparent,
                      ],
                      center: Alignment.center,
                      radius: 0.8,
                    ),
                  ),
                ),
              );
            },
          ),

          // Blob 2: Vibrant Teal/Emerald
          AnimatedBuilder(
            animation: _auroraController2,
            builder: (context, child) {
              return Positioned(
                bottom: -200 + (_auroraController2.value * -30),
                right: -100 + (_auroraController2.value * -50),
                child: Container(
                  width: size.width * 0.9,
                  height: size.height * 0.9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF059669).withOpacity(0.2),
                        Colors.transparent,
                      ],
                      center: Alignment.center,
                      radius: 0.8,
                    ),
                  ),
                ),
              );
            },
          ),

          // Blob 3: Accent Purple/Pink
          AnimatedBuilder(
            animation: _auroraController3,
            builder: (context, child) {
              return Positioned(
                top: size.height * 0.4,
                right: size.width * 0.2,
                child: Opacity(
                  opacity: 0.6,
                  child: Transform.translate(
                    offset: Offset(
                      sin(_auroraController3.value * 2 * pi) * 100,
                      cos(_auroraController3.value * 2 * pi) * 50,
                    ),
                    child: Container(
                      width: 600,
                      height: 600,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFbe185d).withOpacity(0.15),
                            Colors.transparent,
                          ],
                          center: Alignment.center,
                          radius: 0.7,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Blur Filter to smooth everything out
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Grid Overlay (Subtle Tech Feel)
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CustomPaint(painter: _GridPainter()),
            ),
          ),

          // === MAIN SCROLLABLE CONTENT ===
          SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(), // Sturdy feel
            child: Column(
              children: [
                DesktopScreen(
                  onContactTap: () {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                const AboutMe(),
                const SkillsScreen(),
                const ProjectsScreen(),
                const ContactMe(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
