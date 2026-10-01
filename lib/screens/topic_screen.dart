import 'package:flutter/material.dart';
import '../core/art.dart';
import '../core/theme.dart';
import '../data/gita_knowledge.dart';
import '../models/models.dart';
import '../widgets/gs_widgets.dart';
import '../widgets/verse_widgets.dart';
import 'practice_creation_screen.dart';
import 'shell.dart';

enum TopicSection { overview, perspective, why, examples, practices, audio }

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key, required this.topic});
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final n = topic.name.toLowerCase();
    final rows = <(TopicSection, IconData, String, String)>[
      (TopicSection.overview, Icons.local_fire_department_outlined, 'Overview', 'What is $n?'),
      (TopicSection.perspective, Icons.auto_stories_outlined, "Gita's perspective", 'Key verses and teachings'),
      (TopicSection.why, Icons.psychology_alt_outlined, 'Why $n arises', 'Inner causes and patterns'),
      (TopicSection.examples, Icons.groups_2_outlined, 'Modern examples', 'Real life situations'),
      (TopicSection.practices, Icons.spa_outlined, 'Practices', 'Simple daily practices'),
      (TopicSection.audio, Icons.headphones_outlined, 'Guided audio', 'Listen and reflect'),
    ];
    return Scaffold(
      body: ListView(padding: EdgeInsets.zero, children: [
        SizedBox(
          height: 270,
          child: Stack(fit: StackFit.expand, children: [
            SceneArt(sceneFor(topic.scene), sunAt: const Offset(0.75, 0.3)),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, GS.cream.withValues(alpha: 0.0), GS.cream], stops: const [0, 0.55, 1]),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.6)),
                ),
              ),
            ),
            Positioned(left: 22, right: 22, bottom: 8, child: Text(topic.name, style: GS.h(36))),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
          child: Text(topic.blurb, style: GS.b(15, color: GS.muted, height: 1.5)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(children: [
            for (final r in rows) ...[
              GsCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TopicSectionScreen(topic: topic, section: r.$1, title: r.$3))),
                child: Row(children: [
                  IconBubble(r.$2, size: 42),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(r.$3, style: GS.b(15.5, w: FontWeight.w700)),
                      Text(r.$4, style: GS.b(12.5, color: GS.muted)),
                    ]),
                  ),
                  const Icon(Icons.chevron_right, color: GS.muted),
                ]),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 10),
            SoftButton('Talk about ${topic.name.toLowerCase()}', icon: Icons.chat_bubble_outline, onPressed: () => openTalk(context)),
            const SizedBox(height: 28),
          ]),
        ),
      ]),
    );
  }
}

/// Keeps "The Gita says", "GitaSetu interpretation" and "Modern application"
/// visibly distinct (PRD §32).
class TopicSectionScreen extends StatelessWidget {
  const TopicSectionScreen({super.key, required this.topic, required this.section, required this.title});
  final Topic topic;
  final TopicSection section;
  final String title;

  Widget _label(String text, {Color color = GS.terracotta}) =>
      Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: GS.b(12.5, w: FontWeight.w700, color: color)));

  @override
  Widget build(BuildContext context) {
    final concept = GitaKnowledge.bySanskrit(topic.conceptSanskrit!);
    final children = <Widget>[];
    switch (section) {
      case TopicSection.overview:
        children.addAll([
          _label('Sanskrit concept'),
          GsCard(child: Row(children: [
            Expanded(child: Text('${concept.sanskrit} — ${concept.primaryEnglish}', style: GS.h(20))),
          ])),
          const SizedBox(height: 16),
          _label('How it is often felt'),
          Wrap(spacing: 8, runSpacing: 8, children: [for (final h in concept.humanExperience) Chip(label: Text(h), backgroundColor: Colors.white, side: BorderSide(color: GS.line), labelStyle: GS.b(13))]),
          const SizedBox(height: 16),
          _label('Signals you might notice'),
          for (final sg in concept.signals)
            Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(padding: EdgeInsets.only(top: 6, right: 10), child: Icon(Icons.circle, size: 6, color: GS.gold)),
              Expanded(child: Text(sg, style: GS.b(15))),
            ])),
          const SizedBox(height: 12),
          Text('These are common human experiences linked to the concept, not a diagnosis.', style: GS.b(12.5, color: GS.muted)),
        ]);
      case TopicSection.perspective:
        children.addAll([
          _label('The Gita says'),
          for (final r in concept.verseRefs) ...[VerseCard(r), const SizedBox(height: 12)],
        ]);
      case TopicSection.why:
        if (concept.verseRefs.contains('2.62')) {
          const chain = ['Dhyāna — dwelling on an object', 'Saṅga — attachment', 'Kāma — desire', 'Krodha — anger', 'Sammoha — delusion', 'Smṛti-vibhrama — confused memory', 'Buddhi-nāśa — loss of discernment', 'Praṇaśyati — downfall'];
          children.addAll([
            _label('The chain described in the Gita (2.62–2.63)'),
            for (var i = 0; i < chain.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  Container(width: 26, height: 26, alignment: Alignment.center, decoration: const BoxDecoration(color: GS.sage, shape: BoxShape.circle), child: Text('${i + 1}', style: GS.b(12, w: FontWeight.w700, color: GS.teal))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(chain[i], style: GS.b(15))),
                ]),
              ),
            const SizedBox(height: 18),
          ]);
        }
        children.addAll([
          _label('GitaSetu interpretation'),
          GsCard(color: const Color(0xFFF6EBD8), child: Text(concept.interpretation, style: GS.b(15, height: 1.55))),
          const SizedBox(height: 16),
          _label('Practical application', color: GS.teal),
          Text(topic.application, style: GS.b(15, height: 1.5)),
        ]);
      case TopicSection.examples:
        children.addAll([
          _label('Modern application'),
          for (final e in topic.examples) ...[GsCard(child: Text(e, style: GS.b(15, height: 1.5))), const SizedBox(height: 10)],
          Text('Illustrative situations written by GitaSetu, not statements from the Gita.', style: GS.b(12.5, color: GS.muted)),
        ]);
      case TopicSection.practices:
        final offer = PracticeOffer(title: concept.practiceTitle, trigger: concept.practiceTrigger, action: concept.practiceAction, quality: concept.quality, type: concept.practiceType);
        children.addAll([
          _label('A small practice'),
          GsCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(offer.title, style: GS.h(19)),
            const SizedBox(height: 8),
            Text('${offer.trigger}: ${offer.action}', style: GS.b(15, height: 1.5)),
            const SizedBox(height: 14),
            PrimaryButton('Review practice', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PracticeCreationScreen(offer: offer)))),
          ])),
          const SizedBox(height: 10),
          Text('Nothing is added until you tap Create Practice.', style: GS.b(12.5, color: GS.muted)),
        ]);
      case TopicSection.audio:
        children.addAll([
          GsCard(child: Row(children: [
            const IconBubble(Icons.headphones_outlined, bg: GS.sage, fg: GS.teal, size: 46),
            const SizedBox(width: 14),
            Expanded(child: Text('Guided audio for ${topic.name.toLowerCase()} is coming soon.', style: GS.b(15))),
          ])),
        ]);
    }
    return Scaffold(
      appBar: AppBar(title: Text(title, style: GS.h(20))),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 32), children: children),
    );
  }
}
