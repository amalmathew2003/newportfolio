import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:my_portfolio/constants/app_colors.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  bool _isVisible = false;

  final List<ExperienceData> experiences = [
    ExperienceData(
      company: "Avanzo Cyber Security Solutions",
      location: "Thrissur, Kerala",
      role: "Flutter Developer",
      period: "2024 - PRESENT",
      description:
          "Currently leading mobile development for high-security applications. Implementing precision-engineered architectures with high-performance real-time data handling.",
      isCurrent: true,
    ),
    ExperienceData(
      company: "Luminar Technolab",
      location: "Kochi, Kerala",
      role: "Flutter Developer Intern",
      period: "2023 - 2024",
      description:
          "Intensive specialization in high-performance Dart applications and industrial state management patterns including Bloc and Provider.",
      isCurrent: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.primaryRed : AppColors.woodBrown;

    return VisibilityDetector(
      key: const Key('experience-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 100,
          vertical: isMobile ? 80 : 150,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isVisible)
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Row(
                  children: [
                    Container(width: 30, height: 2, color: accentColor),
                    const SizedBox(width: 15),
                    Text(
                      'CAREER TIMELINE',
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

            if (_isVisible)
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 200),
                child: Text(
                  "PROFESSIONAL\nSTAGES",
                  style: GoogleFonts.libreBodoni(
                    fontSize: isMobile ? 40 : 80,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black87,
                    height: 0.9,
                    letterSpacing: -4,
                  ),
                ),
              ),

            const SizedBox(height: 80),

            if (_isVisible)
              ...experiences.asMap().entries.map((entry) {
                final int index = entry.key;
                final ExperienceData exp = entry.value;
                return FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  delay: Duration(milliseconds: 300 + (index * 200)),
                  child: _ExperienceRow(
                    data: exp,
                    accentColor: accentColor,
                    isDark: isDark,
                    isMobile: isMobile,
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _ExperienceRow extends StatefulWidget {
  final ExperienceData data;
  final Color accentColor;
  final bool isDark;
  final bool isMobile;

  const _ExperienceRow({
    required this.data,
    required this.accentColor,
    required this.isDark,
    required this.isMobile,
  });

  @override
  State<_ExperienceRow> createState() => _ExperienceRowState();
}

class _ExperienceRowState extends State<_ExperienceRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: const EdgeInsets.only(bottom: 50),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isHovered 
            ? widget.accentColor.withValues(alpha: 0.015) 
            : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year Indicator
            if (!widget.isMobile)
              Container(
                width: 150,
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  widget.data.period,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: _isHovered ? widget.accentColor : widget.accentColor.withValues(alpha: 0.6),
                    letterSpacing: 2,
                  ),
                ),
              ),
            
            // Bullet & Line
            Column(
              children: [
                _TimelineDot(
                  isCurrent: widget.data.isCurrent,
                  accentColor: widget.accentColor,
                  isDark: widget.isDark,
                ),
                const SizedBox(height: 10),
                Container(
                  width: 1,
                  height: widget.isMobile ? 120 : 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.accentColor.withValues(alpha: 0.2),
                        widget.isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.02),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(width: 40),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isMobile)
                    Text(
                      widget.data.period,
                      style: GoogleFonts.inter(
                        fontSize: 10, 
                        fontWeight: FontWeight.w900, 
                        color: widget.accentColor, 
                        letterSpacing: 2
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    widget.data.company.toUpperCase(),
                    style: GoogleFonts.libreBodoni(
                      fontSize: widget.isMobile ? 24 : 32,
                      fontWeight: FontWeight.w900,
                      color: _isHovered ? widget.accentColor : (widget.isDark ? Colors.white : Colors.black87),
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    widget.data.role,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: widget.isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.data.description,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: widget.isDark ? Colors.white54 : Colors.black54,
                      height: 1.7,
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

class _TimelineDot extends StatefulWidget {
  final bool isCurrent;
  final Color accentColor;
  final bool isDark;

  const _TimelineDot({
    required this.isCurrent,
    required this.accentColor,
    required this.isDark,
  });

  @override
  State<_TimelineDot> createState() => _TimelineDotState();
}

class _TimelineDotState extends State<_TimelineDot> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _isHovered ? 20 : 12,
        height: _isHovered ? 20 : 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isCurrent || _isHovered 
            ? widget.accentColor 
            : (widget.isDark ? Colors.white12 : Colors.black12),
          border: Border.all(
            color: widget.accentColor.withValues(alpha: _isHovered ? 0.6 : 0.3), 
            width: _isHovered ? 2 : 4,
          ),
          boxShadow: _isHovered ? [
            BoxShadow(
              color: widget.accentColor.withValues(alpha: 0.4),
              blurRadius: 15,
              spreadRadius: 2,
            )
          ] : [],
        ),
      ),
    );
  }
}

class ExperienceData {
  final String company;
  final String location;
  final String role;
  final String period;
  final String description;
  final bool isCurrent;

  ExperienceData({
    required this.company,
    required this.location,
    required this.role,
    required this.period,
    required this.description,
    this.isCurrent = false,
  });
}
