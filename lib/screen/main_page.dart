import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:my_portfolio/service/theme_service.dart';
import 'package:my_portfolio/screen/aboutme.dart';
import 'package:my_portfolio/screen/contactme.dart';
import 'package:my_portfolio/screen/projects_screen.dart';
import 'package:my_portfolio/screen/skills_screen.dart';
import 'package:my_portfolio/screen/experience_screen.dart';
import 'package:my_portfolio/widgets/aurora_waves.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Single animation controller for subtle background motion
  late AnimationController _meshController;
  // Separate lightweight controller for nav pulse
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
    // Single slow controller instead of 3 fast ones
    _meshController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
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
    _meshController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Offset _bgMousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: MouseRegion(
        onHover: (event) {
          if (isMobile) return;
          setState(() {
            _bgMousePos = Offset(
              (event.position.dx - size.width / 2) / (size.width / 2),
              (event.position.dy - size.height / 2) / (size.height / 2),
            );
          });
        },
        child: Stack(
          children: [
            // === STATIC MESH GRADIENT BACKGROUND (no per-frame rebuild) ===
            _buildMeshBackground(size),

            // === AURORA WAVES (flowing northern-light effect) ===
            Positioned.fill(
              child: AuroraWaves(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? const [
                        Color(0xFF00FFA3),
                        Color(0xFF8B5CF6),
                        Color(0xFFFF006E),
                        Color(0xFF00D4FF),
                      ]
                    : const [
                        Color(0xFF3B82F6),
                        Color(0xFFEC4899),
                        Color(0xFF96805D),
                        Color(0xFF10B981),
                      ],
              ),
            ),

            // === NOISE TEXTURE OVERLAY (cached, never repaints) ===
            Positioned.fill(
              child: RepaintBoundary(
                child: Opacity(
                  opacity: 0.03,
                  child: CustomPaint(
                    painter: _NoisePainter(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    isComplex: true,
                    willChange: false,
                  ),
                ),
              ),
            ),

            // === SCAN LINE EFFECT (cached, never repaints) ===
            Positioned.fill(
              child: RepaintBoundary(
                child: Opacity(
                  opacity: 0.015,
                  child: CustomPaint(
                    painter: _ScanLinePainter(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    isComplex: true,
                    willChange: false,
                  ),
                ),
              ),
            ),

            // === MAIN SCROLLABLE CONTENT ===
            SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    key: _sectionKeys[0],
                    child: DesktopScreen(
                      onContactTap: () => _scrollToSection(5),
                    ),
                  ),
                  Container(key: _sectionKeys[1], child: const AboutMe()),
                  Container(key: _sectionKeys[2], child: const SkillsScreen()),
                  Container(
                    key: _sectionKeys[3],
                    child: const ExperienceScreen(),
                  ),
                  Container(
                    key: _sectionKeys[4],
                    child: const ProjectsScreen(),
                  ),
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopNav(isMobile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeshBackground(Size size) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: Offset.zero, end: _bgMousePos),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, mouse, child) {
        return RepaintBoundary(
          child: AnimatedBuilder(
            animation: _meshController,
            builder: (context, child) {
              final v = _meshController.value;
              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),

                  // Blob 1 — Emerald (Follows mouse slightly)
                  Positioned(
                    top: -200 + (v * 80) + (mouse.dy * 40),
                    left: -150 + (v * 60) + (mouse.dx * 60),
                    child: _MeshBlob(
                      size: size.width * 0.6,
                      color: const Color(0xFF00FFA3),
                      opacity: 0.08,
                    ),
                  ),

                  // Blob 2 — Violet
                  Positioned(
                    bottom: -300 + ((1 - v) * 50) - (mouse.dy * 30),
                    right: -200 + ((1 - v) * 80) - (mouse.dx * 50),
                    child: _MeshBlob(
                      size: size.width * 0.7,
                      color: const Color(0xFF8B5CF6),
                      opacity: 0.06,
                    ),
                  ),

                  // Blob 3 — Pink
                  Positioned(
                    top: size.height * 0.3 + (mouse.dy * 50),
                    right: size.width * 0.1 + (mouse.dx * 30),
                    child: Transform.translate(
                      offset: Offset(
                        sin(v * 2 * pi) * 60,
                        cos(v * 2 * pi) * 40,
                      ),
                      child: _MeshBlob(
                        size: 400,
                        color: const Color(0xFFFF006E),
                        opacity: 0.04,
                      ),
                    ),
                  ),

                  // Blob 4 — Cyan
                  Positioned(
                    top: size.height * 0.6 - (mouse.dy * 40),
                    left: size.width * 0.05 - (mouse.dx * 20),
                    child: Transform.translate(
                      offset: Offset(
                        cos(v * 2 * pi) * 40,
                        sin(v * 2 * pi) * 30,
                      ),
                      child: _MeshBlob(
                        size: 350,
                        color: const Color(0xFF00D4FF),
                        opacity: 0.04,
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSideNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: .03)
            : Colors.black.withValues(alpha: .03),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: .05)
              : Colors.black.withValues(alpha: .05),
        ),
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
                child: isActive
                    // Only the active dot animates with the pulse controller
                    ? AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color(0xFF00FFA3)
                                  : const Color(0xFF3B82F6),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00FFA3).withValues(
                                    alpha: 0.3 + (_pulseController.value * 0.3),
                                  ),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    // Inactive dots are completely static
                    : Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: .3)
                              : Colors.black.withValues(alpha: .3),
                        ),
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
            color: Theme.of(
              context,
            ).scaffoldBackgroundColor.withValues(alpha: .7),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: .05)
                    : Colors.black.withValues(alpha: .05),
              ),
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
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF00FFA3)
                          : const Color(0xFF96805D), // Bronze
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (Theme.of(context).brightness == Brightness.dark
                                      ? const Color(0xFF00FFA3)
                                      : const Color(0xFF96805D))
                                  .withValues(alpha: .5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Amal Mathew',
                    style: Theme.of(context).brightness == Brightness.dark
                        ? TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          )
                        : GoogleFonts.playfairDisplay(
                            color: const Color(0xFF111111),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                  ),
                ],
              ),

              // Nav Links (desktop only)
              if (!isMobile)
                Row(
                  children: [
                    ...List.generate(_sectionLabels.length, (index) {
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
                    const SizedBox(width: 32),
                    _ThemeToggle(),
                  ],
                ),
              if (isMobile)
                Row(
                  children: [
                    _ThemeToggle(),
                    const SizedBox(width: 8),
                    _MobileMenuButton(onTap: () => _showMobileMenu(context)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF12121A) : const Color(0xFFF9F7F2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: .08)
                    : Colors.black.withValues(alpha: .08),
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 24),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: .15)
                        : Colors.black.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ...List.generate(_sectionLabels.length, (index) {
                  final isActive = _activeSection == index;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 4,
                    ),
                    leading: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? (isDark
                                  ? const Color(0xFF00FFA3)
                                  : const Color(0xFF3B82F6))
                            : (isDark
                                  ? Colors.white.withValues(alpha: .2)
                                  : Colors.black.withValues(alpha: .2)),
                      ),
                    ),
                    title: Text(
                      _sectionLabels[index],
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive
                            ? (isDark
                                  ? const Color(0xFF00FFA3)
                                  : const Color(0xFF111111))
                            : (isDark ? Colors.white54 : Colors.black54),
                        letterSpacing: 3,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _scrollToSection(index);
                    },
                  );
                }),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
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
                ? (Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF00FFA3)
                      : const Color(0xFF96805D))
                : _hovered
                ? (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF111111))
                : (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white54
                      : const Color(0xFF111111).withValues(alpha: .4)),
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

// === Noise Painter (static, seeded) ===
class _NoisePainter extends CustomPainter {
  final Color color;
  _NoisePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // fixed seed = deterministic
    final paint = Paint()..color = color;
    for (int i = 0; i < 500; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) =>
      oldDelegate.color != color;
}

// === Scan Line Painter (static) ===
class _ScanLinePainter extends CustomPainter {
  final Color color;
  _ScanLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.5);
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final isDark = themeService.isDarkMode;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: themeService.toggleTheme,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: .05)
                : Colors.black.withValues(alpha: .05),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? const Color(0xFF00FFA3) : const Color(0xFF96805D),
            size: 20,
          ),
        ),
      ),
    );
  }
}

// === Mobile Menu Button ===
class _MobileMenuButton extends StatefulWidget {
  final VoidCallback onTap;
  const _MobileMenuButton({required this.onTap});

  @override
  State<_MobileMenuButton> createState() => _MobileMenuButtonState();
}

class _MobileMenuButtonState extends State<_MobileMenuButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isHovered
                ? (isDark
                      ? Colors.white.withValues(alpha: .1)
                      : Colors.black.withValues(alpha: .1))
                : (isDark
                      ? Colors.white.withValues(alpha: .05)
                      : Colors.black.withValues(alpha: .05)),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.menu_rounded,
            color: isDark ? const Color(0xFF00FFA3) : const Color(0xFF111111),
            size: 20,
          ),
        ),
      ),
    );
  }
}
