import 'dart:async';
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
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
              child: FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Text(
                  "MY SKILLS",
                  style: GoogleFonts.syne(
                    fontSize: isMobile ? 40 : 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Marquee Rows
            if (_visible) ...[
              _InfiniteTextScroll(
                items: row1,
                direction: Axis.horizontal,
                speed: 30,
                isReverse: false,
              ),
              const SizedBox(height: 20),
              _InfiniteTextScroll(
                items: row2,
                direction: Axis.horizontal,
                speed: 30,
                isReverse: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

///===================================InfiniteTextScroll===================================//
class _InfiniteTextScroll extends StatefulWidget {
  final List<String> items;
  final Axis direction;
  final double speed;
  final bool isReverse;

  const _InfiniteTextScroll({
    required this.items,
    this.direction = Axis.horizontal,
    this.speed = 50,
    this.isReverse = false,
  });

  @override
  State<_InfiniteTextScroll> createState() => _InfiniteTextScrollState();
}

class _InfiniteTextScrollState extends State<_InfiniteTextScroll> {
  late ScrollController _scrollController;
  late Timer _timer;
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!_scrollController.hasClients) return;

      if (widget.isReverse) {
        _offset -= 1; // Simplify speed for now
        if (_offset <= 0) {
          _offset = _scrollController.position.maxScrollExtent;
          _scrollController.jumpTo(_offset);
        } else {
          _scrollController.jumpTo(_offset);
        }
      } else {
        _offset += 1;
        if (_offset >= _scrollController.position.maxScrollExtent) {
          _offset = 0;
          _scrollController.jumpTo(_offset);
        } else {
          _scrollController.jumpTo(_offset);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Duplicate list many times to create infinite effect
    final displayList = [
      ...widget.items,
      ...widget.items,
      ...widget.items,
      ...widget.items,
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
            ), // handled inside
            child: _SkillItem(text: displayList[index]),
          );
        },
      ),
    );
  }
}

///===================================SkillItem===================================//
class _SkillItem extends StatefulWidget {
  final String text;
  const _SkillItem({required this.text});

  @override
  State<_SkillItem> createState() => _SkillItemState();
}

class _SkillItemState extends State<_SkillItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFF00D2FF) : Colors.transparent,
          border: Border.all(color: Colors.white24),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: GoogleFonts.dmSans(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _isHovered ? Colors.black : Colors.white54,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
