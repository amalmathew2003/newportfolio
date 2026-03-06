import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:my_portfolio/data/social_links.dart';

Future<void> downloadCVPlatform(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(color: Color(0xFF00FFA3)),
    ),
  );

  await Future.delayed(const Duration(seconds: 1));

  html.AnchorElement(href: SocialLinks.cvDownloadUrl)
    ..setAttribute("download", "AmalMathewCV.pdf")
    ..click();

  Navigator.pop(context);
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('CV download started')));
}
