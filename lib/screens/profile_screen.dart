import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/conversation_engine.dart';
import '../state/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Profile', style: t.headlineSmall),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Name'),
          subtitle: Text(s.name.isEmpty ? 'Not set' : s.name),
          trailing: const Icon(Icons.edit_outlined),
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
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('AI mode'),
          subtitle: Text(GeminiConfig.enabled
              ? 'Gemini (${GeminiConfig.model})'
              : 'Offline guided mode — build with GEMINI_API_KEY for Gemini'),
        ),
        const Divider(height: 32),
        Text(
          'GitaSetu is a self-reflection and spiritual practice app. It is not a medical or '
          'mental-health service and is not a replacement for professional support.',
          style: t.bodySmall,
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () async {
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
            if (ok == true) await s.clearAll();
          },
          child: const Text('Delete my data'),
        ),
      ],
    );
  }
}
