import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactMe extends StatefulWidget {
  const ContactMe({super.key});

  @override
  State<ContactMe> createState() => _ContactMeState();
}

class _ContactMeState extends State<ContactMe> {
  final String email = 'mathewamalmathew@gmail.com';
  final String github = 'https://github.com/amalmathew2003';
  final String linkedin = 'https://www.linkedin.com/in/amal-mathew-1-/';
  bool _visible = false;

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not open $url")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return VisibilityDetector(
      key: const Key('Contact-me-section'),
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
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                          'GET IN TOUCH',
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
                            colors: [Colors.white, Color(0xFF00d4ff)],
                          ).createShader(bounds),
                          child: Text(
                            'Contact Me',
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
                              colors: [Color(0xFF00d4ff), Color(0xFF00a8cc)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),

            const SizedBox(height: 30),

            // Subtitle
            _visible
                ? FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Text(
                        "I'm open for opportunities, collaborations, or freelance work. Feel free to reach out!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 14 : 16,
                          color: Colors.white70,
                          height: 1.6,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),

            SizedBox(height: isMobile ? 40 : 60),

            // Contact Cards
            Wrap(
              spacing: isMobile ? 15 : 30,
              runSpacing: isMobile ? 15 : 30,
              alignment: WrapAlignment.center,
              children: [
                if (_visible)
                  _ContactCard(
                    title: "Email Me",
                    subtitle: email,
                    icon: FontAwesomeIcons.envelope,
                    gradientColors: const [
                      Color(0xFF667eea),
                      Color(0xFF764ba2),
                    ],
                    onTap: () => _launchUrl('mailto:$email'),
                    delay: 200,
                    isMobile: isMobile,
                  ),
                if (_visible)
                  _ContactCard(
                    title: "GitHub",
                    subtitle: "View my projects",
                    icon: FontAwesomeIcons.github,
                    gradientColors: const [
                      Color(0xFF333333),
                      Color(0xFF666666),
                    ],
                    onTap: () => _launchUrl(github),
                    delay: 400,
                    isMobile: isMobile,
                  ),
                if (_visible)
                  _ContactCard(
                    title: "LinkedIn",
                    subtitle: "Connect with me",
                    icon: FontAwesomeIcons.linkedin,
                    gradientColors: const [
                      Color(0xFF0077B5),
                      Color(0xFF00a0dc),
                    ],
                    onTap: () => _launchUrl(linkedin),
                    delay: 600,
                    isMobile: isMobile,
                  ),
              ],
            ),

            SizedBox(height: isMobile ? 50 : 80),

            // Footer
            _visible
                ? FadeIn(
                    delay: const Duration(milliseconds: 800),
                    child: Column(
                      children: [
                        Container(width: 150, height: 1, color: Colors.white24),
                        const SizedBox(height: 30),
                        Text(
                          '© 2024 Amal Mathew. All rights reserved.',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white38,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Made with ❤️ using Flutter',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final int delay;
  final bool isMobile;

  const _ContactCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
    required this.delay,
    required this.isMobile,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: Duration(milliseconds: widget.delay),
      duration: const Duration(milliseconds: 800),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0),
            width: widget.isMobile ? 280 : 220,
            padding: EdgeInsets.all(widget.isMobile ? 25 : 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: isHovered
                    ? [
                        widget.gradientColors.first.withOpacity(0.3),
                        widget.gradientColors.last.withOpacity(0.1),
                      ]
                    : [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.03),
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
                      : Colors.black.withOpacity(0.2),
                  blurRadius: isHovered ? 25 : 10,
                  spreadRadius: isHovered ? 2 : 0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Icon with glow
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: widget.gradientColors),
                    boxShadow: [
                      BoxShadow(
                        color: widget.gradientColors.first.withOpacity(0.5),
                        blurRadius: isHovered ? 20 : 10,
                        spreadRadius: isHovered ? 2 : 0,
                      ),
                    ],
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white60,
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
