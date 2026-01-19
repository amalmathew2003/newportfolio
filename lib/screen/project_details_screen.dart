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
  final String? videoUrl; // Add video url

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
      backgroundColor: const Color(0xFF050A1F),
      body: Stack(
        children: [
          // Background Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00D2FF).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Image Section
                SizedBox(
                  height: size.height * 0.6,
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
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              const Color(0xFF050A1F).withOpacity(0.8),
                              const Color(0xFF050A1F),
                            ],
                            stops: const [0.2, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Project Info
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 80,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Category
                      FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF00D2FF),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                category.toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF00D2FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              title.toUpperCase(),
                              style: GoogleFonts.syne(
                                fontSize: isMobile ? 40 : 80,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 0.9,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Description & Tech Stack Grid
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
                                      _buildDescription(),
                                      const SizedBox(height: 40),
                                      _buildTechStack(),
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
                                      _buildActions(),
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
                                            _buildDescription(),
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
                                            _buildTechStack(),
                                            const SizedBox(height: 40),
                                            _buildActions(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                          },
                        ),
                      ),

                      const SizedBox(height: 100),

                      // 3. Image Gallery
                      if (imageUrls.length > 1)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GALLERY",
                              style: GoogleFonts.syne(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            ...imageUrls.map(
                              (url) => Padding(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    url,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
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
                Text(
                  "• ",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    color: const Color(0xFF00D2FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.trim().replaceFirst(RegExp(r'^[•\-\*]\s*'), ''),
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.white70,
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
              fontSize: 18,
              color: Colors.white70,
              height: 1.8,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTechStack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TECH STACK",
          style: GoogleFonts.syne(
            fontSize: 14,
            color: Colors.white38,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _TechChip(label: "Flutter"),
            _TechChip(label: "Dart"),
            _TechChip(label: "Firebase"),
            _TechChip(label: "UI/UX"),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return GestureDetector(
      onTap: _launchUrl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF00D2FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FontAwesomeIcons.github, color: Colors.black),
            const SizedBox(width: 15),
            Text(
              "VIEW CODE",
              style: GoogleFonts.inter(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///===========================================TechChip===========================================//

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      ),
    );
  }
}

///===================================VideoPlayerWidget===================================//

class _VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const _VideoPlayerWidget({required this.videoUrl});

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

  bool _isInitialized = false;

  Future<void> _initializePlayer() async {
    // ✅ Prevent re-initialization (THIS IS THE KEY FIX)
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

    // ✅ PRELOAD VIDEO (buffer once, no loading on replay)
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
        playedColor: const Color(0xFF00D2FF),
        handleColor: const Color(0xFF00D2FF),
        bufferedColor: Colors.white38,
        backgroundColor: Colors.white24,
      ),
      placeholder: Container(
        color: Colors.black12,
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF00D2FF)),
        ),
      ),
      errorBuilder: (context, errorMessage) {
        return Container(
          color: Colors.black12,
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
    _chewieController?.pause(); // keep buffer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      return Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF00D2FF)),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 300, // Fixed height or aspect ratio based
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.white10),
        ),
        child: Chewie(controller: _chewieController!),
      ),
    );
  }
}
