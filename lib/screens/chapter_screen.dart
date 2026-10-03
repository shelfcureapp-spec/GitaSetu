import 'package:flutter/material.dart';
import '../core/motion.dart';
import '../core/theme.dart';
import '../data/gita_knowledge.dart';
import '../widgets/gs_widgets.dart';
import '../widgets/verse_widgets.dart';

class ChapterScreen extends StatelessWidget {
  const ChapterScreen({super.key, required this.chapter});
  final Chapter chapter;
  @override
  Widget build(BuildContext context) {
    final verses = GitaKnowledge.verses.values.where((v) => v.chapter == chapter.number).toList()
      ..sort((a, b) => a.ref.compareTo(b.ref));
    return Scaffold(
      appBar: AppBar(title: Text('Chapter ${chapter.number}', style: GS.h(20))),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 32), children: staggered([
        Text(chapter.focus, style: GS.b(15, color: GS.muted)),
        const SizedBox(height: 18),
        if (verses.isEmpty)
          GsCard(child: Row(children: [
            const IconBubble(Icons.hourglass_empty, bg: GS.tint, fg: GS.gold, size: 44),
            const SizedBox(width: 14),
            Expanded(child: Text('Verses for this chapter are still being added.', style: GS.b(15))),
          ])),
        for (final v in verses) ...[
          GsCard(
            onTap: () => openVerse(context, v.ref),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(v.title, style: GS.b(15.5, w: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(v.summary, style: GS.b(13.5, color: GS.muted), maxLines: 2, overflow: TextOverflow.ellipsis),
                ]),
              ),
              const Icon(Icons.chevron_right, color: GS.muted),
            ]),
          ),
          const SizedBox(height: 10),
        ],
      ])),
    );
  }
}
