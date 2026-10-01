import 'package:flutter/material.dart';
import '../core/art.dart';
import '../core/theme.dart';
import '../data/gita_knowledge.dart';

SceneKind sceneFor(TopicScene s) => switch (s) {
      TopicScene.dawn => SceneKind.dawn,
      TopicScene.mist => SceneKind.mist,
      TopicScene.forest => SceneKind.forest,
      TopicScene.lake => SceneKind.lake,
      TopicScene.bridge => SceneKind.bridge,
      TopicScene.dusk => SceneKind.dusk,
    };

void comingSoon(BuildContext context, [String what = 'Audio guidance']) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$what is coming soon.')));
}

class GsCard extends StatelessWidget {
  const GsCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.color = GS.card, this.onTap, this.radius = 20});
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final VoidCallback? onTap;
  final double radius;
  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: GS.line.withValues(alpha: 0.7)),
          boxShadow: GS.softShadow,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
        ),
      );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(this.label, {super.key, required this.onPressed, this.icon, this.color = GS.teal, this.light = false});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final bool light; // white button on dark
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: light ? Colors.white : color,
            foregroundColor: light ? GS.ink : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
            textStyle: GS.b(16, w: FontWeight.w700),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
            Text(label),
          ]),
        ),
      );
}

class SoftButton extends StatelessWidget {
  const SoftButton(this.label, {super.key, required this.onPressed, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: GS.ink,
            backgroundColor: GS.tint.withValues(alpha: 0.6),
            side: BorderSide(color: GS.line),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
            textStyle: GS.b(15, w: FontWeight.w600),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
            Text(label),
          ]),
        ),
      );
}

class IconBubble extends StatelessWidget {
  const IconBubble(this.icon, {super.key, this.bg = GS.terraBg, this.fg = GS.terracotta, this.size = 40});
  final IconData icon;
  final Color bg, fg;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: fg, size: size * 0.5),
      );
}

class ListenPill extends StatelessWidget {
  const ListenPill({super.key, this.label = 'Listen', this.dark = true});
  final String label;
  final bool dark;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => comingSoon(context),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: dark ? GS.navy : GS.teal, shape: BoxShape.circle),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 8),
          Text(label, style: GS.b(13, w: FontWeight.w700, color: dark ? GS.ink : Colors.white)),
        ]),
      );
}

class PillTabs extends StatelessWidget {
  const PillTabs({super.key, required this.labels, required this.index, required this.onChanged, this.dark = false});
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  final bool dark;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: dark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: dark ? null : Border.all(color: GS.line),
        ),
        child: Row(children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: i == index ? (dark ? Colors.white : GS.teal) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(labels[i],
                      style: GS.b(13,
                          w: FontWeight.w700,
                          color: i == index ? (dark ? GS.navy : Colors.white) : (dark ? Colors.white70 : GS.muted))),
                ),
              ),
            ),
        ]),
      );
}

class ProgressBar extends StatelessWidget {
  const ProgressBar(this.value, {super.key, this.color = GS.gold, this.track, this.height = 5});
  final double value;
  final Color color;
  final Color? track;
  final double height;
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: LinearProgressIndicator(
          value: value.clamp(0, 1),
          minHeight: height,
          color: color,
          backgroundColor: track ?? GS.line,
        ),
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing, this.dark = false});
  final String text;
  final Widget? trailing;
  final bool dark;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Expanded(child: Text(text, style: GS.h(18, color: dark ? Colors.white : GS.ink))),
          ?trailing,
        ]),
      );
}

/// Round avatar used for GitaSetu in conversation.
class GsAvatar extends StatelessWidget {
  const GsAvatar({super.key, this.size = 36});
  final double size;
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(color: GS.sage, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Sprout(size: size * 0.7),
      );
}
