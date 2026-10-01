import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/gita_knowledge.dart';
import '../screens/gita_study_screen.dart';
import '../state/app_state.dart';

void openVerse(BuildContext context, String ref) {
  if (GitaKnowledge.verses[ref] == null) return;
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => GitaStudyScreen(ref: ref)));
}

/// "The Gita says" card used in conversation (PRD §48): Sanskrit when we have
/// it, the verse summary, and a way to open the full verse.
class VerseCard extends StatelessWidget {
  const VerseCard(this.ref, {super.key});
  final String ref;
  @override
  Widget build(BuildContext context) {
    final v = GitaKnowledge.verses[ref];
    if (v == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EBD8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GS.line),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.auto_awesome, size: 16, color: GS.gold),
          const SizedBox(width: 6),
          Text('The Gita says  ·  ${v.title}', style: GS.b(12.5, w: FontWeight.w700, color: GS.terracotta)),
        ]),
        const SizedBox(height: 10),
        if (v.sanskrit != null) ...[
          Text(v.sanskrit!, style: GS.sanskrit(17)),
          if (v.transliteration != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(v.transliteration!, style: GS.b(13, color: GS.muted).copyWith(fontStyle: FontStyle.italic)),
            ),
          const SizedBox(height: 10),
        ],
        Text(v.summary, style: GS.b(14.5)),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => openVerse(context, ref),
          icon: const Icon(Icons.menu_book_outlined, size: 16),
          label: const Text('Read full verse'),
          style: OutlinedButton.styleFrom(
            foregroundColor: GS.ink,
            backgroundColor: Colors.white,
            side: BorderSide(color: GS.line),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            textStyle: GS.b(13, w: FontWeight.w700),
          ),
        ),
      ]),
    );
  }
}

class VerseChip extends StatelessWidget {
  const VerseChip(this.ref, {super.key});
  final String ref;
  @override
  Widget build(BuildContext context) => ActionChip(
        avatar: const Icon(Icons.menu_book_outlined, size: 16, color: GS.teal),
        label: Text('Bhagavad Gita $ref'),
        labelStyle: GS.b(13, w: FontWeight.w600),
        backgroundColor: Colors.white,
        side: BorderSide(color: GS.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () => openVerse(context, ref),
      );
}

class BookmarkButton extends StatelessWidget {
  const BookmarkButton(this.ref, {super.key});
  final String ref;
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final on = s.bookmarks.contains(ref);
    return IconButton(
      tooltip: on ? 'Remove bookmark' : 'Bookmark verse',
      icon: Icon(on ? Icons.bookmark : Icons.bookmark_border, color: on ? GS.gold : GS.ink),
      onPressed: () => s.toggleBookmark(ref),
    );
  }
}

