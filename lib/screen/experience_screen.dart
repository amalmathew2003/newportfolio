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
    final accentColor = isDark ? AppColors.primaryRed : AppColors.charcoal;

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
              ...experiences.map((exp) {
                return _ExperienceRow(
                  data: exp,
                  accentColor: accentColor,
                  isDark: isDark,
                  isMobile: isMobile,
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _ExperienceRow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Year Indicator
          if (!isMobile)
            Container(
              width: 150,
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                data.period,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                  letterSpacing: 2,
                ),
              ),
            ),
          
          // Bullet & Line
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: data.isCurrent ? accentColor : Colors.white12,
                  border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 4),
                ),
              ),
              const SizedBox(height: 10),
              Container(width: 1, height: 150, color: Colors.white.withValues(alpha: 0.05)),
            ],
          ),
          
          const SizedBox(width: 40),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isMobile)
                  Text(
                    data.period,
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: accentColor, letterSpacing: 2),
                  ),
                const SizedBox(height: 4),
                Text(
                  data.company.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black87,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  data.role,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  data.description,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: isDark ? Colors.white54 : Colors.black54,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
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
