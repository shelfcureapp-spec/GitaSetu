import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/gita_knowledge.dart';
import '../models/models.dart';

/// Gemini config comes from build-time defines so no key is committed:
/// flutter run --dart-define=GEMINI_API_KEY=... [--dart-define=GEMINI_MODEL=...]
class GeminiConfig {
  static const apiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const model =
      String.fromEnvironment('GEMINI_MODEL', defaultValue: 'gemini-flash-latest');
  static bool get enabled => apiKey.isNotEmpty;
}

class AssistantTurn {
  final String text;
  final List<String> verseRefs;
  final String? gitaConnection;
  final String? reflectionQuestion;
  final String? patternLabel;
  final PracticeOffer? offer;
  final Confidence confidence;
  final bool safety;
  const AssistantTurn({
    required this.text,
    this.verseRefs = const [],
    this.gitaConnection,
    this.reflectionQuestion,
    this.patternLabel,
    this.offer,
    this.confidence = Confidence.low,
    this.safety = false,
  });
}

abstract class ConversationEngine {
  Future<AssistantTurn> respond(List<ChatMessage> history);
}

/// Serious-situation handling (PRD §40). Deliberately conservative keyword
/// screen that runs before any model call; exact handling is a separate spec.
class SafetyScreen {
  static const _terms = [
    'suicide', 'suicidal', 'kill myself', 'end my life', 'want to die',
    'self harm', 'self-harm', 'hurt myself', 'cut myself',
  ];
  static bool triggered(String text) {
    final t = text.toLowerCase();
    return _terms.any(t.contains);
  }

  static const turn = AssistantTurn(
    safety: true,
    text: 'This sounds really difficult, and I am glad you said it. GitaSetu can help you '
        'reflect on situations, but it is not a replacement for professional support. '
        'If you might act on these thoughts or are in danger, please contact your local '
        'emergency number or a crisis line right now, or reach out to someone you trust '
        'to be with you.',
  );
}

/// Picks Gemini when a key is configured, otherwise the offline guided flow;
/// falls back to offline if the network call fails.
class RoutingEngine implements ConversationEngine {
  final ConversationEngine _gemini = GeminiEngine();
  final ConversationEngine _local = LocalGuidedEngine();

  @override
  Future<AssistantTurn> respond(List<ChatMessage> history) async {
    final last = history.lastWhere((m) => m.fromUser).text;
    if (SafetyScreen.triggered(last)) return SafetyScreen.turn;
    if (GeminiConfig.enabled) {
      try {
        return await _gemini.respond(history);
      } catch (_) {/* fall through to offline flow */}
    }
    return _local.respond(history);
  }
}

/// Offline investigation flow: question, question, then teaching + practice.
class LocalGuidedEngine implements ConversationEngine {
  @override
  Future<AssistantTurn> respond(List<ChatMessage> history) async {
    final userMsgs = history.where((m) => m.fromUser).map((m) => m.text).toList();
    final concept = GitaKnowledge.byKeyword(userMsgs.join(' ')) ??
        GitaKnowledge.concepts.firstWhere((c) => c.sanskrit == 'Mana');
    final n = userMsgs.length;
    if (n <= concept.investigationQuestions.length) {
      final lead = n == 1 ? 'Thank you for sharing that. ' : '';
      return AssistantTurn(
        text: '$lead${concept.investigationQuestions[n - 1]}',
        confidence: Confidence.low,
      );
    }
    final ref = concept.verseRefs.first;
    return AssistantTurn(
      text: 'Putting together what you described, this may involve ${concept.primaryEnglish.toLowerCase()} '
          '— I may be wrong, so tell me if it does not fit.\n\n${concept.interpretation}',
      verseRefs: [ref],
      gitaConnection: GitaKnowledge.verses[ref]!.summary,
      reflectionQuestion: concept.reflectionQuestion,
      patternLabel: concept.primaryEnglish,
      confidence: Confidence.medium,
      offer: PracticeOffer(
        title: concept.practiceTitle,
        trigger: concept.practiceTrigger,
        action: concept.practiceAction,
        quality: concept.quality,
        type: concept.practiceType,
      ),
    );
  }
}

/// Gemini orchestrates the conversation but may only cite retrieved verses.
class GeminiEngine implements ConversationEngine {
  static const _system = '''
You are GitaSetu, a calm, concise, non-judgmental guide for self-reflection using the Bhagavad Gita.
RULES:
- Never diagnose, shame, moralise, or claim to be Krishna. Say "Based on the Gita's teaching…", never "Krishna says to you".
- Never state certainty about the user's inner state; use "may", "might". Set confidence to high/medium/low.
- Investigate first: ask ONE short question at a time (what happened before, what they wanted, what they feared losing). Do not give a teaching until you have asked at least two questions, unless the user clearly asks for one.
- You may cite ONLY verses listed in CONTEXT_VERSES, by their ref. Never invent verses, Sanskrit, or meanings.
- Keep replies under 90 words. One teaching, one tiny practice, one question at most.
- Only when you have given a teaching, include one reflection_question and one tiny practice in "practice". Never say a practice has been created; the user confirms in the app.
- Do not offer a practice for serious distress; gently note GitaSetu is not a substitute for professional support.
Respond as JSON: {"text": string, "verse_refs": string[], "gita_connection": string|null,
"confidence": "high"|"medium"|"low", "reflection_question": string|null, "practice": {"title","trigger","action","quality"}|null}
''';

  @override
  Future<AssistantTurn> respond(List<ChatMessage> history) async {
    final recent = history.length > 16 ? history.sublist(history.length - 16) : history;
    final userText = recent.where((m) => m.fromUser).map((m) => m.text).join(' ');
    final concept = GitaKnowledge.byKeyword(userText);
    final refs = concept?.verseRefs ?? const ['2.47', '2.62'];
    final context = {
      for (final r in refs) r: GitaKnowledge.verses[r]!.summary,
      if (concept != null) 'concept': {
        'sanskrit': concept.sanskrit,
        'english': concept.primaryEnglish,
        'experiences': concept.humanExperience,
        'signals': concept.signals,
      },
    };
    final body = {
      'systemInstruction': {
        'parts': [
          {'text': '$_system\nCONTEXT_VERSES: ${jsonEncode(context)}'}
        ]
      },
      'contents': [
        for (final m in recent)
          {
            'role': m.fromUser ? 'user' : 'model',
            'parts': [
              {'text': m.text}
            ]
          }
      ],
      'generationConfig': {'responseMimeType': 'application/json', 'temperature': 0.6},
    };
    final res = await http
        .post(
          Uri.parse(
              'https://generativelanguage.googleapis.com/v1beta/models/${GeminiConfig.model}:generateContent'),
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': GeminiConfig.apiKey,
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode != 200) throw Exception('Gemini ${res.statusCode}');
    final raw = jsonDecode(res.body)['candidates'][0]['content']['parts'][0]['text'] as String;
    return parse(raw,
        allowedRefs: GitaKnowledge.verses.keys.toSet(), patternLabel: concept?.primaryEnglish);
  }

  /// Parses model JSON and drops any verse ref not in the curated store.
  static AssistantTurn parse(String raw,
      {required Set<String> allowedRefs, String? patternLabel}) {
    final j = jsonDecode(raw) as Map<String, dynamic>;
    final verseRefs = [
      for (final r in (j['verse_refs'] as List? ?? const []))
        if (allowedRefs.contains(r.toString())) r.toString()
    ];
    final conf = switch (j['confidence']) {
      'high' => Confidence.high,
      'medium' => Confidence.medium,
      _ => Confidence.low,
    };
    // The "Gita says" text always comes from the curated store, never the model.
    final connection = verseRefs.isEmpty ? null : GitaKnowledge.verses[verseRefs.first]!.summary;
    final p = j['practice'];
    return AssistantTurn(
      text: (j['text'] as String).trim(),
      verseRefs: verseRefs,
      gitaConnection: connection,
      reflectionQuestion: j['reflection_question'] as String?,
      patternLabel: verseRefs.isEmpty ? null : patternLabel,
      confidence: conf,
      offer: p is Map<String, dynamic> ? PracticeOffer.fromJson(p) : null,
    );
  }
}
