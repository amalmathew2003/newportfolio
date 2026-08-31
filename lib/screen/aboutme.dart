import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:my_portfolio/constants/app_colors.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = AppColors.accent(context);

    return VisibilityDetector(
      key: const Key('about-me-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 100,
          vertical: isMobile ? 80 : 150,
        ),
        child: Column(
          children: [
            // Section Header
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: _buildSectionHeader(isMobile, accentColor, isDark),
              ),

            SizedBox(height: isMobile ? 60 : 100),

            // Main Layout
            if (isMobile)
              _buildMobileLayout(accentColor, isDark)
            else
              _buildDesktopLayout(size, accentColor, isDark),

            const SizedBox(height: 80),

            // Stats Row
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 600),
                child: _buildStatsRow(accentColor, isDark, isMobile),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(bool isMobile, Color accentColor, bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 1,
              color: accentColor.withValues(alpha: 0.25),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'HISTORY',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                  color: isDark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30),
                ),
              ),
            ),
            Container(
              width: 40,
              height: 1,
              color: accentColor.withValues(alpha: 0.25),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'PROFESSIONAL\nPROFILE',
          textAlign: TextAlign.center,
          style: GoogleFonts.libreBodoni(
            fontSize: isMobile ? 34 : 64,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black,
            letterSpacing: -3,
            height: 0.9,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(Color accentColor, bool isDark) {
    return Column(
      children: [
        if (_visible) _buildProfileImage(accentColor, isDark, true),
        const SizedBox(height: 50),
        if (_visible) _buildInfoContent(accentColor, isDark, true),
      ],
    );
  }

  Widget _buildDesktopLayout(Size size, Color accentColor, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_visible) _buildProfileImage(accentColor, isDark, false),
        SizedBox(width: size.width * 0.08),
        if (_visible)
          Expanded(child: _buildInfoContent(accentColor, isDark, false)),
      ],
    );
  }

  Widget _buildProfileImage(Color accentColor, bool isDark, bool isMobile) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 1000),
      child: Stack(
        children: [
          // Outer glow/shadow
          Container(
            width: isMobile ? 250 : 340,
            height: isMobile ? 300 : 440,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                  blurRadius: 50,
                  offset: const Offset(10, 20),
                ),
              ],
            ),
          ),
          // Image frame
          Container(
            width: isMobile ? 250 : 340,
            height: isMobile ? 300 : 440,
            decoration: BoxDecoration(
              color: isDark ? AppColors.richBlack : AppColors.offWhite,
              border: Border.all(
                color: AppColors.subtleBorder(
                  context,
                  alpha: 0.08,
                ),
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/portfolio4.png',
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.92),
                  ),
                ),
                // DEVELOPER tag
                Positioned(
                  left: 0,
                  top: 24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    color: accentColor,
                    child: Text(
                      'DEVELOPER',
                      style: GoogleFonts.inter(
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.black : Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
                // Corner accent
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    color: accentColor.withValues(alpha: 0.15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContent(Color accentColor, bool isDark, bool isMobile) {
    return FadeInRight(
      duration: const Duration(milliseconds: 1000),
      delay: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          // Index label
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '01',
                style: GoogleFonts.libreBodoni(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 18),
              Container(
                width: 1,
                height: 44,
                color: isDark ? Colors.white.withValues(alpha: 0.10) : Colors.black.withValues(alpha: 0.10),
              ),
              const SizedBox(width: 18),
              Text(
                'MISSION\nSTATEMENT',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                  color: isDark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Headline
          Text(
            'Crafting high-performance\ndigital experiences with\nprecision and passion.',
            style: GoogleFonts.libreBodoni(
              fontSize: isMobile ? 22 : 30,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
              height: 1.3,
              letterSpacing: -1,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 28),

          // Body
          Text(
            'A dedicated Flutter developer focused on bridging the gap between cutting-edge design and industrial-grade stability. I specialize in building scalable architectures and immersive user interfaces for the next generation of web and mobile platforms.',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: isDark ? Colors.white.withValues(alpha: 0.45) : Colors.black.withValues(alpha: 0.45),
              height: 1.8,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 44),

          // Tech tag chips
          _buildTechTags(accentColor, isDark, isMobile),
        ],
      ),
    );
  }

  Widget _buildTechTags(Color accentColor, bool isDark, bool isMobile) {
    final techs = ['DART', 'FLUTTER', 'FIREBASE', 'PROVIDER', 'ARCHITECTURE'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: techs.map((t) => _TechTag(label: t, accentColor: accentColor, isDark: isDark)).toList(),
    );
  }

  Widget _buildStatsRow(Color accentColor, bool isDark, bool isMobile) {
    final stats = [
      {'value': '2+', 'label': 'YEARS EXP'},
      {'value': '15+', 'label': 'PROJECTS'},
      {'value': '5+', 'label': 'CLIENTS'},
      {'value': '∞', 'label': 'PASSION'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 32,
        horizontal: isMobile ? 0 : 0,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.subtleBorder(context, alpha: 0.1),
          ),
          bottom: BorderSide(
            color: AppColors.subtleBorder(context, alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((s) => _StatItem(
          value: s['value']!,
          label: s['label']!,
          accentColor: accentColor,
          isDark: isDark,
        )).toList(),
      ),
    );
  }
}

// ─── Tech Tag ─────────────────────────────────────────────────────────────────

class _TechTag extends StatefulWidget {
  final String label;
  final Color accentColor;
  final bool isDark;

  const _TechTag({
    required this.label,
    required this.accentColor,
    required this.isDark,
  });

  @override
  State<_TechTag> createState() => _TechTagState();
}

class _TechTagState extends State<_TechTag> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: _isHovered
              ? widget.accentColor
              : Colors.transparent,
          border: Border.all(
            color: _isHovered
                ? widget.accentColor
                : (widget.isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1)),
          ),
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: _isHovered
                ? (widget.isDark ? Colors.black : Colors.white)
                : (widget.isDark ? Colors.white.withValues(alpha: 0.50) : Colors.black.withValues(alpha: 0.50)),
          ),
        ),
      ),
    );
  }
}

// ─── Stat Item ────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color accentColor;
  final bool isDark;

  const _StatItem({
    required this.value,
    required this.label,
    required this.accentColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.libreBodoni(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.5,
            color: isDark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30),
          ),
        ),
      ],
    );
  }
}
