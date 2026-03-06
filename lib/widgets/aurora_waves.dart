import 'dart:math';
import 'package:flutter/material.dart';

/// Flowing aurora / northern lights wave effect.
/// Multiple animated sine waves with gradient fills create a
/// mesmerizing WebGL-style background effect.
class AuroraWaves extends StatefulWidget {
  final List<Color> colors;
  final int waveCount;
  final double speed;

  const AuroraWaves({
    super.key,
    this.colors = const [
      Color(0xFF00FFA3),
      Color(0xFF8B5CF6),
      Color(0xFFFF006E),
      Color(0xFF00D4FF),
    ],
    this.waveCount = 4,
    this.speed = 1.0,
  });

  @override
  State<AuroraWaves> createState() => _AuroraWavesState();
}

class _AuroraWavesState extends State<AuroraWaves>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _AuroraPainter(
              time: _controller.value * pi * 2,
              colors: widget.colors,
              waveCount: widget.waveCount,
              speed: widget.speed,
            ),
          );
        },
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final double time;
  final List<Color> colors;
  final int waveCount;
  final double speed;

  _AuroraPainter({
    required this.time,
    required this.colors,
    required this.waveCount,
    required this.speed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < waveCount; i++) {
      _drawWave(canvas, size, i);
    }
  }

  void _drawWave(Canvas canvas, Size size, int index) {
    final path = Path();
    final color1 = colors[index % colors.length];
    final color2 = colors[(index + 1) % colors.length];

    final phaseShift = index * 0.8;
    final amplitudeBase = size.height * (0.05 + index * 0.03);
    final yCenter = size.height * (0.3 + index * 0.12);
    final frequency = 1.5 + index * 0.3;

    // Start path from bottom-left
    path.moveTo(0, size.height);

    // Build wave from left to right
    const step = 3.0;
    for (double x = 0; x <= size.width; x += step) {
      final normalizedX = x / size.width;

      // Multi-layered sine for organic feel
      final wave1 = sin(
        normalizedX * frequency * pi * 2 + time * speed + phaseShift,
      );
      final wave2 =
          sin(
            normalizedX * frequency * 1.7 * pi * 2 -
                time * speed * 0.7 +
                phaseShift * 1.3,
          ) *
          0.5;
      final wave3 =
          sin(
            normalizedX * frequency * 3.1 * pi * 2 +
                time * speed * 0.3 +
                phaseShift * 2.1,
          ) *
          0.25;

      final y = yCenter + (wave1 + wave2 + wave3) * amplitudeBase;
      path.lineTo(x, y);
    }

    // Close path to bottom
    path.lineTo(size.width, size.height);
    path.close();

    // Gradient fill
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color1.withValues(alpha: 0.06 - index * 0.01),
          color2.withValues(alpha: 0.02),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);

    // Stroke the wave top with a glowing line
    final strokePath = Path();
    strokePath.moveTo(
      0,
      yCenter + sin(time * speed + phaseShift) * amplitudeBase,
    );

    for (double x = 0; x <= size.width; x += step) {
      final normalizedX = x / size.width;
      final wave1 = sin(
        normalizedX * frequency * pi * 2 + time * speed + phaseShift,
      );
      final wave2 =
          sin(
            normalizedX * frequency * 1.7 * pi * 2 -
                time * speed * 0.7 +
                phaseShift * 1.3,
          ) *
          0.5;
      final wave3 =
          sin(
            normalizedX * frequency * 3.1 * pi * 2 +
                time * speed * 0.3 +
                phaseShift * 2.1,
          ) *
          0.25;
      final y = yCenter + (wave1 + wave2 + wave3) * amplitudeBase;
      strokePath.lineTo(x, y);
    }

    // Glow stroke
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = color1.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(strokePath, glowPaint);

    // Thin bright stroke
    final thinPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = color1.withValues(alpha: 0.12);
    canvas.drawPath(strokePath, thinPaint);
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) => true;
}
