import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import 'reflect_screen.dart';
import 'talk_screen.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Practice', style: t.headlineSmall),
        const SizedBox(height: 16),
        if (s.practices.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('No practices yet.', style: t.titleMedium),
                const SizedBox(height: 6),
                Text('Practices are created only after you talk something through and say yes.',
                    style: t.bodyMedium),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const TalkScreen())),
                  child: const Text('Talk to GitaSetu'),
                ),
              ]),
            ),
          ),
        for (final p in s.practices) ...[
          _PracticeCard(p: p),
          const SizedBox(height: 12),
        ],
        if (s.qualityCounts.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text("Qualities you're practising", style: t.titleMedium),
          const SizedBox(height: 8),
          for (final e in s.qualityCounts.entries)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(e.key),
              trailing: Text('Practised ${e.value} time${e.value == 1 ? '' : 's'} this month'),
            ),
        ],
      ],
    );
  }
}

class _PracticeCard extends StatelessWidget {
  const _PracticeCard({required this.p});
  final Practice p;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final t = Theme.of(context).textTheme;
    final done = p.doneOn(DateTime.now());
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(p.title, style: t.titleMedium)),
            PopupMenuButton<String>(
              onSelected: (v) async {
                if (v == 'remove') s.removePractice(p.id);
                if (v == 'reminder') {
                  final time = await showTimePicker(
                      context: context, initialTime: const TimeOfDay(hour: 8, minute: 0));
                  if (time != null) {
                    s.setReminder(p.id,
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                  }
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'reminder', child: Text('Set reminder time')),
                PopupMenuItem(value: 'remove', child: Text('Remove practice')),
              ],
            ),
          ]),
          Text('Trigger', style: t.labelMedium),
          Text(p.trigger, style: t.bodyMedium),
          const SizedBox(height: 8),
          Text('Practice', style: t.labelMedium),
          Text(p.action, style: t.bodyLarge),
          const SizedBox(height: 8),
          Text('${p.last7} / 7 days${p.reminder == null ? '' : '  ·  reminder ${p.reminder}'}',
              style: t.bodySmall),
          const SizedBox(height: 12),
          Wrap(spacing: 8, children: [
            FilledButton.tonal(
              onPressed: done ? null : () => s.markDone(p.id),
              child: Text(done ? 'Done today' : 'Done'),
            ),
            OutlinedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Skipped. No pressure — try again tomorrow.'))),
              child: const Text('Skip'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ReflectionForm(practiceId: p.id))),
              child: const Text('Reflect'),
            ),
          ]),
        ]),
      ),
    );
  }
}
