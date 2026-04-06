import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String title;
  final String category;
  final String description;
  final List<String> imageUrls;
  final String githubUrl;
  final String? videoUrl;
  final List<String> techStack;

  const ProjectDetailsScreen({
    super.key,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrls,
    required this.githubUrl,
    this.videoUrl,
    this.techStack = const ['Flutter', 'Dart', 'Firebase', 'UI/UX'],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.primaryRed : AppColors.charcoal;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Header
            Stack(
              children: [
                Hero(
                  tag: title,
                  child: Container(
                    height: size.height * 0.7,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: imageUrls.isNotEmpty 
                        ? DecorationImage(image: AssetImage(imageUrls[0]), fit: BoxFit.cover, alignment: Alignment.topCenter)
                        : null,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: SafeArea(child: _BackButton(onTap: () => Navigator.pop(context), accentColor: accentColor)),
                ),
                Positioned(
                  bottom: 40,
                  left: isMobile ? 24 : 100,
                  right: isMobile ? 24 : 100,
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(width: 40, height: 2, color: accentColor),
                            const SizedBox(width: 15),
                            Text(
                              category.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4,
                                color: isDark ? Colors.white54 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          title.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 40 : 100,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : Colors.black87,
                            height: 0.9,
                            letterSpacing: -4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 100, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMobile)
                        Expanded(
                          flex: 1,
                          child: _buildMeta(context, accentColor),
                        ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SPECIFICATIONS",
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 3, color: accentColor),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              description,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: isDark ? Colors.white70 : Colors.black.withValues(alpha: 0.7),
                                height: 1.8,
                              ),
                            ),
                            if (videoUrl != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: _VideoPlayerWidget(videoUrl: videoUrl!, accentColor: accentColor),
                              ),
                            const SizedBox(height: 60),
                            _GithubButton(onTap: _launchUrl, accentColor: accentColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  if (imageUrls.length > 1) _buildGallery(imageUrls.sublist(1), isDark),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeta(BuildContext context, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _metaItem("ARCHITECTURE", "CLEAN / MVVM", accentColor),
        const SizedBox(height: 30),
        _metaItem("PLATFORM", "CROSS-PLATFORM", accentColor),
        const SizedBox(height: 30),
        _metaItem("STATUS", "PRODUCTION READY", accentColor),
        const SizedBox(height: 30),
        Text(
          "CORE TECH",
          style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white24),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: techStack.map((t) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(border: Border.all(color: Colors.white12)),
            child: Text(t, style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white38)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _metaItem(String label, String value, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white24)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)),
      ],
    );
  }

  Widget _buildGallery(List<String> images, bool isDark) {
    return Column(
      children: images.map((img) => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Image.asset(img, fit: BoxFit.cover, width: double.infinity),
        ),
      )).toList(),
    );
  }
}

class _GithubButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color accentColor;
  const _GithubButton({required this.onTap, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(color: accentColor),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(FontAwesomeIcons.github, color: Colors.white, size: 16),
              const SizedBox(width: 15),
              Text(
                "SOURCE CODE",
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color accentColor;
  const _BackButton({required this.onTap, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 50, width: 50,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final Color accentColor;
  const _VideoPlayerWidget({required this.videoUrl, required this.accentColor});

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (widget.videoUrl.startsWith('assets')) {
      _videoPlayerController = VideoPlayerController.asset(widget.videoUrl);
    } else {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    }
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: true,
      materialProgressColors: ChewieProgressColors(playedColor: widget.accentColor, handleColor: widget.accentColor),
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white10)),
      child: AspectRatio(aspectRatio: _videoPlayerController.value.aspectRatio, child: Chewie(controller: _chewieController!)),
    );
  }
}
