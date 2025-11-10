import 'package:flutter/material.dart';
import 'package:my_portfolio/screen/aboutme.dart';
import 'package:my_portfolio/screen/contactme.dart';
import 'package:my_portfolio/screen/projects_screen.dart';
import 'package:my_portfolio/screen/skills_screen.dart';

import 'desktop_screen.dart';

class PortfolioScrollablePage extends StatelessWidget {
  const PortfolioScrollablePage({super.key});

  double _sectionHeight(
    BuildContext context,
    double desktop,
    double tablet,
    double mobile,
  ) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return desktop; // Desktop
    if (width >= 800) return tablet; // Tablet
    return mobile; // Mobile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // Section 1: Landing Page
            SizedBox(
              height: _sectionHeight(context, 800, 700, 600),
              child: const DesktopScreen(),
            ),

            // Section 2: About Me
            SizedBox(
              height: _sectionHeight(context, 800, 700, 600),
              child: const AboutMe(),
            ),
            const SkillsScreen(),

            // Section 3: Projects — expands naturally
            SizedBox(
              height: _sectionHeight(context, 800, 700, 600),
              child: const ProjectsScreen(),
            ),

            // Section 4: Contact Me
            SizedBox(
              height: _sectionHeight(context, 700, 600, 500),
              child: const ContactMe(),
            ),
          ],
        ),
      ),
    );
  }
}
