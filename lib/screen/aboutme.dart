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

class _AboutMeState extends State<AboutMe> with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.primaryRed : AppColors.woodBrown;

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
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: _buildSectionHeader(isMobile, accentColor, isDark),
              ),
            SizedBox(height: isMobile ? 60 : 100),
            if (isMobile) _buildMobileLayout(accentColor, isDark) else _buildDesktopLayout(size, accentColor, isDark),
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
            Container(width: 40, height: 1, color: accentColor.withValues(alpha: 0.3)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'HISTORY',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ),
            Container(width: 40, height: 1, color: accentColor.withValues(alpha: 0.3)),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'PROFESSIONAL PROFILE',
          style: GoogleFonts.libreBodoni(
            fontSize: isMobile ? 32 : 60,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black87,
            letterSpacing: -2,
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
        SizedBox(width: size.width * 0.1),
        if (_visible) Expanded(child: _buildInfoContent(accentColor, isDark, false)),
      ],
    );
  }

  Widget _buildProfileImage(Color accentColor, bool isDark, bool isMobile) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 1000),
      child: Container(
        width: isMobile ? 250 : 350,
        height: isMobile ? 300 : 450,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : AppColors.creamWhite,
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 40,
              offset: const Offset(10, 10),
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/portfolio.png', // Reusing the asset
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.9),
              ),
            ),
            Positioned(
              left: 0,
              top: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: accentColor,
                child: Text(
                  'ENGINEERED',
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContent(Color accentColor, bool isDark, bool isMobile) {
    return FadeInRight(
      duration: const Duration(milliseconds: 1000),
      child: Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '01',
                style: GoogleFonts.inter(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 20),
              Container(width: 1, height: 40, color: Colors.white12),
              const SizedBox(width: 20),
              Text(
                'MISSION\nSTATEMENT',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            "Crafting high-performance digital experiences with precision and passion.",
            style: GoogleFonts.inter(
              fontSize: isMobile ? 20 : 28,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
              height: 1.3,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 30),
          Text(
            "A dedicated Flutter developer focused on bridging the gap between cutting-edge design and industrial-grade stability. I specialize in building scalable architectures and immersive user interfaces for the next generation of web and mobile platforms.",
            style: GoogleFonts.inter(
              fontSize: 16,
              color: isDark ? Colors.white54 : Colors.black54,
              height: 1.8,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 50),
          _buildTechList(accentColor, isDark, isMobile),
        ],
      ),
    );
  }

  Widget _buildTechList(Color accentColor, bool isDark, bool isMobile) {
    final techs = ['DART', 'FLUTTER', 'FIREBASE', 'PROVIDER', 'ARCHITECTURE'];
    return Wrap(
      spacing: 40,
      runSpacing: 20,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: techs.map((t) => Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Container(width: 4, height: 4, decoration: BoxDecoration(shape: BoxShape.circle, color: accentColor)),
          const SizedBox(height: 8),
          Text(
            t,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: isDark ? Colors.white24 : Colors.black26,
            ),
          ),
        ],
      )).toList(),
    );
  }
}
