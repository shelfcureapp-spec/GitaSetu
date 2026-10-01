import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Code-drawn illustrations (landscapes, lotus, sprout) used in place of
/// photographic assets. Drop real images into assets/images later and swap
/// them in where [SceneArt] is used.
enum SceneKind { dawn, mist, forest, lake, bridge, night, dusk }

class _Pal {
  final Color skyTop, skyBottom, far, near, sun;
  const _Pal(this.skyTop, this.skyBottom, this.far, this.near, this.sun);
}

const _pals = {
  SceneKind.dawn: _Pal(Color(0xFFF3D6AE), Color(0xFFF7EBD8), Color(0xFFDDBF9F), Color(0xFF7F9279), Color(0xFFFFF1CE)),
  SceneKind.mist: _Pal(Color(0xFFAFC3C2), Color(0xFFDDE7E2), Color(0xFFB2C4C0), Color(0xFF3F5F5C), Color(0xFFF6F2E4)),
  SceneKind.forest: _Pal(Color(0xFFC3D5C0), Color(0xFFE6ECDE), Color(0xFF92AD8E), Color(0xFF2E5A45), Color(0xFFFFF4D6)),
  SceneKind.lake: _Pal(Color(0xFFE9C8A2), Color(0xFFF3E5D0), Color(0xFFCCAA8C), Color(0xFF486B6B), Color(0xFFFFEFC8)),
  SceneKind.bridge: _Pal(Color(0xFFE6D2B2), Color(0xFFF5ECDA), Color(0xFFCDB496), Color(0xFF5E7D6B), Color(0xFFFFF0CB)),
  SceneKind.night: _Pal(Color(0xFF0C2229), Color(0xFF1D4650), Color(0xFF244C56), Color(0xFF0A1D23), Color(0xFFF0E6C8)),
  SceneKind.dusk: _Pal(Color(0xFF51709A), Color(0xFFEBC49A), Color(0xFF8F8FA6), Color(0xFF3C4A63), Color(0xFFFFE3B0)),
};

class SceneArt extends StatelessWidget {
  const SceneArt(this.kind, {super.key, this.radius = 0, this.child, this.sunAt = const Offset(0.74, 0.3)});
  final SceneKind kind;
  final double radius;
  final Offset sunAt;
  final Widget? child;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CustomPaint(painter: _ScenePainter(kind, sunAt), child: child ?? const SizedBox.expand()),
      );
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.kind, this.sunAt);
  final SceneKind kind;
  final Offset sunAt;

  @override
  void paint(Canvas canvas, Size size) {
    final p = _pals[kind]!;
    final w = size.width, h = size.height;
    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [p.skyTop, p.skyBottom]).createShader(Offset.zero & size),
    );
    if (kind == SceneKind.night) {
      final r = math.Random(7);
      for (var i = 0; i < 40; i++) {
        canvas.drawCircle(Offset(r.nextDouble() * w, r.nextDouble() * h * 0.6), r.nextDouble() * 1.1 + 0.3,
            Paint()..color = Colors.white.withValues(alpha: 0.25 + r.nextDouble() * 0.5));
      }
    }
    final sc = Offset(w * sunAt.dx, h * sunAt.dy);
    final sr = math.min(w, h) * 0.2;
    canvas.drawCircle(
      sc,
      sr * 2.4,
      Paint()..shader = RadialGradient(colors: [p.sun.withValues(alpha: 0.7), p.sun.withValues(alpha: 0)]).createShader(Rect.fromCircle(center: sc, radius: sr * 2.4)),
    );
    canvas.drawCircle(sc, sr * 0.55, Paint()..color = p.sun.withValues(alpha: 0.95));

    final layers = kind == SceneKind.forest ? 4 : 3;
    final waterTop = (kind == SceneKind.lake || kind == SceneKind.bridge) ? h * 0.74 : h + 1;
    for (var i = 0; i < layers; i++) {
      final t = i / (layers - 1);
      final color = Color.lerp(p.far, p.near, t)!;
      final base = h * (0.52 + 0.1 * i) - (kind == SceneKind.mist ? h * 0.04 : 0);
      final amp = h * (0.10 - 0.015 * i);
      final path = Path()..moveTo(0, h);
      for (double x = 0; x <= w; x += 4) {
        final y = base - amp * (0.55 * math.sin(x / w * (3.2 + i) + i * 1.7) + 0.45 * math.sin(x / w * (7.1 + i * 2) + i));
        path.lineTo(x, math.min(y, waterTop));
      }
      path.lineTo(w + 2, math.min(base, waterTop));
      path.lineTo(w + 2, h);
      path.close();
      canvas.drawPath(path, Paint()..color = color.withValues(alpha: kind == SceneKind.mist && i < 2 ? 0.7 : 1));
    }
    if (waterTop < h) {
      final water = Rect.fromLTWH(0, waterTop, w, h - waterTop);
      canvas.drawRect(
        water,
        Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [p.skyBottom.withValues(alpha: 0.95), p.far.withValues(alpha: 0.9)]).createShader(water),
      );
      final r = math.Random(3);
      for (var i = 0; i < 9; i++) {
        final y = waterTop + (i + 1) * water.height / 10;
        final x = r.nextDouble() * w * 0.8;
        canvas.drawLine(Offset(x, y), Offset(x + w * 0.18, y), Paint()..color = Colors.white.withValues(alpha: 0.35)..strokeWidth = 1.2);
      }
    }
    if (kind == SceneKind.bridge) {
      final deck = Paint()..color = const Color(0xFF8C7458);
      final y = h * 0.74;
      final arch = Path()
        ..moveTo(w * 0.1, y)
        ..quadraticBezierTo(w * 0.5, y - h * 0.22, w * 0.9, y)
        ..lineTo(w * 0.9, y + 6)
        ..quadraticBezierTo(w * 0.5, y - h * 0.22 + 8, w * 0.1, y + 6)
        ..close();
      canvas.drawPath(arch, deck);
      canvas.drawLine(Offset(w * 0.06, y + 3), Offset(w * 0.94, y + 3), Paint()..color = const Color(0xFF8C7458)..strokeWidth = 3);
    }
  }

  @override
  bool shouldRepaint(_ScenePainter old) => old.kind != kind || old.sunAt != sunAt;
}

/// A stylised lotus.
class Lotus extends StatelessWidget {
  const Lotus({super.key, this.size = 80, this.color = const Color(0xFFE9A46B), this.light = const Color(0xFFF9DDB8)});
  final double size;
  final Color color, light;
  @override
  Widget build(BuildContext context) =>
      SizedBox(width: size, height: size * 0.8, child: CustomPaint(painter: _LotusPainter(color, light)));
}

class _LotusPainter extends CustomPainter {
  _LotusPainter(this.c, this.l);
  final Color c, l;
  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, base = s.height * 0.92;
    void petal(double angle, double len, double wid, double alpha) {
      canvas.save();
      canvas.translate(cx, base);
      canvas.rotate(angle);
      final path = Path()
        ..moveTo(0, 0)
        ..cubicTo(-wid, -len * 0.35, -wid * 0.8, -len * 0.8, 0, -len)
        ..cubicTo(wid * 0.8, -len * 0.8, wid, -len * 0.35, 0, 0);
      canvas.drawPath(
        path,
        Paint()..shader = LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [c.withValues(alpha: alpha), l.withValues(alpha: alpha)]).createShader(Rect.fromLTWH(-wid, -len, wid * 2, len)),
      );
      canvas.drawPath(path, Paint()..style = PaintingStyle.stroke..strokeWidth = 0.8..color = c.withValues(alpha: 0.5));
      canvas.restore();
    }

    final len = s.height * 0.85;
    petal(-1.15, len * 0.8, s.width * 0.16, 0.85);
    petal(1.15, len * 0.8, s.width * 0.16, 0.85);
    petal(-0.62, len * 0.92, s.width * 0.17, 0.95);
    petal(0.62, len * 0.92, s.width * 0.17, 0.95);
    petal(0, len, s.width * 0.18, 1);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, base + 1), width: s.width * 0.7, height: s.height * 0.06),
        Paint()..color = const Color(0xFF2E7D6B).withValues(alpha: 0.45));
  }

  @override
  bool shouldRepaint(_LotusPainter old) => false;
}

/// A small sprouting seedling.
class Sprout extends StatelessWidget {
  const Sprout({super.key, this.size = 70, this.color = const Color(0xFF2E7D55)});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size, child: CustomPaint(painter: _SproutPainter(color)));
}

class _SproutPainter extends CustomPainter {
  _SproutPainter(this.c);
  final Color c;
  @override
  void paint(Canvas canvas, Size s) {
    final stem = Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = s.width * 0.04..strokeCap = StrokeCap.round;
    final base = Offset(s.width * 0.5, s.height * 0.92);
    canvas.drawPath(Path()..moveTo(base.dx, base.dy)..quadraticBezierTo(s.width * 0.52, s.height * 0.6, s.width * 0.5, s.height * 0.4), stem);
    void leaf(double dir, double y, double len) {
      final o = Offset(s.width * 0.5, y);
      final path = Path()
        ..moveTo(o.dx, o.dy)
        ..quadraticBezierTo(o.dx + dir * len * 0.5, o.dy - len * 0.7, o.dx + dir * len, o.dy - len * 0.35)
        ..quadraticBezierTo(o.dx + dir * len * 0.55, o.dy + len * 0.05, o.dx, o.dy);
      canvas.drawPath(path, Paint()..color = Color.lerp(c, const Color(0xFF7FBF8A), 0.35)!);
    }

    leaf(-1, s.height * 0.55, s.width * 0.42);
    leaf(1, s.height * 0.45, s.width * 0.46);
    leaf(-1, s.height * 0.4, s.width * 0.3);
    canvas.drawOval(Rect.fromCenter(center: Offset(s.width * 0.5, s.height * 0.94), width: s.width * 0.5, height: s.height * 0.07),
        Paint()..color = const Color(0xFF8C7458).withValues(alpha: 0.5));
  }

  @override
  bool shouldRepaint(_SproutPainter old) => false;
}

/// The GitaSetu mark: an arch (setu = bridge) under a rising sun.
class SetuMark extends StatelessWidget {
  const SetuMark({super.key, this.size = 56, this.color = const Color(0xFFC9953E)});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size * 0.62, child: CustomPaint(painter: _MarkPainter(color)));
}

class _MarkPainter extends CustomPainter {
  _MarkPainter(this.c);
  final Color c;
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = s.width * 0.045..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromLTWH(s.width * 0.1, s.height * 0.25, s.width * 0.8, s.height * 1.4), math.pi, math.pi, false, p);
    canvas.drawArc(Rect.fromLTWH(s.width * 0.3, s.height * 0.52, s.width * 0.4, s.height * 0.9), math.pi, math.pi, false, p);
    canvas.drawLine(Offset(0, s.height * 0.97), Offset(s.width, s.height * 0.97), p);
    canvas.drawCircle(Offset(s.width * 0.5, s.height * 0.12), s.width * 0.05, Paint()..color = c);
  }

  @override
  bool shouldRepaint(_MarkPainter old) => false;
}
