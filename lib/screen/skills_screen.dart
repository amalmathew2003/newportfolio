import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:animate_do/animate_do.dart';
import 'package:my_portfolio/constants/app_colors.dart';

class SkillDetail {
  final String title;
  final String performance;

  SkillDetail({
    required this.title,
    required this.performance,
  });
}

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  final List<SkillDetail> skills = [
    SkillDetail(title: "FLUTTER SDK", performance: "OPTIMIZED"),
    SkillDetail(title: "DART LANG", performance: "PEAK"),
    SkillDetail(title: "STATE MGMT (BLoC/GETX)", performance: "ARCHITECTED"),
    SkillDetail(title: "FIREBASE", performance: "REALTIME"),
    SkillDetail(title: "SUPABASE", performance: "SCALABLE"),
    SkillDetail(title: "NODE.JS / EXPRESS", performance: "BACKEND"),
    SkillDetail(title: "POSTGRESQL / MONGODB", performance: "DATA"),
    SkillDetail(title: "REST APIs / GRAPHQL", performance: "SYNC"),
    SkillDetail(title: "ANDROID / iOS SDK", performance: "NATIVE"),
    SkillDetail(title: "GIT / VCS / CI-CD", performance: "SECURE"),
    SkillDetail(title: "UI DESIGN / FIGMA", performance: "VISUAL"),
    SkillDetail(title: "UNIT TESTING", performance: "RELIABLE"),
  ];

  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.primaryRed : AppColors.charcoal;

    return VisibilityDetector(
      key: const Key('skills-section'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Row(
                  children: [
                    Container(width: 30, height: 2, color: accentColor),
                    const SizedBox(width: 15),
                    Text(
                      'CORE COMPETENCIES',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            // Big title
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 200),
                child: Text(
                  "TECHNICAL\nSTACK",
                  style: GoogleFonts.libreBodoni(
                    fontSize: isMobile ? 40 : 80,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black87,
                    height: 0.9,
                    letterSpacing: -4,
                  ),
                ),
              ),

            const SizedBox(height: 80),

            // Skills Grid
            if (_visible)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 4,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: isMobile ? 2.5 : 1.5,
                ),
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    child: _SkillCard(
                      skill: skills[index],
                      accentColor: accentColor,
                      isDark: isDark,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  final SkillDetail skill;
  final Color accentColor;
  final bool isDark;

  const _SkillCard({
    required this.skill,
    required this.accentColor,
    required this.isDark,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _isHovered 
            ? widget.accentColor.withValues(alpha: 0.08) 
            : Colors.transparent,
          border: Border.all(
            color: widget.isDark 
              ? Colors.white.withValues(alpha: 0.05) 
              : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.shrink(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.skill.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: widget.isDark ? Colors.white70 : Colors.black87,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "PERFORMANCE: ${widget.skill.performance}",
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    color: widget.isDark ? Colors.white24 : Colors.black26,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
