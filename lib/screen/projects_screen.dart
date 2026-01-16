import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1000;

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
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 60 : 100,
          horizontal: isMobile ? 20 : 60,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0a0a0a), Color(0xFF1a1a2e), Color(0xFF0a0a0a)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Section Title
            _visible
                ? FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    child: Column(
                      children: [
                        Text(
                          'MY PROJECTS',
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF00d4ff),
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.white, Color(0xFF764ba2)],
                          ).createShader(bounds),
                          child: Text(
                            'Recent Work',
                            style: GoogleFonts.poppins(
                              fontSize: isMobile ? 32 : 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 80,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),

            SizedBox(height: isMobile ? 40 : 60),

            // Projects Grid
            Wrap(
              spacing: isMobile ? 20 : 30,
              runSpacing: isMobile ? 20 : 30,
              alignment: WrapAlignment.center,
              children: [
                if (_visible)
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 800),
                    child: ProjectCard(
                      title: "Facebook UI Clone",
                      description:
                          "A Flutter project that replicates Facebook's UI, including stories, feed, and navigation bar.",
                      imagePath: "assests/images/facebook.png",
                      githubUrl: 'https://github.com/amalmathew2003/Facebook',
                      gradientColors: const [
                        Color(0xFF667eea),
                        Color(0xFF764ba2),
                      ],
                      isMobile: isMobile,
                    ),
                  ),
                if (_visible)
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 800),
                    child: ProjectCard(
                      title: "OP Booking App",
                      description:
                          "Flutter & Firebase-based app where users log in, select district, hospital, and doctor, book available slots.",
                      imagePath: "assests/images/op.png",
                      githubUrl: 'https://github.com/amalmathew2003/Hospital',
                      gradientColors: const [
                        Color(0xFFf093fb),
                        Color(0xFFf5576c),
                      ],
                      isMobile: isMobile,
                    ),
                  ),
                if (_visible)
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 800),
                    child: ProjectCard(
                      title: "Voice Note App",
                      description:
                          "A smart speech-to-text note app that supports multiple Indian languages with Firebase Firestore.",
                      imagePath: "assests/images/noteapp.png",
                      githubUrl: 'https://github.com/amalmathew2003/note-app',
                      gradientColors: const [
                        Color(0xFF00d4ff),
                        Color(0xFF00a8cc),
                      ],
                      isMobile: isMobile,
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

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final String githubUrl;
  final List<Color> gradientColors;
  final bool isMobile;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.githubUrl,
    required this.gradientColors,
    required this.isMobile,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool isHovered = false;

  Future<void> _launchGitHub() async {
    final Uri url = Uri.parse(widget.githubUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch ${widget.githubUrl}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, isHovered ? -10.0 : 0.0),
        width: widget.isMobile ? 300 : 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isHovered
                ? widget.gradientColors.first.withOpacity(0.8)
                : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? widget.gradientColors.first.withOpacity(0.4)
                  : Colors.black.withOpacity(0.3),
              blurRadius: isHovered ? 30 : 15,
              spreadRadius: isHovered ? 5 : 0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Image with overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Image.asset(
                    widget.imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          widget.gradientColors.last.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // View on GitHub button
                  GestureDetector(
                    onTap: _launchGitHub,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(colors: widget.gradientColors),
                        boxShadow: [
                          BoxShadow(
                            color: widget.gradientColors.first.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.code, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'View Code',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
