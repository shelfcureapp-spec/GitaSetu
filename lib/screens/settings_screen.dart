import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../services/conversation_engine.dart';
import '../state/app_state.dart';
import '../widgets/gs_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: GS.h(20))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        GsCard(
          onTap: () async {
            final c = TextEditingController(text: s.name);
            final v = await showDialog<String>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Your name'),
                content: TextField(controller: c, autofocus: true),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  FilledButton(onPressed: () => Navigator.pop(context, c.text), child: const Text('Save')),
                ],
              ),
            );
            if (v != null) s.setName(v);
          },
          child: Row(children: [
            const IconBubble(Icons.person_outline, bg: GS.sage, fg: GS.teal, size: 40),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Name', style: GS.b(15, w: FontWeight.w700)),
              Text(s.name.isEmpty ? 'Not set' : s.name, style: GS.b(13, color: GS.muted)),
            ])),
            const Icon(Icons.edit_outlined, size: 18, color: GS.muted),
          ]),
        ),
        const SizedBox(height: 10),
        GsCard(
          child: Row(children: [
            const IconBubble(Icons.auto_awesome, bg: GS.sage, fg: GS.teal, size: 40),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('AI mode', style: GS.b(15, w: FontWeight.w700)),
              Text(GeminiConfig.enabled ? 'Gemini (${GeminiConfig.model})' : 'Offline guided mode — build with GEMINI_API_KEY to use Gemini', style: GS.b(13, color: GS.muted)),
            ])),
          ]),
        ),
        const SizedBox(height: 22),
        Text(
          'GitaSetu is a self-reflection and spiritual practice app. It is not a medical or mental-health '
          'service and is not a replacement for professional support.',
          style: GS.b(13, color: GS.muted),
        ),
        const SizedBox(height: 22),
        SoftButton('Delete my data', icon: Icons.delete_outline, onPressed: () async {
          final ok = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Delete all data?'),
              content: const Text('Practices, reflections and conversations on this device will be removed.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
              ],
            ),
          );
          if (ok == true) {
            await s.clearAll();
            if (context.mounted) Navigator.of(context).popUntil((r) => r.isFirst);
          }
        }),
      ]),
    );
  }
}
