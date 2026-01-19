import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return VisibilityDetector(
      key: const Key('about-me-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() {
            _visible = true;
          });
        }
      },
      child: Container(
        width: double.infinity,
        // Removed opaque background to let main gradient show through
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 60,
          vertical: isMobile ? 60 : 100,
        ),
        child: Column(
          children: [
            // Section Title
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  children: [
                    Text(
                      'This is Me',
                      style: GoogleFonts.outfit(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF00D2FF), // Cyan
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Color(0xFF00D2FF)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds),
                      child: Text(
                        'ABOUT ME',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isMobile ? 32 : 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -1,
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
                          colors: [
                            Color(0xFF7000FF),
                            Color(0xFFFF0055),
                          ], // Violet -> Magenta
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: isMobile ? 40 : 80),

            // Content - Responsive layout
            if (isMobile) _buildMobileLayout() else _buildDesktopLayout(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        if (_visible) _buildProfileImage(true),
        const SizedBox(height: 40),
        if (_visible) _buildAboutCard(true),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_visible) Flexible(flex: 0, child: _buildProfileImage(false)),
        const SizedBox(width: 40),
        if (_visible) Expanded(child: _buildAboutCard(false)),
      ],
    );
  }

  Widget _buildProfileImage(bool isMobile) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 800),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7000FF).withValues(alpha: .4),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF00D2FF), Color(0xFFFF0055)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              'assests/images/portfolio.png',
              width: isMobile ? 180 : 250,
              height: isMobile ? 180 : 250,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutCard(bool isMobile) {
    return FadeInRight(
      duration: const Duration(milliseconds: 800),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 600,
            ),
            padding: EdgeInsets.all(isMobile ? 25 : 40),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .03),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: .1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi! I'm Amal Mathew",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "A passionate Flutter developer with a knack for building beautiful, responsive, and high-performance mobile and web applications. I enjoy turning ideas into real, functional apps and creating smooth user experiences.",
                  style: GoogleFonts.outfit(
                    fontSize: isMobile ? 14 : 16,
                    color: Colors.white70,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "With hands-on experience in Flutter, Dart, Provider, Dio, and Firebase, I love exploring new technologies, optimizing code, and solving challenging problems.",
                  style: GoogleFonts.outfit(
                    fontSize: isMobile ? 14 : 16,
                    color: Colors.white60,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 30),
                // Tech tags
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    'Flutter',
                    'Dart',
                    'Firebase',
                    'Provider',
                    'Bloc',
                  ].map((tech) => _buildTechTag(tech)).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTechTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00D2FF).withValues(alpha: .3)),
        color: const Color(0xFF00D2FF).withValues(alpha: .05),
      ),
      child: Text(
        text,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 12,
          color: const Color(0xFF00D2FF), // Cyan
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

