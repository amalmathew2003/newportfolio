import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/service/downloadcv.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final isMobile = size.width < 600;
          final isTablet = size.width >= 600 && size.width < 1200;

          double titleFontSize = isMobile
              ? 32
              : isTablet
              ? 48
              : 60;
          double subtitleFontSize = isMobile
              ? 16
              : isTablet
              ? 20
              : 24;
          double horizontalPadding = isMobile
              ? 20
              : isTablet
              ? 40
              : 80;

          return Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assests/images/landingpage.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              // Overlay gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              // Centered content
              Align(
                alignment: isMobile ? Alignment.center : Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isMobile
                          ? size.width * 0.9
                          : isTablet
                          ? size.width * 0.7
                          : size.width * 0.5,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isMobile
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.end,
                      children: [
                        // Name animation
                        Row(
                          mainAxisAlignment: isMobile
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FadeInUp(
                              duration: const Duration(seconds: 2),
                              child: Text(
                                'Amal ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            FadeInDown(
                              duration: const Duration(seconds: 3),
                              child: Text(
                                'Mathew',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Subtitle
                        Wrap(
                          alignment: isMobile
                              ? WrapAlignment.center
                              : WrapAlignment.end,
                          children: [
                            AnimatedTextKit(
                              repeatForever: true,
                              pause: const Duration(seconds: 2),
                              animatedTexts: [
                                TyperAnimatedText(
                                  'Flutter Developer |',
                                  textStyle: GoogleFonts.namdhinggo(
                                    color: Colors.white70,
                                    fontSize: subtitleFontSize,
                                  ),
                                ),
                              ],
                            ),
                            AnimatedTextKit(
                              repeatForever: true,
                              pause: const Duration(seconds: 2),
                              animatedTexts: [
                                TyperAnimatedText(
                                  ' UI/UX Enthusiast',
                                  textStyle: GoogleFonts.namdhinggo(
                                    color: Colors.white70,
                                    fontSize: subtitleFontSize,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Download CV button
                        ElasticInUp(
                          duration: const Duration(seconds: 2),
                          delay: const Duration(milliseconds: 800),
                          child: GestureDetector(
                            onTap: () {
                              downloadCV(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF0F2027),
                                    Color(0xFF203A43),
                                    Color(0xFF2C5364),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withValues(alpha: .4),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Download CV',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
