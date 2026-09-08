import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/app_colors.dart';

class BreadcrumbNav extends StatelessWidget {
  final int activeIndex;
  final List<String> sections;
  final Function(int) onSectionTap;
  final VoidCallback onThemeToggle;
  final bool isDark;

  const BreadcrumbNav({
    super.key,
    required this.activeIndex,
    required this.sections,
    required this.onSectionTap,
    required this.onThemeToggle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.background(context).withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: AppColors.line(context),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Root Icon / Brand
            InkWell(
              onTap: () => onSectionTap(0),
              borderRadius: BorderRadius.circular(3),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: AppColors.cyan.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.developer_mode, size: 14, color: AppColors.cyan),
                    const SizedBox(width: 6),
                    Text(
                      'App',
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.cyan,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),
            Text(
              '›',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 14,
                color: AppColors.dim,
              ),
            ),
            const SizedBox(width: 8),

            // Responsive Breadcrumbs
            Expanded(
              child: isMobile
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _buildBreadcrumbs(context),
                      ),
                    )
                  : Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: _buildBreadcrumbs(context),
                    ),
            ),

            // DevTools Theme Toggle Button
            Tooltip(
              message: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              child: InkWell(
                onTap: onThemeToggle,
                borderRadius: BorderRadius.circular(3),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard(context),
                    border: Border.all(color: AppColors.line(context)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                        size: 14,
                        color: isDark ? AppColors.pink : AppColors.cyan,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isDark ? 'LIGHT' : 'DARK',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBreadcrumbs(BuildContext context) {
    List<Widget> list = [];
    for (int i = 1; i < sections.length; i++) {
      final isActive = i == activeIndex;

      list.add(
        InkWell(
          onTap: () => onSectionTap(i),
          borderRadius: BorderRadius.circular(3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Text(
              sections[i],
              style: GoogleFonts.ibmPlexMono(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive
                    ? AppColors.primaryText(context)
                    : AppColors.dim,
                decoration: isActive ? TextDecoration.underline : TextDecoration.none,
                decorationColor: AppColors.pink,
              ),
            ),
          ),
        ),
      );

      if (i < sections.length - 1) {
        list.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '›',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 12,
                color: AppColors.dim,
              ),
            ),
          ),
        );
      }
    }
    return list;
  }
}
