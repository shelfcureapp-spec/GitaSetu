import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/conversation_engine.dart';

class AppState extends ChangeNotifier {
  AppState(this._prefs, {ConversationEngine? engine})
      : _engine = engine ?? RoutingEngine() {
    name = _prefs.getString('name') ?? '';
    onboarded = _prefs.getBool('onboarded') ?? false;
    practices = decodeList(_prefs.getString('practices')).map(Practice.fromJson).toList();
    reflections = decodeList(_prefs.getString('reflections')).map(Reflection.fromJson).toList();
    messages = decodeList(_prefs.getString('messages')).map(ChatMessage.fromJson).toList();
  }

  final SharedPreferences _prefs;
  final ConversationEngine _engine;

  late String name;
  late bool onboarded;
  late List<Practice> practices;
  late List<Reflection> reflections;
  late List<ChatMessage> messages;
  bool thinking = false;
  int _seq = 0;

  String _id() => '${DateTime.now().microsecondsSinceEpoch}_${_seq++}';

  Future<void> _save() async {
    await _prefs.setString('name', name);
    await _prefs.setBool('onboarded', onboarded);
    await _prefs.setString('practices', encodeList(practices.map((e) => e.toJson()).toList()));
    await _prefs.setString('reflections', encodeList(reflections.map((e) => e.toJson()).toList()));
    await _prefs.setString('messages', encodeList(messages.map((e) => e.toJson()).toList()));
  }

  void _commit() {
    notifyListeners();
    _save();
  }

  void completeOnboarding(String userName) {
    name = userName.trim();
    onboarded = true;
    _commit();
  }

  void setName(String n) {
    name = n.trim();
    _commit();
  }

  // ---- Talk to GitaSetu ----
  Future<void> send(String text) async {
    final t = text.trim();
    if (t.isEmpty || thinking) return;
    messages = [...messages, ChatMessage(id: _id(), fromUser: true, text: t)];
    thinking = true;
    _commit();
    try {
      final turn = await _engine.respond(messages);
      messages = [
        ...messages,
        ChatMessage(
          id: _id(),
          fromUser: false,
          text: turn.text,
          verseRefs: turn.verseRefs,
          gitaConnection: turn.gitaConnection,
          offer: turn.offer,
          safety: turn.safety,
        )
      ];
    } catch (_) {
      messages = [
        ...messages,
        ChatMessage(
            id: _id(),
            fromUser: false,
            text: 'Something went wrong on my side. Please try sending that again.')
      ];
    }
    thinking = false;
    _commit();
  }

  void newConversation() {
    messages = [];
    _commit();
  }

  void _setOffer(String msgId, OfferState s) {
    messages = [for (final m in messages) m.id == msgId ? m.withOfferState(s) : m];
  }

  void declineOffer(String msgId) {
    _setOffer(msgId, OfferState.declined);
    _commit();
  }

  /// The ONLY path that creates a practice, called from an explicit user tap
  /// on "Create Practice" (PRD §24).
  Practice createPractice(String msgId, PracticeOffer offer, {String? reminder}) {
    final p = Practice(
      id: _id(),
      title: offer.title,
      trigger: offer.trigger,
      action: offer.action,
      quality: offer.quality,
      reminder: reminder,
      createdAt: DateTime.now(),
    );
    practices = [...practices, p];
    _setOffer(msgId, OfferState.created);
    _commit();
    return p;
  }

  // ---- Practice ----
  void markDone(String practiceId) {
    practices = [
      for (final p in practices)
        if (p.id == practiceId && !p.doneOn(DateTime.now()))
          p.copyWith(completions: [...p.completions, DateTime.now()])
        else
          p
    ];
    _commit();
  }

  void setReminder(String practiceId, String? hhmm) {
    practices = [
      for (final p in practices) p.id == practiceId ? p.copyWith(reminder: hhmm) : p
    ];
    _commit();
  }

  void removePractice(String id) {
    practices = practices.where((p) => p.id != id).toList();
    _commit();
  }

  int get doneToday => practices.where((p) => p.doneOn(DateTime.now())).length;

  // ---- Reflection ----
  void addReflection(Map<String, String> answers, {String? practiceId}) {
    final filled = {
      for (final e in answers.entries)
        if (e.value.trim().isNotEmpty) e.key: e.value.trim()
    };
    if (filled.isEmpty) return;
    reflections = [
      Reflection(id: _id(), createdAt: DateTime.now(), answers: filled, practiceId: practiceId),
      ...reflections
    ];
    _commit();
  }

  /// "Qualities you're practising" — counts of behaviour, not a score (PRD §36).
  Map<String, int> get qualityCounts {
    final monthAgo = DateTime.now().subtract(const Duration(days: 30));
    final out = <String, int>{};
    for (final p in practices) {
      final n = p.completions.where((c) => c.isAfter(monthAgo)).length;
      if (n > 0 && p.quality.isNotEmpty) out[p.quality] = (out[p.quality] ?? 0) + n;
    }
    return out;
  }

  Future<void> clearAll() async {
    await _prefs.clear();
    name = '';
    onboarded = false;
    practices = [];
    reflections = [];
    messages = [];
    notifyListeners();
  }
}
