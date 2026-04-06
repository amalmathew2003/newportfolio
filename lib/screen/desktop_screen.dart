import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/service/downloadcv.dart';

class DesktopScreen extends StatefulWidget {
  final VoidCallback? onContactTap;
  const DesktopScreen({super.key, this.onContactTap});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen>
    with TickerProviderStateMixin {
  Offset _mousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.primaryRed : AppColors.charcoal;

    return MouseRegion(
      onHover: (event) {
        if (!isMobile) {
          setState(() {
            _mousePos = Offset(
              (event.localPosition.dx - size.width / 2) / (size.width / 2),
              (event.localPosition.dy - size.height / 2) / (size.height / 2),
            );
          });
        }
      },
      child: Container(
        height: size.height,
        width: double.infinity,
        color: isDark ? AppColors.charcoal : AppColors.techWhite,
        child: Stack(
          children: [
            // === BACKDROP TEXT (EDITORIAL STYLE) ===
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.22),
                child: Opacity(
                  opacity: isDark ? 0.03 : 0.08,
                  child: Text(
                    "AMAL MATHEW",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.libreBodoni(
                      fontSize: isMobile ? 60 : size.width * 0.12,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),

            // === LEFT CONTENT (EDITORIAL INFO) ===
            Positioned(
              left: isMobile ? 24 : 100,
              top: size.height * 0.25,
              child: FadeInLeft(
                duration: const Duration(milliseconds: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "*01",
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "HI, I AM",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 10,
                        color: isDark ? Colors.white38 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "AMAL\nMATHEW",
                      style: GoogleFonts.libreBodoni(
                        fontSize: isMobile ? 50 : 120,
                        fontWeight: FontWeight.w900,
                        height: 0.85,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 60),
                    _IndustrialButton(
                      text: "DOWNLOAD RESUME",
                      onTap: () => downloadCV(context),
                      accentColor: accentColor,
                    ),
                  ],
                ),
              ),
            ),

            // === CENTER IMAGE (PARALLAX PROPORTION) ===
            Positioned(
              right: size.width * 0.05,
              top: size.height * 0.15,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(_mousePos.dx * 20, _mousePos.dy * 20),
                child: FadeIn(
                  duration: const Duration(seconds: 2),
                  child: Container(
                    width: size.width * (isMobile ? 0.8 : 0.45),
                    height: size.height * 0.7,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/portfolio.png'),
                        fit: BoxFit.contain,
                      ),
                      boxShadow: isDark
                          ? [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.1),
                                blurRadius: 100,
                                spreadRadius: -20,
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 60,
                                offset: const Offset(0, 30),
                              ),
                            ],
                    ),
                  ),
                ),
              ),
            ),

            // === RIGHT TECHNICAL META ===
            if (!isMobile)
              Positioned(
                right: 40,
                bottom: 80,
                child: FadeInRight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _MetaItem(
                        "STATUS",
                        "AVAILABLE FOR HIRE",
                        accentColor,
                        isDark,
                      ),
                      const SizedBox(height: 30),
                      _MetaItem(
                        "ROLE",
                        "FLUTTER DEVELOPER",
                        accentColor,
                        isDark,
                      ),
                      const SizedBox(height: 30),
                      _MetaItem("BASE", "KERALA, INDIA", accentColor, isDark),
                    ],
                  ),
                ),
              ),

            // === NOISE OVERLAY ===
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.02,
                  child: Image.asset(
                    'assets/images/noise.png',
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;
  final bool isDark;
  const _MetaItem(this.label, this.value, this.accentColor, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: accentColor.withValues(alpha: 0.6), // Using brand red/charcoal
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: isDark ? Colors.white : AppColors.charcoal,
          ),
        ),
      ],
    );
  }
}

class _IndustrialButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color accentColor;
  const _IndustrialButton({
    required this.text,
    required this.onTap,
    required this.accentColor,
  });

  @override
  State<_IndustrialButton> createState() => _IndustrialButtonState();
}

class _IndustrialButtonState extends State<_IndustrialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            color: _isHovered ? widget.accentColor : Colors.transparent,
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor
                  : (isDark ? Colors.white10 : Colors.black12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  color: _isHovered
                      ? Colors.white
                      : (isDark ? Colors.white54 : Colors.black54),
                ),
              ),
              const SizedBox(width: 15),
              Icon(
                Icons.arrow_right_alt,
                color: _isHovered
                    ? Colors.white
                    : (isDark ? Colors.white24 : Colors.black26),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
