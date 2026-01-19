import 'package:flutter/material.dart';
import 'package:my_portfolio/screen/main_page.dart';
import 'package:my_portfolio/widgets/mouse_follower.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MouseFollower(child: PortfolioLandingPage()),
    );
  }
}

class PortfolioLandingPage extends StatelessWidget {
  const PortfolioLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Return different screens based on width
    return const PortfolioScrollablePage();
  }
}
