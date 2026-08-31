import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:animate_do/animate_do.dart';
import 'package:my_portfolio/constants/app_colors.dart';

class SkillDetail {
  final String title;
  final String category;

  SkillDetail({
    required this.title,
    required this.category,
  });
}

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  final Map<String, List<SkillDetail>> categorizedSkills = {
    'CORE PLATFORMS': [
      SkillDetail(title: 'FLUTTER', category: 'MOBILE / WEB SDK'),
      SkillDetail(title: 'DART', category: 'PRIMARY LANGUAGE'),
      SkillDetail(title: 'ANDROID', category: 'NATIVE STACK'),
      SkillDetail(title: 'iOS', category: 'NATIVE STACK'),
      SkillDetail(title: 'WEB', category: 'RESPONSIVE DESKTOP'),
    ],
    'STATE MANAGEMENT': [
      SkillDetail(title: 'PROVIDER', category: 'CORE PATTERN'),
      SkillDetail(title: 'BLoC', category: 'ENTERPRISE PATTERN'),
      SkillDetail(title: 'GETX', category: 'FAST-TRACK PATTERN'),
      SkillDetail(title: 'RIVERPOD', category: 'MODERN PATTERN'),
    ],
    'BACKEND & INFRA': [
      SkillDetail(title: 'FIREBASE', category: 'BaaS ECOSYSTEM'),
      SkillDetail(title: 'SUPABASE', category: 'POSTGRES ECOSYSTEM'),
      SkillDetail(title: 'REST API', category: 'CLIENT-SERVER SYNC'),
    ],
    'DESIGN & TOOLS': [
      SkillDetail(title: 'FIGMA', category: 'PROTOTYPING'),
      SkillDetail(title: 'UI/UX', category: 'USER CENTRIC DESIGN'),
      SkillDetail(title: 'GIT', category: 'VERSION CONTROL'),
    ],
  };

  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = AppColors.accent(context);

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
            // Section label
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: Row(
                  children: [
                    Container(width: 28, height: 1.5, color: accentColor.withValues(alpha: 0.5)),
                    const SizedBox(width: 14),
                    Text(
                      'CORE COMPETENCIES',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: isDark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 28),

            // Big title
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                delay: const Duration(milliseconds: 150),
                child: Text(
                  'TECHNICAL\nSTACK',
                  style: GoogleFonts.libreBodoni(
                    fontSize: isMobile ? 42 : 84,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                    height: 0.88,
                    letterSpacing: -4,
                  ),
                ),
              ),

            const SizedBox(height: 80),

            // Skill Categories
            if (_visible)
              ...categorizedSkills.entries.toList().asMap().entries.map((outerEntry) {
                final catIndex = outerEntry.key;
                final entry = outerEntry.value;
                return FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  delay: Duration(milliseconds: 200 + catIndex * 150),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 64),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category header
                        Row(
                          children: [
                            Text(
                              entry.key,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 3,
                                color: accentColor.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.subtleBorder(context, alpha: 0.08),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Cards grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 1 : 4,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                            childAspectRatio: isMobile ? 4 : 1.8,
                          ),
                          itemCount: entry.value.length,
                          itemBuilder: (context, index) {
                            return _SkillCard(
                              skill: entry.value[index],
                              accentColor: accentColor,
                              isDark: isDark,
                              index: index,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

// ─── Skill Card ───────────────────────────────────────────────────────────────

class _SkillCard extends StatefulWidget {
  final SkillDetail skill;
  final Color accentColor;
  final bool isDark;
  final int index;

  const _SkillCard({
    required this.skill,
    required this.accentColor,
    required this.isDark,
    required this.index,
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
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        transform: _isHovered
            ? (Matrix4.identity()..translate(0, -4.0, 0))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.glassHover(context)
              : AppColors.glass(context),
          border: Border.all(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.3)
                : AppColors.subtleBorder(context, alpha: 0.08),
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: widget.isDark ? 0.3 : 0.08,
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Index number (top right corner)
            Align(
              alignment: Alignment.topRight,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 280),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: _isHovered
                      ? widget.accentColor.withValues(alpha: 0.5)
                      : (widget.isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.1)),
                ),
                child: Text(
                  (widget.index + 1).toString().padLeft(2, '0'),
                ),
              ),
            ),
            // Skill info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 280),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: _isHovered
                        ? widget.accentColor
                        : (widget.isDark ? Colors.white : Colors.black),
                    letterSpacing: 0.5,
                  ),
                  child: Text(widget.skill.title),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.skill.category,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: widget.isDark
                        ? Colors.white.withValues(alpha: 0.28)
                        : Colors.black.withValues(alpha: 0.28),
                    letterSpacing: 1,
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
