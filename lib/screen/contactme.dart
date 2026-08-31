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
  bool _emailHovered = false;

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = AppColors.accent(context);

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
            // Label
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 28, height: 1.5, color: accentColor.withValues(alpha: 0.5)),
                    const SizedBox(width: 14),
                    Text(
                      'GET IN TOUCH',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: isDark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(width: 28, height: 1.5, color: accentColor.withValues(alpha: 0.5)),
                  ],
                ),
              ),

            const SizedBox(height: 28),

            // Title
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                delay: const Duration(milliseconds: 150),
                child: Text(
                  'START A\nCOLLABORATION',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.libreBodoni(
                    fontSize: isMobile ? 42 : 84,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                    height: 0.88,
                    letterSpacing: -4,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Sub-description
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                delay: const Duration(milliseconds: 250),
                child: Text(
                  'Open to freelance, collaborations & full-time opportunities.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: isDark ? Colors.white.withValues(alpha: 0.38) : Colors.black.withValues(alpha: 0.38),
                    height: 1.6,
                  ),
                ),
              ),

            const SizedBox(height: 64),

            // Email CTA
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                delay: const Duration(milliseconds: 350),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _emailHovered = true),
                  onExit: (_) => setState(() => _emailHovered = false),
                  child: GestureDetector(
                    onTap: () => _launchUrl('mailto:$email'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 22,
                      ),
                      transform: _emailHovered
                          ? (Matrix4.identity()..translate(0, -3.0, 0))
                          : Matrix4.identity(),
                      decoration: BoxDecoration(
                        color: _emailHovered
                            ? accentColor
                            : Colors.transparent,
                        border: Border.all(
                          color: _emailHovered
                              ? accentColor
                              : AppColors.mediumBorder(context, alpha: 0.15),
                          width: 1.5,
                        ),
                        boxShadow: _emailHovered
                            ? [
                                BoxShadow(
                                  color: accentColor.withValues(alpha: 0.2),
                                  blurRadius: 30,
                                  offset: const Offset(0, 12),
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.alternate_email_rounded,
                            size: 16,
                            color: _emailHovered
                                ? (isDark ? Colors.black : Colors.white)
                                : (isDark ? Colors.white.withValues(alpha: 0.50) : Colors.black.withValues(alpha: 0.50)),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            email,
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 13 : 18,
                              fontWeight: FontWeight.w700,
                              color: _emailHovered
                                  ? (isDark ? Colors.black : Colors.white)
                                  : accentColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.arrow_outward_rounded,
                            size: 16,
                            color: _emailHovered
                                ? (isDark ? Colors.black : Colors.white)
                                : (isDark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 60),

            // Social icons
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                delay: const Duration(milliseconds: 500),
                child: _buildSocialGrid(accentColor, isDark),
              ),

            const SizedBox(height: 120),

            // Footer
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
          child: _SocialIcon(
            icon: FontAwesomeIcons.linkedin,
            url: 'https://linkedin.com/in/amal-mathew-1-/',
            label: 'LinkedIn',
            accentColor: accentColor,
          ),
        ),
        const SizedBox(width: 20),
        ZoomIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 750),
          child: _SocialIcon(
            icon: FontAwesomeIcons.github,
            url: 'https://github.com/amalmathew2003',
            label: 'GitHub',
            accentColor: accentColor,
          ),
        ),
        const SizedBox(width: 20),
        ZoomIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 900),
          child: _SocialIcon(
            icon: FontAwesomeIcons.instagram,
            url: 'https://instagram.com/',
            label: 'Instagram',
            accentColor: accentColor,
          ),
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
          color: AppColors.subtleBorder(context, alpha: 0.08),
        ),
        const SizedBox(height: 36),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '© ${DateTime.now().year} AMAL MATHEW',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white.withValues(alpha: 0.20) : Colors.black.withValues(alpha: 0.20),
                letterSpacing: 2,
              ),
            ),
            Text(
              'BUILT WITH FLUTTER',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: accentColor.withValues(alpha: 0.4),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Social Icon ──────────────────────────────────────────────────────────────

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  final String label;
  final Color accentColor;

  const _SocialIcon({
    required this.icon,
    required this.url,
    required this.label,
    required this.accentColor,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(widget.url);
        await launchUrl(uri);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          transform: _isHovered
              ? (Matrix4.identity()..translate(0, -4.0, 0))
              : Matrix4.identity(),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered
                ? widget.accentColor
                : Colors.transparent,
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor
                  : AppColors.subtleBorder(context, alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: FaIcon(
            widget.icon,
            color: _isHovered
                ? (isDark ? Colors.black : Colors.white)
                : (isDark ? Colors.white.withValues(alpha: 0.40) : Colors.black.withValues(alpha: 0.40)),
            size: 20,
          ),
        ),
      ),
    );
  }
}
