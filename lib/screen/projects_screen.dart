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
                        "(2024 - 2026)",
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
                          "assests/images/vn1full.png",

                          "assests/images/VN1bg.png",
                          "assests/images/VN2bg.png",
                          "assests/images/VN3bg.png",
                        ],
                        videoUrl: "assests/video/VN.mp4",
                        description:
                            "The Smart Voice Note App is a Flutter-Firebase based mobile application developed to provide users with a simple, reliable, and efficient way to record, store, and manage voice notes. The primary goal of the application is to help users capture ideas, reminders, meetings, and personal notes instantly through audio, without the need for typing. The app emphasizes usability, performance, and clean architecture while maintaining a modern and intuitive user interface.\n\n"
                            "In today’s fast-paced environment, users often need a quick way to save thoughts or information. This application addresses that requirement by offering a seamless one-tap recording experience combined with organized storage and smooth playback functionality. The app is designed to work offline, ensuring that users can access their recordings anytime without depending on network connectivity.\n\n"
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
                    _BrutalistProjectCard(
                      index: "02",
                      title: "Travel Tracker App",
                      category: "Mobile App • Flutter",
                      imageUrls: const [
                        "assests/images/travalappfull.png",
                        "assests/images/travalapp.png",
                        "assests/images/travalapp2.png",
                      ],
                      githubUrl: "https://github.com/amalmathew2003/travelapp",
                      delay: 400,
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
                    _BrutalistProjectCard(
                      index: "03",
                      title: "Motion Detection App",
                      category: "Mobile App • Flutter",
                      imageUrls: const [
                        "assests/images/motion.png",
                        "assests/images/motion2.png",
                      ],
                      githubUrl:
                          "https://github.com/amalmathew2003/MotionDetectionApp",
                      delay: 200,
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
                        // videoUrl: "assests/video/VN.mp4",
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
                  color: Colors.white.withValues(alpha: .2),
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
                                  color: Colors.red.withValues(alpha: .1),
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
