import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/gita_knowledge.dart';
import '../state/app_state.dart';
import '../widgets/verse_sheet.dart';
import 'talk_screen.dart';

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
    final t = Theme.of(context).textTheme;
    final now = DateTime.now();
    final day = now.difference(DateTime(now.year)).inDays;
    final reflection = dailyReflections[day % dailyReflections.length];
    final verse = GitaKnowledge.verses[dailyInsights[day % dailyInsights.length]]!;
    final name = s.name.isEmpty ? '' : ', ${s.name}';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('${greeting(now)}$name', style: t.headlineSmall),
        const SizedBox(height: 4),
        Text('Take a moment before you begin.', style: t.bodyMedium),
        const SizedBox(height: 24),
        Text("Today's reflection", style: t.labelLarge),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text('“$reflection”', style: t.titleLarge),
          ),
        ),
        const SizedBox(height: 20),
        Text("Today's Gita insight", style: t.labelLarge),
        const SizedBox(height: 8),
        Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => showVerseSheet(context, verse.ref),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(verse.title, style: t.titleSmall),
                const SizedBox(height: 6),
                Text(verse.summary, style: t.bodyLarge),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text("Today's practice", style: t.labelLarge),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: s.practices.isEmpty
                ? Text('No practices yet. Talk to GitaSetu to find one that fits you.',
                    style: t.bodyMedium)
                : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(s.practices.first.title, style: t.titleMedium),
                    const SizedBox(height: 4),
                    Text('${s.doneToday} of ${s.practices.length} practices completed',
                        style: t.bodyMedium),
                  ]),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const TalkScreen())),
          icon: const Icon(Icons.chat_bubble_outline),
          label: const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Text('Pause & Reflect'),
          ),
        ),
      ],
    );
  }
}
