import 'dart:convert';

/// How a piece of knowledge relates to the source (PRD §12).
enum SourceType { direct, derived, commentarial, modernApplication, aiGenerated }

extension SourceTypeLabel on SourceType {
  String get label => switch (this) {
        SourceType.direct => 'Direct — stated in the Gita',
        SourceType.derived => 'Derived — inferred from the text',
        SourceType.commentarial => 'Commentarial',
        SourceType.modernApplication => 'Modern application',
        SourceType.aiGenerated => 'AI-generated wording',
      };
}

enum Confidence { high, medium, low }

class GitaVerse {
  final String ref; // e.g. "2.62"
  final String summary; // English summary of what the verse says
  final String? sanskrit; // to be ingested from the curated source
  final SourceType sourceType;
  const GitaVerse({
    required this.ref,
    required this.summary,
    this.sanskrit,
    this.sourceType = SourceType.direct,
  });
  String get title => 'Bhagavad Gita $ref';
}

/// Three-level concept mapping (PRD §14).
class Concept {
  final String sanskrit; // Level A
  final String primaryEnglish;
  final List<String> humanExperience; // Level B
  final List<String> signals; // Level C
  final List<String> verseRefs;
  final List<String> keywords; // retrieval hints
  final List<String> investigationQuestions;
  final String interpretation;
  final String practiceTitle;
  final String practiceTrigger;
  final String practiceAction;
  final String quality;
  const Concept({
    required this.sanskrit,
    required this.primaryEnglish,
    required this.humanExperience,
    required this.signals,
    required this.verseRefs,
    required this.keywords,
    required this.investigationQuestions,
    required this.interpretation,
    required this.practiceTitle,
    required this.practiceTrigger,
    required this.practiceAction,
    required this.quality,
  });
}

class PracticeOffer {
  final String title;
  final String trigger;
  final String action;
  final String quality;
  const PracticeOffer({
    required this.title,
    required this.trigger,
    required this.action,
    required this.quality,
  });
  Map<String, dynamic> toJson() =>
      {'title': title, 'trigger': trigger, 'action': action, 'quality': quality};
  factory PracticeOffer.fromJson(Map<String, dynamic> j) => PracticeOffer(
        title: j['title'] ?? 'Small practice',
        trigger: j['trigger'] ?? '',
        action: j['action'] ?? '',
        quality: j['quality'] ?? '',
      );
}

enum OfferState { pending, created, declined }

class ChatMessage {
  final String id;
  final bool fromUser;
  final String text;
  final List<String> verseRefs;
  final String? gitaConnection;
  final PracticeOffer? offer;
  final OfferState offerState;
  final bool safety;
  const ChatMessage({
    required this.id,
    required this.fromUser,
    required this.text,
    this.verseRefs = const [],
    this.gitaConnection,
    this.offer,
    this.offerState = OfferState.pending,
    this.safety = false,
  });

  ChatMessage withOfferState(OfferState s) => ChatMessage(
        id: id,
        fromUser: fromUser,
        text: text,
        verseRefs: verseRefs,
        gitaConnection: gitaConnection,
        offer: offer,
        offerState: s,
        safety: safety,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fromUser': fromUser,
        'text': text,
        'verseRefs': verseRefs,
        'gitaConnection': gitaConnection,
        'offer': offer?.toJson(),
        'offerState': offerState.name,
        'safety': safety,
      };
  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
        id: j['id'],
        fromUser: j['fromUser'],
        text: j['text'],
        verseRefs: List<String>.from(j['verseRefs'] ?? const []),
        gitaConnection: j['gitaConnection'],
        offer: j['offer'] == null ? null : PracticeOffer.fromJson(j['offer']),
        offerState: OfferState.values.byName(j['offerState'] ?? 'pending'),
        safety: j['safety'] ?? false,
      );
}

class Practice {
  final String id;
  final String title;
  final String trigger;
  final String action;
  final String quality;
  final String? reminder; // "HH:mm"
  final DateTime createdAt;
  final List<DateTime> completions;
  const Practice({
    required this.id,
    required this.title,
    required this.trigger,
    required this.action,
    required this.quality,
    required this.createdAt,
    this.reminder,
    this.completions = const [],
  });

  bool doneOn(DateTime d) => completions
      .any((c) => c.year == d.year && c.month == d.month && c.day == d.day);

  /// Days practiced in the last 7 days.
  int get last7 {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    return completions.where((c) => c.isAfter(cutoff)).length;
  }

  Practice copyWith({String? reminder, List<DateTime>? completions}) => Practice(
        id: id,
        title: title,
        trigger: trigger,
        action: action,
        quality: quality,
        createdAt: createdAt,
        reminder: reminder ?? this.reminder,
        completions: completions ?? this.completions,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'trigger': trigger,
        'action': action,
        'quality': quality,
        'reminder': reminder,
        'createdAt': createdAt.toIso8601String(),
        'completions': completions.map((e) => e.toIso8601String()).toList(),
      };
  factory Practice.fromJson(Map<String, dynamic> j) => Practice(
        id: j['id'],
        title: j['title'],
        trigger: j['trigger'],
        action: j['action'],
        quality: j['quality'] ?? '',
        reminder: j['reminder'],
        createdAt: DateTime.parse(j['createdAt']),
        completions: [
          for (final c in (j['completions'] as List? ?? const []))
            DateTime.parse(c)
        ],
      );
}

class Reflection {
  final String id;
  final DateTime createdAt;
  final String? practiceId;
  final Map<String, String> answers; // prompt -> answer
  const Reflection({
    required this.id,
    required this.createdAt,
    required this.answers,
    this.practiceId,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'practiceId': practiceId,
        'answers': answers,
      };
  factory Reflection.fromJson(Map<String, dynamic> j) => Reflection(
        id: j['id'],
        createdAt: DateTime.parse(j['createdAt']),
        practiceId: j['practiceId'],
        answers: Map<String, String>.from(j['answers']),
      );
}

String encodeList(List<Map<String, dynamic>> l) => jsonEncode(l);
List<Map<String, dynamic>> decodeList(String? s) => s == null
    ? []
    : (jsonDecode(s) as List).cast<Map<String, dynamic>>();
