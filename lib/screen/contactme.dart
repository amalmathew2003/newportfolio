import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/constants/app_colors.dart';

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not open $url")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.primaryRed : AppColors.woodBrown;

    return VisibilityDetector(
      key: const Key('Contact-me-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 80 : 150,
          horizontal: isMobile ? 24 : 100,
        ),
        child: Column(
          children: [
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 30, height: 2, color: accentColor),
                    const SizedBox(width: 15),
                    Text(
                      'GET IN TOUCH',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 200),
                child: Text(
                  "START A\nCOLLABORATION",
                  style: GoogleFonts.libreBodoni(
                    fontSize: isMobile ? 40 : 80,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black87,
                    height: 0.9,
                    letterSpacing: -4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 60),

            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 400),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _launchUrl('mailto:$email'),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          email.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 18 : 32,
                            fontWeight: FontWeight.w900,
                            color: accentColor,
                            letterSpacing: -1,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    _buildSocialGrid(accentColor, isDark),
                  ],
                ),
              ),

            const SizedBox(height: 150),
            _buildFooter(isDark, accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialGrid(Color accentColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ZoomIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 600),
          child: _SocialIcon(icon: FontAwesomeIcons.linkedin, url: 'https://linkedin.com/in/amal-mathew-1-/', accentColor: accentColor),
        ),
        const SizedBox(width: 30),
        ZoomIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 800),
          child: _SocialIcon(icon: FontAwesomeIcons.github, url: 'https://github.com/amalmathew2003', accentColor: accentColor),
        ),
        const SizedBox(width: 30),
        ZoomIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 1000),
          child: _SocialIcon(icon: FontAwesomeIcons.instagram, url: 'https://instagram.com/', accentColor: accentColor),
        ),
      ],
    );
  }

  Widget _buildFooter(bool isDark, Color accentColor) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '© 2026 AMAL MATHEW',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white24 : Colors.black26,
                letterSpacing: 2,
              ),
            ),
            Text(
              'ENGINEERED BY AMAL',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: accentColor,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;
  final Color accentColor;

  const _SocialIcon({required this.icon, required this.url, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        await launchUrl(uri);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Icon(
          icon,
          color: isDark ? Colors.white38 : Colors.black38,
          size: 24,
        ),
      ),
    );
  }
}
