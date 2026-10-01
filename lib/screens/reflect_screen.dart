import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'talk_screen.dart';

const reflectionPrompts = [
  'What happened?',
  'What did you feel?',
  'What did you want?',
  'What were you afraid of losing?',
  'What did you do?',
  'What happened afterward?',
  'What would you like to practise next time?',
];

class ReflectScreen extends StatelessWidget {
  const ReflectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Reflect', style: t.headlineSmall),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: const Text('Talk to GitaSetu'),
            subtitle: const Text('Something just happened? Talk it through.'),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const TalkScreen())),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.edit_note),
            title: const Text('Evening reflection'),
            subtitle: const Text('A couple of quiet minutes.'),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const ReflectionForm())),
          ),
        ),
        const SizedBox(height: 24),
        Text("Patterns you've noticed", style: t.titleMedium),
        const SizedBox(height: 4),
        Text('Your past reflections', style: t.bodySmall),
        const SizedBox(height: 8),
        if (s.reflections.isEmpty)
          Text('Nothing here yet.', style: t.bodyMedium),
        for (final r in s.reflections)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_fmt(r.createdAt), style: t.labelMedium),
                  for (final e in r.answers.entries) ...[
                    const SizedBox(height: 8),
                    Text(e.key, style: t.labelMedium),
                    Text(e.value, style: t.bodyMedium),
                  ],
                ]),
              ),
            ),
          ),
      ],
    );
  }

  static String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class ReflectionForm extends StatefulWidget {
  const ReflectionForm({super.key, this.practiceId});
  final String? practiceId;
  @override
  State<ReflectionForm> createState() => _ReflectionFormState();
}

class _ReflectionFormState extends State<ReflectionForm> {
  final _c = {for (final p in reflectionPrompts) p: TextEditingController()};

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reflection')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final p in reflectionPrompts) ...[
            Text(p, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            TextField(controller: _c[p], minLines: 1, maxLines: 4),
            const SizedBox(height: 16),
          ],
          const Text('Answer only what feels useful — blanks are fine.'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              context.read<AppState>().addReflection(
                    {for (final e in _c.entries) e.key: e.value.text},
                    practiceId: widget.practiceId,
                  );
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
