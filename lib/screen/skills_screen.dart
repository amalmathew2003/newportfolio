import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/widgets/inspector_box.dart';

class SkillChipData {
  final String prefix;
  final String name;

  const SkillChipData(this.prefix, this.name);
}

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  static const List<SkillChipData> skills = [
    // Languages & SDK
    SkillChipData('lang', 'Dart'),
    SkillChipData('lang', 'Flutter'),
    SkillChipData('lang', 'C'),
    SkillChipData('lang', 'HTML/CSS'),
    
    // State Management
    SkillChipData('state', 'Provider'),
    SkillChipData('state', 'Bloc'),
    SkillChipData('state', 'Riverpod'),
    SkillChipData('state', 'GetX'),

    // Backend & APIs
    SkillChipData('backend', 'Firebase'),
    SkillChipData('backend', 'REST API'),
    SkillChipData('backend', 'Supabase'),

    // Local Storage & Database
    SkillChipData('db', 'Hive'),
    SkillChipData('db', 'SQLite'),
    SkillChipData('db', 'SharedPref'),

    // Packages & Integrations
    SkillChipData('pkg', 'Dio'),
    SkillChipData('pkg', 'http'),
    SkillChipData('pkg', 'GoogleMaps'),
    SkillChipData('pkg', 'PaymentGateway'),
    SkillChipData('pkg', 'SensorsPlus'),

    // Dev Tools & Architecture
    SkillChipData('tool', 'Git/GitHub'),
    SkillChipData('tool', 'Clean Architecture'),
    SkillChipData('tool', 'Figma'),
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
            widgetTag: 'Skills',
            dimensionTag: 'items: ${skills.length}',
            signalAccent: SignalAccent.pink,
            padding: EdgeInsets.all(isMobile ? 20 : 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header in IBM Plex Mono
                Text(
                  'Map<Prefix, Skill> techStack = {',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: isMobile ? 13 : 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.pink,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Technical Skills & Package Ecosystem',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 24 : 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText(context),
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Categorized Flutter packages, state libraries, database engines, and developer tools.',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 14 : 16,
                    color: AppColors.dim,
                  ),
                ),

                const SizedBox(height: 32),

                // Animated Skill Chips Wrap
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: skills.map((s) => AnimatedSkillChip(skill: s)).toList(),
                ),

                const SizedBox(height: 32),

                Text(
                  '}; // end techStack',
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
}

class AnimatedSkillChip extends StatefulWidget {
  final SkillChipData skill;

  const AnimatedSkillChip({super.key, required this.skill});

  @override
  State<AnimatedSkillChip> createState() => _AnimatedSkillChipState();
}

class _AnimatedSkillChipState extends State<AnimatedSkillChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final prefixColor = widget.skill.prefix == 'pkg'
        ? AppColors.cyan
        : widget.skill.prefix == 'lang'
            ? AppColors.pink
            : widget.skill.prefix == 'state'
                ? AppColors.pink
                : widget.skill.prefix == 'backend'
                    ? AppColors.cyan
                    : AppColors.dim;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _isHovered
              ? prefixColor.withValues(alpha: 0.14)
              : AppColors.background(context),
          border: Border.all(
            color: _isHovered ? prefixColor : AppColors.line(context),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.ibmPlexMono(fontSize: 12),
            children: [
              TextSpan(
                text: '${widget.skill.prefix}:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: prefixColor,
                ),
              ),
              TextSpan(
                text: widget.skill.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryText(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
