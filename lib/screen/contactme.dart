import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContactMe extends StatefulWidget {
  const ContactMe({super.key});

  @override
  State<ContactMe> createState() => _ContactMeState();
}

class _ContactMeState extends State<ContactMe> {
  final String email = 'mathewamalmathew@gmail.com';
  final String github = 'https://github.com/amalmathew2003';
  final String linkedin = 'https://www.linkedin.com/in/amal-mathew-1-/';
  bool _visible = false;

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not open $url")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return VisibilityDetector(
      key: const Key('Contact-me-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() {
            _visible = true; // triggers the animations
          });
        }
      },

      child: Container(
        width: double.infinity,
        height: 600, // Center vertically by giving height
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              // Animated Title
              _visible
                  ? FadeInUpBig(
                      duration: const Duration(seconds: 1),

                      child: Text(
                        "Contact Me",
                        style: TextStyle(
                          fontSize: isMobile ? 32 : 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              SizedBox(height: isMobile ? 20 : 40),
              _visible
                  ? FadeIn(
                      duration: const Duration(seconds: 1),

                      child: Container(
                        width: 120,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),

              const SizedBox(height: 20),

              // Animated Subtitle
              FadeInUpBig(
                duration: const Duration(seconds: 1),
                child: Text(
                  "I'm open for opportunities, collaborations, or freelance work.\nFeel free to reach out!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .8),
                    fontSize: isMobile ? 16 : 18,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Contact Cards
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _animatedCard(
                    title: "Email Me",
                    subtitle: email,
                    imagePath:
                        "assests/images/mail.png", // replace with your image
                    startColor: Colors.blueAccent,
                    endColor: Colors.lightBlue,
                    onTap: () => _launchUrl('mailto:$email'),
                  ),
                  _animatedCard(
                    title: "GitHub",
                    subtitle: "View my projects",
                    imagePath: "assests/images/githublogo.png",
                    startColor: Colors.black,
                    endColor: const Color.fromARGB(255, 81, 81, 81),
                    onTap: () => _launchUrl(github),
                  ),
                  _animatedCard(
                    title: "LinkedIn",
                    subtitle: "Connect with me",
                    imagePath: "assests/images/link.png",
                    startColor: Colors.blue[700]!,
                    endColor: Colors.lightBlueAccent,
                    onTap: () => _launchUrl(linkedin),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animatedCard({
    required String title,
    required String subtitle,
    required String imagePath, // changed from IconData
    required Color startColor,
    required Color endColor,
    required VoidCallback onTap,
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 1.0, end: 1.0),
            duration: const Duration(milliseconds: 200),
            builder: (context, double scale, child) {
              return HoverAnimatedContainer(
                width: 240,
                padding: const EdgeInsets.all(20),
                startColor: startColor,
                endColor: endColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Display image instead of icon
                    Image.asset(
                      imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class HoverAnimatedContainer extends StatefulWidget {
  final double width;
  final EdgeInsets padding;
  final Widget child;
  final Color startColor;
  final Color endColor;

  const HoverAnimatedContainer({
    super.key,
    required this.width,
    required this.padding,
    required this.child,
    required this.startColor,
    required this.endColor,
  });

  @override
  State<HoverAnimatedContainer> createState() => _HoverAnimatedContainerState();
}

class _HoverAnimatedContainerState extends State<HoverAnimatedContainer> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: widget.width,
      padding: widget.padding,
      transform: Matrix4.identity()..scale(isHover ? 1.05 : 1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            Color.lerp(
              widget.startColor,
              Colors.transparent,
              isHover ? 0.0 : 0.1,
            )!,
            Color.lerp(
              widget.endColor,
              Colors.transparent,
              isHover ? 0.0 : 0.2,
            )!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Color.fromARGB(51, 255, 255, 255), width: 1),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(isHover ? 153 : 102, 0, 0, 0),
            blurRadius: isHover ? 18 : 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHover = true),
        onExit: (_) => setState(() => isHover = false),
        child: widget.child,
      ),
    );
  }
}
