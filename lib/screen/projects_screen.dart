import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/data/projects_data.dart';
import 'package:my_portfolio/screen/project_details_screen.dart';
import 'package:my_portfolio/widgets/inspector_box.dart';
import 'package:my_portfolio/widgets/tech_generic_tag.dart';
import 'package:my_portfolio/widgets/gradient_button.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  void _navigateToDetails(BuildContext context, ProjectData project) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProjectDetailsScreen(
              title: project.title,
              category: project.category,
              description: project.description,
              imageUrls: project.galleryUrls,
              githubUrl: project.githubUrl,
              videoUrl: project.videoUrl,
              techStack: project.techStack,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

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
            widgetTag: 'Projects',
            dimensionTag: 'items: ${portfolioProjects.length}',
            signalAccent: SignalAccent.pink,
            padding: EdgeInsets.all(isMobile ? 20 : 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header in IBM Plex Mono
                Text(
                  'List<Widget> showcase = [',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: isMobile ? 13 : 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.pink,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Featured Applications & Projects',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 24 : 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText(context),
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Production-ready Flutter applications, real-time tracking engines, and sensor-driven alert utilities.',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 14 : 16,
                    color: AppColors.dim,
                  ),
                ),

                const SizedBox(height: 36),

                // Projects Column
                Column(
                  children: portfolioProjects
                      .map((p) => _buildProjectCard(context, p, isMobile))
                      .toList(),
                ),

                const SizedBox(height: 24),

                Text(
                  ']; // end showcase',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 14,
                    color: AppColors.pink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectData project, bool isMobile) {
    final cleanTitle = project.title.replaceAll(RegExp(r'\s+'), '');

    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      child: InspectorBox(
        widgetTag: 'Project($cleanTitle)',
        dimensionTag: project.category,
        signalAccent: SignalAccent.cyan,
        padding: EdgeInsets.only(
          top: isMobile ? 32 : 38,
          left: isMobile ? 16 : 24,
          right: isMobile ? 16 : 24,
          bottom: isMobile ? 16 : 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project.title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: isMobile ? 20 : 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText(context),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.pink.withValues(alpha: 0.1),
                    border: Border.all(color: AppColors.pink.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    project.category,
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.pink,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Tech Stack Generic Tag
            TechGenericTag(
              baseName: cleanTitle,
              typeArguments: project.techStack,
              fontSize: 13,
            ),

            const SizedBox(height: 16),

            // Short Description
            Text(
              project.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.spaceGrotesk(
                fontSize: isMobile ? 14 : 15,
                height: 1.5,
                color: AppColors.dim,
              ),
            ),

            const SizedBox(height: 20),

            // Action Links (No Arrow Glyphs!)
            Wrap(
              spacing: 16,
              runSpacing: 10,
              children: [
                DevToolsButton(
                  text: 'VIEW SOURCE',
                  onPressed: () => _launchUrl(project.githubUrl),
                  icon: Icons.code,
                ),
                DevToolsButton(
                  text: 'DETAILS & DEMO',
                  isSecondary: true,
                  onPressed: () => _navigateToDetails(context, project),
                  icon: Icons.visibility_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
