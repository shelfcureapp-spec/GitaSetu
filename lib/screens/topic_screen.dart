import 'package:flutter/material.dart';
import '../data/gita_knowledge.dart';
import '../widgets/verse_sheet.dart';
import 'talk_screen.dart';

/// Gita Study (PRD §32): keeps "Gita says", "GitaSetu interpretation" and
/// "Practical application" visibly separate.
class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key, required this.topic});
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final concept = GitaKnowledge.bySanskrit(topic.conceptSanskrit!);
    Widget section(String label, Widget child) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: t.labelLarge),
            const SizedBox(height: 8),
            child,
          ]),
        );

    return Scaffold(
      appBar: AppBar(title: Text(topic.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          section(
            'Key concept',
            Text('${concept.sanskrit} — ${concept.primaryEnglish}\n'
                'Often felt as: ${concept.humanExperience.join(', ')}.\n'
                'Signals: ${concept.signals.join(', ')}.', style: t.bodyLarge),
          ),
          section(
            'The Gita says',
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (final ref in concept.verseRefs) ...[
                Text(GitaKnowledge.verses[ref]!.summary, style: t.bodyLarge),
                const SizedBox(height: 6),
                VerseChip(ref),
                const SizedBox(height: 10),
              ]
            ]),
          ),
          section('GitaSetu interpretation', Text(concept.interpretation, style: t.bodyLarge)),
          section('Practical application', Text(topic.application, style: t.bodyLarge)),
          section('Reflect', Text(topic.reflection, style: t.titleMedium)),
          OutlinedButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const TalkScreen())),
            child: const Text('Talk about this'),
          ),
        ],
      ),
    );
  }
}
