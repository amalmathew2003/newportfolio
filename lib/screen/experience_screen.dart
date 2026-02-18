import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
      period: "Present",
      description:
          "Currently working as a Flutter Developer, focusing on building high-quality, performant mobile applications. Handling end-to-end development, from UI implementation to backend integration.",
      isCurrent: true,
    ),
    ExperienceData(
      company: "Luminar Technolab",
      location: "Kochi, Kerala",
      role: "Flutter Developer Intern",
      period: "6 Months",
      description:
          "Completed an intensive 6-month internship focused on Flutter development. Gained expertise in Dart, state management solutions like Provider and Bloc, and integrated various Firebase services.",
      isCurrent: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return VisibilityDetector(
      key: const Key('experience-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 100,
          vertical: 120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            if (_isVisible)
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: _buildSectionHeader(isMobile),
              ),

            const SizedBox(height: 20),

            if (_isVisible)
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                delay: const Duration(milliseconds: 200),
                child: Text(
                  "WORK\nJOURNEY",
                  style: Theme.of(context).brightness == Brightness.dark
                      ? GoogleFonts.spaceGrotesk(
                          fontSize: isMobile ? 50 : 100,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 0.9,
                          letterSpacing: -3,
                        )
                      : GoogleFonts.playfairDisplay(
                          fontSize: isMobile ? 50 : 100,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF111111),
                          height: 0.95,
                          letterSpacing: -2,
                        ),
                ),
              ),

            const SizedBox(height: 80),

            if (_isVisible)
              ...experiences.asMap().entries.map((entry) {
                final index = entry.key;
                final exp = entry.value;
                return _ExperienceCard(
                  data: exp,
                  index: index,
                  isLast: index == experiences.length - 1,
                  isMobile: isMobile,
                );
              }),
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
              color:
                  (Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFFF006E)
                          : const Color(0xFF96805D))
                      .withValues(alpha: .3),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '03',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFFFF006E)
                  : const Color(0xFF96805D),
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
                  (Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFFF006E)
                          : const Color(0xFF96805D))
                      .withValues(alpha: .3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'EXPERIENCE',
          style: GoogleFonts.spaceGrotesk(
            fontSize: isMobile ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white54
                : Colors.black54,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final ExperienceData data;
  final int index;
  final bool isLast;
  final bool isMobile;

  const _ExperienceCard({
    required this.data,
    required this.index,
    required this.isLast,
    required this.isMobile,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = widget.data.isCurrent
        ? (isDark ? const Color(0xFF00FFA3) : const Color(0xFF111111))
        : (isDark ? const Color(0xFF8B5CF6) : const Color(0xFF96805D));

    return FadeInUp(
      delay: Duration(milliseconds: 300 * widget.index),
      duration: const Duration(milliseconds: 800),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline
              Column(
                children: [
                  // Dot with glow
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: widget.data.isCurrent || _isHovered
                          ? accentColor
                          : (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withValues(alpha: .15)
                                : Colors.black.withValues(alpha: .15)),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accentColor.withValues(alpha: .3),
                        width: 2,
                      ),
                      boxShadow: widget.data.isCurrent || _isHovered
                          ? [
                              BoxShadow(
                                color: accentColor.withValues(alpha: .4),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                  ),
                  // Line
                  if (!widget.isLast)
                    Expanded(
                      child: Container(
                        width: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              accentColor.withValues(alpha: .3),
                              isDark
                                  ? Colors.white.withValues(alpha: .05)
                                  : Colors.black.withValues(alpha: .05),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 30),

              // Card Content
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.all(widget.isMobile ? 24 : 32),
                  margin: const EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? accentColor.withValues(alpha: .03)
                        : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: .02)
                              : Colors.black.withValues(alpha: .02)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isHovered
                          ? accentColor.withValues(alpha: .2)
                          : (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withValues(alpha: .05)
                                : Colors.black.withValues(alpha: .08)),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.data.company,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: widget.isMobile ? 22 : 28,
                                fontWeight: FontWeight.w700,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          // Period badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: accentColor.withValues(alpha: .2),
                              ),
                            ),
                            child: Text(
                              widget.data.period,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Role
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 2,
                            color: accentColor.withValues(alpha: .5),
                            margin: const EdgeInsets.only(right: 10),
                          ),
                          Text(
                            widget.data.role,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: accentColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withValues(alpha: .3)
                                : Colors.black.withValues(alpha: .4),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.data.location,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white.withValues(alpha: .3)
                                  : Colors.black.withValues(alpha: .6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Description
                      Text(
                        widget.data.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: .5)
                              : Colors.black.withValues(alpha: .75),
                          height: 1.7,
                        ),
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
