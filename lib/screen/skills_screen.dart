import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  bool _visible = false;

  final List<_SkillData> _skills = [
    _SkillData(
      "Flutter",
      "https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png",
      const Color(0xFF54C5F8),
    ),
    _SkillData(
      "Dart",
      "https://upload.wikimedia.org/wikipedia/commons/7/7e/Dart-logo.png",
      const Color(0xFF0175C2),
    ),
    _SkillData(
      "Firebase",
      "https://firebase.google.com/static/images/brand-guidelines/logo-logomark.png",
      const Color(0xFFFFCA28),
    ),
    _SkillData(
      "Bloc",
      "https://raw.githubusercontent.com/felangel/bloc/master/docs/assets/bloc_logo_full.png",
      const Color(0xFF16D2FD),
    ),
    _SkillData(
      "Provider",
      "https://pub.dev/packages/provider/versions/6.0.5/gen-res/gen/100x100/logo.webp",
      const Color(0xFF722FBB),
    ),
    _SkillData(
      "GetX",
      "https://raw.githubusercontent.com/jonataslaw/getx/master/documentation/assets/logo.png",
      const Color(0xFFD32F2F),
    ),
    _SkillData(
      "Sqflite",
      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Sqlite-square-icon.svg/1200px-Sqlite-square-icon.svg.png",
      const Color(0xFF003B57),
    ),
    _SkillData(
      "Git",
      "https://git-scm.com/images/logos/downloads/Git-Icon-1788C.png",
      const Color(0xFFF05032),
    ),
    _SkillData(
      "GitHub",
      "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/GitHub_Invertocat_Logo.svg/1200px-GitHub_Invertocat_Logo.svg.png",
      const Color(0xFFFFFFFF),
    ),
    _SkillData(
      "VS Code",
      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Visual_Studio_Code_1.35_icon.svg/2048px-Visual_Studio_Code_1.35_icon.svg.png",
      const Color(0xFF007ACC),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return VisibilityDetector(
      key: const Key('skills-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() {
            _visible = true;
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 60 : 100,
          horizontal: isMobile ? 20 : 60,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF0F1020), // Slightly different dark bg
          backgroundBlendMode: BlendMode.srcOver,
        ),
        child: Column(
          children: [
            // Header
            if (_visible)
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Column(
                  children: [
                    Text(
                      "MY ARSENAL",
                      style: GoogleFonts.oswald(
                        fontSize: isMobile ? 40 : 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 50),
                      height: 4,
                      width: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),

            // Skills Grid
            if (_visible)
              Wrap(
                spacing: 30,
                runSpacing: 30,
                alignment: WrapAlignment.center,
                children: List.generate(_skills.length, (index) {
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 100),
                    child: _HolographicSkillCard(
                      skill: _skills[index],
                      isMobile: isMobile,
                    ),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}

class _SkillData {
  final String name;
  final String imageUrl;
  final Color color;

  _SkillData(this.name, this.imageUrl, this.color);
}

class _HolographicSkillCard extends StatefulWidget {
  final _SkillData skill;
  final bool isMobile;

  const _HolographicSkillCard({required this.skill, required this.isMobile});

  @override
  State<_HolographicSkillCard> createState() => _HolographicSkillCardState();
}

class _HolographicSkillCardState extends State<_HolographicSkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: widget.isMobile ? 150 : 200,
        height: widget.isMobile ? 180 : 240,
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.05 : 1.0)
          ..translate(0.0, _isHovered ? -10.0 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(_isHovered ? 0.1 : 0.05),
              Colors.white.withOpacity(_isHovered ? 0.05 : 0.02),
            ],
          ),
          border: Border.all(
            color: _isHovered
                ? widget.skill.color.withOpacity(0.8)
                : Colors.white.withOpacity(0.1),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: widget.skill.color.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Stack(
              children: [
                // Glowing Background Gradient (Subtle)
                Positioned.fill(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isHovered ? 0.2 : 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.0,
                          colors: [widget.skill.color, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon Container
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: widget.isMobile ? 60 : 80,
                          height: widget.isMobile ? 60 : 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: _isHovered
                                ? [
                                    BoxShadow(
                                      color: widget.skill.color.withOpacity(
                                        0.5,
                                      ),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Image.network(
                            widget.skill.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.code,
                                size: 50,
                                color: widget.skill.color,
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Text Container
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? widget.skill.color.withOpacity(0.8)
                              : Colors.white.withOpacity(0.05),
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.skill.name.toUpperCase(),
                            style: GoogleFonts.chakraPetch(
                              fontSize: widget.isMobile ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: _isHovered ? Colors.black : Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
