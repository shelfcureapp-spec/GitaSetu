import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/art.dart';
import '../core/motion.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/gs_widgets.dart';

/// Review-and-confirm screen. This is the only place a practice is created.
class PracticeCreationScreen extends StatefulWidget {
  const PracticeCreationScreen({super.key, required this.offer, this.msgId});
  final PracticeOffer offer;
  final String? msgId;
  @override
  State<PracticeCreationScreen> createState() => _PracticeCreationScreenState();
}

class _PracticeCreationScreenState extends State<PracticeCreationScreen> {
  TimeOfDay? _time;
  bool _saving = false;

  String? get _hhmm => _time == null ? null : '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}';

  Future<void> _pick() async {
    final t = await showTimePicker(
      context: context,
      helpText: 'When would you like to practise this?',
      initialTime: _time ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (t != null) setState(() => _time = t);
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.offer;
    Widget row(IconData i, String k, String v, {VoidCallback? onTap, bool chevron = false}) => InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(i, size: 22, color: GS.ink),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(k, style: GS.b(14.5, w: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(v, style: GS.b(14, color: GS.muted)),
                ]),
              ),
              if (chevron) const Icon(Icons.chevron_right, color: GS.muted),
            ]),
          ),
        );

    return Scaffold(
      appBar: AppBar(),
      body: ListView(padding: const EdgeInsets.fromLTRB(22, 0, 22, 28), children: staggered([
        Text('A small practice\nfor you', style: GS.h(28, height: 1.2)),
        const SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFEEF3EA), borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
          child: Column(children: [
            const Breathing(child: Sprout(size: 84)),
            const SizedBox(height: 12),
            Text(o.title, textAlign: TextAlign.center, style: GS.h(21)),
            const SizedBox(height: 10),
            Text('${o.trigger}, ${o.action[0].toLowerCase()}${o.action.substring(1)}', textAlign: TextAlign.center, style: GS.b(15.5, height: 1.5)),
          ]),
        ),
        const SizedBox(height: 16),
        row(Icons.bolt_outlined, 'Trigger', o.trigger),
        const Divider(height: 1),
        row(Icons.self_improvement, 'Action', o.action),
        const Divider(height: 1),
        row(Icons.repeat, 'Frequency', o.frequency),
        const Divider(height: 1),
        row(Icons.category_outlined, 'Type', o.type),
        const Divider(height: 1),
        row(Icons.notifications_none, 'Reminder', _time == null ? 'None — tap to choose a time' : _time!.format(context), onTap: _pick, chevron: true),
        const SizedBox(height: 22),
        PrimaryButton('Create Practice', onPressed: _saving ? null : () async {
          setState(() => _saving = true);
          context.read<AppState>().createPractice(o, msgId: widget.msgId, reminder: _hhmm);
          await showCalmSuccess(context, 'Added to My Practice');
          if (context.mounted) Navigator.of(context).pop();
        }),
        const SizedBox(height: 10),
        SoftButton('Not Now', onPressed: () {
          if (widget.msgId != null) context.read<AppState>().declineOffer(widget.msgId!);
          Navigator.of(context).pop();
        }),
      ])),
    );
  }
}
