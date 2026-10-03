import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/art.dart';
import '../core/motion.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/gs_widgets.dart';
import '../widgets/verse_widgets.dart';
import 'practice_creation_screen.dart';

/// "Talk to GitaSetu" — start screen when empty, conversation otherwise.
class TalkScreen extends StatefulWidget {
  const TalkScreen({super.key});
  @override
  State<TalkScreen> createState() => _TalkScreenState();
}

class _TalkScreenState extends State<TalkScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _input.clear();
    context.read<AppState>().send(text);
    _toEnd();
  }

  void _toEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent + 300, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final empty = s.messages.isEmpty;
    return SafeArea(
      bottom: false,
      child: Column(children: [
        if (!empty) _Header(onBack: () => s.go(0), onNew: s.newConversation),
        Expanded(child: empty ? _Start(onPick: (t) { s.send(t); _toEnd(); }) : _Conversation(controller: _scroll)),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
              child: Focus(
                // Enter sends on hardware keyboards; Shift+Enter adds a new line.
                onKeyEvent: (_, e) {
                  if (e is KeyDownEvent && e.logicalKey == LogicalKeyboardKey.enter && !HardwareKeyboard.instance.isShiftPressed) {
                    _send();
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: TextField(
                  controller: _input,
                  focusNode: _focus,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: empty ? "Tell me what's going on…" : 'Share your thoughts…',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: BorderSide(color: GS.line)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: BorderSide(color: GS.line)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: s.thinking ? GS.line : GS.teal,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: s.thinking ? null : _send,
                child: const SizedBox(width: 50, height: 50, child: Icon(Icons.arrow_forward, color: Colors.white)),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack, required this.onNew});
  final VoidCallback onBack, onNew;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
        decoration: BoxDecoration(color: GS.cream, border: Border(bottom: BorderSide(color: GS.line.withValues(alpha: 0.6)))),
        child: Row(children: [
          IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
          const GsAvatar(size: 38),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('GitaSetu', style: GS.b(16, w: FontWeight.w700)),
              Text('Reflecting with you', style: GS.b(12, color: GS.teal)),
            ]),
          ),
          PopupMenuButton<String>(
            onSelected: (_) => onNew(),
            itemBuilder: (_) => const [PopupMenuItem(value: 'new', child: Text('New conversation'))],
          ),
        ]),
      );
}

class _Start extends StatelessWidget {
  const _Start({required this.onPick});
  final ValueChanged<String> onPick;
  @override
  Widget build(BuildContext context) {
    const examples = [
      (Icons.favorite_border, 'I feel angry in my relationship.'),
      (Icons.phone_iphone, "I can't stop checking whether someone replied."),
      (Icons.sentiment_dissatisfied_outlined, "I feel jealous of my friend's success."),
      (Icons.schedule, 'I procrastinate important work.'),
      (Icons.track_changes, 'I want to be more disciplined.'),
    ];
    return ListView(padding: const EdgeInsets.fromLTRB(22, 26, 22, 12), children: staggered([
      const Center(child: Breathing(amount: 0.04, child: BloomingLotus(size: 84))),
      const SizedBox(height: 14),
      Center(child: Text('Talk to GitaSetu', style: GS.h(28))),
      const SizedBox(height: 8),
      Center(child: Text("Share what's on your mind.\nLet's explore it together.", textAlign: TextAlign.center, style: GS.b(15, color: GS.muted, height: 1.5))),
      const SizedBox(height: 26),
      for (final e in examples) ...[
        GsCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          radius: 18,
          onTap: () => onPick(e.$2),
          child: Row(children: [
            IconBubble(e.$1, bg: GS.sage, fg: GS.teal, size: 32),
            const SizedBox(width: 12),
            Expanded(child: Text(e.$2, style: GS.b(14.5))),
          ]),
        ),
        const SizedBox(height: 10),
      ],
    ]));
  }
}

class _Conversation extends StatelessWidget {
  const _Conversation({required this.controller});

  /// Messages already shown once; only new ones animate in.
  static final _seen = <String>{};
  final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      itemCount: s.messages.length + (s.thinking ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (_, i) {
        if (i == s.messages.length) return const FadeSlideIn(child: _Typing());
        final m = s.messages[i];
        return FadeSlideIn(key: ValueKey(m.id), animate: _seen.add(m.id), offset: 14, child: _Bubble(msg: m));
      },
    );
  }
}

class _Typing extends StatelessWidget {
  const _Typing();
  @override
  Widget build(BuildContext context) => const Row(children: [
        GsAvatar(size: 32),
        SizedBox(width: 10),
        TypingDots(),
      ]);
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg});
  final ChatMessage msg;

  @override
  Widget build(BuildContext context) {
    if (msg.fromUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: GS.userBubble,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(5)),
          ),
          child: Text(msg.text, style: GS.b(15.5)),
        ),
      );
    }
    final hasDepth = msg.verseRefs.isNotEmpty || msg.offer != null;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(top: 2), child: GsAvatar(size: hasDepth ? 30 : 34)),
      const SizedBox(width: 10),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: msg.safety ? const Color(0xFFF7E3D2) : Colors.white,
              border: Border.all(color: GS.line),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: Text(msg.text, style: GS.b(15.5, height: 1.5)),
          ),
          for (final r in msg.verseRefs) ...[const SizedBox(height: 10), VerseCard(r)],
          if (msg.reflectionQuestion != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: GS.sage.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(20)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('A reflection for you', style: GS.b(12.5, w: FontWeight.w700, color: GS.teal)),
                const SizedBox(height: 6),
                Text(msg.reflectionQuestion!, style: GS.h(16.5, height: 1.4)),
              ]),
            ),
          ],
          if (msg.offer != null) ...[const SizedBox(height: 10), _OfferCard(msg: msg)],
        ]),
      ),
    ]);
  }
}

/// Offer made in conversation. Nothing is created until the user confirms on
/// the practice screen (PRD §24).
class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.msg});
  final ChatMessage msg;
  @override
  Widget build(BuildContext context) {
    final o = msg.offer!;
    return GsCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const IconBubble(Icons.local_florist_outlined, size: 34),
          const SizedBox(width: 10),
          Expanded(child: Text('I have one small practice for you.', style: GS.b(14, w: FontWeight.w700))),
        ]),
        const SizedBox(height: 12),
        Text(o.title, style: GS.h(18)),
        const SizedBox(height: 4),
        Text('${o.trigger}, ${o.action[0].toLowerCase()}${o.action.substring(1)}', style: GS.b(14.5, height: 1.45)),
        const SizedBox(height: 14),
        CalmSwitcher(id: msg.offerState, child: switch (msg.offerState) {
          OfferState.pending => Column(children: [
              PrimaryButton('Create Practice', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PracticeCreationScreen(offer: o, msgId: msg.id)))),
              const SizedBox(height: 8),
              TextButton(onPressed: () => context.read<AppState>().declineOffer(msg.id), child: Text('Not now', style: GS.b(14, w: FontWeight.w700, color: GS.muted))),
            ]),
          OfferState.created => Row(children: [
              const Icon(Icons.check_circle, size: 18, color: GS.teal),
              const SizedBox(width: 8),
              Text('Added to My Practice', style: GS.b(14, w: FontWeight.w700, color: GS.teal)),
            ]),
          OfferState.declined => Text('Not now — that is fine.', style: GS.b(14, color: GS.muted)),
        }),
      ]),
    );
  }
}
