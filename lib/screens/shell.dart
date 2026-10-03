import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/motion.dart';
import '../state/app_state.dart';
import 'explore_screen.dart';
import 'home_screen.dart';
import 'journey_screen.dart';
import 'practice_screen.dart';
import 'talk_screen.dart';

/// Bottom navigation: Home | Explore | Talk | Practice | Profile.
class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final dark = s.tab == 4;
    return Scaffold(
      backgroundColor: dark ? const Color(0xFF0C2229) : null,
      body: FadeIndexedStack(
        index: s.tab,
        children: const [
          HomeScreen(),
          ExploreScreen(),
          TalkScreen(),
          PracticeScreen(),
          JourneyScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: s.tab,
        onDestinationSelected: s.go,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Talk'),
          NavigationDestination(icon: Icon(Icons.self_improvement_outlined), selectedIcon: Icon(Icons.self_improvement), label: 'Practice'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/// Switch to the Talk tab from anywhere, optionally seeding a message.
void openTalk(BuildContext context, {String? seed}) {
  final s = context.read<AppState>();
  Navigator.of(context).popUntil((r) => r.isFirst);
  s.go(2);
  if (seed != null) s.send(seed);
}
