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
          horizontal: isMobile ? 20 : 80,
          vertical: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isVisible)
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Text(
                  "EXPERIENCE",
                  style: GoogleFonts.syne(
                    fontSize: isMobile ? 40 : 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -2,
                  ),
                ),
              ),
            const SizedBox(height: 60),
            if (_isVisible)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: experiences.length,
                itemBuilder: (context, index) {
                  return _ExperienceCard(
                    data: experiences[index],
                    index: index,
                    isLast: index == experiences.length - 1,
                    isMobile: isMobile,
                  );
                },
              ),
          ],
        ),
      ),
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
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline line and dot
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: widget.data.isCurrent || _isHovered
                        ? const Color(0xFF00D2FF)
                        : Colors.white24,
                    shape: BoxShape.circle,
                    boxShadow: widget.data.isCurrent || _isHovered
                        ? [
                            BoxShadow(
                              color: const Color(
                                0xFF00D2FF,
                              ).withValues(alpha: .5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                ),
                if (!widget.isLast)
                  Expanded(child: Container(width: 2, color: Colors.white12)),
              ],
            ),
            const SizedBox(width: 30),
            // Content card
            Expanded(
              child: FadeInRight(
                delay: Duration(milliseconds: 200 * widget.index),
                duration: const Duration(milliseconds: 800),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.all(widget.isMobile ? 20 : 30),
                      margin: const EdgeInsets.only(bottom: 40),
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? Colors.white.withValues(alpha: .05)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isHovered ? Colors.white24 : Colors.white10,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.data.company,
                                  style: GoogleFonts.syne(
                                    fontSize: widget.isMobile ? 20 : 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF00D2FF,
                                  ).withValues(alpha: .1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.data.period,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF00D2FF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.work_outline,
                                size: 16,
                                color: Colors.white54,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.data.role,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: const Color(0xFF00D2FF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: Colors.white54,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.data.location,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.data.description,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Colors.white70,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
