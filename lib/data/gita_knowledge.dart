import '../models/models.dart';

/// Curated Gita knowledge layer (PRD §11, §47). Gemini may only cite verses
/// that exist here. Summaries are paraphrases; Sanskrit/transliteration and
/// authoritative translations must be ingested from the curated source
/// (IIT Kanpur Gita Supersite) before release.
class GitaKnowledge {
  static const verses = <String, GitaVerse>{
    '2.14': GitaVerse(
      ref: '2.14',
      summary:
          'Contacts of the senses with their objects bring cold and heat, pleasure and pain. '
          'They come and go and are impermanent — learn to bear them.',
    ),
    '2.47': GitaVerse(
      ref: '2.47',
      summary:
          'You have a right to action alone, never to its fruits. Do not let the fruit of action '
          'be your motive, and do not become attached to inaction.',
    ),
    '2.48': GitaVerse(
      ref: '2.48',
      summary:
          'Act steadily, letting go of attachment, remaining even-minded in success and failure. '
          'Such evenness of mind is called yoga.',
    ),
    '2.62': GitaVerse(
      ref: '2.62',
      summary:
          'Dwelling on objects of the senses gives rise to attachment to them; from attachment '
          'desire arises; and from desire, anger.',
    ),
    '2.63': GitaVerse(
      ref: '2.63',
      summary:
          'From anger comes delusion; from delusion, confusion of memory; from that, loss of '
          'discrimination; and with loss of discrimination, one is ruined.',
    ),
    '3.37': GitaVerse(
      ref: '3.37',
      summary:
          'It is desire and anger, born of rajas, that are all-consuming and a great obstacle. '
          'Know this as the enemy here.',
    ),
    '6.5': GitaVerse(
      ref: '6.5',
      summary:
          'Lift yourself by your own self; do not let yourself sink. The self is its own friend, '
          'and also its own enemy.',
    ),
  };

  static const concepts = <Concept>[
    Concept(
      sanskrit: 'Krodha',
      primaryEnglish: 'Anger',
      humanExperience: ['anger', 'irritation', 'resentment', 'frustration', 'rage'],
      signals: ['tension', 'raised voice', 'blame', 'urge to retaliate'],
      verseRefs: ['2.62', '2.63'],
      keywords: ['angry', 'anger', 'furious', 'irritat', 'rage', 'mad at', 'resent', 'frustrat', 'snapp', 'yell', 'shout', 'annoy'],
      investigationQuestions: [
        'What usually happens in the moment just before the anger rises?',
        'In that moment, what did you want — or feel you needed — from the other person or situation?',
      ],
      interpretation:
          'The Gita describes anger as one step in a chain: dwelling, attachment, desire, anger. '
          'If anger arrives when something you wanted is blocked, the useful place to look is '
          'earlier in the chain — at the wanting — rather than only at the anger itself.',
      practiceTitle: 'Pause before reacting',
      practiceTrigger: 'When I notice anger rising',
      practiceAction: 'Take one slow breath before responding.',
      quality: 'Self-control',
    ),
    Concept(
      sanskrit: 'Saṅga',
      primaryEnglish: 'Attachment',
      humanExperience: ['clinging', 'needing reassurance', 'can\'t let go', 'checking'],
      signals: ['repeatedly checking', 'restlessness while waiting', 'rehearsing conversations'],
      verseRefs: ['2.62'],
      keywords: ['checking', 'waiting for', 'reply', 'text back', 'cling', 'attach', "can't stop", 'cannot stop', 'obsess', 'let go', 'miss them', 'reassur'],
      investigationQuestions: [
        'What are you hoping that moment — the reply, the message, the result — will give you?',
        'If it did not come, what would that mean to you?',
      ],
      interpretation:
          'The behaviour may not only be about the thing you are checking. There may be an '
          'attachment to the reassurance it would bring. The Gita notes how repeated dwelling '
          'deepens attachment, and attachment feeds desire.',
      practiceTitle: 'Wait before checking',
      practiceTrigger: 'When I feel the urge to check',
      practiceAction: 'Wait 60 seconds, take a breath, and notice the urge before acting.',
      quality: 'Detachment',
    ),
    Concept(
      sanskrit: 'Ahaṅkāra',
      primaryEnglish: 'Ego / identification',
      humanExperience: ['hurt pride', 'comparison', 'jealousy', 'needing recognition'],
      signals: ['wanting to prove oneself', 'measuring against others', 'feeling disrespected'],
      verseRefs: ['3.37', '2.62'],
      keywords: ['respect', 'recogni', 'jealous', 'envy', 'compar', 'insult', 'ignored', 'disrespect', 'proud', 'status', 'criticiz', 'criticis', 'successful than'],
      investigationQuestions: [
        'What did you feel was being taken from you or denied to you in that moment?',
        'Whose opinion or approval were you hoping to receive?',
      ],
      interpretation:
          'Hurt and comparison often point to something we are identifying with — an image, a '
          'role, a standing. This may involve a desire to be recognised. Seeing that desire '
          'clearly is the first step in loosening its grip.',
      practiceTitle: 'Name the wanting',
      practiceTrigger: 'When I feel hurt or compare myself to someone',
      practiceAction: 'Silently finish the sentence: "Right now I want…" and pause for one breath.',
      quality: 'Equanimity',
    ),
    Concept(
      sanskrit: 'Karma-phala-āsakti',
      primaryEnglish: 'Attachment to results',
      humanExperience: ['result anxiety', 'procrastination', 'fear of failure', 'overthinking outcomes'],
      signals: ['avoiding starting', 'worrying about outcome', 'restless after finishing work'],
      verseRefs: ['2.47', '2.48'],
      keywords: ['procrastinat', 'outcome', 'result', 'fail', 'anxious', 'anxiety', 'worry', 'worried', 'deadline', 'exam', 'perfect', 'putting off', 'avoid starting', 'pass'],
      investigationQuestions: [
        'When you think of starting, what are you most concerned will happen?',
        'What outcome are you hoping for — and what would it mean if it did not happen?',
      ],
      interpretation:
          'The Gita separates the action, which is in your hands, from the fruit, which is not '
          'entirely. When peace depends on the result, starting can feel risky. Bringing '
          'attention back to the next small action can loosen that.',
      practiceTitle: 'Two minutes, no outcome',
      practiceTrigger: 'When I notice myself avoiding a task',
      practiceAction: 'Work on it for just two minutes, without judging how it turns out.',
      quality: 'Discipline',
    ),
    Concept(
      sanskrit: 'Sukha-duḥkha',
      primaryEnglish: 'Pleasure, pain and equanimity',
      humanExperience: ['stress', 'overwhelm', 'hardship', 'discomfort'],
      signals: ['tight chest', 'racing thoughts', 'wanting it to stop'],
      verseRefs: ['2.14', '2.48'],
      keywords: ['stress', 'overwhelm', 'pressure', 'hard time', 'difficult', 'pain', 'cope', 'burnout', 'exhaust'],
      investigationQuestions: [
        'What part of this feels hardest to bear right now?',
        'What are you hoping will change, and how much of that is within your reach today?',
      ],
      interpretation:
          'The Gita points out that pleasant and painful experiences come and go. That does not '
          'make them unreal, but it can help to meet them with steadiness rather than resistance.',
      practiceTitle: 'This too passes',
      practiceTrigger: 'When stress starts to build',
      practiceAction: 'Name it — "this is stress" — and take three slow breaths.',
      quality: 'Equanimity',
    ),
    Concept(
      sanskrit: 'Mana',
      primaryEnglish: 'The restless mind',
      humanExperience: ['restlessness', 'self-doubt', 'lack of direction', 'self-criticism'],
      signals: ['scattered attention', 'harsh inner voice', 'indecision'],
      verseRefs: ['6.5'],
      keywords: ['restless', "can't focus", 'cannot focus', 'distract', 'lost', 'direction', 'purpose', 'doing with my life', 'hate myself', 'useless', 'discipline'],
      investigationQuestions: [
        'When did this feeling last ease, even slightly? What was different?',
        'If you treated yourself as a friend would, what would you do next?',
      ],
      interpretation:
          'The Gita describes the self as capable of being its own friend or its own obstacle. '
          'That is an invitation to notice how you are treating yourself right now.',
      practiceTitle: 'Be a friend to myself',
      practiceTrigger: 'When my inner voice turns harsh',
      practiceAction: 'Pause and say one kind, honest sentence to yourself.',
      quality: 'Clarity',
    ),
  ];

  static Concept? byKeyword(String text) {
    final t = text.toLowerCase();
    Concept? best;
    var bestScore = 0;
    for (final c in concepts) {
      final s = c.keywords.where(t.contains).length;
      if (s > bestScore) {
        best = c;
        bestScore = s;
      }
    }
    return best;
  }

  static Concept bySanskrit(String name) =>
      concepts.firstWhere((c) => c.sanskrit == name, orElse: () => concepts.first);
}

class Topic {
  final String name;
  final String? conceptSanskrit; // null => coming soon
  final String application;
  final String reflection;
  const Topic(this.name, this.conceptSanskrit, {this.application = '', this.reflection = ''});
}

const topics = <Topic>[
  Topic('Anger', 'Krodha',
      application: 'Notice the wanting that sits before the anger, then create a small gap before you act.',
      reflection: 'What did I want just before I got angry?'),
  Topic('Desire', 'Krodha',
      application: 'Ask what a craving is really promising you — comfort, approval, certainty?',
      reflection: 'What am I wanting right now that I have not named?'),
  Topic('Attachment', 'Saṅga',
      application: 'Notice what your peace has quietly become dependent on.',
      reflection: 'What am I holding too tightly?'),
  Topic('Ego', 'Ahaṅkāra',
      application: 'When hurt, ask what image of yourself felt threatened.',
      reflection: 'Whose approval was I hoping for?'),
  Topic('Comparison', 'Ahaṅkāra',
      application: 'Treat comparison as a signal to look at your own wanting, not at their success.',
      reflection: 'What do I feel I lack when I compare?'),
  Topic('Work', 'Karma-phala-āsakti',
      application: 'Give full attention to the next action; let the outcome be what it will be.',
      reflection: 'What is the next small action within my control?'),
  Topic('Discipline', 'Mana',
      application: 'Start small and be a friend to yourself while you build the habit.',
      reflection: 'How am I treating myself as I try to change?'),
  Topic('Stress', 'Sukha-duḥkha',
      application: 'Name the stress, breathe, and separate what is within reach from what is not.',
      reflection: 'What can I actually do about this today?'),
  Topic('Equanimity', 'Sukha-duḥkha',
      application: 'Practise meeting both good and bad news with the same steady breath.',
      reflection: 'Where did I lose my balance today?'),
  Topic('Fear', null),
  Topic('Relationships', null),
  Topic('Detachment', null),
  Topic('Sattva', null),
  Topic('Rajas', null),
  Topic('Tamas', null),
  Topic('Dharma', null),
  Topic('Bhakti', null),
];

const dailyReflections = [
  'What are you currently holding too tightly?',
  'What did you want today that you did not get?',
  'Where did you act without noticing why?',
  'What would it feel like to act without needing a specific result?',
  'What is one thing you can let be, just for today?',
  'When did you last pause before reacting?',
  'What quality would you like to practise this week?',
];

const dailyInsights = ['2.62', '2.47', '2.14', '6.5', '2.48', '3.37', '2.63'];
