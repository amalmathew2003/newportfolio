import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/data/projects_data.dart';
import 'package:my_portfolio/screen/project_details_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  bool _visible = false;

  void _navigateToDetails(BuildContext context, ProjectData project) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProjectDetailsScreen(
              title: project.title,
              category: project.category,
              description: project.description,
              imageUrls: project.galleryUrls,
              githubUrl: project.githubUrl,
              videoUrl: project.videoUrl,
              techStack: project.techStack,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeOut).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = AppColors.accent(context);

    return VisibilityDetector(
      key: const Key('Project-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 80 : 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section label
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 100),
              child: _visible
                  ? FadeInUp(
                      duration: const Duration(milliseconds: 700),
                      child: Row(
                        children: [
                          Container(width: 28, height: 1.5, color: accentColor.withValues(alpha: 0.5)),
                          const SizedBox(width: 14),
                          Text(
                            'CRAFTED PROJECTS',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                              color: isDark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 28),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 100),
              child: _visible
                  ? FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      delay: const Duration(milliseconds: 150),
                      child: Text(
                        'PROJECT\nCOLLECTION',
                        style: GoogleFonts.libreBodoni(
                          fontSize: isMobile ? 42 : 84,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : Colors.black,
                          height: 0.88,
                          letterSpacing: -4,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 60),

            // Project rows
            if (_visible)
              ...portfolioProjects.asMap().entries.map((entry) {
                final project = entry.value;
                final index = entry.key;
                return FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  delay: Duration(milliseconds: 300 + (index * 120)),
                  child: _ProjectRow(
                    project: project,
                    accentColor: accentColor,
                    isDark: isDark,
                    isMobile: isMobile,
                    onTap: () => _navigateToDetails(context, project),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

// ─── Project Row ──────────────────────────────────────────────────────────────

class _ProjectRow extends StatefulWidget {
  final ProjectData project;
  final Color accentColor;
  final bool isDark;
  final bool isMobile;
  final VoidCallback onTap;

  const _ProjectRow({
    required this.project,
    required this.accentColor,
    required this.isDark,
    required this.isMobile,
    required this.onTap,
  });

  @override
  State<_ProjectRow> createState() => _ProjectRowState();
}

class _ProjectRowState extends State<_ProjectRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            vertical: widget.isMobile ? 24 : 42,
            horizontal: widget.isMobile ? 24 : 100,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.subtleBorder(context, alpha: 0.08),
              ),
            ),
            color: _isHovered
                ? AppColors.glass(context)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              // Large index number
              SizedBox(
                width: widget.isMobile ? 36 : 70,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: GoogleFonts.libreBodoni(
                    fontSize: widget.isMobile ? 18 : 28,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    color: _isHovered
                        ? widget.accentColor
                        : (widget.isDark
                            ? Colors.white.withValues(alpha: 0.12)
                            : Colors.black.withValues(alpha: 0.12)),
                    letterSpacing: -1,
                  ),
                  child: Text(widget.project.index.toString().padLeft(2, '0')),
                ),
              ),

              const SizedBox(width: 16),

              // Project title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: GoogleFonts.libreBodoni(
                        fontSize: widget.isMobile ? 22 : 46,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        letterSpacing: _isHovered ? 1 : -1,
                        color: _isHovered
                            ? widget.accentColor
                            : (widget.isDark ? Colors.white : Colors.black),
                      ),
                      child: Text(widget.project.title.toUpperCase()),
                    ),
                    const SizedBox(height: 4),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: _isHovered ? 1.0 : 0.0,
                      child: Text(
                        widget.project.category.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.5,
                          color: widget.accentColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Hover preview image
              if (!widget.isMobile)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 350),
                  opacity: _isHovered ? 1.0 : 0.0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutQuint,
                    width: _isHovered ? 280 : 240,
                    height: 150,
                    margin: EdgeInsets.only(right: _isHovered ? 24 : 48),
                    decoration: BoxDecoration(
                      image: widget.project.thumbnailUrls.isNotEmpty
                          ? DecorationImage(
                              image: AssetImage(widget.project.thumbnailUrls[0]),
                              fit: BoxFit.cover,
                            )
                          : null,
                      border: Border.all(
                        color: AppColors.subtleBorder(context, alpha: 0.12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                  ),
                ),

              // Arrow icon
              const SizedBox(width: 16),
              AnimatedRotation(
                duration: const Duration(milliseconds: 300),
                turns: _isHovered ? -0.125 : 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isHovered
                        ? widget.accentColor
                        : Colors.transparent,
                    border: Border.all(
                      color: _isHovered
                          ? widget.accentColor
                          : AppColors.subtleBorder(context, alpha: 0.15),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    size: 16,
                    color: _isHovered
                        ? (widget.isDark ? Colors.black : Colors.white)
                        : (widget.isDark ? Colors.white.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.25)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
