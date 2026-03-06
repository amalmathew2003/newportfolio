import 'dart:math';
import 'package:flutter/material.dart';

/// Interactive particle constellation field — WebGL-style effect.
/// Particles float, connect with glowing lines when nearby, and
/// react to the mouse/touch cursor with a gravitational pull.
class ParticleField extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final Color lineColor;
  final double connectionDistance;
  final bool interactive;

  const ParticleField({
    super.key,
    this.particleCount = 80,
    this.particleColor = const Color(0xFF00FFA3),
    this.lineColor = const Color(0xFF00FFA3),
    this.connectionDistance = 150,
    this.interactive = true,
  });

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  Offset? _mousePos;
  final Random _rng = Random(42);
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _particles = [];
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  void _initParticles(Size size) {
    if (size == _lastSize && _particles.isNotEmpty) return;
    _lastSize = size;
    _particles = List.generate(widget.particleCount, (_) {
      return _Particle(
        x: _rng.nextDouble() * size.width,
        y: _rng.nextDouble() * size.height,
        vx: (_rng.nextDouble() - 0.5) * 0.6,
        vy: (_rng.nextDouble() - 0.5) * 0.6,
        radius: _rng.nextDouble() * 2 + 0.5,
        opacity: _rng.nextDouble() * 0.6 + 0.2,
        pulseSpeed: _rng.nextDouble() * 0.02 + 0.005,
        pulsePhase: _rng.nextDouble() * pi * 2,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initParticles(size);

        return MouseRegion(
          onHover: widget.interactive
              ? (event) => _mousePos = event.localPosition
              : null,
          onExit: (_) => _mousePos = null,
          child: Listener(
            onPointerMove: widget.interactive
                ? (event) => _mousePos = event.localPosition
                : null,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    size: size,
                    painter: _ParticleFieldPainter(
                      particles: _particles,
                      mousePos: _mousePos,
                      particleColor: widget.particleColor,
                      lineColor: widget.lineColor,
                      connectionDistance: widget.connectionDistance,
                      bounds: size,
                      time: _controller.value,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Particle {
  double x, y, vx, vy, radius, opacity, pulseSpeed, pulsePhase;
  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.opacity,
    required this.pulseSpeed,
    required this.pulsePhase,
  });
}

class _ParticleFieldPainter extends CustomPainter {
  final List<_Particle> particles;
  final Offset? mousePos;
  final Color particleColor;
  final Color lineColor;
  final double connectionDistance;
  final Size bounds;
  final double time;

  _ParticleFieldPainter({
    required this.particles,
    this.mousePos,
    required this.particleColor,
    required this.lineColor,
    required this.connectionDistance,
    required this.bounds,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Update particle positions
    for (final p in particles) {
      p.x += p.vx;
      p.y += p.vy;

      // Wrap around edges
      if (p.x < 0) p.x = bounds.width;
      if (p.x > bounds.width) p.x = 0;
      if (p.y < 0) p.y = bounds.height;
      if (p.y > bounds.height) p.y = 0;

      // Mouse attraction / repulsion
      if (mousePos != null) {
        final dx = mousePos!.dx - p.x;
        final dy = mousePos!.dy - p.y;
        final dist = sqrt(dx * dx + dy * dy);
        if (dist < 200 && dist > 0) {
          final force = (200 - dist) / 200 * 0.15;
          p.vx += dx / dist * force;
          p.vy += dy / dist * force;
        }
      }

      // Damping
      p.vx *= 0.99;
      p.vy *= 0.99;

      // Speed limit
      final speed = sqrt(p.vx * p.vx + p.vy * p.vy);
      if (speed > 2) {
        p.vx = p.vx / speed * 2;
        p.vy = p.vy / speed * 2;
      }
    }

    // Draw connection lines
    final linePaint = Paint()..strokeWidth = 0.5;

    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final dx = particles[i].x - particles[j].x;
        final dy = particles[i].y - particles[j].y;
        final dist = sqrt(dx * dx + dy * dy);

        if (dist < connectionDistance) {
          final alpha = (1 - dist / connectionDistance) * 0.25;
          linePaint.color = lineColor.withValues(alpha: alpha);
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            linePaint,
          );
        }
      }
    }

    // Draw mouse connections
    if (mousePos != null) {
      for (final p in particles) {
        final dx = mousePos!.dx - p.x;
        final dy = mousePos!.dy - p.y;
        final dist = sqrt(dx * dx + dy * dy);
        if (dist < connectionDistance * 1.5) {
          final alpha = (1 - dist / (connectionDistance * 1.5)) * 0.4;
          linePaint.color = lineColor.withValues(alpha: alpha);
          linePaint.strokeWidth = 0.8;
          canvas.drawLine(Offset(p.x, p.y), mousePos!, linePaint);
        }
      }

      // Mouse glow
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            particleColor.withValues(alpha: 0.15),
            particleColor.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: mousePos!, radius: 120));
      canvas.drawCircle(mousePos!, 120, glowPaint);
    }

    // Draw particles with pulsing
    final particlePaint = Paint();
    for (final p in particles) {
      final pulse = sin(time * pi * 2 * 60 * p.pulseSpeed + p.pulsePhase);
      final currentRadius = p.radius + pulse * 0.5;
      final currentOpacity = (p.opacity + pulse * 0.15).clamp(0.1, 1.0);

      // Glow
      particlePaint.shader =
          RadialGradient(
            colors: [
              particleColor.withValues(alpha: currentOpacity * 0.8),
              particleColor.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(p.x, p.y),
              radius: currentRadius * 4,
            ),
          );
      canvas.drawCircle(Offset(p.x, p.y), currentRadius * 4, particlePaint);

      // Core
      particlePaint.shader = null;
      particlePaint.color = particleColor.withValues(alpha: currentOpacity);
      canvas.drawCircle(Offset(p.x, p.y), currentRadius, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleFieldPainter oldDelegate) => true;
}
