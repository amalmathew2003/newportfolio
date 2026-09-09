import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:my_portfolio/constants/app_colors.dart';
import 'package:my_portfolio/service/downloadcv.dart';
import 'package:my_portfolio/widgets/inspector_box.dart';
import 'package:my_portfolio/widgets/gradient_button.dart';
import 'package:my_portfolio/widgets/mouse_follow_avatar.dart';
import 'package:my_portfolio/widgets/tech_generic_tag.dart';

class DesktopScreen extends StatefulWidget {
  final VoidCallback? onContactTap;
  final VoidCallback? onProjectsTap;

  const DesktopScreen({super.key, this.onContactTap, this.onProjectsTap});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen>
    with SingleTickerProviderStateMixin {
  int _rebuildCounter = 1;
  bool _isDiffFlashing = false;
  late AnimationController _fabAnimController;

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fabAnimController.dispose();
    super.dispose();
  }

  void _triggerHotReload() {
    final reducedMotion = MediaQuery.of(context).accessibleNavigation;
    if (reducedMotion) {
      setState(() {
        _rebuildCounter++;
      });
      return;
    }

    setState(() {
      _isDiffFlashing = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _isDiffFlashing = false;
          _rebuildCounter++;
        });
      }
    });
  }

  void _showProfileImageLightbox(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (dialogContext) {
        final size = MediaQuery.of(dialogContext).size;
        final isSmall = size.width < 500;
        final avatarSize = isSmall ? 250.0 : 310.0;

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Close Button Bar
              SizedBox(
                width: avatarSize,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(dialogContext).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.line(context)),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Floating Circular Profile Avatar (Instagram Lightbox style)
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cyan, width: 3.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.4),
                      blurRadius: 32,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/portfolio1.png',
                    fit: BoxFit.cover,
                    alignment: const Alignment(-0.35, -0.25),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Clean text info below image
              Text(
                'Amal Mathew',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Flutter Developer • Thrissur, Kerala',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.cyan,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      color: AppColors.background(context),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 48,
        vertical: isMobile ? 24 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: InspectorBox(
            widgetTag: 'Hero',
            dimensionTag: '${size.width.toInt()}×${size.height.toInt()}',
            signalAccent: SignalAccent.pink,
            padding: EdgeInsets.all(isMobile ? 20 : 36),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroText(context, isMobile: true),
                      const SizedBox(height: 36),
                      Center(child: _buildPhoneMockup(context)),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _buildHeroText(context, isMobile: false),
                      ),
                      const SizedBox(width: 48),
                      Expanded(
                        flex: 5,
                        child: Center(child: MouseFollowAvatar(size: 300)),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroText(BuildContext context, {required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        // Code metadata role tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.cyan.withValues(alpha: 0.1),
            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            'const Role = FlutterDeveloper & MobileArchitect;',
            style: GoogleFonts.ibmPlexMono(
              fontSize: isMobile ? 11 : 13,
              fontWeight: FontWeight.w600,
              color: AppColors.cyan,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Main Name Headline
        Text(
          'Amal Mathew',
          style: GoogleFonts.spaceGrotesk(
            fontSize: isMobile ? 38 : 64,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText(context),
            letterSpacing: -1.5,
            height: 1.05,
          ),
        ),

        const SizedBox(height: 16),

        // Subtitle / Bio
        Text(
          'Building high-performance, cross-platform mobile & web applications with Dart, Flutter, and clean software architecture.',
          style: GoogleFonts.spaceGrotesk(
            fontSize: isMobile ? 15 : 18,
            height: 1.5,
            color: AppColors.dim,
          ),
        ),

        const SizedBox(height: 24),

        // Generic type stack tag
        const TechGenericTag(
          baseName: 'Stack',
          typeArguments: [
            'Flutter',
            'Dart',
            'Firebase',
            'REST',
            'Provider',
            'Hive',
          ],
          fontSize: 13,
        ),

        const SizedBox(height: 32),

        // Action Buttons
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            DevToolsButton(
              text: 'VIEW WORK',
              onPressed: () {
                if (widget.onProjectsTap != null) {
                  widget.onProjectsTap!();
                }
              },
              icon: Icons.code,
            ),
            DevToolsButton(
              text: 'DOWNLOAD CV',
              isSecondary: true,
              onPressed: () => downloadCV(context),
              icon: Icons.download_outlined,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhoneMockup(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        width: 280,
        height: 480,
        decoration: BoxDecoration(
          color: isDark ? AppColors.ink : AppColors.paper,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.pink, width: 1.5),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // Phone Top Notch Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard(context),
                    border: Border(
                      bottom: BorderSide(color: AppColors.line(context)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.pink,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'HotReloadDemo()',
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.pink,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'v3.22.0',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 9,
                          color: AppColors.dim,
                        ),
                      ),
                    ],
                  ),
                ),

                // Phone Screen Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Developer Profile App Header Card (Entire Box Clickable)
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => _showProfileImageLightbox(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard(context),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppColors.line(context),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.cyan,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/portfolio1.png',
                                        fit: BoxFit.cover,
                                        alignment: const Alignment(
                                          -0.35,
                                          -0.25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Amal Mathew',
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primaryText(
                                              context,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Flutter Developer',
                                          style: GoogleFonts.ibmPlexMono(
                                            fontSize: 10,
                                            color: AppColors.cyan,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Counter Display Card
                        Column(
                          children: [
                            Text(
                              'Widget Rebuilds',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13,
                                color: AppColors.dim,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$_rebuildCounter',
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 52,
                                fontWeight: FontWeight.w700,
                                color: AppColors.cyan,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cyan.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: AppColors.cyan.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                'final counter = useState($_rebuildCounter);',
                                style: GoogleFonts.ibmPlexMono(
                                  fontSize: 10,
                                  color: AppColors.cyan,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),

                // Phone Bottom Bar / Hint
                Container(
                  padding: const EdgeInsets.all(10),
                  color: AppColors.surfaceCard(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Click FAB for cyan diff flash',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 9,
                          color: AppColors.dim,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Diff Flash Overlay (~200ms cyan flash on hot reload)
            if (_isDiffFlashing)
              Positioned.fill(
                child: Container(
                  color: AppColors.cyan.withValues(alpha: 0.4),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: AppColors.cyan),
                      ),
                      child: Text(
                        '⚡ HOT RELOAD DIFF',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.cyan,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Pink Floating Action Button (FAB) with Lottie Animated Pulse & Tap Hint
            Positioned(
              bottom: 30,
              right: 8,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // 1. Vector Lottie Tap Ripple Animation
                  IgnorePointer(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Lottie.asset(
                        'assets/lottie/tap_animation.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // 2. Bouncing "TAP ME ⚡" Tooltip Pill Tag
                  Positioned(
                    right: 52,
                    child: AnimatedBuilder(
                      animation: _fabAnimController,
                      builder: (context, child) {
                        final offsetX = -5.0 * _fabAnimController.value;
                        return Transform.translate(
                          offset: Offset(offsetX, 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.pink,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.pink.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'TAP ME',
                                  style: GoogleFonts.ibmPlexMono(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 9,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 3. Interactive Floating Action Button
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: FloatingActionButton.small(
                      onPressed: _triggerHotReload,
                      backgroundColor: AppColors.pink,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.flash_on,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
