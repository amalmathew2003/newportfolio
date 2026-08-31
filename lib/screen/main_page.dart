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
import 'package:my_portfolio/widgets/scroll_progress_bar.dart';
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

  Offset _mousePos = Offset.zero;
  bool _navScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    final viewportHeight = MediaQuery.of(context).size.height;

    // Nav shadow on scroll
    final shouldShowShadow = scrollOffset > 20;
    if (shouldShowShadow != _navScrolled) {
      setState(() => _navScrolled = shouldShowShadow);
    }

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
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOutQuart,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = AppColors.accent(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background(context),
      body: Stack(
        children: [
          // === SUBTLE GRID BACKGROUND ===
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: isDark ? 0.03 : 0.04,
                child: CustomPaint(
                  painter: _GridPainter(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),

          // === CONTENT ===
          MouseRegion(
            onHover: (event) => setState(() => _mousePos = event.localPosition),
            child: Stack(
              children: [
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

                // === CURSOR ATMOSPHERIC LIGHTING ===
                if (!isMobile)
                  Positioned(
                    left: _mousePos.dx - 350,
                    top: _mousePos.dy - 350,
                    child: IgnorePointer(
                      child: Container(
                        width: 700,
                        height: 700,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              accentColor.withValues(alpha: isDark ? 0.04 : 0.06),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // === SIDE DOT NAV (DESKTOP) ===
          if (!isMobile)
            Positioned(
              right: 28,
              top: 0,
              bottom: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_sectionLabels.length, (index) {
                    final isActive = _activeSection == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: GestureDetector(
                        onTap: () => _scrollToSection(index),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Tooltip(
                            message: _sectionLabels[index],
                            preferBelow: false,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOutCubic,
                              width: isActive ? 24 : 6,
                              height: isActive ? 6 : 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: isActive
                                    ? accentColor
                                    : accentColor.withValues(alpha: 0.2),
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: accentColor.withValues(alpha: 0.4),
                                          blurRadius: 12,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : [],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

          // === TOP NAV + SCROLL PROGRESS ===
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTopNav(isMobile, accentColor, isDark),
                ScrollProgressBar(
                  scrollController: _scrollController,
                  color: accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNav(bool isMobile, Color accentColor, bool isDark) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 60,
            vertical: 18,
          ),
          decoration: BoxDecoration(
            color: AppColors.background(context).withValues(alpha: _navScrolled ? 0.9 : 0.7),
            border: Border(
              bottom: BorderSide(
                color: _navScrolled
                    ? AppColors.subtleBorder(context, alpha: 0.12)
                    : Colors.transparent,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              GestureDetector(
                onTap: () => _scrollToSection(0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'AMAL MATHEW',
                        style: GoogleFonts.inter(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isMobile)
                Row(
                  children: [
                    ...List.generate(_sectionLabels.length, (index) {
                      final isActive = _activeSection == index;
                      return Padding(
                        padding: const EdgeInsets.only(left: 36),
                        child: _NavItem(
                          label: _sectionLabels[index],
                          isActive: isActive,
                          accentColor: accentColor,
                          onTap: () => _scrollToSection(index),
                        ),
                      );
                    }),
                    const SizedBox(width: 36),
                    const _ThemeToggle(),
                  ],
                ),
              if (isMobile)
                Row(
                  children: [
                    const _ThemeToggle(),
                    const SizedBox(width: 14),
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
    final accentColor = AppColors.accent(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.richBlack.withValues(alpha: 0.97)
                    : AppColors.pureWhite.withValues(alpha: 0.97),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.06),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 36,
                    height: 3,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(_sectionLabels.length, (index) {
                    final isActive = _activeSection == index;
                    return ListTile(
                      title: Text(
                        _sectionLabels[index],
                        style: GoogleFonts.inter(
                          color: isActive
                              ? accentColor
                              : (isDark ? Colors.white.withValues(alpha: 0.54) : Colors.black.withValues(alpha: 0.45)),
                          fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                          letterSpacing: 2.5,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _scrollToSection(index);
                      },
                    );
                  }),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Nav Item ────────────────────────────────────────────────────────────────

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
    final showActive = widget.isActive || _isHovered;

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: GoogleFonts.inter(
                color: showActive
                    ? widget.accentColor
                    : (isDark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30)),
                fontSize: 10,
                fontWeight: showActive ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: 1.8,
              ),
              child: Text(widget.label),
            ),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: showActive ? 18 : 0,
              height: 1.5,
              decoration: BoxDecoration(
                color: widget.accentColor,
                borderRadius: BorderRadius.circular(1),
                boxShadow: widget.isActive
                    ? [
                        BoxShadow(
                          color: widget.accentColor.withValues(alpha: 0.4),
                          blurRadius: 6,
                        ),
                      ]
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Theme Toggle ─────────────────────────────────────────────────────────────

class _ThemeToggle extends StatefulWidget {
  const _ThemeToggle();

  @override
  State<_ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<_ThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _rotateAnim = Tween<double>(begin: 0, end: 0.5).animate(
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
    final themeService = Provider.of<ThemeService>(context);
    final isDark = themeService.isDarkMode;
    final accentColor = AppColors.accent(context);

    return GestureDetector(
      onTap: () {
        _ctrl.forward(from: 0);
        themeService.toggleTheme();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _rotateAnim,
          builder: (_, child) => Transform.rotate(
            angle: _rotateAnim.value * 2 * 3.14159,
            child: child,
          ),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.subtleBorder(context, alpha: 0.15),
              ),
            ),
            child: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: accentColor,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Mobile Menu Button ───────────────────────────────────────────────────────

class _MobileMenuButton extends StatelessWidget {
  final VoidCallback onTap;
  const _MobileMenuButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.accent(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.subtleBorder(context, alpha: 0.15),
          ),
        ),
        child: Icon(Icons.menu_rounded, color: accentColor, size: 18),
      ),
    );
  }
}

// ─── Background Grid Painter ──────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    const spacing = 60.0;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
