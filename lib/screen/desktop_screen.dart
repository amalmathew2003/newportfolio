import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/service/downloadcv.dart';
import 'package:my_portfolio/widgets/gradient_button.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final isTablet =
              constraints.maxWidth >= 600 && constraints.maxWidth < 1200;

          double titleFontSize = isMobile
              ? 36
              : isTablet
              ? 52
              : 68;
          double subtitleFontSize = isMobile
              ? 18
              : isTablet
              ? 22
              : 28;
          double horizontalPadding = isMobile
              ? 20
              : isTablet
              ? 40
              : 80;

          return Stack(
            children: [
              // Animated gradient background
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.lerp(
                            const Color(0xFF0a0a0a),
                            const Color(0xFF1a1a2e),
                            _controller.value,
                          )!,
                          Color.lerp(
                            const Color(0xFF16213e),
                            const Color(0xFF0f3460),
                            _controller.value,
                          )!,
                          Color.lerp(
                            const Color(0xFF1a1a2e),
                            const Color(0xFF0a0a0a),
                            _controller.value,
                          )!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  );
                },
              ),

              // Background image with overlay
              Positioned.fill(
                child: FadeIn(
                  duration: const Duration(seconds: 2),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assests/images/landingpage.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      // Dark overlay for better text visibility
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.4),
                              Colors.black.withOpacity(0.7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Floating glow orbs
              Positioned(
                top: size.height * 0.2,
                left: size.width * 0.1,
                child: FadeIn(
                  delay: const Duration(seconds: 1),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF667eea).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.15,
                right: size.width * 0.05,
                child: FadeIn(
                  delay: const Duration(milliseconds: 1500),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFf093fb).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Main content
              Align(
                alignment: isMobile ? Alignment.center : Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isMobile
                          ? constraints.maxWidth * 0.9
                          : isTablet
                          ? constraints.maxWidth * 0.7
                          : constraints.maxWidth * 0.55,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isMobile
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.end,
                      children: [
                        // Greeting text
                        FadeInDown(
                          duration: const Duration(milliseconds: 800),
                          child: Text(
                            'Hello, I\'m',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF00d4ff),
                              fontSize: subtitleFontSize * 0.8,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Name with gradient effect
                        FadeInUp(
                          duration: const Duration(seconds: 1),
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFFffffff), Color(0xFF00d4ff)],
                            ).createShader(bounds),
                            child: Text(
                              'Amal Mathew',
                              textAlign: isMobile
                                  ? TextAlign.center
                                  : TextAlign.right,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Animated subtitle
                        FadeIn(
                          delay: const Duration(milliseconds: 500),
                          child: DefaultTextStyle(
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: isMobile
                                ? TextAlign.center
                                : TextAlign.right,
                            child: AnimatedTextKit(
                              repeatForever: true,
                              pause: const Duration(seconds: 2),
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Flutter Developer',
                                  speed: const Duration(milliseconds: 100),
                                ),
                                TypewriterAnimatedText(
                                  'UI/UX Enthusiast',
                                  speed: const Duration(milliseconds: 100),
                                ),
                                TypewriterAnimatedText(
                                  'Mobile App Creator',
                                  speed: const Duration(milliseconds: 100),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // CTA Buttons
                        FadeInUp(
                          delay: const Duration(milliseconds: 800),
                          child: Wrap(
                            alignment: isMobile
                                ? WrapAlignment.center
                                : WrapAlignment.end,
                            spacing: 20,
                            runSpacing: 15,
                            children: [
                              GradientButton(
                                text: 'Download CV',
                                icon: Icons.download_rounded,
                                onPressed: () => downloadCV(context),
                                gradientColors: const [
                                  Color(0xFF667eea),
                                  Color(0xFF764ba2),
                                ],
                              ),
                              GradientButton(
                                text: 'View Projects',
                                icon: Icons.work_outline_rounded,
                                onPressed: () {
                                  // Scroll to projects
                                },
                                gradientColors: const [
                                  Color(0xFF00d4ff),
                                  Color(0xFF00a8cc),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Scroll indicator
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: FadeInUp(
                  delay: const Duration(seconds: 2),
                  child: Center(
                    child: Pulse(
                      infinite: true,
                      child: Column(
                        children: [
                          Text(
                            'Scroll Down',
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white54,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
