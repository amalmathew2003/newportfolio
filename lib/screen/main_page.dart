import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/service/theme_service.dart';
import 'package:my_portfolio/screen/desktop_screen.dart';
import 'package:my_portfolio/screen/avatar_section.dart';
import 'package:my_portfolio/screen/aboutme.dart';
import 'package:my_portfolio/screen/skills_screen.dart';
import 'package:my_portfolio/screen/experience_screen.dart';
import 'package:my_portfolio/screen/projects_screen.dart';
import 'package:my_portfolio/screen/contactme.dart';

class PortfolioScrollablePage extends StatefulWidget {
  const PortfolioScrollablePage({super.key});

  @override
  State<PortfolioScrollablePage> createState() =>
      _PortfolioScrollablePageState();
}

class _PortfolioScrollablePageState extends State<PortfolioScrollablePage> {
  final ScrollController _scrollController = ScrollController();
  int _activeSection = 0;

  final List<String> _sections = [
    'Dev',
    'App',
    'About',
    'Skills',
    'Work',
    'Projects',
    'Contact',
  ];

  final List<GlobalKey> _sectionKeys = List.generate(7, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    final viewportHeight = MediaQuery.of(context).size.height;

    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final key = _sectionKeys[i];
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position =
            renderBox.localToGlobal(Offset.zero).dy + _scrollController.offset;
        if (scrollOffset + viewportHeight * 0.45 >= position) {
          if (_activeSection != i) {
            setState(() => _activeSection = i);
          }
          break;
        }
      }
    }
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Stack(
        children: [
          // Scrollable Sections Body
            SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 56),
                  KeyedSubtree(
                    key: _sectionKeys[0],
                    child: const AvatarSection(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[1],
                    child: DesktopScreen(
                      onProjectsTap: () => _scrollToSection(5),
                      onContactTap: () => _scrollToSection(6),
                    ),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[2],
                    child: const AboutMe(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[3],
                    child: const SkillsScreen(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[4],
                    child: const ExperienceScreen(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[5],
                    child: const ProjectsScreen(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[6],
                    child: const ContactMe(),
                  ),
                ],
              ),
            ),

            // Top sticky status bar (Breadcrumb/ProgressBar) removed.
          ],
        ),
      
    );
  }
}
