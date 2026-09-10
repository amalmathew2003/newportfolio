import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/widgets/inspector_box.dart';
import 'package:my_portfolio/widgets/tech_generic_tag.dart';

class ExperienceItem {
  final String company;
  final String tagCompany;
  final String location;
  final String role;
  final String period;
  final String description;
  final List<String> techStack;

  const ExperienceItem({
    required this.company,
    required this.tagCompany,
    required this.location,
    required this.role,
    required this.period,
    required this.description,
    required this.techStack,
  });
}

class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({super.key});

  static const List<ExperienceItem> experiences = [
    ExperienceItem(
      company: 'Avanzo Cyber Security Solutions',
      tagCompany: 'AvanzoSecurity',
      location: 'Thrissur, Kerala',
      role: 'Flutter Developer',
      period: '2024 — Present',
      description:
          'Leading mobile development for high-security applications. Implementing precision-engineered architectures with high-performance real-time data handling, custom state management, and secure API integrations.',
      techStack: ['Flutter', 'Dart', 'Security', 'Provider', 'REST'],
    ),
    ExperienceItem(
      company: 'Luminar Technolab',
      tagCompany: 'LuminarTechnolab',
      location: 'Kochi, Kerala',
      role: 'Flutter Developer Intern',
      period: '2023 — 2024',
      description:
          'Specialized in high-performance Dart applications and industrial state management patterns including Bloc, Provider, and local database caching.',
      techStack: ['Flutter', 'Dart', 'Bloc', 'SQLite', 'Git'],
    ),
  ];

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
            widgetTag: 'WorkExperience',
            dimensionTag: 'roles: ${experiences.length}',
            signalAccent: SignalAccent.cyan,
            padding: EdgeInsets.all(isMobile ? 20 : 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header in IBM Plex Mono
                Text(
                  'List<WorkHistory> career = [',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: isMobile ? 13 : 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cyan,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Work Experience & Career Stages',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 24 : 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText(context),
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Chronological timeline of professional software development roles using real dates as sequence markers.',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 14 : 16,
                    color: AppColors.dim,
                  ),
                ),

                const SizedBox(height: 36),

                // Experience Items List
                Column(
                  children: experiences.map((exp) => _buildExperienceBox(context, exp, isMobile)).toList(),
                ),

                const SizedBox(height: 24),

                Text(
                  ']; // end career',
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

  Widget _buildExperienceBox(BuildContext context, ExperienceItem exp, bool isMobile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      child: InspectorBox(
        widgetTag: exp.tagCompany,
        dimensionTag: exp.period,
        signalAccent: SignalAccent.pink,
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    exp.role,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: isMobile ? 18 : 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText(context),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withValues(alpha: 0.1),
                    border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    exp.period,
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.cyan,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              '${exp.company} — ${exp.location}',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 12,
                color: AppColors.dim,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              exp.description,
              style: GoogleFonts.spaceGrotesk(
                fontSize: isMobile ? 14 : 15,
                height: 1.5,
                color: AppColors.dim,
              ),
            ),

            const SizedBox(height: 16),

            TechGenericTag(
              baseName: exp.tagCompany,
              typeArguments: exp.techStack,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }
}
