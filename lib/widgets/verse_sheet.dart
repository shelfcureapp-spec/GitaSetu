import 'package:flutter/material.dart';
import '../data/gita_knowledge.dart';
import '../models/models.dart';

/// Citation UI (PRD §48): shows what the Gita says, clearly labelled and
/// separate from any GitaSetu interpretation.
void showVerseSheet(BuildContext context, String ref) {
  final v = GitaKnowledge.verses[ref];
  if (v == null) return;
  final t = Theme.of(context).textTheme;
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(v.title, style: t.titleLarge),
          const SizedBox(height: 4),
          Text(v.sourceType.label, style: t.labelMedium),
          const SizedBox(height: 16),
          Text('The Gita says', style: t.labelLarge),
          const SizedBox(height: 4),
          Text(v.summary, style: t.bodyLarge),
          const SizedBox(height: 16),
          Text(
            'This is a summary. The original verse and an authoritative translation '
            'will be shown here once the curated text is loaded.',
            style: t.bodySmall,
          ),
        ],
      ),
    ),
  );
}

class VerseChip extends StatelessWidget {
  const VerseChip(this.ref, {super.key});
  final String ref;
  @override
  Widget build(BuildContext context) => ActionChip(
        avatar: const Icon(Icons.menu_book_outlined, size: 16),
        label: Text('Bhagavad Gita $ref'),
        onPressed: () => showVerseSheet(context, ref),
      );
}
