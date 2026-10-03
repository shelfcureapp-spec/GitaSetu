import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/art.dart';
import '../core/motion.dart';
import '../core/motion_graphics.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/gs_widgets.dart';

/// Splash -> two onboarding pages -> name & disclaimer.
class IntroFlow extends StatefulWidget {
  const IntroFlow({super.key});
  @override
  State<IntroFlow> createState() => _IntroFlowState();
}

class _IntroFlowState extends State<IntroFlow> {
  bool _splash = true;
  final _pc = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  void _next() => _pc.nextPage(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );

  @override
  Widget build(BuildContext context) {
    if (_splash) return _Splash(onStart: () => setState(() => _splash = false));
    return Scaffold(
      body: PageView(
        controller: _pc,
        onPageChanged: (i) => setState(() => _page = i),
        children: [
          _OnboardPage(
            page: _page,
            onNext: _next,
            onSkip: () => _pc.jumpToPage(2),
            top: const LivingScene(SceneKind.bridge, sunAt: Offset(0.7, 0.28)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ancient wisdom\nfor modern life.',
                  style: GS.h(32, height: 1.15),
                ),
                const SizedBox(height: 14),
                Text(
                  'Understand yourself, make better choices and grow through the timeless teachings of the Bhagavad Gita.',
                  style: GS.b(15.5, color: GS.muted, height: 1.5),
                ),
              ],
            ),
          ),
          _OnboardPage(
            page: _page,
            onNext: _next,
            onSkip: () => _pc.jumpToPage(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text('How GitaSetu\nhelps you', style: GS.h(30, height: 1.15)),
                const SizedBox(height: 24),
                ...staggered([
                  for (final r in const [
                    (
                      Icons.local_florist_outlined,
                      'Understand your real patterns',
                      'Explore what is happening inside you.',
                      GS.terraBg,
                      GS.terracotta,
                    ),
                    (
                      Icons.menu_book_outlined,
                      'Learn from the Gita',
                      'Relevant verses with clear explanations.',
                      Color(0xFFF7DCD8),
                      Color(0xFFC0583F),
                    ),
                    (
                      Icons.spa_outlined,
                      'Build small practices',
                      'Turn insight into tiny daily actions.',
                      GS.sage,
                      GS.teal,
                    ),
                    (
                      Icons.bar_chart_rounded,
                      'Grow over time',
                      'Notice the changes in how you respond.',
                      GS.sage,
                      GS.teal,
                    ),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Row(
                        children: [
                          IconBubble(r.$1, bg: r.$4, fg: r.$5, size: 52),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.$2, style: GS.b(16, w: FontWeight.w700)),
                                Text(r.$3, style: GS.b(13.5, color: GS.muted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ], start: 2),
              ],
            ),
          ),
          const _NamePage(),
        ],
      ),
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash({required this.onStart});
  final VoidCallback onStart;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        const LivingScene(SceneKind.dawn, sunAt: Offset(0.5, 0.42), rising: true),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 56, 28, 24),
            child: Column(
              children: [
                const FadeSlideIn(order: 1, child: SetuMark(size: 64)),
                const SizedBox(height: 10),
                FadeSlideIn(
                  order: 2,
                  child: Text('GitaSetu', style: GS.h(44, color: GS.tealDeep)),
                ),
                const SizedBox(height: 6),
                FadeSlideIn(
                  order: 4,
                  child: Text(
                    'From wisdom to practice.',
                    style: GS.b(16, color: GS.ink),
                  ),
                ),
                const Spacer(),
                const LotusPond(
                  size: 110,
                  delay: Duration(milliseconds: 500),
                  rippleColor: Colors.white,
                ),
                const Spacer(),
                FadeSlideIn(
                  order: 9,
                  child: PrimaryButton(
                    'Get Started',
                    onPressed: onStart,
                    light: true,
                  ),
                ),
                const SizedBox(height: 14),
                FadeSlideIn(
                  order: 10,
                  child: Text(
                    'A calmer, more mindful you',
                    style: GS.b(14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({
    required this.page,
    required this.onNext,
    required this.onSkip,
    required this.child,
    this.top,
  });
  final int page;
  final VoidCallback onNext, onSkip;
  final Widget child;
  final Widget? top;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (top != null)
        Expanded(
          flex: 11,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(36),
                ),
                child: top!,
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: onSkip,
                    child: Text(
                      'Skip',
                      style: GS.b(14, color: GS.ink, w: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      else
        SafeArea(
          bottom: false,
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onSkip,
              child: Text(
                'Skip',
                style: GS.b(14, color: GS.muted, w: FontWeight.w700),
              ),
            ),
          ),
        ),
      Expanded(
        flex: top != null ? 10 : 1,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: FadeSlideIn(order: 1, child: child),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < 3; i++)
                    AnimatedContainer(
                      duration: Motion.medium,
                      curve: Motion.ease,
                      margin: const EdgeInsets.only(right: 6),
                      width: i == page ? 18 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: i == page ? GS.teal : GS.line,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  const Spacer(),
                  Material(
                    color: GS.teal,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onNext,
                      child: const SizedBox(
                        width: 58,
                        height: 58,
                        child: Icon(Icons.arrow_forward, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _NamePage extends StatefulWidget {
  const _NamePage();
  @override
  State<_NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<_NamePage> {
  final _name = TextEditingController();
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          const Center(
            child: LotusPond(size: 90),
          ),
          const SizedBox(height: 28),
          Text('What should we\ncall you?', style: GS.h(30, height: 1.15)),
          const SizedBox(height: 18),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'Your name (optional)'),
          ),
          const SizedBox(height: 20),
          Text(
            'GitaSetu is a self-reflection and spiritual practice companion. It is not a medical or '
            'mental-health service and is not a replacement for professional support.',
            style: GS.b(13, color: GS.muted),
          ),
          const Spacer(),
          PrimaryButton(
            'Begin',
            onPressed: () =>
                context.read<AppState>().completeOnboarding(_name.text),
          ),
        ],
      ),
    ),
  );
}
