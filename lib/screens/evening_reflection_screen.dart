import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/gs_widgets.dart';

const reflectionPrompts = [
  'What happened today?',
  'What did you feel?',
  'What did you want?',
  'What were you afraid of losing?',
  'What did you do?',
  'What did you learn?',
  'What would you like to practise next time?',
];

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
String formatDay(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

class EveningReflectionScreen extends StatefulWidget {
  const EveningReflectionScreen({super.key, this.practiceId});
  final String? practiceId;
  @override
  State<EveningReflectionScreen> createState() => _EveningReflectionScreenState();
}

class _EveningReflectionScreenState extends State<EveningReflectionScreen> {
  final _c = {for (final p in reflectionPrompts) p: TextEditingController()};
  String? _open = reflectionPrompts.first;

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
      appBar: AppBar(),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 28), children: [
        Text('Evening Reflection', style: GS.h(28)),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: GS.line), borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.circle_outlined, size: 14, color: GS.teal),
              const SizedBox(width: 8),
              Text('Today, ${formatDay(DateTime.now())}', style: GS.b(12.5, w: FontWeight.w600)),
            ]),
          ),
        ),
        const SizedBox(height: 8),
        Text('Answer only what feels useful — blanks are fine.', style: GS.b(13, color: GS.muted)),
        const SizedBox(height: 14),
        for (final p in reflectionPrompts) ...[
          GsCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            radius: 16,
            child: Column(children: [
              InkWell(
                onTap: () => setState(() => _open = _open == p ? null : p),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(children: [
                    Expanded(child: Text(p, style: GS.b(15, w: FontWeight.w600))),
                    if (_c[p]!.text.trim().isNotEmpty) const Padding(padding: EdgeInsets.only(right: 6), child: Icon(Icons.check_circle, size: 18, color: GS.teal)),
                    Icon(_open == p ? Icons.expand_less : Icons.chevron_right, color: GS.muted),
                  ]),
                ),
              ),
              if (_open == p)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: TextField(
                    controller: _c[p],
                    autofocus: true,
                    minLines: 2,
                    maxLines: 6,
                    onChanged: (_) => setState(() {}),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Write here…',
                      fillColor: GS.cream,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 10),
        PrimaryButton('Save Reflection', onPressed: () {
          context.read<AppState>().addReflection({for (final e in _c.entries) e.key: e.value.text}, practiceId: widget.practiceId);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reflection saved.')));
        }),
      ]),
    );
  }
}
