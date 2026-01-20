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
    final isMobile = size.width < 900;

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
        height: size.height * 0.8,
        padding: EdgeInsets.symmetric(
          vertical: 60,
          horizontal: isMobile ? 20 : 80,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Big Call to Action
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Column(
                  children: [
                    Text(
                      "HAVE AN IDEA?",
                      style: GoogleFonts.syne(
                        fontSize: isMobile ? 40 : 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -2,
                        height: 0.9,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "LET'S BUILD IT.",
                      style: GoogleFonts.syne(
                        fontSize: isMobile ? 40 : 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.white38, // Stroke effect
                        letterSpacing: -2,
                        height: 0.9,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 60),

                    // Giant Email Button
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _launchUrl('mailto:$email'),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 30 : 60,
                            vertical: isMobile ? 20 : 30,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D2FF),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            "SEND EMAIL",
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 18 : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Footer Links
            if (_visible)
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialLink(
                      icon: FontAwesomeIcons.linkedin,
                      url: 'https://www.linkedin.com/in/amal-mathew-1-/',
                      onTap: _launchUrl,
                    ),
                    const SizedBox(width: 40),
                    _SocialLink(
                      icon: FontAwesomeIcons.github,
                      url: 'https://github.com/amalmathew2003',
                      onTap: _launchUrl,
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

///===================================SocialLink===================================//

class _SocialLink extends StatefulWidget {
  final IconData icon;
  final String url;
  final Function(String) onTap;

  const _SocialLink({
    required this.icon,
    required this.url,
    required this.onTap,
  });

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onTap(widget.url),
        child: AnimatedScale(
          scale: _isHovered ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            widget.icon,
            color: _isHovered ? const Color(0xFF00D2FF) : Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
