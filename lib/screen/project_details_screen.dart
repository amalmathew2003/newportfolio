import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/widgets/inspector_box.dart';
import 'package:my_portfolio/widgets/tech_generic_tag.dart';
import 'package:my_portfolio/widgets/gradient_button.dart';

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

  void _showImageLightbox(BuildContext context, int initialIndex) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (dialogContext) {
        return _ScreenshotLightboxDialog(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
          projectTitle: title,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    final cleanTitle = title.replaceAll(RegExp(r'\s+'), '');

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryText(context)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'ProjectInspector › $title',
          style: GoogleFonts.ibmPlexMono(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.cyan,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 48,
            vertical: isMobile ? 24 : 48,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: InspectorBox(
                widgetTag: 'ProjectDetail($cleanTitle)',
                dimensionTag: category,
                signalAccent: SignalAccent.cyan,
                padding: EdgeInsets.only(
                  top: isMobile ? 36 : 42,
                  left: isMobile ? 16 : 24,
                  right: isMobile ? 16 : 24,
                  bottom: isMobile ? 16 : 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: isMobile ? 24 : 36,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryText(context),
                            ),
                          ),
                        ),
                        DevToolsButton(
                          text: 'GITHUB SOURCE',
                          onPressed: _launchUrl,
                          icon: Icons.code,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    TechGenericTag(
                      baseName: cleanTitle,
                      typeArguments: techStack,
                      fontSize: 14,
                    ),

                    const SizedBox(height: 28),

                    // Phone Screenshots Showcase Gallery
                    if (imageUrls.isNotEmpty)
                      _buildScreenshotsGallery(context, isMobile),

                    const SizedBox(height: 36),

                    Text(
                      'Overview & Specifications',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText(context),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      description,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: isMobile ? 14 : 16,
                        height: 1.6,
                        color: AppColors.dim,
                      ),
                    ),

                    const SizedBox(height: 32),

                    DevToolsButton(
                      text: 'BACK TO PORTFOLIO',
                      isSecondary: true,
                      onPressed: () => Navigator.pop(context),
                      icon: Icons.arrow_back,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScreenshotsGallery(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'App Screenshots (${imageUrls.length})',
              style: GoogleFonts.spaceGrotesk(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText(context),
              ),
            ),
            Text(
              'Scroll →',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 11,
                color: AppColors.cyan,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Horizontal Gallery of Mobile Phone Mockups
        SizedBox(
          height: isMobile ? 360 : 420,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: imageUrls.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final imgUrl = imageUrls[index];
              return _buildPhoneScreenshotCard(context, imgUrl, index, isMobile);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneScreenshotCard(
    BuildContext context,
    String imgUrl,
    int index,
    bool isMobile,
  ) {
    final phoneHeight = isMobile ? 310.0 : 360.0;
    final phoneWidth = phoneHeight * (9.0 / 19.5); // Native mobile phone ratio

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _showImageLightbox(context, index),
            child: Container(
              height: phoneHeight,
              width: phoneWidth,
              decoration: BoxDecoration(
                color: AppColors.surfaceCard(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.cyan.withValues(alpha: 0.6),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    // Phone Screen Image
                    Positioned.fill(
                      child: Image.asset(
                        imgUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (ctx, err, stack) => Center(
                          child: Text(
                            '[ Screen ${index + 1} ]',
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 11,
                              color: AppColors.dim,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Top Phone Notch / Dynamic Pill Indicator
                    Positioned(
                      top: 6,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),

                    // Hover Lightbox Hint Icon
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.zoom_in,
                          color: AppColors.cyan,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Screen ${index + 1}',
          style: GoogleFonts.ibmPlexMono(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.dim,
          ),
        ),
      ],
    );
  }
}

class _ScreenshotLightboxDialog extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String projectTitle;

  const _ScreenshotLightboxDialog({
    required this.imageUrls,
    required this.initialIndex,
    required this.projectTitle,
  });

  @override
  State<_ScreenshotLightboxDialog> createState() => _ScreenshotLightboxDialogState();
}

class _ScreenshotLightboxDialogState extends State<_ScreenshotLightboxDialog> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _next() {
    if (_currentIndex < widget.imageUrls.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _prev() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 600;
    final phoneHeight = size.height * (isSmall ? 0.65 : 0.75);
    final phoneWidth = phoneHeight * (9.0 / 19.5);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isSmall ? 360 : 480,
        ),
        child: InspectorBox(
          widgetTag: 'ScreenshotView(${_currentIndex + 1}/${widget.imageUrls.length})',
          dimensionTag: '${phoneWidth.toInt()}×${phoneHeight.toInt()}',
          signalAccent: SignalAccent.cyan,
          padding: const EdgeInsets.only(top: 36, left: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${widget.projectTitle} • Screen ${_currentIndex + 1}',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.cyan,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.dim, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Phone Frame View
              Center(
                child: Container(
                  height: phoneHeight,
                  width: phoneWidth,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.cyan,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyan.withValues(alpha: 0.25),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      widget.imageUrls[_currentIndex],
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Navigation Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    color: _currentIndex > 0 ? AppColors.cyan : AppColors.dim.withValues(alpha: 0.3),
                    onPressed: _currentIndex > 0 ? _prev : null,
                  ),
                  Text(
                    '${_currentIndex + 1} / ${widget.imageUrls.length}',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.dim,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    color: _currentIndex < widget.imageUrls.length - 1
                        ? AppColors.cyan
                        : AppColors.dim.withValues(alpha: 0.3),
                    onPressed: _currentIndex < widget.imageUrls.length - 1 ? _next : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
