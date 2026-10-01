import 'package:flutter/material.dart';
import '../core/art.dart';
import '../core/theme.dart';
import '../data/gita_knowledge.dart';
import '../widgets/gs_widgets.dart';
import 'chapter_screen.dart';
import 'topic_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _tab = 0;
  bool _searching = false;
  String _q = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 4),
          child: Row(children: [
            Expanded(child: Text('Explore', style: GS.h(28))),
            IconButton(
              onPressed: () => setState(() {
                _searching = !_searching;
                if (!_searching) _q = '';
              }),
              icon: Icon(_searching ? Icons.close : Icons.search),
            ),
          ]),
        ),
        if (_searching)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
              decoration: const InputDecoration(hintText: 'Search topics'),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: PillTabs(labels: const ['Topics', 'Chapters', 'Guided Audio'], index: _tab, onChanged: (i) => setState(() => _tab = i)),
        ),
        Expanded(child: switch (_tab) { 0 => _topics(), 1 => const _Chapters(), _ => const _AudioList() }),
      ]),
    );
  }

  Widget _topics() {
    final list = topics.where((t) => _q.isEmpty || t.name.toLowerCase().contains(_q) || t.tagline.toLowerCase().contains(_q)).toList();
    if (list.isEmpty) {
      return Center(child: Text('No topics match "$_q".', style: GS.b(14, color: GS.muted)));
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.86),
      itemCount: list.length,
      itemBuilder: (_, i) => _TopicTile(topic: list[i]),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({required this.topic});
  final Topic topic;
  @override
  Widget build(BuildContext context) {
    final soon = !topic.available;
    return GestureDetector(
      onTap: soon ? () => comingSoon(context, '${topic.name} topic') : () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TopicScreen(topic: topic))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(fit: StackFit.expand, children: [
          SceneArt(sceneFor(topic.scene), sunAt: Offset(0.3 + (topic.name.length % 5) * 0.1, 0.28)),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: soon ? 0.7 : 0.55)], stops: const [0.35, 1]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (soon)
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(10)),
                  child: Text('Soon', style: GS.b(11, color: Colors.white, w: FontWeight.w700)),
                ),
              Text(topic.name, style: GS.h(20, color: Colors.white)),
              const SizedBox(height: 2),
              Text(topic.tagline, style: GS.b(12, color: Colors.white.withValues(alpha: 0.9)), maxLines: 2, overflow: TextOverflow.ellipsis),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Chapters extends StatelessWidget {
  const _Chapters();
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
      itemCount: chapters.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final c = chapters[i];
        final n = GitaKnowledge.verses.values.where((v) => v.chapter == c.number).length;
        return GsCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChapterScreen(chapter: c))),
          child: Row(children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: GS.tint, shape: BoxShape.circle),
              child: Text('${c.number}', style: GS.h(16, color: GS.teal)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Chapter ${c.number}', style: GS.b(15, w: FontWeight.w700)),
                Text(c.focus, style: GS.b(12.5, color: GS.muted), maxLines: 2, overflow: TextOverflow.ellipsis),
              ]),
            ),
            Text(n == 0 ? 'Soon' : '$n verse${n == 1 ? '' : 's'}', style: GS.b(12, color: n == 0 ? GS.muted : GS.teal, w: FontWeight.w700)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: GS.muted),
          ]),
        );
      },
    );
  }
}

class _AudioList extends StatelessWidget {
  const _AudioList();
  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.menu_book_outlined, 'Gita explanation', '30–90 seconds'),
      (Icons.self_improvement, 'Guided reflection', '30–90 seconds'),
      (Icons.wb_sunny_outlined, 'Daily practice', '15–30 seconds'),
      (Icons.nights_stay_outlined, 'Evening reflection', '30–60 seconds'),
      (Icons.spa_outlined, 'Habit guidance', '10–30 seconds'),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
      children: [
        Text('Calm English audio, generated with Gemini TTS.', style: GS.b(13.5, color: GS.muted)),
        const SizedBox(height: 12),
        for (final i in items) ...[
          GsCard(
            onTap: () => comingSoon(context),
            child: Row(children: [
              IconBubble(i.$1, bg: GS.sage, fg: GS.teal, size: 44),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(i.$2, style: GS.b(15.5, w: FontWeight.w700)),
                  Text(i.$3, style: GS.b(12.5, color: GS.muted)),
                ]),
              ),
              Text('Soon', style: GS.b(12, color: GS.muted, w: FontWeight.w700)),
            ]),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
