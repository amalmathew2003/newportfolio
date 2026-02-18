import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String title;
  final String category;
  final String description;
  final List<String> imageUrls;
  final String githubUrl;
  final String? videoUrl;

  const ProjectDetailsScreen({
    super.key,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrls,
    required this.githubUrl,
    this.videoUrl,
  });

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(githubUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background mesh blobs
          Positioned(
            top: -150,
            right: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00FFA3).withValues(alpha: .06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -200,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8B5CF6).withValues(alpha: .05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Main Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image
                SizedBox(
                  height: size.height * 0.55,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: title,
                        child: Image.asset(
                          imageUrls.isNotEmpty
                              ? imageUrls[0]
                              : 'https://via.placeholder.com/800',
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(
                                context,
                              ).scaffoldBackgroundColor.withValues(alpha: .3),
                              Theme.of(
                                context,
                              ).scaffoldBackgroundColor.withValues(alpha: .8),
                              Theme.of(context).scaffoldBackgroundColor,
                            ],
                            stops: const [0.1, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Project Info
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : 100,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge + Title
                      FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? const Color(0xFF00FFA3)
                                            : const Color(0xFF3B82F6))
                                        .withValues(alpha: .1),
                                border: Border.all(
                                  color:
                                      (Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? const Color(0xFF00FFA3)
                                              : const Color(0xFF3B82F6))
                                          .withValues(alpha: .3),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                category.toUpperCase(),
                                style: GoogleFonts.jetBrainsMono(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF00FFA3)
                                      : const Color(0xFF2563EB),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              title.toUpperCase(),
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: isMobile ? 40 : 80,
                                fontWeight: FontWeight.w700,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                height: 0.9,
                                letterSpacing: -2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Description & Tech Stack
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 800),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return isMobile
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDescription(context),
                                      const SizedBox(height: 40),
                                      _buildTechStack(context),
                                      const SizedBox(height: 40),
                                      if (videoUrl != null)
                                        Column(
                                          children: [
                                            _VideoPlayerWidget(
                                              videoUrl: videoUrl!,
                                            ),
                                            const SizedBox(height: 40),
                                          ],
                                        ),
                                      _buildActions(context),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildDescription(context),
                                            if (videoUrl != null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 40,
                                                ),
                                                child: _VideoPlayerWidget(
                                                  videoUrl: videoUrl!,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 80),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildTechStack(context),
                                            const SizedBox(height: 40),
                                            _buildActions(context),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                          },
                        ),
                      ),

                      const SizedBox(height: 100),

                      // Image Gallery
                      if (imageUrls.length > 1)
                        FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 2,
                                    color: const Color(0xFF8B5CF6),
                                    margin: const EdgeInsets.only(right: 12),
                                  ),
                                  Text(
                                    "GALLERY",
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 20,
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              ...imageUrls.map(
                                (url) => Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withValues(
                                                alpha: .05,
                                              )
                                            : Colors.black.withValues(
                                                alpha: .08,
                                              ),
                                        border: Border.all(
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white.withValues(
                                                  alpha: .05,
                                                )
                                              : Colors.black.withValues(
                                                  alpha: .08,
                                                ),
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Image.asset(
                                        url,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 20,
            child: SafeArea(
              child: _BackButton(onTap: () => Navigator.pop(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final paragraphs = description.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((item) {
        if (item.trim().isEmpty) return const SizedBox(height: 10);

        final isBullet =
            item.trim().startsWith('•') ||
            item.trim().startsWith('-') ||
            item.trim().startsWith('*');

        if (isBullet) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 8, right: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF00FFA3),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.trim().replaceFirst(RegExp(r'^[•\-\*]\s*'), ''),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withValues(alpha: .6)
                          : Colors.black.withValues(alpha: .75),
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            item.trim(),
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: .6)
                  : Colors.black.withValues(alpha: .7),
              height: 1.8,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTechStack(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TECH STACK",
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: .3)
                : Colors.black.withValues(alpha: .4),
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _TechChip(label: "Flutter", color: const Color(0xFF00FFA3)),
            _TechChip(label: "Dart", color: const Color(0xFF8B5CF6)),
            _TechChip(label: "Firebase", color: const Color(0xFFFF006E)),
            _TechChip(label: "UI/UX", color: const Color(0xFF00D4FF)),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return _GithubButton(onTap: _launchUrl);
  }
}

// === Tech Chip ===
class _TechChip extends StatelessWidget {
  final String label;
  final Color color;
  const _TechChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .05),
        border: Border.all(color: color.withValues(alpha: .15)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// === GitHub Button ===
class _GithubButton extends StatefulWidget {
  final VoidCallback onTap;
  const _GithubButton({required this.onTap});

  @override
  State<_GithubButton> createState() => _GithubButtonState();
}

class _GithubButtonState extends State<_GithubButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF00FFA3)
                : const Color(0xFF00FFA3).withValues(alpha: .1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(
                0xFF00FFA3,
              ).withValues(alpha: _isHovered ? 1.0 : 0.3),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF00FFA3).withValues(alpha: .3),
                      blurRadius: 20,
                      spreadRadius: -5,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesomeIcons.github,
                color: _isHovered
                    ? const Color(0xFF0A0A0F)
                    : const Color(0xFF00FFA3),
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                "VIEW CODE",
                style: GoogleFonts.inter(
                  color: _isHovered
                      ? Theme.of(context).scaffoldBackgroundColor
                      : const Color(0xFF00FFA3),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === Back Button ===
class _BackButton extends StatefulWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered
                ? (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: .1)
                      : Colors.black.withValues(alpha: .05))
                : Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withValues(alpha: .6),
            border: Border.all(
              color: _isHovered
                  ? (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: .2)
                        : Colors.black.withValues(alpha: .2))
                  : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: .08)
                        : Colors.black.withValues(alpha: .1)),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back,
            color: _isHovered
                ? (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black)
                : (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black54),
            size: 22,
          ),
        ),
      ),
    );
  }
}

// === Video Player Widget ===
class _VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const _VideoPlayerWidget({required this.videoUrl});

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (_isInitialized) return;

    if (widget.videoUrl.startsWith('assets') ||
        widget.videoUrl.startsWith('assests')) {
      _videoPlayerController = VideoPlayerController.asset(widget.videoUrl);
    } else {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
    }

    await _videoPlayerController.initialize();

    await _videoPlayerController.play();
    await Future.delayed(const Duration(milliseconds: 300));
    await _videoPlayerController.pause();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: true,
      showControls: true,
      allowFullScreen: true,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        playedColor: const Color(0xFF00FFA3),
        handleColor: const Color(0xFF00FFA3),
        bufferedColor: Colors.white38,
        backgroundColor: Colors.white24,
      ),
      placeholder: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF00FFA3)),
        ),
      ),
      errorBuilder: (context, errorMessage) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: const Center(
            child: Icon(Icons.error, color: Colors.white, size: 40),
          ),
        );
      },
    );

    _isInitialized = true;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _chewieController?.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      return Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: .02)
              : Colors.black.withValues(alpha: .03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: .05)
                : Colors.black.withValues(alpha: .08),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF00FFA3)),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: .05)
                : Colors.black.withValues(alpha: .08),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Chewie(controller: _chewieController!),
      ),
    );
  }
}
