import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/art.dart';
import '../core/motion.dart';
import '../core/theme.dart';
import '../data/gita_knowledge.dart';
import '../state/app_state.dart';
import '../widgets/gs_widgets.dart';
import '../widgets/verse_widgets.dart';
import 'evening_reflection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static String greeting(DateTime now) {
    if (now.hour < 12) return 'Good morning';
    if (now.hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final now = DateTime.now();
    final day = now.difference(DateTime(now.year)).inDays;
    final reflection = dailyReflections[day % dailyReflections.length];
    final verse = GitaKnowledge.verses[dailyInsights[day % dailyInsights.length]]!;
    final icon = now.hour < 17 ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded;
    final active = s.activePractices;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 210,
            child: const DecoratedBox(
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [GS.navy, GS.navy2])),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Flexible(
                          child: Text(
                            s.name.isEmpty ? greeting(now) : '${greeting(now)}, ${s.name}',
                            style: GS.h(26, color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(icon, color: const Color(0xFFF2C46B), size: 26),
                      ]),
                      const SizedBox(height: 6),
                      Text('May your day be calm and clear.', style: GS.b(14, color: Colors.white70)),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => s.go(4),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: GS.gold,
                      child: Text(s.name.isEmpty ? 'G' : s.name[0].toUpperCase(), style: GS.b(16, w: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ]),
                const SizedBox(height: 22),
                FadeSlideIn(order: 1, offset: 26, child: _ReflectionCard(text: reflection)),
              ]),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: staggered(start: 2, [
            const SectionTitle("Today's Gita insight"),
            GsCard(
              onTap: () => openVerse(context, verse.ref),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(verse.summary, style: GS.b(15.5, height: 1.5)),
                    const SizedBox(height: 8),
                    Text('— ${verse.title}', style: GS.b(13, color: GS.muted)),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => openVerse(context, verse.ref),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Read verse'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: GS.ink,
                        side: BorderSide(color: GS.line),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        textStyle: GS.b(13, w: FontWeight.w700),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(width: 8),
                const BloomingLotus(size: 76, delay: Duration(milliseconds: 400)),
              ]),
            ),
            const SizedBox(height: 22),
            SectionTitle("Today's practice", trailing: active.isEmpty ? null : IconButton(onPressed: () => s.go(3), icon: const Icon(Icons.arrow_forward, size: 20, color: GS.muted))),
            if (active.isEmpty)
              GsCard(
                onTap: () => s.go(2),
                child: Row(children: [
                  const IconBubble(Icons.spa_outlined, bg: GS.sage, fg: GS.teal, size: 46),
                  const SizedBox(width: 14),
                  Expanded(child: Text('No practices yet. Talk to GitaSetu to find one that fits you.', style: GS.b(14.5))),
                  const Icon(Icons.chevron_right, color: GS.muted),
                ]),
              )
            else
              GsCard(
                onTap: () => s.go(3),
                child: Row(children: [
                  const IconBubble(Icons.local_florist_outlined, size: 46),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(active.first.title, style: GS.b(16, w: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('${s.doneToday} of ${s.practices.length} completed today', style: GS.b(13, color: GS.muted)),
                      const SizedBox(height: 8),
                      ProgressBar(s.practices.isEmpty ? 0 : s.doneToday / s.practices.length, color: GS.teal),
                    ]),
                  ),
                  const Icon(Icons.chevron_right, color: GS.muted),
                ]),
              ),
            const SizedBox(height: 14),
            GsCard(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EveningReflectionScreen())),
              child: Row(children: [
                const IconBubble(Icons.nights_stay_outlined, bg: Color(0xFFDDE5EE), fg: GS.navy2, size: 46),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Evening reflection', style: GS.b(16, w: FontWeight.w700)),
                    Text('A couple of quiet minutes.', style: GS.b(13, color: GS.muted)),
                  ]),
                ),
                const Icon(Icons.chevron_right, color: GS.muted),
              ]),
            ),
            const SizedBox(height: 18),
            PrimaryButton('Pause & Reflect', icon: Icons.chat_bubble_outline, onPressed: () => s.go(2)),
          ])),
        ),
      ],
    );
  }
}

class _ReflectionCard extends StatelessWidget {
  const _ReflectionCard({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 14, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.14), blurRadius: 24, offset: const Offset(0, 10))],
        ),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Today's reflection", style: GS.b(12.5, w: FontWeight.w700, color: GS.terracotta)),
              const SizedBox(height: 8),
              Text(text, style: GS.h(19, height: 1.3)),
              const SizedBox(height: 14),
              const ListenPill(),
            ]),
          ),
          const SizedBox(width: 6),
          const Breathing(child: Sprout(size: 84)),
        ]),
      );
}
