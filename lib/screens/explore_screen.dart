import 'package:flutter/material.dart';
import '../data/gita_knowledge.dart';
import 'topic_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Explore', style: t.headlineSmall),
        const SizedBox(height: 4),
        Text('Start from a topic, not a chapter.', style: t.bodyMedium),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final topic in topics)
              ActionChip(
                label: Text(topic.name),
                onPressed: topic.conceptSanskrit == null
                    ? null
                    : () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => TopicScreen(topic: topic))),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Greyed-out topics are coming soon.', style: t.bodySmall),
      ],
    );
  }
}
