import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/app_colors.dart';

/// Thin hairline scroll progress indicator bar pinned to the top of the screen.
class ScrollProgressBar extends StatelessWidget {
  final ScrollController? controller;
  final ScrollController? scrollController;
  final Color? color;

  const ScrollProgressBar({
    super.key,
    this.controller,
    this.scrollController,
    this.color,
  });

  ScrollController get _activeController => controller ?? scrollController ?? ScrollController();

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.cyan;

    return AnimatedBuilder(
      animation: _activeController,
      builder: (context, _) {
        double progress = 0.0;

        if (_activeController.hasClients) {
          try {
            final max = _activeController.position.maxScrollExtent;
            if (max > 0) {
              progress = (_activeController.offset / max).clamp(0.0, 1.0);
            }
          } catch (_) {}
        }

        return SizedBox(
          height: 2,
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              width: MediaQuery.of(context).size.width * progress,
              height: 2,
              decoration: BoxDecoration(
                color: activeColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

