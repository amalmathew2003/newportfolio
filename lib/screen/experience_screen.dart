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
      company: 'Avanzo Cyber Security Solutions',
      location: 'Thrissur, Kerala',
      role: 'Flutter Developer',
      period: '2024 — PRESENT',
      description:
          'Currently leading mobile development for high-security applications. Implementing precision-engineered architectures with high-performance real-time data handling.',
      isCurrent: true,
    ),
    ExperienceData(
      company: 'Luminar Technolab',
      location: 'Kochi, Kerala',
      role: 'Flutter Developer Intern',
      period: '2023 — 2024',
      description:
          'Intensive specialization in high-performance Dart applications and industrial state management patterns including Bloc and Provider.',
      isCurrent: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = AppColors.accent(context);

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
            // Section label
            if (_isVisible)
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: Row(
                  children: [
                    Container(width: 28, height: 1.5, color: accentColor.withValues(alpha: 0.5)),
                    const SizedBox(width: 14),
                    Text(
                      'CAREER TIMELINE',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: isDark ? Colors.white.withValues(alpha: 0.30) : Colors.black.withValues(alpha: 0.30),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 28),

            // Title
            if (_isVisible)
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                delay: const Duration(milliseconds: 150),
                child: Text(
                  'PROFESSIONAL\nSTAGES',
                  style: GoogleFonts.libreBodoni(
                    fontSize: isMobile ? 42 : 84,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                    height: 0.88,
                    letterSpacing: -4,
                  ),
                ),
              ),

            const SizedBox(height: 80),

            // Timeline entries
            if (_isVisible)
              ...experiences.asMap().entries.map((entry) {
                final index = entry.key;
                final exp = entry.value;
                return FadeInUp(
                  duration: const Duration(milliseconds: 900),
                  delay: Duration(milliseconds: 300 + (index * 200)),
                  child: _ExperienceCard(
                    data: exp,
                    accentColor: accentColor,
                    isDark: isDark,
                    isMobile: isMobile,
                    isLast: index == experiences.length - 1,
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

// ─── Experience Card ──────────────────────────────────────────────────────────

class _ExperienceCard extends StatefulWidget {
  final ExperienceData data;
  final Color accentColor;
  final bool isDark;
  final bool isMobile;
  final bool isLast;

  const _ExperienceCard({
    required this.data,
    required this.accentColor,
    required this.isDark,
    required this.isMobile,
    required this.isLast,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline column
              Column(
                children: [
                  // Dot
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isHovered ? 16 : 10,
                    height: _isHovered ? 16 : 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.data.isCurrent || _isHovered
                          ? widget.accentColor
                          : Colors.transparent,
                      border: Border.all(
                        color: _isHovered
                            ? widget.accentColor
                            : widget.accentColor.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: widget.accentColor.withValues(alpha: 0.35),
                                blurRadius: 14,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                  ),
                  // Connecting line
                  if (!widget.isLast)
                    Expanded(
                      child: Container(
                        width: 1,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              widget.accentColor.withValues(alpha: 0.25),
                              widget.isDark
                                  ? Colors.white.withValues(alpha: 0.03)
                                  : Colors.black.withValues(alpha: 0.03),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 36),

              // Content
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 48),
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? AppColors.glassHover(context)
                        : AppColors.glass(context),
                    border: Border.all(
                      color: _isHovered
                          ? widget.accentColor.withValues(alpha: 0.25)
                          : AppColors.subtleBorder(context, alpha: 0.08),
                    ),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: widget.isDark ? 0.25 : 0.06,
                              ),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Current badge
                                if (widget.data.isCurrent)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widget.accentColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text(
                                      'CURRENT',
                                      style: GoogleFonts.inter(
                                        fontSize: 7,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2.5,
                                        color: widget.isDark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                Text(
                                  widget.data.company,
                                  style: GoogleFonts.libreBodoni(
                                    fontSize: widget.isMobile ? 20 : 26,
                                    fontWeight: FontWeight.w900,
                                    color: _isHovered
                                        ? widget.accentColor
                                        : (widget.isDark
                                            ? Colors.white
                                            : Colors.black),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.data.role,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: widget.isDark
                                        ? Colors.white.withValues(alpha: 0.35)
                                        : Colors.black.withValues(alpha: 0.35),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Period
                          Text(
                            widget.data.period,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _isHovered
                                  ? widget.accentColor
                                  : widget.accentColor.withValues(alpha: 0.5),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Container(
                        height: 1,
                        color: AppColors.subtleBorder(context, alpha: 0.07),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        widget.data.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: widget.isDark
                              ? Colors.white.withValues(alpha: 0.45)
                              : Colors.black.withValues(alpha: 0.45),
                          height: 1.75,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Location chip
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 11,
                            color: widget.isDark
                                ? Colors.white.withValues(alpha: 0.25)
                                : Colors.black.withValues(alpha: 0.25),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.data.location,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: widget.isDark
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : Colors.black.withValues(alpha: 0.25),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Data Model ───────────────────────────────────────────────────────────────

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
