import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:my_portfolio/screen/project_details_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  bool _visible = false;

  void _navigateToDetails(
    BuildContext context, {
    required String title,
    required String category,
    required String description,
    required List<String> imageUrls,
    required String githubUrl,
    String? videoUrl,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailsScreen(
          title: title,
          category: category,
          description: description,
          imageUrls: imageUrls,
          githubUrl: githubUrl,
          videoUrl: videoUrl,
        ),
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
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
              child: FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        "MY WORKS",
                        style: GoogleFonts.syne(
                          fontSize: isMobile ? 40 : 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -2,
                          height: 0.9,
                        ),
                      ),
                    ),
                    if (!isMobile)
                      Text(
                        "(2023 - 2024)",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 80),

            // Projects List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
              child: Column(
                children: [
                  if (_visible)
                    _BrutalistProjectCard(
                      index: "01",
                      title: "Facebook Clone",
                      category: "Mobile App • Flutter",
                      imageUrls: const [
                        "assests/images/VN1bg.png",
                        "assests/images/VN2bg.png",
                        "assests/images/VN3bg.png",
                      ],
                      githubUrl: "https://github.com/amalmathew2003/Facebook",
                      delay: 200,
                      onTap: () => _navigateToDetails(
                        context,
                        title: "Facebook Clone",
                        category: "Mobile App • Flutter",
                        githubUrl: "https://github.com/amalmathew2003/Facebook",
                        imageUrls: const [
                          "assests/images/VN1bg.png",
                          "assests/images/VN2bg.png",
                          "assests/images/VN3bg.png",
                        ],
                        videoUrl: "assests/video/VN.mp4",
                        description:
                            "A pixel-perfect Facebook clone built using Flutter.",
                      ),
                    ),

                  if (_visible)
                    _BrutalistProjectCard(
                      index: "02",
                      title: "OP Booking",
                      category: "Medical • Firebase",
                      imageUrls: const [
                        "assests/images/VN1bg.png",
                        "assests/images/VN2bg.png",
                        "assests/images/VN3bg.png",
                      ],
                      githubUrl: "https://github.com/amalmathew2003/Hospital",
                      delay: 400,
                      onTap: () => _navigateToDetails(
                        context,
                        title: "OP Booking",
                        category: "Medical • Firebase",
                        githubUrl: "https://github.com/amalmathew2003/Hospital",
                        imageUrls: const [
                          "assests/images/VN1bg.png",
                          "assests/images/VN2bg.png",
                          "assests/images/VN3bg.png",
                        ],
                        videoUrl: "assests/video/VN.mp4",
                        description:
                            "An Outpatient Booking System designed to streamline hospital appointments. Built with Flutter and backed by Firebase, this app allows patients to book slots with doctors real-time. It features user authentication, doctor availability management, live appointment status tracking, and an admin dashboard for hospital staff.",
                      ),
                    ),
                  if (_visible)
                    _BrutalistProjectCard(
                      index: "03",
                      title: "Voice Notes",
                      category: "AI • Productivity",
                      imageUrls: const [
                        "assests/images/VN1bg.png",
                        "assests/images/VN2bg.png",
                        "assests/images/VN3bg.png",
                      ],
                      githubUrl: "https://github.com/amalmathew2003/note-app",
                      delay: 600,
                      onTap: () => _navigateToDetails(
                        context,
                        title: "Voice Notes",
                        category: "AI • Productivity",
                        githubUrl: "https://github.com/amalmathew2003/note-app",
                        imageUrls: const [
                          "assests/images/VN1bg.png",
                          "assests/images/VN2bg.png",
                          "assests/images/VN3bg.png",
                        ],
                        videoUrl: "assests/video/VN.mp4",
                        description:
                            "The Smart Voice Note App is a Flutter-based mobile application designed to help users quickly record, store, and manage voice notes with ease. The app provides a simple and intuitive interface that allows users to capture high-quality audio using a single tap. Each recording is automatically saved with relevant details such as date and time, making it easy to organize and identify voice notes. The application works offline and ensures reliable access to recordings at any time"
                            "This project focuses on performance, usability, and clean architecture. It includes smooth audio playback controls, efficient local file storage, and proper handling of microphone permissions to ensure user privacy and stability. Through this application, I gained hands-on experience in audio recording and playback in Flutter, state management, local storage handling, and building responsive, user-friendly mobile applications.",
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

///===================================BrutalistProjectCard===================================//
///
class _BrutalistProjectCard extends StatefulWidget {
  final String index;
  final String title;
  final String category;
  final List<String> imageUrls;
  final String githubUrl;
  final int delay;
  final VoidCallback onTap;

  const _BrutalistProjectCard({
    required this.index,
    required this.title,
    required this.category,
    required this.imageUrls,
    required this.githubUrl,
    required this.delay,
    required this.onTap,
  });

  @override
  State<_BrutalistProjectCard> createState() => _BrutalistProjectCardState();
}

class _BrutalistProjectCardState extends State<_BrutalistProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: Duration(milliseconds: widget.delay),
      duration: const Duration(milliseconds: 1000),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            padding: const EdgeInsets.only(bottom: 40),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Index
                    Text(
                      widget.index,
                      style: GoogleFonts.syne(
                        fontSize: 20,
                        color: _isHovered
                            ? const Color(0xFF00D2FF)
                            : Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 40),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title.toUpperCase(),
                            style: GoogleFonts.syne(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.category,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: _isHovered
                                  ? const Color(0xFF00D2FF)
                                  : Colors.white54,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Arrow Icon
                    AnimatedRotation(
                      turns: _isHovered ? -0.125 : 0, // 45 degrees
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.arrow_forward,
                        color: _isHovered
                            ? const Color(0xFF00D2FF)
                            : Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),

                // Reveal Images Gallery on Hover
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: _isHovered ? 300 : 0, // Sufficient height for images
                  width: double.infinity,
                  curve: Curves.fastOutSlowIn,
                  margin: EdgeInsets.only(top: _isHovered ? 30 : 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: widget.imageUrls.map((path) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              path,
                              height: 300,
                              width: 400,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 300,
                                  width: 400,
                                  color: Colors.red.withOpacity(0.1),
                                  child: const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
