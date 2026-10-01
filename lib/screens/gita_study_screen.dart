import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/gita_knowledge.dart';
import '../models/models.dart';
import '../widgets/gs_widgets.dart';
import '../widgets/verse_widgets.dart';

/// Gita Study: original verse, meaning, and a clear split between what the Gita
/// says and GitaSetu's interpretation (PRD §32).
class GitaStudyScreen extends StatelessWidget {
  const GitaStudyScreen({super.key, required this.ref});
  final String ref;

  @override
  Widget build(BuildContext context) {
    final v = GitaKnowledge.verses[ref]!;
    final concept = GitaKnowledge.concepts.where((c) => c.verseRefs.contains(ref)).firstOrNull;
    final topic = topics.where((t) => t.available && t.conceptSanskrit == concept?.sanskrit).firstOrNull;
    final keys = GitaKnowledge.verses.keys.toList()..sort();
    final i = keys.indexOf(ref);

    Widget label(String t, {Color c = GS.terracotta}) =>
        Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: GS.b(12.5, w: FontWeight.w700, color: c)));

    return Scaffold(
      appBar: AppBar(
        title: Text(v.title, style: GS.h(18)),
        actions: [BookmarkButton(ref)],
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 32), children: [
        if (v.sanskrit != null)
          GsCard(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(v.sanskrit!, style: GS.sanskrit(19)),
              if (v.transliteration != null) ...[
                const SizedBox(height: 12),
                Text(v.transliteration!, style: GS.b(14.5, color: GS.muted, height: 1.55).copyWith(fontStyle: FontStyle.italic)),
              ],
            ]),
          )
        else
          GsCard(
            color: GS.tint,
            child: Text('The original Sanskrit for this verse will appear here once it is loaded from the curated source.', style: GS.b(14, color: GS.muted)),
          ),
        const SizedBox(height: 14),
        GsCard(
          onTap: () => comingSoon(context, 'Verse audio'),
          child: Row(children: [
            Container(width: 42, height: 42, decoration: const BoxDecoration(color: GS.navy, shape: BoxShape.circle), child: const Icon(Icons.play_arrow_rounded, color: Colors.white)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Listen to verse', style: GS.b(14.5, w: FontWeight.w700)),
                Text('Audio coming soon', style: GS.b(12.5, color: GS.muted)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 24),
        label('The Gita says'),
        Text(v.summary, style: GS.b(16.5, height: 1.55)),
        const SizedBox(height: 4),
        Text(v.sourceType.label, style: GS.b(12, color: GS.muted)),
        if (concept != null) ...[
          const SizedBox(height: 24),
          label('GitaSetu interpretation'),
          GsCard(color: const Color(0xFFF6EBD8), child: Text(concept.interpretation, style: GS.b(15, height: 1.55))),
        ],
        if (topic != null) ...[
          const SizedBox(height: 20),
          label('Practical application', c: GS.teal),
          Text(topic.application, style: GS.b(15, height: 1.5)),
          const SizedBox(height: 20),
          label('Reflect', c: GS.teal),
          Text(topic.reflection, style: GS.h(18, height: 1.35)),
        ],
        const SizedBox(height: 28),
        Row(children: [
          Expanded(child: SoftButton('Previous', onPressed: i > 0 ? () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => GitaStudyScreen(ref: keys[i - 1]))) : null)),
          const SizedBox(width: 12),
          Expanded(child: SoftButton('Next', onPressed: i < keys.length - 1 ? () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => GitaStudyScreen(ref: keys[i + 1]))) : null)),
        ]),
      ]),
    );
  }
}
