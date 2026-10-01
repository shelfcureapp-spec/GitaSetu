import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/practice_offer_card.dart';
import '../widgets/verse_sheet.dart';

/// "Talk to GitaSetu" — the central AI screen (PRD §38).
class TalkScreen extends StatefulWidget {
  const TalkScreen({super.key});
  @override
  State<TalkScreen> createState() => _TalkScreenState();
}

class _TalkScreenState extends State<TalkScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _input.text;
    _input.clear();
    context.read<AppState>().send(text);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent + 200,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Talk to GitaSetu'),
        actions: [
          if (s.messages.isNotEmpty)
            IconButton(
              tooltip: 'New conversation',
              icon: const Icon(Icons.add_comment_outlined),
              onPressed: s.newConversation,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: s.messages.isEmpty
                ? const _Prompts()
                : ListView.separated(
                    controller: _scroll,
                    padding: const EdgeInsets.all(16),
                    itemCount: s.messages.length + (s.thinking ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => i == s.messages.length
                        ? const _Thinking()
                        : _Bubble(msg: s.messages[i]),
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _send(),
                    decoration: const InputDecoration(hintText: 'What is on your mind?'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: s.thinking ? null : _send,
                  icon: const Icon(Icons.arrow_upward),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Prompts extends StatelessWidget {
  const _Prompts();
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    const examples = [
      'I keep getting angry when people don\'t listen to me.',
      'I can\'t stop checking whether someone replied.',
      'I keep procrastinating.',
      'I\'m jealous of my friend\'s success.',
    ];
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Describe what happened, in your own words.', style: t.titleMedium),
        const SizedBox(height: 8),
        Text('I will ask a few questions before offering anything.', style: t.bodyMedium),
        const SizedBox(height: 20),
        for (final e in examples)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ActionChip(
              label: Text(e),
              onPressed: () => context.read<AppState>().send(e),
            ),
          ),
      ],
    );
  }
}

class _Thinking extends StatelessWidget {
  const _Thinking();
  @override
  Widget build(BuildContext context) => const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg});
  final ChatMessage msg;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    if (msg.fromUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
              color: c.primaryContainer, borderRadius: BorderRadius.circular(18)),
          child: Text(msg.text, style: t.bodyLarge),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: msg.safety ? c.tertiaryContainer : c.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(msg.text, style: t.bodyLarge),
        ),
        if (msg.gitaConnection != null) ...[
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('The Gita says', style: t.labelLarge),
                const SizedBox(height: 4),
                Text(msg.gitaConnection!, style: t.bodyMedium),
              ]),
            ),
          ),
        ],
        if (msg.verseRefs.isNotEmpty) ...[
          const SizedBox(height: 4),
          Wrap(spacing: 8, children: [for (final r in msg.verseRefs) VerseChip(r)]),
        ],
        if (msg.offer != null) ...[
          const SizedBox(height: 8),
          PracticeOfferCard(msg: msg),
        ],
      ],
    );
  }
}
