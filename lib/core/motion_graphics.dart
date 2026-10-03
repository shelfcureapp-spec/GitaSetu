import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'art.dart';
import 'motion.dart';
import 'theme.dart';

/// Ambient, looping motion graphics drawn in code: drifting clouds, gliding
/// birds, rising light motes, water shimmer, rolling mist, twinkling stars,
/// lotus ripples and a guided breathing circle.
///
/// Each piece repaints from a single elapsed-seconds clock without rebuilding
/// widgets, pauses when its tab is hidden (TickerMode), and freezes on a
/// pleasant still frame when the OS asks to reduce motion.

/// Provides elapsed seconds to [builder]; frozen at [stillAt] under reduced motion.
class AmbientClock extends StatefulWidget {
  const AmbientClock({super.key, required this.builder, this.stillAt = 8});
  final Widget Function(BuildContext context, ValueNotifier<double> seconds) builder;
  final double stillAt;
  @override
  State<AmbientClock> createState() => _AmbientClockState();
}

class _AmbientClockState extends State<AmbientClock> with SingleTickerProviderStateMixin {
  late final ValueNotifier<double> _t = ValueNotifier(widget.stillAt);
  late final Ticker _ticker = createTicker((d) => _t.value = widget.stillAt + d.inMicroseconds / 1e6);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      if (_ticker.isActive) _ticker.stop();
      _t.value = widget.stillAt;
    } else if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(child: widget.builder(context, _t));
}

double _hash(int i, int salt) {
  final x = math.sin(i * 127.1 + salt * 311.7) * 43758.5453;
  return x - x.floorToDouble();
}

// ---------------------------------------------------------------------------
// Living landscape
// ---------------------------------------------------------------------------

/// [SceneArt] with an animated atmosphere layered on top.
class LivingScene extends StatelessWidget {
  const LivingScene(this.kind, {super.key, this.sunAt = const Offset(0.74, 0.3), this.radius = 0, this.birds = true, this.rising = false});
  final SceneKind kind;
  final Offset sunAt;
  final double radius;
  final bool birds;

  /// Animate the sun rising into [sunAt] on first appearance.
  final bool rising;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(fit: StackFit.expand, children: [
          rising ? RisingScene(kind, to: sunAt, from: Offset(sunAt.dx, sunAt.dy + 0.2)) : SceneArt(kind, sunAt: sunAt),
          AmbientClock(builder: (_, t) => CustomPaint(painter: _AtmospherePainter(kind, t, birds: birds))),
        ]),
      );
}

class _AtmospherePainter extends CustomPainter {
  _AtmospherePainter(this.kind, this.t, {required this.birds}) : super(repaint: t);
  final SceneKind kind;
  final ValueNotifier<double> t;
  final bool birds;

  bool get _night => kind == SceneKind.night;
  bool get _water => kind == SceneKind.lake || kind == SceneKind.bridge;

  @override
  void paint(Canvas canvas, Size size) {
    final s = t.value;
    final w = size.width, h = size.height;

    // Clouds: soft clusters drifting right, wrapping around.
    final cloud = Paint()..color = Colors.white.withValues(alpha: _night ? 0.06 : 0.42);
    for (var i = 0; i < 3; i++) {
      final cw = w * (0.32 + 0.16 * _hash(i, 1));
      final speed = w / (70 + 40 * _hash(i, 2));
      final x = ((s * speed + _hash(i, 3) * (w + cw)) % (w + cw)) - cw;
      final y = h * (0.1 + 0.2 * _hash(i, 4));
      for (var k = 0; k < 4; k++) {
        final ox = cw * (0.15 + 0.22 * k);
        final r = cw * (0.13 + 0.07 * math.sin(k * 1.9 + i));
        canvas.drawOval(Rect.fromCenter(center: Offset(x + ox, y), width: r * 2.6, height: r * 1.2), cloud);
      }
    }

    // Mist: wide translucent bands sliding slowly in opposite directions.
    if (kind == SceneKind.mist || kind == SceneKind.forest) {
      for (var i = 0; i < 2; i++) {
        final dir = i.isEven ? 1 : -1;
        final dx = math.sin(s / (14 + i * 5)) * w * 0.12 * dir;
        final rect = Rect.fromLTWH(-w * 0.2 + dx, h * (0.55 + 0.12 * i), w * 1.4, h * 0.09);
        canvas.drawOval(rect, Paint()..color = Colors.white.withValues(alpha: 0.18)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
      }
    }

    // Water shimmer: short highlights that sway and flicker.
    if (_water) {
      final top = h * 0.74;
      for (var i = 0; i < 12; i++) {
        final y = top + (i + 0.6) * (h - top) / 12.5;
        final len = w * (0.08 + 0.12 * _hash(i, 5));
        final x = w * _hash(i, 6) + math.sin(s * 0.6 + i) * w * 0.04;
        final a = 0.15 + 0.3 * (0.5 + 0.5 * math.sin(s * 1.3 + i * 2.1));
        canvas.drawLine(Offset(x, y), Offset(x + len, y), Paint()..color = Colors.white.withValues(alpha: a)..strokeWidth = 1.3..strokeCap = StrokeCap.round);
      }
    }

    // Birds: a small flock crossing every ~24 seconds, wings flapping.
    if (birds && !_night) {
      const period = 24.0;
      final phase = (s % period) / period;
      if (phase < 0.55) {
        final p = phase / 0.55;
        final bird = Paint()
          ..color = const Color(0xFF4A4A44).withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round;
        for (var i = 0; i < 3; i++) {
          final bx = -w * 0.1 + p * w * 1.25 - i * w * 0.07;
          final by = h * (0.2 + 0.03 * i) - p * h * 0.06 + math.sin(p * 6 + i) * 3;
          final span = w * 0.022 * (1 - 0.15 * i);
          final flap = math.sin(s * 7 + i * 1.3) * span * 0.55;
          canvas.drawPath(
            Path()
              ..moveTo(bx - span, by - flap)
              ..quadraticBezierTo(bx - span * 0.4, by - span * 0.15, bx, by)
              ..quadraticBezierTo(bx + span * 0.4, by - span * 0.15, bx + span, by - flap),
            bird,
          );
        }
      }
    }

    // Light motes: rise slowly, sway, and fade in and out.
    _motes(canvas, size, s, count: _night ? 10 : 14, color: _night ? const Color(0xFFF0E6C8) : Colors.white);
  }

  @override
  bool shouldRepaint(_AtmospherePainter old) => old.kind != kind || old.birds != birds;
}

void _motes(Canvas canvas, Size size, double s, {required int count, required Color color, double maxAlpha = 0.7, double scale = 1}) {
  final w = size.width, h = size.height;
  for (var i = 0; i < count; i++) {
    final life = 9 + 7 * _hash(i, 7);
    final p = ((s + _hash(i, 8) * life) % life) / life;
    final x = w * _hash(i, 9) + math.sin(s * 0.5 + i) * 10 * scale;
    final y = h * (0.95 - 0.75 * p);
    final a = math.sin(p * math.pi) * maxAlpha;
    final r = (1.1 + 1.6 * _hash(i, 10)) * scale;
    canvas.drawCircle(Offset(x, y), r * 2.4, Paint()..color = color.withValues(alpha: a * 0.18));
    canvas.drawCircle(Offset(x, y), r, Paint()..color = color.withValues(alpha: a));
  }
}

/// Floating light motes over any background (e.g. the Home header).
class FloatingMotes extends StatelessWidget {
  const FloatingMotes({super.key, this.count = 12, this.color = const Color(0xFFF2C46B), this.maxAlpha = 0.55});
  final int count;
  final Color color;
  final double maxAlpha;
  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: AmbientClock(builder: (_, t) => CustomPaint(painter: _MotesPainter(t, count, color, maxAlpha), size: Size.infinite)),
      );
}

class _MotesPainter extends CustomPainter {
  _MotesPainter(this.t, this.count, this.color, this.maxAlpha) : super(repaint: t);
  final ValueNotifier<double> t;
  final int count;
  final Color color;
  final double maxAlpha;
  @override
  void paint(Canvas canvas, Size size) => _motes(canvas, size, t.value, count: count, color: color, maxAlpha: maxAlpha);
  @override
  bool shouldRepaint(_MotesPainter old) => false;
}

// ---------------------------------------------------------------------------
// Night sky
// ---------------------------------------------------------------------------

/// Twinkling stars with an occasional slow shooting star.
class Starfield extends StatelessWidget {
  const Starfield({super.key, this.count = 70});
  final int count;
  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: AmbientClock(builder: (_, t) => CustomPaint(painter: _StarPainter(t, count), size: Size.infinite)),
      );
}

class _StarPainter extends CustomPainter {
  _StarPainter(this.t, this.count) : super(repaint: t);
  final ValueNotifier<double> t;
  final int count;
  @override
  void paint(Canvas canvas, Size size) {
    final s = t.value;
    for (var i = 0; i < count; i++) {
      final p = Offset(size.width * _hash(i, 11), size.height * _hash(i, 12));
      final tw = 0.5 + 0.5 * math.sin(s * (0.6 + _hash(i, 13) * 1.6) + i);
      final r = 0.5 + 1.1 * _hash(i, 14);
      canvas.drawCircle(p, r, Paint()..color = const Color(0xFFF7EFD8).withValues(alpha: 0.15 + 0.6 * tw));
    }
    // Shooting star roughly every 14s, crossing in ~1.2s.
    const period = 14.0;
    final ph = s % period;
    if (ph < 1.2) {
      final k = (s / period).floor();
      final p = ph / 1.2;
      final start = Offset(size.width * (0.15 + 0.6 * _hash(k, 15)), size.height * (0.05 + 0.25 * _hash(k, 16)));
      final dir = const Offset(1, 0.45);
      final head = start + dir * (size.width * 0.45 * Curves.easeOut.transform(p));
      final tail = head - dir * (size.width * 0.12);
      final a = math.sin(p * math.pi);
      canvas.drawLine(
        tail,
        head,
        Paint()
          ..shader = LinearGradient(colors: [Colors.white.withValues(alpha: 0), Colors.white.withValues(alpha: 0.85 * a)]).createShader(Rect.fromPoints(tail, head))
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter old) => false;
}

// ---------------------------------------------------------------------------
// Lotus pond and swaying sprout
// ---------------------------------------------------------------------------

/// A lotus that blooms, then floats on water: slow sway, ripple rings and a
/// few motes rising from it.
class LotusPond extends StatelessWidget {
  const LotusPond({super.key, this.size = 100, this.delay = Duration.zero, this.rippleColor = GS.teal});
  final double size;
  final Duration delay;
  final Color rippleColor;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: size * 1.9,
        height: size * 1.15,
        child: AmbientClock(
          builder: (_, t) => Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: [
            Positioned.fill(child: CustomPaint(painter: _PondPainter(t, rippleColor))),
            AnimatedBuilder(
              animation: t,
              builder: (_, child) => Transform.rotate(angle: math.sin(t.value * 0.9) * 0.035, alignment: Alignment.bottomCenter, child: child),
              child: Transform.translate(offset: Offset(0, -size * 0.08), child: BloomingLotus(size: size, delay: delay)),
            ),
          ]),
        ),
      );
}

class _PondPainter extends CustomPainter {
  _PondPainter(this.t, this.color) : super(repaint: t);
  final ValueNotifier<double> t;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final s = t.value;
    final c = Offset(size.width / 2, size.height * 0.8);
    for (var i = 0; i < 3; i++) {
      final p = ((s / 4.5) + i / 3) % 1.0;
      final rw = size.width * (0.25 + 0.75 * p);
      canvas.drawOval(
        Rect.fromCenter(center: c, width: rw, height: rw * 0.18),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = color.withValues(alpha: 0.35 * (1 - p)),
      );
    }
    _motes(canvas, Size(size.width, size.height * 0.85), s, count: 6, color: const Color(0xFFF2B57A), maxAlpha: 0.6, scale: 0.8);
  }

  @override
  bool shouldRepaint(_PondPainter old) => false;
}

/// A sprout swaying as if in a light breeze.
class SwayingSprout extends StatelessWidget {
  const SwayingSprout({super.key, this.size = 80, this.motes = false});
  final double size;
  final bool motes;
  @override
  Widget build(BuildContext context) => AmbientClock(
        builder: (_, t) => Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
          if (motes) Positioned.fill(child: CustomPaint(painter: _MotesPainter(t, 6, GS.teal, 0.45))),
          AnimatedBuilder(
            animation: t,
            builder: (_, child) {
              final gust = math.sin(t.value * 1.1) * 0.05 + math.sin(t.value * 2.7) * 0.015;
              return Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..rotateZ(gust)
                  ..scaleByDouble(1, 1 + 0.02 * math.sin(t.value * 0.8), 1, 1),
                child: child,
              );
            },
            child: Sprout(size: size),
          ),
        ]),
      );
}

// ---------------------------------------------------------------------------
// Breathing guide
// ---------------------------------------------------------------------------

/// A guided breath: the circle grows while breathing in (4s), rests (1s) and
/// shrinks while breathing out (5s). Tap to start or stop.
class BreathingGuide extends StatefulWidget {
  const BreathingGuide({super.key, this.size = 200});
  final double size;
  @override
  State<BreathingGuide> createState() => _BreathingGuideState();
}

class _BreathingGuideState extends State<BreathingGuide> with SingleTickerProviderStateMixin {
  static const _inhale = 4.0, _hold = 1.0, _exhale = 5.0;
  static const _cycle = _inhale + _hold + _exhale;
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 10000));
  bool _running = false;
  int _breaths = 0;

  @override
  void initState() {
    super.initState();
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed && _running) {
        setState(() => _breaths++);
        _c.forward(from: 0);
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _running = !_running;
      if (_running) {
        _breaths = 0;
        _c.forward(from: 0);
      } else {
        _c.stop();
        _c.value = 0;
      }
    });
  }

  ({double scale, String label}) _phase(double v) {
    final s = v * _cycle;
    if (s < _inhale) return (scale: Curves.easeInOut.transform(s / _inhale), label: 'Breathe in');
    if (s < _inhale + _hold) return (scale: 1, label: 'Rest');
    return (scale: 1 - Curves.easeInOut.transform((s - _inhale - _hold) / _exhale), label: 'Breathe out');
  }

  @override
  Widget build(BuildContext context) {
    final reduced = Motion.reduced(context);
    final d = widget.size;
    return GestureDetector(
      onTap: _toggle,
      child: Semantics(
        button: true,
        label: _running ? 'Stop breathing guide' : 'Start breathing guide',
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, _) {
            final ph = _phase(_c.value);
            final k = reduced ? 0.6 : (_running ? ph.scale : 0.0);
            final label = _running ? ph.label : 'Tap to begin';
            return Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                width: d,
                height: d,
                child: Stack(alignment: Alignment.center, children: [
                  // Guide ring: the size the circle will reach.
                  Container(
                    width: d,
                    height: d,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: GS.teal.withValues(alpha: 0.18), width: 1.5)),
                  ),
                  // Soft glow.
                  Container(
                    width: d * (0.45 + 0.55 * k),
                    height: d * (0.45 + 0.55 * k),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [GS.sage, GS.sage.withValues(alpha: 0.25)]),
                      boxShadow: [BoxShadow(color: GS.teal.withValues(alpha: 0.12 + 0.12 * k), blurRadius: 30 * (0.5 + k), spreadRadius: 4)],
                    ),
                  ),
                  // Core.
                  Container(
                    width: d * (0.3 + 0.3 * k),
                    height: d * (0.3 + 0.3 * k),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: GS.teal),
                    child: Icon(_running ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 26),
                  ),
                ]),
              ),
              const SizedBox(height: 14),
              Text(label, style: GS.h(20)),
              const SizedBox(height: 2),
              Text(
                _running ? (_breaths == 0 ? 'Follow the circle' : '$_breaths breath${_breaths == 1 ? '' : 's'}') : 'In for 4, rest, out for 5',
                style: GS.b(13, color: GS.muted),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
