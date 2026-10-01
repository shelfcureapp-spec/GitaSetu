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
      sanskrit: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन ।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि ॥',
      transliteration: 'karmaṇy evādhikāras te mā phaleṣu kadācana\nmā karma-phala-hetur bhūr mā te saṅgo \'stv akarmaṇi',
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
      sanskrit: 'ध्यायतो विषयान्पुंसः सङ्गस्तेषूपजायते ।\nसङ्गात्सञ्जायते कामः कामात्क्रोधोऽभिजायते ॥',
      transliteration: 'dhyāyato viṣayān puṃsaḥ saṅgas teṣūpajāyate\nsaṅgāt sañjāyate kāmaḥ kāmāt krodho \'bhijāyate',
      summary:
          'Dwelling on objects of the senses gives rise to attachment to them; from attachment '
          'desire arises; and from desire, anger.',
    ),
    '2.63': GitaVerse(
      ref: '2.63',
      sanskrit: 'क्रोधाद्भवति सम्मोहः सम्मोहात्स्मृतिविभ्रमः ।\nस्मृतिभ्रंशाद् बुद्धिनाशो बुद्धिनाशात्प्रणश्यति ॥',
      transliteration: 'krodhād bhavati sammohaḥ sammohāt smṛti-vibhramaḥ\nsmṛti-bhraṃśād buddhi-nāśo buddhi-nāśāt praṇaśyati',
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
      reflectionQuestion: 'What did you want in the moment just before the anger came?',
      practiceTitle: 'Pause before reacting',
      practiceTrigger: 'When I notice anger rising',
      practiceAction: 'Take one slow breath before responding.',
      practiceType: 'Pause practice',
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
      reflectionQuestion: 'What are you hoping this check will give you, and can you give it to yourself?',
      practiceTitle: 'Wait before checking',
      practiceTrigger: 'When I feel the urge to check',
      practiceAction: 'Wait 60 seconds, take a breath, and notice the urge before acting.',
      practiceType: 'Awareness + pause',
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
      reflectionQuestion: 'What image of yourself felt threatened just now?',
      practiceTitle: 'Name the wanting',
      practiceTrigger: 'When I feel hurt or compare myself to someone',
      practiceAction: 'Silently finish the sentence: "Right now I want…" and pause for one breath.',
      practiceType: 'Awareness practice',
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
      reflectionQuestion: 'What is the very next small action, regardless of how it turns out?',
      practiceTitle: 'Two minutes, no outcome',
      practiceTrigger: 'When I notice myself avoiding a task',
      practiceAction: 'Work on it for just two minutes, without judging how it turns out.',
      practiceType: 'Tiny action',
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
      reflectionQuestion: 'What part of this can you actually influence today?',
      practiceTitle: 'This too passes',
      practiceTrigger: 'When stress starts to build',
      practiceAction: 'Name it — "this is stress" — and take three slow breaths.',
      practiceType: 'Equanimity practice',
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
      reflectionQuestion: 'What would you say to a friend feeling exactly this?',
      practiceTitle: 'Be a friend to myself',
      practiceTrigger: 'When my inner voice turns harsh',
      practiceAction: 'Pause and say one kind, honest sentence to yourself.',
      practiceType: 'Reframe practice',
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

enum TopicScene { dawn, mist, forest, lake, bridge, dusk }

class Topic {
  final String name;
  final String tagline;
  final String blurb;
  final TopicScene scene;
  final String? conceptSanskrit; // null => coming soon
  final String application;
  final String reflection;
  final List<String> examples;
  const Topic(
    this.name,
    this.conceptSanskrit, {
    required this.tagline,
    this.blurb = '',
    this.scene = TopicScene.mist,
    this.application = '',
    this.reflection = '',
    this.examples = const [],
  });
  bool get available => conceptSanskrit != null;
}

const topics = <Topic>[
  Topic('Anger', 'Krodha',
      tagline: 'Transform reaction into clarity',
      blurb: 'Understand anger through the wisdom of the Gita and learn practical ways to respond differently.',
      scene: TopicScene.mist,
      application: 'Notice the wanting that sits before the anger, then create a small gap before you act.',
      reflection: 'What did I want just before I got angry?',
      examples: [
        'A colleague talks over you in a meeting and you feel heat rising. The wish to be heard came first; the anger followed.',
        'You snap at a family member who forgot something you asked. Underneath may be the expectation that your effort would be noticed.',
      ]),
  Topic('Desire', 'Krodha',
      tagline: 'Understand what you really seek',
      blurb: 'See how wanting grows, and what it is really promising you.',
      scene: TopicScene.dawn,
      application: 'Ask what a craving is really promising you — comfort, approval, certainty?',
      reflection: 'What am I wanting right now that I have not named?',
      examples: [
        'You keep opening a shopping app. The item matters less than the brief feeling of having something to look forward to.',
        'You want a promotion badly and notice it colouring every conversation at work.',
      ]),
  Topic('Attachment', 'Saṅga',
      tagline: 'Let go with wisdom',
      blurb: 'Notice what your peace has quietly become dependent on.',
      scene: TopicScene.lake,
      application: 'Notice what your peace has quietly become dependent on.',
      reflection: 'What am I holding too tightly?',
      examples: [
        'You check your phone repeatedly after sending an important message, waiting for reassurance.',
        'You cannot enjoy a good day because you are afraid of losing it.',
      ]),
  Topic('Ego', 'Ahaṅkāra',
      tagline: 'See beyond the self-image',
      blurb: 'Look at the image of yourself that feels threatened when you are hurt.',
      scene: TopicScene.dusk,
      application: 'When hurt, ask what image of yourself felt threatened.',
      reflection: 'Whose approval was I hoping for?',
      examples: [
        'Someone corrects you in front of others and the sting lasts all day.',
        'You rehearse replies to a comment that questioned your competence.',
      ]),
  Topic('Comparison', 'Ahaṅkāra',
      tagline: 'Return to your own path',
      blurb: 'Treat comparison as a signal to look at your own wanting.',
      scene: TopicScene.bridge,
      application: 'Treat comparison as a signal to look at your own wanting, not at their success.',
      reflection: 'What do I feel I lack when I compare?',
      examples: [
        'A friend announces good news and you feel a pang before the happiness arrives.',
        'Scrolling through other people\'s highlights leaves you feeling behind.',
      ]),
  Topic('Work', 'Karma-phala-āsakti',
      tagline: 'Act with focus and balance',
      blurb: 'Give full attention to the action; let the outcome be what it will be.',
      scene: TopicScene.forest,
      application: 'Give full attention to the next action; let the outcome be what it will be.',
      reflection: 'What is the next small action within my control?',
      examples: [
        'You put off a report because you fear it will not be good enough.',
        'You keep refreshing your inbox after submitting an important proposal.',
      ]),
  Topic('Discipline', 'Mana',
      tagline: 'Begin small, stay steady',
      blurb: 'Start small and be a friend to yourself while you build the habit.',
      scene: TopicScene.dawn,
      application: 'Start small and be a friend to yourself while you build the habit.',
      reflection: 'How am I treating myself as I try to change?',
      examples: [
        'You miss a day of a new routine and decide the whole effort has failed.',
        'Your inner voice calls you lazy every time you hesitate.',
      ]),
  Topic('Stress', 'Sukha-duḥkha',
      tagline: 'Find calm in a busy mind',
      blurb: 'Name the stress, breathe, and separate what is within reach from what is not.',
      scene: TopicScene.mist,
      application: 'Name the stress, breathe, and separate what is within reach from what is not.',
      reflection: 'What can I actually do about this today?',
      examples: [
        'A week of deadlines leaves your chest tight and your thoughts racing.',
        'A difficult family situation sits in the back of your mind all day.',
      ]),
  Topic('Equanimity', 'Sukha-duḥkha',
      tagline: 'Stay steady in joy and loss',
      blurb: 'Practise meeting both good and bad news with the same steady breath.',
      scene: TopicScene.lake,
      application: 'Practise meeting both good and bad news with the same steady breath.',
      reflection: 'Where did I lose my balance today?',
      examples: [
        'A great review makes you elated; a small criticism the next day flattens you.',
        'You notice your mood rising and falling with every notification.',
      ]),
  Topic('Fear', null, tagline: 'Build inner confidence', scene: TopicScene.dusk),
  Topic('Relationships', null, tagline: 'Create harmony with understanding', scene: TopicScene.bridge),
  Topic('Detachment', null, tagline: 'Act without clinging', scene: TopicScene.lake),
  Topic('Sattva', null, tagline: 'Clarity and serenity', scene: TopicScene.dawn),
  Topic('Rajas', null, tagline: 'Restless activity and craving', scene: TopicScene.dusk),
  Topic('Tamas', null, tagline: 'Inertia and negligence', scene: TopicScene.mist),
  Topic('Dharma', null, tagline: 'Duty and right action', scene: TopicScene.forest),
  Topic('Bhakti', null, tagline: 'Devotion and trust', scene: TopicScene.dawn),
];

class Chapter {
  final int number;
  final String focus;
  const Chapter(this.number, this.focus);
}

/// Product focus per chapter (PRD §17).
const chapters = <Chapter>[
  Chapter(1, 'Crisis, confusion, human struggle'),
  Chapter(2, 'Self, equanimity, attachment, desire'),
  Chapter(3, 'Action, motivation, senses'),
  Chapter(4, 'Knowledge, action, wisdom'),
  Chapter(5, 'Renunciation and action'),
  Chapter(6, 'Mind, meditation, self-mastery'),
  Chapter(7, 'Knowledge and divine reality'),
  Chapter(8, 'Ultimate reality and remembrance'),
  Chapter(9, 'Devotion and relationship with the Divine'),
  Chapter(10, 'Divine manifestations'),
  Chapter(11, 'Universal form'),
  Chapter(12, 'Bhakti and qualities of a devotee'),
  Chapter(13, 'Field, knower, Prakṛti/Puruṣa'),
  Chapter(14, 'Sattva, Rajas, Tamas'),
  Chapter(15, 'Purushottama and transcendence'),
  Chapter(16, 'Daivī and Āsurī qualities'),
  Chapter(17, 'Faith, food, speech, discipline, charity'),
  Chapter(18, 'Knowledge, action, doer, intellect, determination, happiness, renunciation'),
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

const dailyInsights = ['2.47', '2.62', '2.14', '6.5', '2.48', '3.37', '2.63'];
