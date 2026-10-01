import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/gs_widgets.dart';
import '../widgets/verse_widgets.dart';
import 'evening_reflection_screen.dart';
import 'settings_screen.dart';

/// Profile tab: "Your Journey". Shows what the user has noticed and practised —
/// counts of behaviour, never a spiritual score (PRD §35–36).
class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});
  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  int _tab = 0;
  static const _bg = Color(0xFF0C2229);
  static final _panel = Colors.white.withValues(alpha: 0.07);

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return ColoredBox(
      color: _bg,
      child: SafeArea(
        bottom: false,
        child: ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 28), children: [
          Row(children: [
            Expanded(child: Text('Your Journey', style: GS.h(28, color: Colors.white))),
            IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
              icon: const Icon(Icons.settings_outlined, color: Colors.white70),
            ),
            CircleAvatar(
              radius: 19,
              backgroundColor: GS.gold,
              child: Text(s.name.isEmpty ? 'G' : s.name[0].toUpperCase(), style: GS.b(15, w: FontWeight.w700, color: Colors.white)),
            ),
          ]),
          const SizedBox(height: 16),
          PillTabs(labels: const ['Patterns', 'Insights', 'Growth'], index: _tab, onChanged: (i) => setState(() => _tab = i), dark: true),
          const SizedBox(height: 22),
          ...switch (_tab) { 0 => _patterns(s), 1 => _insights(s), _ => _growth(s) },
        ]),
      ),
    );
  }

  Widget _row(IconData icon, String title, String trailing, {Color iconBg = const Color(0x22C9953E), VoidCallback? onTap}) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: _panel,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                Container(width: 38, height: 38, decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle), child: Icon(icon, color: GS.gold, size: 20)),
                const SizedBox(width: 14),
                Expanded(child: Text(title, style: GS.b(15, w: FontWeight.w700, color: Colors.white))),
                Text(trailing, style: GS.b(12.5, color: Colors.white60)),
              ]),
            ),
          ),
        ),
      );

  Widget _empty(String text) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: _panel, borderRadius: BorderRadius.circular(16)),
        child: Text(text, style: GS.b(14.5, color: Colors.white70, height: 1.5)),
      );

  List<Widget> _patterns(AppState s) => [
        const SectionTitle("Patterns you've noticed", dark: true),
        if (s.patternCounts.isEmpty)
          _empty('As you talk things through, recurring patterns will be gathered here — as things you have noticed, not labels about who you are.'),
        for (final p in s.patternCounts.take(5)) _row(Icons.change_history_rounded, p.key, 'Appeared ${p.value} time${p.value == 1 ? '' : 's'}'),
        const SizedBox(height: 18),
        ..._qualities(s),
      ];

  List<Widget> _qualities(AppState s) {
    final q = s.qualityCounts;
    final max = q.values.fold<int>(1, (a, b) => b > a ? b : a);
    return [
      const SectionTitle("Qualities you're practising", dark: true),
      if (q.isEmpty) _empty('Complete a practice and the quality it builds will show up here.'),
      for (final e in q.entries)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: _panel, borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              Row(children: [
                Expanded(child: Text(e.key, style: GS.b(15, w: FontWeight.w700, color: Colors.white))),
                Text('${e.value} time${e.value == 1 ? '' : 's'}', style: GS.b(12.5, color: Colors.white60)),
              ]),
              const SizedBox(height: 10),
              ProgressBar(e.value / max, color: GS.gold, track: Colors.white12),
            ]),
          ),
        ),
    ];
  }

  List<Widget> _insights(AppState s) {
    final talks = s.messages.where((m) => m.fromUser).length;
    Widget stat(String n, String l) => Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: _panel, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(n, style: GS.h(26, color: Colors.white)),
              Text(l, style: GS.b(12.5, color: Colors.white60)),
            ]),
          ),
        );
    return [
      Row(children: [stat('$talks', 'things you shared'), const SizedBox(width: 10), stat('${s.reflections.length}', 'reflections')]),
      const SizedBox(height: 10),
      Row(children: [stat('${s.practices.length}', 'practices created'), const SizedBox(width: 10), stat('${s.bookmarks.length}', 'verses saved')]),
      const SizedBox(height: 22),
      const SectionTitle('Your reflections', dark: true),
      if (s.reflections.isEmpty) _empty('Your saved evening reflections will appear here.'),
      for (final r in s.reflections.take(10))
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: _panel, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(formatDay(r.createdAt), style: GS.b(12, w: FontWeight.w700, color: GS.gold)),
              for (final e in r.answers.entries) ...[
                const SizedBox(height: 8),
                Text(e.key, style: GS.b(12, color: Colors.white60)),
                Text(e.value, style: GS.b(14.5, color: Colors.white)),
              ],
            ]),
          ),
        ),
      const SizedBox(height: 6),
      OutlinedButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EveningReflectionScreen())),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white24), minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
        child: const Text('New reflection'),
      ),
    ];
  }

  List<Widget> _growth(AppState s) => [
        ..._qualities(s),
        const SizedBox(height: 18),
        const SectionTitle('Saved verses', dark: true),
        if (s.bookmarks.isEmpty) _empty('Bookmark a verse while studying it and it will be kept here.'),
        for (final r in (s.bookmarks.toList()..sort())) _row(Icons.bookmark, 'Bhagavad Gita $r', '', onTap: () => openVerse(context, r)),
      ];
}
