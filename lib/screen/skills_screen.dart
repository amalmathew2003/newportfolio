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
    "CORE PLATFORMS": [
      SkillDetail(title: "FLUTTER", category: "MOBILE / WEB SDK"),
      SkillDetail(title: "DART", category: "PRIMARY LANGUAGE"),
      SkillDetail(title: "ANDROID", category: "NATIVE STACK"),
      SkillDetail(title: "iOS", category: "NATIVE STACK"),
      SkillDetail(title: "WEB", category: "RESPONSIVE DESKTOP"),
    ],
    "STATE MANAGEMENT": [
      SkillDetail(title: "PROVIDER", category: "CORE PATTERN"),
      SkillDetail(title: "BLoC", category: "ENTERPRISE PATTERN"),
      SkillDetail(title: "GETX", category: "FAST-TRACK PATTERN"),
      SkillDetail(title: "RIVERPOD", category: "MODERN PATTERN"),
    ],
    "BACKEND & INFRA": [
      SkillDetail(title: "FIREBASE", category: "BaaS ECOSYSTEM"),
      SkillDetail(title: "SUPABASE", category: "POSTGRES ECOSYSTEM"),
      SkillDetail(title: "REST API", category: "CLIENT-SERVER SYNC"),
    ],
    "DESIGN & TOOLS": [
      SkillDetail(title: "FIGMA", category: "PROTOTYPING"),
      SkillDetail(title: "UI/UX", category: "USER CENTRIC DESIGN"),
      SkillDetail(title: "GIT", category: "VERSION CONTROL"),
    ],
  };

  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.primaryRed : AppColors.woodBrown;

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

            if (_visible)
              ...categorizedSkills.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            entry.key,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 3,
                              color: accentColor.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 1 : 4,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          childAspectRatio: isMobile ? 3 : 1.8,
                        ),
                        itemCount: entry.value.length,
                        itemBuilder: (context, index) {
                          return _SkillCard(
                            skill: entry.value[index],
                            accentColor: accentColor,
                            isDark: isDark,
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
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
                  widget.skill.category.toUpperCase(),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: widget.accentColor.withValues(alpha: 0.6),
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
