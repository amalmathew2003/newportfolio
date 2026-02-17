import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:my_portfolio/screen/aboutme.dart';
import 'package:my_portfolio/screen/contactme.dart';
import 'package:my_portfolio/screen/projects_screen.dart';
import 'package:my_portfolio/screen/skills_screen.dart';
import 'package:my_portfolio/screen/experience_screen.dart';
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

  // Animated mesh controllers
  late AnimationController _meshController1;
  late AnimationController _meshController2;
  late AnimationController _meshController3;
  late AnimationController _pulseController;

  // Navigation
  int _activeSection = 0;
  final List<String> _sectionLabels = [
    'HOME',
    'ABOUT',
    'SKILLS',
    'WORK',
    'PROJECTS',
    'CONTACT',
  ];
  final List<GlobalKey> _sectionKeys = List.generate(6, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _meshController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
    _meshController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat(reverse: true);
    _meshController3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Determine which section is most visible
    final scrollOffset = _scrollController.offset;
    final viewportHeight = MediaQuery.of(context).size.height;

    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final key = _sectionKeys[i];
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position =
            renderBox.localToGlobal(Offset.zero).dy + _scrollController.offset;
        if (scrollOffset + viewportHeight * 0.4 >= position) {
          if (_activeSection != i) {
            setState(() => _activeSection = i);
          }
          break;
        }
      }
    }
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _meshController1.dispose();
    _meshController2.dispose();
    _meshController3.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
          // === ANIMATED MESH GRADIENT BACKGROUND ===
          _buildMeshBackground(size),

          // === NOISE TEXTURE OVERLAY ===
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CustomPaint(painter: _NoisePainter()),
            ),
          ),

          // === SCAN LINE EFFECT ===
          Positioned.fill(
            child: Opacity(
              opacity: 0.015,
              child: CustomPaint(painter: _ScanLinePainter()),
            ),
          ),

          // === MAIN SCROLLABLE CONTENT ===
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Hero Section
                Container(
                  key: _sectionKeys[0],
                  child: DesktopScreen(onContactTap: () => _scrollToSection(5)),
                ),
                // About Section
                Container(key: _sectionKeys[1], child: const AboutMe()),
                // Skills Section
                Container(key: _sectionKeys[2], child: const SkillsScreen()),
                // Experience Section
                Container(
                  key: _sectionKeys[3],
                  child: const ExperienceScreen(),
                ),
                // Projects Section
                Container(key: _sectionKeys[4], child: const ProjectsScreen()),
                // Contact Section
                Container(key: _sectionKeys[5], child: const ContactMe()),
              ],
            ),
          ),

          // === FLOATING SIDE NAVIGATION ===
          if (!isMobile)
            Positioned(
              right: 30,
              top: 0,
              bottom: 0,
              child: Center(child: _buildSideNav()),
            ),

          // === TOP NAVIGATION BAR ===
          Positioned(top: 0, left: 0, right: 0, child: _buildTopNav(isMobile)),
        ],
      ),
    );
  }

  Widget _buildMeshBackground(Size size) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _meshController1,
        _meshController2,
        _meshController3,
      ]),
      builder: (context, child) {
        return Stack(
          children: [
            // Base dark overlay
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5,
                    colors: [Color(0xFF0F0F1A), Color(0xFF0A0A0F)],
                  ),
                ),
              ),
            ),

            // Mesh blob 1 — Emerald Green
            Positioned(
              top: -200 + (_meshController1.value * 100),
              left: -150 + (_meshController2.value * 80),
              child: _MeshBlob(
                size: size.width * 0.7,
                color: const Color(0xFF00FFA3),
                opacity: 0.08,
              ),
            ),

            // Mesh blob 2 — Electric Violet
            Positioned(
              bottom: -300 + (_meshController2.value * -60),
              right: -200 + (_meshController1.value * -100),
              child: _MeshBlob(
                size: size.width * 0.8,
                color: const Color(0xFF8B5CF6),
                opacity: 0.06,
              ),
            ),

            // Mesh blob 3 — Hot Pink
            Positioned(
              top: size.height * 0.3,
              right: size.width * 0.1,
              child: Transform.translate(
                offset: Offset(
                  sin(_meshController3.value * 2 * pi) * 120,
                  cos(_meshController3.value * 2 * pi) * 80,
                ),
                child: _MeshBlob(
                  size: 500,
                  color: const Color(0xFFFF006E),
                  opacity: 0.05,
                ),
              ),
            ),

            // Mesh blob 4 — Cyan accent
            Positioned(
              top: size.height * 0.6,
              left: size.width * 0.05,
              child: Transform.translate(
                offset: Offset(
                  cos(_meshController1.value * 2 * pi) * 60,
                  sin(_meshController2.value * 2 * pi) * 40,
                ),
                child: _MeshBlob(
                  size: 400,
                  color: const Color(0xFF00D4FF),
                  opacity: 0.04,
                ),
              ),
            ),

            // Heavy blur to blend everything
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSideNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .03),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: .05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_sectionLabels.length, (index) {
          final isActive = _activeSection == index;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _scrollToSection(index),
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isActive ? 12 : 6,
                      height: isActive ? 12 : 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? const Color(0xFF00FFA3)
                            : Colors.white.withValues(alpha: .3),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF00FFA3).withValues(
                                    alpha: 0.3 + (_pulseController.value * 0.3),
                                  ),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTopNav(bool isMobile) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 60,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0F).withValues(alpha: .7),
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: .05)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FFA3),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00FFA3).withValues(alpha: .5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Amal Mathew',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),

              // Nav Links (desktop only)
              if (!isMobile)
                Row(
                  children: List.generate(_sectionLabels.length, (index) {
                    final isActive = _activeSection == index;
                    return Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: _NavItem(
                        label: _sectionLabels[index],
                        isActive: isActive,
                        onTap: () => _scrollToSection(index),
                      ),
                    );
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// === Mesh Blob Widget ===
class _MeshBlob extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _MeshBlob({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            Colors.transparent,
          ],
          center: Alignment.center,
          radius: 0.7,
        ),
      ),
    );
  }
}

// === Nav Item ===
class _NavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: widget.isActive
                ? const Color(0xFF00FFA3)
                : _hovered
                ? Colors.white
                : Colors.white54,
            fontSize: 11,
            fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: widget.isActive ? 20 : 0,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFF00FFA3),
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00FFA3).withValues(alpha: .5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === Noise Painter ===
class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < 800; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// === Scan Line Painter ===
class _ScanLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
