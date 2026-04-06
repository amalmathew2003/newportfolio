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
    final accentColor = isDark ? AppColors.primaryRed : AppColors.woodBrown;

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
            // Section Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 100),
              child: _visible
                  ? FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: Row(
                        children: [
                          Container(width: 30, height: 2, color: accentColor),
                          const SizedBox(width: 15),
                          Text(
                            'ENGINEERING PORTFOLIO',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 30),

            // Main Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 100),
              child: _visible
                  ? FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        "PROJECT\nCOLLECTION / 24",
                        style: GoogleFonts.libreBodoni(
                          fontSize: isMobile ? 40 : 80,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : Colors.black87,
                          height: 0.9,
                          letterSpacing: -4,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 80),

            // Projects List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 100),
              child: Column(
                children: [
                  if (_visible)
                    ...portfolioProjects.asMap().entries.map((entry) {
                      final project = entry.value;
                      final index = entry.key;
                      return FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        delay: Duration(milliseconds: 400 + (index * 150)),
                        child: _ProjectRow(
                          project: project,
                          accentColor: accentColor,
                          isDark: isDark,
                          onTap: () => _navigateToDetails(context, project),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectRow extends StatefulWidget {
  final ProjectData project;
  final Color accentColor;
  final bool isDark;
  final VoidCallback onTap;

  const _ProjectRow({
    required this.project,
    required this.accentColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_ProjectRow> createState() => _ProjectRowState();
}

class _ProjectRowState extends State<_ProjectRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(vertical: isMobile ? 25 : 50, horizontal: 0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            color: _isHovered 
              ? widget.accentColor.withValues(alpha: 0.015) 
              : Colors.transparent,
          ),
          child: Row(
            children: [
              // Index
              SizedBox(
                width: isMobile ? 30 : 60,
                child: Text(
                  widget.project.index.toString().padLeft(2, '0'),
                  style: GoogleFonts.spectral( // Using a serif for technical indicators
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    color: _isHovered ? widget.accentColor : (widget.isDark ? Colors.white24 : Colors.black26),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              
              // Project Info
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    widget.project.title.toUpperCase(),
                  ),
                  style: GoogleFonts.libreBodoni(
                    fontSize: isMobile ? 24 : 48,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    letterSpacing: _isHovered ? 2 : -1,
                    color: _isHovered ? widget.accentColor : (widget.isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ),

              // Dynamic Preview Image
              if (!isMobile)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: _isHovered ? 1.0 : 0.0,
                  curve: Curves.easeInOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutQuint,
                    width: _isHovered ? 300 : 250,
                    height: 160,
                    margin: EdgeInsets.only(right: _isHovered ? 20 : 40),
                    decoration: BoxDecoration(
                      image: widget.project.thumbnailUrls.isNotEmpty 
                        ? DecorationImage(
                            image: AssetImage(widget.project.thumbnailUrls[0]), 
                            fit: BoxFit.cover,
                          )
                        : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        )
                      ],
                    ),
                  ),
                ),

              // Custom Interaction Marker
              const SizedBox(width: 20),
              AnimatedRotation(
                duration: const Duration(milliseconds: 300),
                turns: _isHovered ? -0.125 : 0,
                child: Icon(
                  Icons.arrow_outward_rounded,
                  size: 24,
                  color: _isHovered ? widget.accentColor : (widget.isDark ? Colors.white12 : Colors.black26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
