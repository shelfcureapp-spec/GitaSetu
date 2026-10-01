import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text('GitaSetu', style: t.displaySmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('From wisdom to practice.', style: t.titleMedium),
              const SizedBox(height: 32),
              Text(
                'Notice what is happening inside you, see how the Bhagavad Gita speaks to it, '
                'and try one small practice.',
                style: t.bodyLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'GitaSetu is a self-reflection and spiritual practice companion. It is not a '
                'medical or mental-health service.',
                style: t.bodySmall,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'What should we call you? (optional)'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.read<AppState>().completeOnboarding(_name.text),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Begin'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
