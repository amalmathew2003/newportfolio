import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
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

    return VisibilityDetector(
      key: const Key('Project-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() {
            _visible = true;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 100),
              child: _visible
                  ? FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: _buildSectionHeader(isMobile),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 20),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 100),
              child: _visible
                  ? FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 200),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "SELECTED\nWORKS",
                            style:
                                Theme.of(context).brightness == Brightness.dark
                                ? GoogleFonts.spaceGrotesk(
                                    fontSize: isMobile ? 50 : 100,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 0.9,
                                    letterSpacing: -3,
                                  )
                                : GoogleFonts.playfairDisplay(
                                    fontSize: isMobile ? 50 : 100,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF111111),
                                    height: 0.95,
                                    letterSpacing: -2,
                                  ),
                          ),
                          if (!isMobile)
                            Text(
                              "(2024 — 2026)",
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 14,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white30
                                    : Colors.black38,
                                letterSpacing: 2,
                              ),
                            ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 80),

            // Projects List — driven by centralized data
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 100),
              child: Column(
                children: [
                  if (_visible)
                    ...portfolioProjects.asMap().entries.map((entry) {
                      final index = entry.key;
                      final project = entry.value;
                      final accentColors = [
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF00FFA3)
                            : const Color(0xFF111111),
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF8B5CF6)
                            : const Color(0xFF96805D),
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFFFF006E)
                            : const Color(0xFF96805D),
                      ];

                      return _ProjectCard(
                        index: project.index,
                        title: project.title,
                        category: project.category,
                        accentColor: accentColors[index % accentColors.length],
                        imageUrls: project.thumbnailUrls,
                        delay: 400 + (index * 200),
                        onTap: () => _navigateToDetails(context, project),
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

  Widget _buildSectionHeader(bool isMobile) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  (Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF00D4FF)
                          : const Color(0xFF96805D))
                      .withValues(alpha: .3),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '04',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF00D4FF)
                  : const Color(0xFF96805D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF00D4FF)
                          : const Color(0xFF3B82F6))
                      .withValues(alpha: .3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'PROJECTS',
          style: GoogleFonts.spaceGrotesk(
            fontSize: isMobile ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white54
                : Colors.black54,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }
}

// === Project Card ===
class _ProjectCard extends StatefulWidget {
  final String index;
  final String title;
  final String category;
  final Color accentColor;
  final List<String> imageUrls;
  final int delay;
  final VoidCallback onTap;

  const _ProjectCard({
    required this.index,
    required this.title,
    required this.category,
    required this.accentColor,
    required this.imageUrls,
    required this.delay,
    required this.onTap,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;
  Offset _targetTiltOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return FadeInUp(
      delay: Duration(milliseconds: widget.delay),
      duration: const Duration(milliseconds: 1000),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() {
          _isHovered = false;
          _targetTiltOffset = Offset.zero;
        }),
        onHover: (event) {
          if (isMobile) return;
          final renderBox = context.findRenderObject() as RenderBox;
          final size = renderBox.size;
          final center = Offset(size.width / 2, size.height / 2);
          setState(() {
            _targetTiltOffset = Offset(
              (event.localPosition.dx - center.dx) / (size.width / 2),
              (event.localPosition.dy - center.dy) / (size.height / 2),
            );
          });
        },
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(begin: Offset.zero, end: _targetTiltOffset),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            builder: (context, tilt, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                margin: const EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(isMobile ? 20 : 30),
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..rotateX(-tilt.dy * 0.08)
                  ..rotateY(tilt.dx * 0.08)
                  ..scale(_isHovered ? 1.02 : 1.0, _isHovered ? 1.02 : 1.0),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? widget.accentColor.withValues(alpha: .06)
                      : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withValues(alpha: .01)
                            : Colors.black.withValues(alpha: .02)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHovered
                        ? widget.accentColor.withValues(alpha: .3)
                        : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: .04)
                              : Colors.black.withValues(alpha: .06)),
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: widget.accentColor.withValues(alpha: .15),
                            blurRadius: 30,
                            spreadRadius: -10,
                            offset: Offset(tilt.dx * 10, 15 + tilt.dy * 10),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    // Top Info Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Index number
                        Text(
                          widget.index,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 14,
                            color: _isHovered
                                ? widget.accentColor
                                : (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withValues(alpha: .2)
                                      : Colors.black.withValues(alpha: .2)),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Project name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title.toUpperCase(),
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: isMobile ? 28 : 42,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                  letterSpacing: -1,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.category,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  color: _isHovered
                                      ? widget.accentColor
                                      : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withValues(alpha: .3)
                                            : Colors.black.withValues(
                                                alpha: .5,
                                              )),
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Arrow + View Details
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // View Details badge
                            AnimatedOpacity(
                              opacity: _isHovered ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: AnimatedSlide(
                                offset: _isHovered
                                    ? Offset.zero
                                    : const Offset(0.5, 0),
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    color: widget.accentColor.withValues(
                                      alpha: .1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: widget.accentColor.withValues(
                                        alpha: .3,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "VIEW",
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: widget.accentColor,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Arrow
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isHovered
                                    ? widget.accentColor.withValues(alpha: .15)
                                    : (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white.withValues(alpha: .03)
                                          : Colors.black.withValues(
                                              alpha: .03,
                                            )),
                                border: Border.all(
                                  color: _isHovered
                                      ? widget.accentColor.withValues(alpha: .3)
                                      : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withValues(
                                                alpha: .08,
                                              )
                                            : Colors.black.withValues(
                                                alpha: .1,
                                              )),
                                ),
                              ),
                              child: AnimatedRotation(
                                turns: _isHovered ? -0.125 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: _isHovered
                                      ? widget.accentColor
                                      : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withValues(alpha: .4)
                                            : Colors.black.withValues(
                                                alpha: .4,
                                              )),
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Image Gallery — expands on hover
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      height: _isHovered ? (isMobile ? 250 : 350) : 0,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: _isHovered ? 24 : 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: widget.imageUrls.map((path) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: widget.accentColor.withValues(
                                          alpha: .1,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.asset(
                                      path,
                                      height: isMobile ? 250 : 350,
                                      width: isMobile ? size.width * 0.7 : 450,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 250,
                                          width: 350,
                                          decoration: BoxDecoration(
                                            color: Colors.red.withValues(
                                              alpha: .05,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              color: Colors.red,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
