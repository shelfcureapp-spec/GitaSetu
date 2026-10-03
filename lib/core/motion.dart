import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'theme.dart';

/// Calm motion for GitaSetu. Every animation here is skipped when the user
/// has asked the OS to reduce motion.
class Motion {
  static const fast = Duration(milliseconds: 180);
  static const medium = Duration(milliseconds: 420);
  static const slow = Duration(milliseconds: 900);
  static const ease = Curves.easeOutCubic;

  static bool reduced(BuildContext context) => MediaQuery.maybeDisableAnimationsOf(context) ?? false;
}

/// Fades and lifts its child into place. [order] staggers siblings.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({super.key, required this.child, this.order = 0, this.offset = 18, this.animate = true, this.duration = Motion.medium});
  final Widget child;
  final int order;
  final double offset;
  final bool animate;
  final Duration duration;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _t = CurvedAnimation(parent: _c, curve: Motion.ease);
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!widget.animate || Motion.reduced(context)) {
      _c.value = 1;
      return;
    }
    final delay = Duration(milliseconds: 70 * math.min(widget.order, 10));
    Future.delayed(delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _t,
        child: widget.child,
        builder: (_, child) => Opacity(
          opacity: _t.value,
          child: Transform.translate(offset: Offset(0, (1 - _t.value) * widget.offset), child: child),
        ),
      );
}

/// Shrinks slightly while pressed, for tactile feedback on cards and buttons.
class Pressable extends StatefulWidget {
  const Pressable({super.key, required this.child, this.enabled = true});
  final Widget child;
  final bool enabled;
  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;
  void _set(bool v) {
    if (widget.enabled && _down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) => Listener(
        onPointerDown: (_) => _set(true),
        onPointerUp: (_) => _set(false),
        onPointerCancel: (_) => _set(false),
        child: AnimatedScale(
          scale: _down && !Motion.reduced(context) ? 0.975 : 1,
          duration: Motion.fast,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      );
}

/// A slow, continuous inhale/exhale. Used on illustrations that invite a pause.
class Breathing extends StatefulWidget {
  const Breathing({super.key, required this.child, this.amount = 0.05, this.period = const Duration(seconds: 4)});
  final Widget child;
  final double amount;
  final Duration period;
  @override
  State<Breathing> createState() => _BreathingState();
}

class _BreathingState extends State<Breathing> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.period);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        child: widget.child,
        builder: (_, child) => Transform.scale(
          scale: 1 + widget.amount * Curves.easeInOut.transform(_c.value),
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
}

/// Three dots that rise in turn while GitaSetu is composing a reply.
class TypingDots extends StatefulWidget {
  const TypingDots({super.key, this.color = GS.muted});
  final Color color;
  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _c.value = 0.2;
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: GS.line),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, _) => Row(mainAxisSize: MainAxisSize.min, children: [
            for (var i = 0; i < 3; i++)
              Builder(builder: (_) {
                final t = ((_c.value - i * 0.18) % 1.0);
                final lift = t < 0.4 ? math.sin(t / 0.4 * math.pi) : 0.0;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 7,
                  height: 7,
                  transform: Matrix4.translationValues(0, -4 * lift, 0),
                  decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.45 + 0.55 * lift), shape: BoxShape.circle),
                );
              }),
          ]),
        ),
      );
}

/// Soft fade with a short rise, used for every pushed screen.
class CalmPageTransitionsBuilder extends PageTransitionsBuilder {
  const CalmPageTransitionsBuilder();
  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if (Motion.reduced(context)) return child;
    final a = CurvedAnimation(parent: animation, curve: Motion.ease, reverseCurve: Curves.easeInCubic);
    return FadeTransition(
      opacity: a,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(a),
        child: FadeTransition(
          opacity: Tween(begin: 1.0, end: 0.6).animate(CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOut)),
          child: child,
        ),
      ),
    );
  }
}

/// IndexedStack that fades in the newly selected tab while keeping every
/// tab's state alive.
class FadeIndexedStack extends StatefulWidget {
  const FadeIndexedStack({super.key, required this.index, required this.children});
  final int index;
  final List<Widget> children;
  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 260), value: 1);

  @override
  void didUpdateWidget(FadeIndexedStack old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index && !Motion.reduced(context)) _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: CurvedAnimation(parent: _c, curve: Curves.easeOut),
        child: IndexedStack(index: widget.index, children: [
          // Hidden tabs pause their animations.
          for (var i = 0; i < widget.children.length; i++) TickerMode(enabled: i == widget.index, child: widget.children[i]),
        ]),
      );
}

/// A brief, calm confirmation: a circle fills and a check draws itself.
Future<void> showCalmSuccess(BuildContext context, String message) async {
  final nav = Navigator.of(context);
  final reduced = Motion.reduced(context);
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: message,
    barrierColor: Colors.black.withValues(alpha: 0.25),
    transitionDuration: reduced ? Duration.zero : Motion.medium,
    pageBuilder: (_, _, _) => Center(child: _SuccessCard(message: message)),
    transitionBuilder: (_, a, _, child) => FadeTransition(
      opacity: a,
      child: ScaleTransition(scale: Tween(begin: 0.92, end: 1.0).animate(CurvedAnimation(parent: a, curve: Motion.ease)), child: child),
    ),
  );
  await Future.delayed(const Duration(milliseconds: 1500));
  if (nav.mounted && nav.canPop()) nav.pop();
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 28, 32, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: Motion.reduced(context) ? 1 : 0, end: 1),
              duration: Motion.slow,
              curve: Curves.easeInOutCubic,
              builder: (_, t, _) => SizedBox(width: 64, height: 64, child: CustomPaint(painter: _CheckPainter(t))),
            ),
            const SizedBox(height: 14),
            Text(message, style: GS.h(18)),
          ]),
        ),
      );
}

class _CheckPainter extends CustomPainter {
  _CheckPainter(this.t);
  final double t;
  @override
  void paint(Canvas canvas, Size s) {
    final c = Offset(s.width / 2, s.height / 2);
    final r = s.width / 2;
    canvas.drawCircle(c, r * Curves.easeOut.transform((t * 1.6).clamp(0, 1)), Paint()..color = GS.sage);
    final ring = Paint()
      ..color = GS.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: c, radius: r - 2), -math.pi / 2, 2 * math.pi * (t * 1.4).clamp(0, 1), false, ring);
    final p = ((t - 0.45) / 0.55).clamp(0.0, 1.0);
    if (p > 0) {
      final a = Offset(s.width * 0.3, s.height * 0.52), b = Offset(s.width * 0.45, s.height * 0.66), d = Offset(s.width * 0.72, s.height * 0.38);
      final path = Path()..moveTo(a.dx, a.dy);
      if (p < 0.4) {
        final q = Offset.lerp(a, b, p / 0.4)!;
        path.lineTo(q.dx, q.dy);
      } else {
        path.lineTo(b.dx, b.dy);
        final q = Offset.lerp(b, d, (p - 0.4) / 0.6)!;
        path.lineTo(q.dx, q.dy);
      }
      canvas.drawPath(path, ring..strokeWidth = 4);
    }
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.t != t;
}

/// Wraps each child in [FadeSlideIn] with increasing delay.
List<Widget> staggered(List<Widget> children, {int start = 0}) => [
      for (var i = 0; i < children.length; i++) FadeSlideIn(order: start + i, child: children[i]),
    ];

/// Cross-fades between content keyed by [id] (tab bodies, state changes).
class CalmSwitcher extends StatelessWidget {
  const CalmSwitcher({super.key, required this.id, required this.child});
  final Object id;
  final Widget child;
  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: Motion.reduced(context) ? Duration.zero : const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        layoutBuilder: (current, previous) => Stack(alignment: Alignment.topCenter, children: [...previous, ?current]),
        child: KeyedSubtree(key: ValueKey(id), child: child),
      );
}
