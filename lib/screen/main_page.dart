import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/service/theme_service.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _pulseController;

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
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.primaryRed : AppColors.charcoal;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // === SOLID BACKGROUND ===
          Positioned.fill(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),

          // === NOISE TEXTURE ===
          Positioned.fill(
            child: Opacity(
              opacity: 0.02,
              child: CustomPaint(
                painter: _NoisePainter(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),

          // === CONTENT ===
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
                Container(key: _sectionKeys[3], child: const ExperienceScreen()),
                Container(key: _sectionKeys[4], child: const ProjectsScreen()),
                Container(key: _sectionKeys[5], child: const ContactMe()),
              ],
            ),
          ),

          // === SIDE NAV (DESKTOP) ===
          if (!isMobile)
            Positioned(
              right: 30,
              top: 0,
              bottom: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_sectionLabels.length, (index) {
                    final isActive = _activeSection == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: GestureDetector(
                        onTap: () => _scrollToSection(index),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: isActive ? 12 : 6,
                            height: isActive ? 12 : 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive ? accentColor : Colors.white24,
                              boxShadow: isActive ? [
                                BoxShadow(
                                  color: accentColor.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                )
                              ] : [],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

          // === TOP NAV ===
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopNav(isMobile, accentColor, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNav(bool isMobile, Color accentColor, bool isDark) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 60,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
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
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AMAL MATHEW',
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              if (!isMobile)
                Row(
                  children: [
                    ...List.generate(_sectionLabels.length, (index) {
                      final isActive = _activeSection == index;
                      return Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: _NavItem(
                          label: _sectionLabels[index],
                          isActive: isActive,
                          accentColor: accentColor,
                          onTap: () => _scrollToSection(index),
                        ),
                      );
                    }),
                    const SizedBox(width: 35),
                    const _ThemeToggle(),
                  ],
                ),
              if (isMobile)
                Row(
                  children: [
                    const _ThemeToggle(),
                    const SizedBox(width: 12),
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
    final accentColor = isDark ? AppColors.primaryRed : AppColors.charcoal;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111111) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              ...List.generate(_sectionLabels.length, (index) {
                final isActive = _activeSection == index;
                return ListTile(
                  title: Text(
                    _sectionLabels[index],
                    style: GoogleFonts.inter(
                      color: isActive ? accentColor : (isDark ? Colors.white70 : Colors.black54),
                      fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _scrollToSection(index);
                  },
                );
              }),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final Color accentColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: GoogleFonts.inter(
                color: widget.isActive 
                  ? widget.accentColor 
                  : (_isHovered ? (isDark ? Colors.white : Colors.black) : (isDark ? Colors.white38 : Colors.black38)),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: widget.isActive || _isHovered ? 15 : 0,
              height: 2,
              color: widget.accentColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final isDark = themeService.isDarkMode;
    final accentColor = isDark ? AppColors.primaryRed : AppColors.charcoal;

    return GestureDetector(
      onTap: themeService.toggleTheme,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Icon(
          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          color: accentColor,
          size: 20,
        ),
      ),
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  final VoidCallback onTap;
  const _MobileMenuButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.primaryRed : AppColors.charcoal;
    return GestureDetector(
      onTap: onTap,
      child: Icon(Icons.menu_rounded, color: accentColor),
    );
  }
}

class _NoisePainter extends CustomPainter {
  final Color color;
  _NoisePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    final paint = Paint()..color = color.withValues(alpha: 0.1);
    for (int i = 0; i < 1000; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
