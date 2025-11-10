import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
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
    final isMobile = size.width < 800;

    return VisibilityDetector(
      key: const Key('Project-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() {
            _visible = true; // triggers the animations
          });
        }
      },
      child: Container(
        height: isMobile ? 600 : 700,
        color: const Color(0xFF0F2027),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              SizedBox(height: isMobile ? 10 : 20),

              _visible
                  ? FadeInUpBig(
                      duration: const Duration(seconds: 1),

                      child: Text(
                        "My Project",
                        style: TextStyle(
                          fontSize: isMobile ? 32 : 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              SizedBox(height: isMobile ? 10 : 20),
              //divider
              _visible
                  ? FadeIn(
                      duration: const Duration(seconds: 1),
                      child: Container(
                        width: 120,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              SizedBox(height: isMobile ? 30 : 60),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _visible
                      ? const ProjectCard(
                          title: "Facebook UI Clone",
                          description:
                              "A Flutter project that replicates Facebook's UI, including stories, feed, and navigation bar.",
                          imagePath: "assests/images/facebook.png",
                          githubUrl:
                              'https://github.com/amalmathew2003/Facebook',
                          gradientColors: [
                            Color(0xFF2C5364),
                            Color(0xFF0F2027),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(width: 20),
                  _visible
                      ? const ProjectCard(
                          title: "OP Booking App",
                          description:
                              "Flutter & Firebase-based app where users log in, select district, hospital, and doctor, book available slots, and download their OP ticket.",
                          imagePath: "assests/images/op.png",
                          githubUrl:
                              'https://github.com/amalmathew2003/Hospital',
                          gradientColors: [
                            Color(0xFF4568DC),
                            Color(0xFFB06AB3),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(width: 20),
                  _visible
                      ? ProjectCard(
                          title: "Voice Note App",
                          description:
                              "A smart speech-to-text note app that supports multiple Indian languages, allowing users to record, edit,delete,and save notes securely using Firebase Firestore.n",
                          imagePath: "assests/images/noteapp.png",
                          githubUrl:
                              'https://github.com/amalmathew2003/note-app',
                          gradientColors: [
                            Color(0xFF43C6AC),
                            Color(0xFF191654),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final List<Color> gradientColors;
  final String githubUrl; // 👈 new field

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.gradientColors,
    required this.githubUrl,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  Future<void> _launchGitHub() async {
    if (widget.githubUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("GitHub link not available")),
      );
      return;
    }

    final Uri url = Uri.parse(widget.githubUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch ${widget.githubUrl}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: widget.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .4),
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 📱 Project image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.contain,
              height: 250,
            ),
          ),
          const SizedBox(height: 2),

          // 🧾 Title and Description
          Column(
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    widget.title,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    speed: Duration(milliseconds: 80),
                  ),
                ],
                repeatForever: true,
                totalRepeatCount: 1,
              ),

              const SizedBox(height: 10),
              FadeInUpBig(
                animate: true,
                child: Text(
                  widget.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .8),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          // 🔗 GitHub button
          ElevatedButton.icon(
            onPressed: _launchGitHub,
            icon: const Icon(Icons.code, color: Colors.white),
            label: const Text(
              "View on GitHub",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withValues(alpha: .6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
