import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/widgets/inspector_box.dart';
import 'package:my_portfolio/widgets/tech_generic_tag.dart';

// Auto-calculates total experience from career start date
String _calcExperience() {
  // Internship: 6 months
  // Professional: ~1.3 years, started around June 2025
  final internshipMonths = 6;
  final professionalStart = DateTime(2025, 6, 1);
  final now = DateTime.now();
  final professionalMonths =
      (now.year - professionalStart.year) * 12 +
      (now.month - professionalStart.month);
  final totalMonths = internshipMonths + professionalMonths;
  final years = totalMonths ~/ 12;
  final months = totalMonths % 12;
  if (years == 0) return '${months}m Experience';
  if (months == 0) return '${years}y Experience';
  return '${years}y ${months}m Experience';
}

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  int _selectedTab = 0; // 0: Education, 1: Highlights

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      color: AppColors.background(context),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 48,
        vertical: isMobile ? 32 : 64,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: InspectorBox(
            widgetTag: 'About',
            dimensionTag: 'tab: ${_selectedTab == 0 ? "Education" : "Highlights"}',
            signalAccent: SignalAccent.cyan,
            padding: EdgeInsets.all(isMobile ? 20 : 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Header line in IBM Plex Mono
                Text(
                  'class AboutMe extends DeveloperProfile {',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: isMobile ? 13 : 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cyan,
                  ),
                ),

                const SizedBox(height: 20),

                // Main Title
                Text(
                  'Flutter Developer & Mobile Engineer',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 26 : 38,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText(context),
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Detailed Bio Paragraphs
                Text(
                  'A Flutter developer with a 6-month internship and over a year of professional experience building cross-platform mobile apps. I specialise in clean architecture, state management, and shipping smooth, production-ready experiences on both Android and iOS.',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 14 : 16,
                    height: 1.6,
                    color: AppColors.dim,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'I enjoy integrating AI capabilities — Groq, Gemini API, speech-to-text, and real-time sensor data — into mobile workflows to solve meaningful, real-world problems.',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 14 : 16,
                    height: 1.6,
                    color: AppColors.dim,
                  ),
                ),

                const SizedBox(height: 32),

                // Generic Tag
                const TechGenericTag(
                  baseName: 'Specialization',
                  typeArguments: ['Flutter', 'StateManagement', 'CleanArchitecture', 'MobilePerformance'],
                  fontSize: 13,
                ),

                const SizedBox(height: 36),

                // Tab Selector
                Row(
                  children: [
                    _buildTabButton(0, 'Education()'),
                    const SizedBox(width: 12),
                    _buildTabButton(1, 'Highlights()'),
                  ],
                ),

                const SizedBox(height: 24),

                // Tab Content Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.background(context),
                    border: Border.all(color: AppColors.line(context)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: _selectedTab == 0
                      ? _buildEducationList(context)
                      : _buildHighlightsList(context),
                ),

                const SizedBox(height: 24),

                // Closing code line
                Text(
                  '} // end AboutMe',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 14,
                    color: AppColors.cyan,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final isActive = _selectedTab == index;

    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      borderRadius: BorderRadius.circular(2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.cyan.withValues(alpha: 0.15)
              : Colors.transparent,
          border: Border.all(
            color: isActive ? AppColors.cyan : AppColors.line(context),
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          label,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            color: isActive ? AppColors.cyan : AppColors.dim,
          ),
        ),
      ),
    );
  }

  Widget _buildEducationList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          context,
          title: 'Bachelor of Computer Applications (BCA)',
          subtitle: 'Mahatma Gandhi University (MG University)',
          date: '2021 — 2024',
          description: 'Specialized in Computer Applications, Software Development, Object-Oriented Programming, Data Structures, Web Technology, and Database Management Systems.',
        ),
      ],
    );
  }


  Widget _buildHighlightsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          context,
          title: 'Professional Experience',
          subtitle: 'Flutter Developer — Full-Time',
          date: '1y 3m',
          description: 'Building and shipping production-ready Flutter apps with Provider, Bloc, REST APIs, and Hive/SQLite caching. Responsible for feature development, code reviews, and app-store releases.',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          context,
          title: 'Internship',
          subtitle: 'Flutter Intern',
          date: '6 Months',
          description: 'Hands-on internship building real-world Flutter applications, learning state management patterns, REST API integration, and delivering features under production timelines.',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          context,
          title: 'Total Experience (Auto-Calculated)',
          subtitle: 'Internship + Professional',
          date: _calcExperience(),
          description: 'Combined experience across internship (6 months) and professional role. The duration badge above updates automatically as time progresses — no manual edits needed.',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          context,
          title: 'AI & Sensor Integrations',
          subtitle: 'Hardware & Machine Learning',
          date: 'Production Projects',
          description: 'Integrated speech-to-text audio processing, motion detection sensors, background services, and real-time mapping APIs into Flutter apps.',
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String date,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText(context),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.line(context),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                date,
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  color: AppColors.dim,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 12,
            color: AppColors.cyan,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            height: 1.5,
            color: AppColors.dim,
          ),
        ),
      ],
    );
  }
}
