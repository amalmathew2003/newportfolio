import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: isMobile ? 50 : 100,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 0.9,
                              letterSpacing: -3,
                            ),
                          ),
                          if (!isMobile)
                            Text(
                              "(2024 — 2026)",
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 14,
                                color: Colors.white30,
                                letterSpacing: 2,
                              ),
                            ),
                        ],
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
                    _ProjectCard(
                      index: "01",
                      title: "Voice Notes",
                      category: "AI • Productivity",
                      accentColor: const Color(0xFF00FFA3),
                      imageUrls: const [
                        "assests/images/VN1bg.png",
                        "assests/images/VN2bg.png",
                        "assests/images/VN3bg.png",
                      ],
                      delay: 400,
                      onTap: () => _navigateToDetails(
                        context,
                        title: "Voice Notes",
                        category: "AI • Productivity",
                        githubUrl: "https://github.com/amalmathew2003/note-app",
                        imageUrls: const [
                          "assests/images/vn1full.png",
                          "assests/images/VN1bg.png",
                          "assests/images/VN2bg.png",
                          "assests/images/VN3bg.png",
                        ],
                        videoUrl: "assests/video/VN.mp4",
                        description:
                            "The Smart Voice Note App is a Flutter-Firebase based mobile application developed to provide users with a simple, reliable, and efficient way to record, store, and manage voice notes. The primary goal of the application is to help users capture ideas, reminders, meetings, and personal notes instantly through audio, without the need for typing. The app emphasizes usability, performance, and clean architecture while maintaining a modern and intuitive user interface.\n\n"
                            "In today's fast-paced environment, users often need a quick way to save thoughts or information. This application addresses that requirement by offering a seamless one-tap recording experience combined with organized storage and smooth playback functionality. The app is designed to work offline, ensuring that users can access their recordings anytime without depending on network connectivity.\n\n"
                            "Key Features:\n"
                            "* One-tap high-quality audio recording\n"
                            "* Automatic organization with date and time labels\n"
                            "* View a list of recorded notes with timestamps\n"
                            "* Play, pause, and control audio playback\n"
                            "* Delete recordings when no longer needed\n"
                            "The application follows a clean and minimal UI approach, making it accessible for users of all age groups. From recording to playback, every interaction is designed to be intuitive and responsive.",
                      ),
                    ),

                  if (_visible)
                    _ProjectCard(
                      index: "02",
                      title: "Travel Tracker",
                      category: "Mobile App • Flutter",
                      accentColor: const Color(0xFF8B5CF6),
                      imageUrls: const [
                        "assests/images/travalappfull.png",
                        "assests/images/travalapp.png",
                        "assests/images/travalapp2.png",
                      ],
                      delay: 600,
                      onTap: () => _navigateToDetails(
                        context,
                        title: "Travel Tracker App",
                        category: "Mobile App • Flutter",
                        githubUrl:
                            "https://github.com/amalmathew2003/travelapp",
                        imageUrls: const [
                          "assests/images/travalappfull.png",
                          "assests/images/travalapp.png",
                          "assests/images/travalapp2.png",
                        ],
                        videoUrl: "assests/video/travalApp.mp4",
                        description:
                            "The Travel Tracker App is a Flutter-based mobile application developed to help users track and record their travel activities in real time. The app allows users to monitor their location movements during a journey and maintain a record of travel routes and trips. It focuses on accurately capturing travel data while providing a simple and intuitive interface for viewing tracked information.\n\n"
                            "This project emphasizes real-time location tracking, background execution, and efficient data handling. The app is designed to work continuously during travel and reliably store tracking information for later reference. Through this project, I gained hands-on experience in location services, background task handling, permission management, and building Flutter applications that operate smoothly while tracking movement over extended periods.\n\n",
                      ),
                    ),

                  if (_visible)
                    _ProjectCard(
                      index: "03",
                      title: "Motion Detection",
                      category: "Mobile App • Flutter",
                      accentColor: const Color(0xFFFF006E),
                      imageUrls: const [
                        "assests/images/motion.png",
                        "assests/images/motion2.png",
                      ],
                      delay: 800,
                      onTap: () => _navigateToDetails(
                        context,
                        title: "Motion Detection App",
                        category: "Mobile App • Flutter",
                        githubUrl:
                            "https://github.com/amalmathew2003/MotionDetectionApp",
                        imageUrls: const [
                          "assests/images/motion.png",
                          "assests/images/motion2.png",
                        ],
                        description:
                            "The Motion Detection App is a Flutter-based mobile application designed to detect physical movement of the device using built-in sensors such as the accelerometer, gyroscope, and proximity sensor. The application continuously monitors sensor data to identify any significant movement or orientation changes of the phone. When motion is detected, the app immediately triggers an alarm sound, making it suitable for device security, theft prevention, and motion-based alert use cases. The app is capable of running in the background, ensuring continuous monitoring even when the application is not actively in use.\n\n"
                            "This project emphasizes real-time sensor data processing, background execution, and efficient system resource management. Motion detection is implemented using the sensors_plus package for accelerometer and gyroscope data, proximity_sensor for near-device detection, and audioplayers for triggering alarm sounds. Through this project, I gained hands-on experience in working with mobile sensors, managing background services, handling permissions, and building reliable Flutter applications that respond instantly to real-world physical interactions.",
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

  Widget _buildSectionHeader(bool isMobile) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF00D4FF).withValues(alpha: .3),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '04',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: const Color(0xFF00D4FF),
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
                  const Color(0xFF00D4FF).withValues(alpha: .3),
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
            color: Colors.white54,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return FadeInUp(
      delay: Duration(milliseconds: widget.delay),
      duration: const Duration(milliseconds: 1000),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: const EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.all(isMobile ? 20 : 30),
            decoration: BoxDecoration(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: .03)
                  : Colors.white.withValues(alpha: .01),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovered
                    ? widget.accentColor.withValues(alpha: .2)
                    : Colors.white.withValues(alpha: .04),
              ),
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
                            : Colors.white.withValues(alpha: .2),
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
                              color: Colors.white,
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
                                  : Colors.white.withValues(alpha: .3),
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
                                color: widget.accentColor.withValues(alpha: .1),
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
                                : Colors.white.withValues(alpha: .03),
                            border: Border.all(
                              color: _isHovered
                                  ? widget.accentColor.withValues(alpha: .3)
                                  : Colors.white.withValues(alpha: .08),
                            ),
                          ),
                          child: AnimatedRotation(
                            turns: _isHovered ? -0.125 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.arrow_forward,
                              color: _isHovered
                                  ? widget.accentColor
                                  : Colors.white.withValues(alpha: .4),
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
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
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
          ),
        ),
      ),
    );
  }
}
