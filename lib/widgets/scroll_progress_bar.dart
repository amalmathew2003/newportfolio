import 'package:flutter/material.dart';

/// Thin scroll progress indicator bar pinned to the top of the screen.
class ScrollProgressBar extends StatelessWidget {
  final ScrollController scrollController;
  final Color color;

  const ScrollProgressBar({
    super.key,
    required this.scrollController,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        double progress = 0.0;

        // Guard: controller must have a client AND the position must be ready
        if (scrollController.hasClients) {
          try {
            final max = scrollController.position.maxScrollExtent;
            if (max > 0) {
              progress = (scrollController.offset / max).clamp(0.0, 1.0);
            }
          } catch (_) {
            // Position not ready yet — keep progress at 0
          }
        }

        return SizedBox(
          height: 2,
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 80),
              width: MediaQuery.of(context).size.width * progress,
              height: 2,
              decoration: BoxDecoration(
                color: color,
                boxShadow: progress > 0
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.45),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
            ),
          ),
        );
      },
    );
  }
}
