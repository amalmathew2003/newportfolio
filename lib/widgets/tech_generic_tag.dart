import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';

/// Dart generic syntax renderer for tech stacks:
/// `ProjectName<Flutter, Hive, GroqAI>`
class TechGenericTag extends StatelessWidget {
  final String baseName;
  final List<String> typeArguments;
  final double fontSize;

  const TechGenericTag({
    super.key,
    required this.baseName,
    required this.typeArguments,
    this.fontSize = 13.0,
  });

  @override
  Widget build(BuildContext context) {
    final cleanBase = baseName.replaceAll(RegExp(r'\s+'), '');
    final cleanArgs = typeArguments.map((arg) => arg.replaceAll(RegExp(r'\s+'), '')).join(', ');

    return RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexMono(
          fontSize: fontSize,
          height: 1.4,
        ),
        children: [
          TextSpan(
            text: cleanBase,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText(context),
            ),
          ),
          TextSpan(
            text: '<',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.pink,
            ),
          ),
          TextSpan(
            text: cleanArgs,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: AppColors.cyan,
            ),
          ),
          TextSpan(
            text: '>',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.pink,
            ),
          ),
        ],
      ),
    );
  }
}
