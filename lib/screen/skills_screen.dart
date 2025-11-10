import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width < 1100 && !isMobile;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 50 : 80,
        horizontal: isMobile ? 20 : 60,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 800),
            child: Text(
              "My Skills",
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile
                    ? 30
                    : isTablet
                    ? 42
                    : 54,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 10),
          FadeInUp(
            duration: const Duration(milliseconds: 1000),
            child: Container(
              width: 100,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 60),

          // Categories
          FadeInUp(
            duration: const Duration(milliseconds: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                _SkillCategory(
                  title: "Core Flutter Skills",
                  skills: [
                    "Flutter",
                    "Dart",
                    "Bloc",
                    "Provider",
                    "Riverpod",
                    "Sqflite",
                    "API Integration",
                    "Firebase",
                  ],
                ),
                SizedBox(height: 50),
                _SkillCategory(
                  title: "Version Control ",
                  skills: ["Git / GitHub"],
                ),
                SizedBox(height: 50),
                _SkillCategory(
                  title: "Basic Programming Knowledge",
                  skills: ["C (Basic)", "C++ (Basic)", "HTML (Basic)"],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillCategory extends StatelessWidget {
  final String title;
  final List<String> skills;
  const _SkillCategory({required this.title, required this.skills});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 700),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: isMobile ? 22 : 26,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 25),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: skills
              .map((skill) => _HoverSkillCard(skill: skill))
              .toList(),
        ),
      ],
    );
  }
}

class _HoverSkillCard extends StatefulWidget {
  final String skill;
  const _HoverSkillCard({required this.skill});

  @override
  State<_HoverSkillCard> createState() => _HoverSkillCardState();
}

class _HoverSkillCardState extends State<_HoverSkillCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return BounceInUp(
      duration: const Duration(milliseconds: 700),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(isHovered ? 1.08 : 1.0),
          width: isMobile ? 150 : 220,
          height: isMobile ? 70 : 90,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isHovered
                  ? [
                      Colors.cyanAccent.withValues(alpha: .4),
                      Colors.blueAccent.withValues(alpha: 0.3),
                    ]
                  : [
                      Colors.blueAccent.withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.4),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isHovered
                  ? Colors.cyanAccent
                  : Colors.cyanAccent.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? Colors.cyanAccent.withValues(alpha: 0.7)
                    : Colors.cyanAccent.withValues(alpha: 0.3),
                blurRadius: isHovered ? 20 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            widget.skill,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isHovered ? Colors.cyanAccent : Colors.white,
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
