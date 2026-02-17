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

class _ContactMeState extends State<ContactMe>
    with SingleTickerProviderStateMixin {
  final String email = 'mathewamalmathew@gmail.com';
  bool _visible = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Could not open $url")));
      }
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
        padding: EdgeInsets.symmetric(
          vertical: 120,
          horizontal: isMobile ? 24 : 100,
        ),
        child: Column(
          children: [
            // Section Header
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: _buildSectionHeader(isMobile),
              ),

            SizedBox(height: isMobile ? 60 : 100),

            // Main CTA
            if (_visible)
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    // Big heading
                    Text(
                      "LET'S CREATE",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: isMobile ? 40 : 80,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -2,
                        height: 0.9,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "SOMETHING AMAZING",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: isMobile ? 40 : 80,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: .15),
                        letterSpacing: -2,
                        height: 0.9,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // Subtitle
                    SizedBox(
                      width: isMobile ? double.infinity : 500,
                      child: Text(
                        "Got a project in mind? I'd love to hear about it. Let's work together to build something extraordinary.",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: .4),
                          height: 1.7,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Email button with animated glow
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return _GlowingEmailButton(
                          email: email,
                          pulseValue: _pulseController.value,
                          onTap: () => _launchUrl('mailto:$email'),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // Or connect text
                    Text(
                      "or find me on",
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: .2),
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Social links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialButton(
                          icon: FontAwesomeIcons.linkedin,
                          label: 'LinkedIn',
                          color: const Color(0xFF0A66C2),
                          url: 'https://www.linkedin.com/in/amal-mathew-1-/',
                          onTap: _launchUrl,
                        ),
                        const SizedBox(width: 16),
                        _SocialButton(
                          icon: FontAwesomeIcons.github,
                          label: 'GitHub',
                          color: Colors.white,
                          url: 'https://github.com/amalmathew2003',
                          onTap: _launchUrl,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 100),

            // Footer
            if (_visible)
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: _buildFooter(isMobile),
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
              color: const Color(0xFF00FFA3).withValues(alpha: .3),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '05',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: const Color(0xFF00FFA3),
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
                  const Color(0xFF00FFA3).withValues(alpha: .3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'CONTACT',
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

  Widget _buildFooter(bool isMobile) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.white.withValues(alpha: .05),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '© 2026 Amal Mathew',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: Colors.white.withValues(alpha: .2),
                letterSpacing: 1,
              ),
            ),
            Text(
              'Built with Flutter 💙',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: Colors.white.withValues(alpha: .2),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// === Glowing Email Button ===
class _GlowingEmailButton extends StatefulWidget {
  final String email;
  final double pulseValue;
  final VoidCallback onTap;

  const _GlowingEmailButton({
    required this.email,
    required this.pulseValue,
    required this.onTap,
  });

  @override
  State<_GlowingEmailButton> createState() => _GlowingEmailButtonState();
}

class _GlowingEmailButtonState extends State<_GlowingEmailButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF00FFA3)
                : const Color(0xFF00FFA3).withValues(alpha: .1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(
                0xFF00FFA3,
              ).withValues(alpha: 0.3 + (widget.pulseValue * 0.3)),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FFA3).withValues(
                  alpha: _isHovered ? 0.3 : (0.05 + widget.pulseValue * 0.1),
                ),
                blurRadius: _isHovered ? 30 : 20,
                spreadRadius: _isHovered ? 0 : -5,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.email_outlined,
                color: _isHovered
                    ? const Color(0xFF0A0A0F)
                    : const Color(0xFF00FFA3),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                "SEND EMAIL",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _isHovered
                      ? const Color(0xFF0A0A0F)
                      : const Color(0xFF00FFA3),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === Social Button ===
class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String url;
  final Function(String) onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.url,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onTap(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.color.withValues(alpha: .1)
                : Colors.white.withValues(alpha: .03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? widget.color.withValues(alpha: .3)
                  : Colors.white.withValues(alpha: .06),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: _isHovered ? widget.color : Colors.white54,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: _isHovered ? widget.color : Colors.white54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
