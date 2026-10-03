import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/motion.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/gs_widgets.dart';
import 'evening_reflection_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});
  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final list = _tab == 0 ? s.activePractices : s.completedPractices;
    return SafeArea(
      bottom: false,
      child: ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 24), children: [
        Row(children: [
          Expanded(child: Text('My Practice', style: GS.h(28))),
          IconButton(
            onPressed: () => s.go(2),
            tooltip: 'Find a new practice',
            icon: const Icon(Icons.add),
          ),
        ]),
        const SizedBox(height: 12),
        PillTabs(labels: ['Active (${s.activePractices.length})', 'Completed'], index: _tab, onChanged: (i) => setState(() => _tab = i)),
        const SizedBox(height: 16),
        if (list.isEmpty)
          GsCard(
            onTap: _tab == 0 ? () => s.go(2) : null,
            child: Row(children: [
              const IconBubble(Icons.spa_outlined, bg: GS.sage, fg: GS.teal, size: 46),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  _tab == 0 ? 'No active practices. Talk something through and say yes to a small practice.' : 'Practices you finish 7 days of will appear here.',
                  style: GS.b(14.5),
                ),
              ),
            ]),
          ),
        for (final (i, p) in list.indexed) ...[
          FadeSlideIn(key: ValueKey('${_tab}_${p.id}'), order: i + 1, child: _PracticeTile(p: p)),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 8),
        GsCard(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EveningReflectionScreen())),
          child: Row(children: [
            const IconBubble(Icons.nights_stay_outlined, bg: Color(0xFFDDE5EE), fg: GS.navy2, size: 44),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Evening reflection', style: GS.b(15.5, w: FontWeight.w700)),
                Text('What did you notice today?', style: GS.b(12.5, color: GS.muted)),
              ]),
            ),
            const Icon(Icons.chevron_right, color: GS.muted),
          ]),
        ),
      ]),
    );
  }
}

class _PracticeTile extends StatelessWidget {
  const _PracticeTile({required this.p});
  final Practice p;
  @override
  Widget build(BuildContext context) => GsCard(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PracticeDetailScreen(id: p.id))),
        child: Row(children: [
          const IconBubble(Icons.local_florist_outlined, size: 46),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.title, style: GS.b(15.5, w: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(p.trigger, style: GS.b(13, color: GS.muted)),
              const SizedBox(height: 8),
              Text('${p.daysDone} / ${Practice.targetDays} days', style: GS.b(12.5, w: FontWeight.w700)),
              const SizedBox(height: 4),
              ProgressBar(p.daysDone / Practice.targetDays),
            ]),
          ),
          const Icon(Icons.chevron_right, color: GS.muted),
        ]),
      );
}

class PracticeDetailScreen extends StatelessWidget {
  const PracticeDetailScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final p = s.practices.where((e) => e.id == id).firstOrNull;
    if (p == null) return Scaffold(appBar: AppBar());
    final done = p.doneOn(DateTime.now());
    Widget row(IconData i, String k, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(i, size: 20),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(k, style: GS.b(14, w: FontWeight.w700)), Text(v, style: GS.b(14, color: GS.muted))])),
          ]),
        );
    return Scaffold(
      appBar: AppBar(actions: [
        PopupMenuButton<String>(
          onSelected: (v) async {
            if (v == 'remove') {
              s.removePractice(p.id);
              Navigator.of(context).pop();
            } else if (v == 'reminder') {
              final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 8, minute: 0));
              if (t != null) s.setReminder(p.id, '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
            } else if (v == 'restart') {
              s.restartPractice(p.id);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'reminder', child: Text('Set reminder time')),
            PopupMenuItem(value: 'restart', child: Text('Start over')),
            PopupMenuItem(value: 'remove', child: Text('Remove practice')),
          ],
        ),
      ]),
      body: ListView(padding: const EdgeInsets.fromLTRB(22, 0, 22, 28), children: staggered([
        Text(p.title, style: GS.h(26)),
        const SizedBox(height: 6),
        Text('${p.daysDone} / ${Practice.targetDays} days', style: GS.b(14, w: FontWeight.w700, color: GS.gold)),
        const SizedBox(height: 8),
        ProgressBar(p.daysDone / Practice.targetDays, height: 7),
        const SizedBox(height: 14),
        row(Icons.bolt_outlined, 'Trigger', p.trigger),
        row(Icons.self_improvement, 'Action', p.action),
        row(Icons.repeat, 'Frequency', p.frequency),
        row(Icons.category_outlined, 'Type', p.type),
        row(Icons.notifications_none, 'Reminder', p.reminder ?? 'None'),
        const SizedBox(height: 18),
        if (p.completed)
          PrimaryButton('Practise again', onPressed: () => s.restartPractice(p.id))
        else
          PrimaryButton(done ? 'Done today' : 'Done', icon: done ? Icons.check : null, onPressed: done ? null : () => s.markDone(p.id)),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: SoftButton('Skip', onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Skipped. No pressure — try again tomorrow.'))))),
          const SizedBox(width: 12),
          Expanded(child: SoftButton('Reflect', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EveningReflectionScreen(practiceId: p.id))))),
        ]),
      ])),
    );
  }
}
