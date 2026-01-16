import 'package:flutter/material.dart';
import 'dart:async';

class MouseFollower extends StatefulWidget {
  final Widget child;
  const MouseFollower({super.key, required this.child});

  @override
  State<MouseFollower> createState() => _MouseFollowerState();
}

class _MouseFollowerState extends State<MouseFollower> {
  final List<Offset> _trail = [];
  Offset? _mousePos;
  Timer? _decayTimer;

  @override
  void initState() {
    super.initState();
    // Continuously prune the trail to create a shrinking/fading "ghost" effect
    // when movement stops.
    _decayTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_trail.isNotEmpty) {
        setState(() {
          _trail.removeAt(0); // Remove oldest point
        });
      }
    });
  }

  @override
  void dispose() {
    _decayTimer?.cancel();
    super.dispose();
  }

  void _onHover(PointerEvent event) {
    setState(() {
      _mousePos = event.position;
      // Add current position to history
      _trail.add(event.position);
      // Limit trail length so it doesn't get infinitely long
      if (_trail.length > 15) {
        _trail.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit: (_) {
        setState(() {
          _trail.clear();
          _mousePos = null;
        });
      },
      child: Stack(
        children: [
          // Main Application
          widget.child,

          // Trail Effect (rendered first so it's behind the main dot)
          ..._trail.asMap().entries.map((entry) {
            final index = entry.key;
            final pos = entry.value;
            // Calculate scale/opacity based on how "fresh" the point is
            final double progress =
                index / _trail.length; // 0.0 (old) -> 1.0 (new)
            final double size = 4 + (6 * progress); // Ranges from 4px to 10px

            return Positioned(
              left: pos.dx - (size / 2),
              top: pos.dy - (size / 2),
              child: IgnorePointer(
                child: Opacity(
                  opacity: progress * 0.4, // Max opacity 0.4
                  child: Container(
                    width: size,
                    height: size,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00FF94),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),

          // Main Dot (Animated Pulse)
          if (_mousePos != null)
            Positioned(
              left: _mousePos!.dx - 6,
              top: _mousePos!.dy - 6,
              child: IgnorePointer(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FF94),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00FF94).withOpacity(0.8),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
