import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';

/// Mandatory confirmation step (PRD §24). Nothing is saved or scheduled until
/// the user taps "Create Practice".
class PracticeOfferCard extends StatelessWidget {
  const PracticeOfferCard({super.key, required this.msg});
  final ChatMessage msg;

  Future<void> _create(BuildContext context) async {
    final state = context.read<AppState>();
    final offer = msg.offer!;
    final time = await showTimePicker(
      context: context,
      helpText: 'When would you like to practise this?',
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      cancelText: 'No reminder',
    );
    final hhmm = time == null
        ? null
        : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    state.createPractice(msg.id, offer, reminder: hhmm);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Added to your practices.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final offer = msg.offer!;
    final t = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('I have one small practice for you.', style: t.labelLarge),
            const SizedBox(height: 8),
            Text(offer.trigger, style: t.bodyMedium),
            Text(offer.action, style: t.titleMedium),
            const SizedBox(height: 12),
            switch (msg.offerState) {
              OfferState.pending => Row(children: [
                  FilledButton(
                      onPressed: () => _create(context), child: const Text('Create Practice')),
                  const SizedBox(width: 8),
                  TextButton(
                      onPressed: () => context.read<AppState>().declineOffer(msg.id),
                      child: const Text('Not now')),
                ]),
              OfferState.created => Row(children: [
                  const Icon(Icons.check_circle_outline, size: 18),
                  const SizedBox(width: 6),
                  Text('Added to your practices', style: t.bodyMedium),
                ]),
              OfferState.declined => Text('Not now — that is fine.', style: t.bodyMedium),
            },
          ],
        ),
      ),
    );
  }
}
