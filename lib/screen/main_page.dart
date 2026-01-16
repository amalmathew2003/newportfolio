import 'package:flutter/material.dart';
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

class _PortfolioScrollablePageState extends State<PortfolioScrollablePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: Stack(
        children: [
          // === PARALLAX BACKGROUND LAYERS ===

          // Layer 1: Deep background gradient (slowest)
          Positioned(
            top: -_scrollOffset * 0.1,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0a0a0a),
                    const Color(0xFF1a1a2e).withOpacity(0.8),
                    const Color(0xFF16213e).withOpacity(0.6),
                    const Color(0xFF0f3460).withOpacity(0.4),
                    const Color(0xFF0a0a0a),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Layer 2: Large floating orb - Purple (medium speed)
          Positioned(
            top: 150 - _scrollOffset * 0.3,
            left: size.width * 0.05,
            child: _buildParallaxOrb(
              size: 350,
              color: const Color(0xFF667eea),
              opacity: (1 - _scrollOffset / 800).clamp(0.0, 0.3),
            ),
          ),

          // Layer 3: Medium orb - Pink (medium-fast)
          Positioned(
            top: size.height * 0.8 - _scrollOffset * 0.25,
            right: size.width * 0.1,
            child: _buildParallaxOrb(
              size: 250,
              color: const Color(0xFFf093fb),
              opacity: ((1 - (_scrollOffset - 300) / 1000)).clamp(0.0, 0.25),
            ),
          ),

          // Layer 4: Small orb - Cyan (fast)
          Positioned(
            top: size.height * 1.5 - _scrollOffset * 0.2,
            left: size.width * 0.3,
            child: _buildParallaxOrb(
              size: 200,
              color: const Color(0xFF00d4ff),
              opacity: ((1 - (_scrollOffset - 800) / 1200)).clamp(0.0, 0.2),
            ),
          ),

          // Layer 5: Extra orb for skills section
          Positioned(
            top: size.height * 2.2 - _scrollOffset * 0.15,
            right: size.width * 0.2,
            child: _buildParallaxOrb(
              size: 180,
              color: const Color(0xFFf5576c),
              opacity: ((1 - (_scrollOffset - 1500) / 1000)).clamp(0.0, 0.2),
            ),
          ),

          // Layer 6: Projects section orb
          Positioned(
            top: size.height * 3 - _scrollOffset * 0.12,
            left: size.width * 0.15,
            child: _buildParallaxOrb(
              size: 220,
              color: const Color(0xFF764ba2),
              opacity: ((1 - (_scrollOffset - 2000) / 1000)).clamp(0.0, 0.2),
            ),
          ),

          // === DECORATIVE LINES (subtle parallax) ===
          Positioned(
            top: size.height * 0.5 - _scrollOffset * 0.05,
            left: 0,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: size.width * 1.5,
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFF667eea).withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // === MAIN SCROLLABLE CONTENT ===
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: const [
                // Section 1: Landing Page
                DesktopScreen(),

                // Section 2: About Me
                AboutMe(),

                // Section 3: Skills
                SkillsScreen(),

                // Section 4: Projects
                ProjectsScreen(),

                // Section 5: Contact Me
                ContactMe(),
              ],
            ),
          ),

          // === SCROLL PROGRESS INDICATOR ===
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 3,
              child: LinearProgressIndicator(
                value: _scrollOffset / (size.height * 4),
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF00d4ff),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParallaxOrb({
    required double size,
    required Color color,
    required double opacity,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(opacity),
            color.withOpacity(opacity * 0.5),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
    );
  }
}
