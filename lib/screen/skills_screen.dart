import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:animate_do/animate_do.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  final List<String> row1 = [
    "FLUTTER",
    "DART",
    "FIREBASE",
    "SUPABASE",
    "ANDROID",
    "IOS",
    "WEB",
    "UI/UX",
  ];

  final List<String> row2 = [
    "PROVIDER",
    "BLOC",
    "GETX",
    "RIVERPOD",
    "FIGMA",
    "GIT",
    "REST API",
  ];

  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

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
        padding: const EdgeInsets.symmetric(vertical: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 100),
              child: _visible
                  ? FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: _buildSectionHeader(isMobile),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 20),

            // Big title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 100),
              child: _visible
                  ? FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        "MY\nSKILLS",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isMobile ? 50 : 100,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 0.9,
                          letterSpacing: -3,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 80),

            // Scrolling marquee rows
            if (_visible) ...[
              _InfiniteScrollBand(
                items: row1,
                speed: 30,
                isReverse: false,
                accentColor: const Color(0xFF00FFA3),
              ),
              const SizedBox(height: 4),
              _InfiniteScrollBand(
                items: row2,
                speed: 30,
                isReverse: true,
                accentColor: const Color(0xFF8B5CF6),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(bool isMobile) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF8B5CF6).withValues(alpha: .3),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '02',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: const Color(0xFF8B5CF6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF8B5CF6).withValues(alpha: .3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'SKILLS',
          style: GoogleFonts.spaceGrotesk(
            fontSize: isMobile ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.white54,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }
}

// === Infinite Scrolling Band ===
class _InfiniteScrollBand extends StatefulWidget {
  final List<String> items;
  final double speed;
  final bool isReverse;
  final Color accentColor;

  const _InfiniteScrollBand({
    required this.items,
    this.speed = 50,
    this.isReverse = false,
    required this.accentColor,
  });

  @override
  State<_InfiniteScrollBand> createState() => _InfiniteScrollBandState();
}

class _InfiniteScrollBandState extends State<_InfiniteScrollBand>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animController;
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // placeholder, runs forever
    )..addListener(_tick);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isReverse && _scrollController.hasClients) {
        _offset = _scrollController.position.maxScrollExtent;
        _scrollController.jumpTo(_offset);
      }
      _animController.repeat();
    });
  }

  void _tick() {
    if (!_scrollController.hasClients) return;

    if (widget.isReverse) {
      _offset -= 0.8;
      if (_offset <= 0) {
        _offset = _scrollController.position.maxScrollExtent;
      }
    } else {
      _offset += 0.8;
      if (_offset >= _scrollController.position.maxScrollExtent) {
        _offset = 0;
      }
    }
    _scrollController.jumpTo(_offset);
  }

  @override
  void dispose() {
    _animController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayList = [
      ...widget.items,
      ...widget.items,
      ...widget.items,
      ...widget.items,
      ...widget.items,
    ];

    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayList.length,
        itemBuilder: (context, index) {
          return _SkillChip(
            text: displayList[index],
            accentColor: widget.accentColor,
          );
        },
      ),
    );
  }
}

// === Skill Chip ===
class _SkillChip extends StatefulWidget {
  final String text;
  final Color accentColor;
  const _SkillChip({required this.text, required this.accentColor});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: _isHovered
              ? widget.accentColor.withValues(alpha: .15)
              : Colors.white.withValues(alpha: .02),
          border: Border.all(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: .4)
                : Colors.white.withValues(alpha: .06),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _isHovered
                  ? widget.accentColor
                  : Colors.white.withValues(alpha: .4),
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
