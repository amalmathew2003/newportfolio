import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/widgets/inspector_box.dart';
import 'package:my_portfolio/widgets/tech_generic_tag.dart';

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
                  'Cross-Platform Developer & Technical Architect',
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
                  'I am a passionate software developer specializing in building cross-platform mobile and web applications with Flutter & Dart. My focus lies in architecting modular codebase structures, implementing state management, and delivering smooth 60fps user experiences.',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 14 : 16,
                    height: 1.6,
                    color: AppColors.dim,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Driven by technical curiosity, I continuously integrate emerging AI tools (like Groq, Gemini API, and audio intelligence) into mobile workflows to solve real-world productivity challenges.',
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
          title: 'Cross-Platform Mobile Development',
          subtitle: 'Flutter & Dart Ecosystem',
          date: '3+ Years Practice',
          description: 'Proficient in building production-ready apps with Provider, Riverpod, Bloc, REST APIs, and Hive/SQLite local caching.',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          context,
          title: 'AI & Sensor Integrations',
          subtitle: 'Hardware & Machine Learning',
          date: 'Production Projects',
          description: 'Experienced with speech-to-text audio processing, motion detection sensors, background services, and real-time mapping APIs.',
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
