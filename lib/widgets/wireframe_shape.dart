import 'dart:math';
import 'package:flutter/material.dart';

/// 3D wireframe shape that rotates in space — like a Three.js geometry.
/// Renders a dodecahedron/icosahedron with glowing edges and perspective projection.
class WireframeShape extends StatefulWidget {
  final double size;
  final Color color;
  final Color glowColor;
  final double rotationSpeed;
  final ShapeType shapeType;

  const WireframeShape({
    super.key,
    this.size = 200,
    this.color = const Color(0xFF00FFA3),
    this.glowColor = const Color(0xFF8B5CF6),
    this.rotationSpeed = 1.0,
    this.shapeType = ShapeType.icosahedron,
  });

  @override
  State<WireframeShape> createState() => _WireframeShapeState();
}

enum ShapeType { icosahedron, torusKnot, octahedron }

class _WireframeShapeState extends State<WireframeShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset? _mouseOffset;

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
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _mouseOffset = Offset(
            (event.localPosition.dx - widget.size / 2) / widget.size,
            (event.localPosition.dy - widget.size / 2) / widget.size,
          );
        });
      },
      onExit: (_) => setState(() => _mouseOffset = null),
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _WireframePainter(
                time: _controller.value * pi * 2,
                color: widget.color,
                glowColor: widget.glowColor,
                rotationSpeed: widget.rotationSpeed,
                shapeType: widget.shapeType,
                mouseOffset: _mouseOffset,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Vec3 {
  double x, y, z;
  _Vec3(this.x, this.y, this.z);

  _Vec3 rotateX(double angle) {
    final c = cos(angle), s = sin(angle);
    return _Vec3(x, y * c - z * s, y * s + z * c);
  }

  _Vec3 rotateY(double angle) {
    final c = cos(angle), s = sin(angle);
    return _Vec3(x * c + z * s, y, -x * s + z * c);
  }

  _Vec3 rotateZ(double angle) {
    final c = cos(angle), s = sin(angle);
    return _Vec3(x * c - y * s, x * s + y * c, z);
  }

  Offset project(double fov, double viewDist, double cx, double cy) {
    final factor = fov / (viewDist + z);
    return Offset(x * factor + cx, y * factor + cy);
  }

  double get depth => z;
}

class _WireframePainter extends CustomPainter {
  final double time;
  final Color color;
  final Color glowColor;
  final double rotationSpeed;
  final ShapeType shapeType;
  final Offset? mouseOffset;

  _WireframePainter({
    required this.time,
    required this.color,
    required this.glowColor,
    required this.rotationSpeed,
    required this.shapeType,
    this.mouseOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final scale = size.width * 0.3;

    // Get shape data
    final (vertices, edges) = _getShapeData();

    // Calculate rotation angles — mouse influences rotation
    final mx = mouseOffset?.dx ?? 0;
    final my = mouseOffset?.dy ?? 0;
    final rx = time * rotationSpeed * 0.4 + my * 0.5;
    final ry = time * rotationSpeed * 0.6 + mx * 0.5;
    final rz = time * rotationSpeed * 0.2;

    // Transform vertices
    final projected = <Offset>[];
    final depths = <double>[];
    for (final v in vertices) {
      var p = _Vec3(v.x * scale, v.y * scale, v.z * scale);
      p = p.rotateX(rx).rotateY(ry).rotateZ(rz);
      projected.add(p.project(400, 600, cx, cy));
      depths.add(p.depth);
    }

    // Sort edges by average depth (back to front)
    final sortedEdges = List.generate(edges.length, (i) => i);
    sortedEdges.sort((a, b) {
      final da = (depths[edges[a][0]] + depths[edges[a][1]]) / 2;
      final db = (depths[edges[b][0]] + depths[edges[b][1]]) / 2;
      return da.compareTo(db);
    });

    // Draw edges
    for (final ei in sortedEdges) {
      final e = edges[ei];
      final p1 = projected[e[0]];
      final p2 = projected[e[1]];
      final avgDepth = (depths[e[0]] + depths[e[1]]) / 2;

      // Depth-based opacity (further = dimmer)
      final depthFactor = ((avgDepth / scale) + 1) / 2; // 0 to 1
      final alpha = (0.15 + depthFactor * 0.45).clamp(0.05, 0.6);

      // Glow line (wider, transparent)
      final glowPaint = Paint()
        ..color = Color.lerp(
          color,
          glowColor,
          depthFactor,
        )!.withValues(alpha: alpha * 0.4)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawLine(p1, p2, glowPaint);

      // Core line
      final linePaint = Paint()
        ..color = Color.lerp(
          color,
          glowColor,
          depthFactor,
        )!.withValues(alpha: alpha)
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(p1, p2, linePaint);
    }

    // Draw vertices
    for (int i = 0; i < projected.length; i++) {
      final depthFactor = ((depths[i] / scale) + 1) / 2;
      final alpha = (0.3 + depthFactor * 0.5).clamp(0.1, 0.8);
      final vertexSize = 1.5 + depthFactor * 2;

      // Vertex glow
      final glowPaint = Paint()
        ..shader =
            RadialGradient(
              colors: [
                Color.lerp(
                  color,
                  glowColor,
                  depthFactor,
                )!.withValues(alpha: alpha * 0.5),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCircle(center: projected[i], radius: vertexSize * 4),
            );
      canvas.drawCircle(projected[i], vertexSize * 4, glowPaint);

      // Vertex core
      final dotPaint = Paint()
        ..color = Color.lerp(
          color,
          glowColor,
          depthFactor,
        )!.withValues(alpha: alpha);
      canvas.drawCircle(projected[i], vertexSize, dotPaint);
    }
  }

  (List<_Vec3>, List<List<int>>) _getShapeData() {
    switch (shapeType) {
      case ShapeType.icosahedron:
        return _icosahedron();
      case ShapeType.torusKnot:
        return _torusKnot();
      case ShapeType.octahedron:
        return _octahedron();
    }
  }

  (List<_Vec3>, List<List<int>>) _icosahedron() {
    final t = (1 + sqrt(5)) / 2; // golden ratio
    final vertices = [
      _Vec3(-1, t, 0),
      _Vec3(1, t, 0),
      _Vec3(-1, -t, 0),
      _Vec3(1, -t, 0),
      _Vec3(0, -1, t),
      _Vec3(0, 1, t),
      _Vec3(0, -1, -t),
      _Vec3(0, 1, -t),
      _Vec3(t, 0, -1),
      _Vec3(t, 0, 1),
      _Vec3(-t, 0, -1),
      _Vec3(-t, 0, 1),
    ];
    // Normalize
    final len = sqrt(1 + t * t);
    for (final v in vertices) {
      v.x /= len;
      v.y /= len;
      v.z /= len;
    }
    final edges = [
      [0, 11],
      [0, 5],
      [0, 1],
      [0, 7],
      [0, 10],
      [1, 5],
      [1, 9],
      [1, 8],
      [1, 7],
      [2, 4],
      [2, 11],
      [2, 10],
      [2, 6],
      [2, 3],
      [3, 4],
      [3, 9],
      [3, 8],
      [3, 6],
      [4, 5],
      [4, 9],
      [4, 11],
      [5, 9],
      [5, 11],
      [6, 7],
      [6, 8],
      [6, 10],
      [7, 8],
      [7, 10],
      [8, 9],
      [10, 11],
    ];
    return (vertices, edges);
  }

  (List<_Vec3>, List<List<int>>) _octahedron() {
    final vertices = [
      _Vec3(1, 0, 0),
      _Vec3(-1, 0, 0),
      _Vec3(0, 1, 0),
      _Vec3(0, -1, 0),
      _Vec3(0, 0, 1),
      _Vec3(0, 0, -1),
    ];
    final edges = [
      [0, 2],
      [0, 3],
      [0, 4],
      [0, 5],
      [1, 2],
      [1, 3],
      [1, 4],
      [1, 5],
      [2, 4],
      [2, 5],
      [3, 4],
      [3, 5],
    ];
    return (vertices, edges);
  }

  (List<_Vec3>, List<List<int>>) _torusKnot() {
    final vertices = <_Vec3>[];
    final edges = <List<int>>[];
    const segments = 80;
    const p = 2, q = 3;
    const r1 = 0.8, r2 = 0.3;

    for (int i = 0; i < segments; i++) {
      final t = i / segments * pi * 2 * p;
      final r = r1 + r2 * cos(q * t / p);
      vertices.add(_Vec3(r * cos(t), r * sin(t), r2 * sin(q * t / p)));
      edges.add([i, (i + 1) % segments]);
      // Add cross-connections for visual complexity
      if (i % 4 == 0 && i + 20 < segments) {
        edges.add([i, i + 20]);
      }
    }
    return (vertices, edges);
  }

  @override
  bool shouldRepaint(covariant _WireframePainter oldDelegate) => true;
}
