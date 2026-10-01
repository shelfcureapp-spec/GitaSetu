# GitaSetu — Product Requirements Document

- **Product:** GitaSetu
- **Type:** Mobile application
- **Platform:** Android first; iOS later
- **Primary language:** English
- **AI:** Google Gemini
- **AI audio:** Google Gemini TTS (Gemini 3.8 Flash TTS / Gemini 3.8 Flash-Lite TTS)
- **Core source:** Bhagavad Gita
- **Behavioral framework:** Modern habit-building principles
- **Primary audience:** People interested in self-reflection, personal growth, spirituality, and practical application of the Bhagavad Gita

> **Audio model note:** earlier drafts used older TTS model names. This PRD uses the current lineup, Gemini 3.8 Flash TTS and Gemini 3.8 Flash-Lite TTS (reported GA in the September 2026 release notes). Confirm exact model IDs against Google's current docs before implementation.

---

## 1. Product Vision

GitaSetu is a mobile companion that connects the wisdom of the Bhagavad Gita with everyday human situations.

It helps a user move from:

1. "Why did I react like this?"
2. "What was happening inside me?"
3. "What does the Gita teach about this?"
4. "What can I practice differently next time?"

It is not simply a Gita reader, an AI chatbot, a meditation app, a habit tracker, or a quote app. It combines these into one coherent experience.

**Core loop:** Notice → Name → Understand → Pause → Choose → Practice → Reflect

## 2. Product Philosophy

GitaSetu preserves the distinction between:

| Layer | Role |
|---|---|
| **Ancient source** — Bhagavad Gita | The philosophical and spiritual source |
| **AI interpretation** — Gemini | Understands the user's situation, asks questions, explains retrieved teachings, personalizes communication |
| **Behavioral mechanism** — habit/practice system | Turns understanding into repeated action |

The AI must never present its own generated philosophy as a direct teaching of Krishna or the Bhagavad Gita.

## 3. Core Product Principle

Don't tell users what they are. Help them investigate what is happening.

- Bad: "You are a Rajasik person."
- Better: "Your recent responses may resemble a Rajas-associated pattern: strong desire for an outcome followed by restlessness when the outcome is uncertain."
- Bad: "You are an angry person."
- Better: "Anger seems to have arisen in this situation. Let's look at what you wanted and what you felt was being threatened."

## 4. Target Users

**Primary:** adults who are interested in the Gita, want practical self-improvement, struggle with emotions/reactions/attachment/comparison/procrastination/anger, want guidance without studying the entire Gita, and prefer guided reflection over passive reading.

**Secondary:** users who already read the Gita and want to apply it, want a daily spiritual practice, want guided audio reflection, or want a structured way to develop patience, discipline, equanimity and self-control.

## 5. Main User Problem

People understand a spiritual principle intellectually but struggle to apply it in real situations. "I know I shouldn't get angry" — but when criticized: trigger → thought → desire → attachment → anger → impulse → reaction.

The missing bridge is **Wisdom → Awareness → Practice → Repetition**. GitaSetu is that bridge.

## 6. Positioning

- **One line:** GitaSetu turns the wisdom of the Bhagavad Gita into practical daily reflection and practice.
- **Tagline:** From wisdom to practice.
- **Alternative:** Understand yourself through the Gita.

## 7. Core Experience

The primary experience is conversational. Example: *"I keep getting angry at my wife."* GitaSetu does not immediately recommend a habit.

1. **Understand** — "What usually happens immediately before the anger?"  
   User: "She doesn't listen when I ask her something."
2. **Investigate** — "When she doesn't listen, what do you feel you needed from her in that moment?"  
   User: "I wanted her to take me seriously."
3. **Identify the pattern** — expectation, attachment, desire, anger, identification, reaction.
4. **Retrieve Gita teaching** — relevant concepts/verses from the curated knowledge engine, e.g. Gita 2.62–2.63 (dwelling on objects → attachment → desire → anger → delusion → loss of memory → loss of discrimination → downfall). Source: IIT Kanpur Gita Supersite.
5. **Explain** — Gemini translates the teaching into modern English.
6. **Practice** — "Next time you notice anger rising, try taking one deliberate breath before responding."
7. **Confirmation** — "Create this practice?" `[Create Practice]` `[Not now]`
8. **Reminder** — only after confirmation: "When would you like to practice this?"

## 8. Core Product Loop

```
USER EXPERIENCES EVENT → NOTICE → DESCRIBE SITUATION → GEMINI INVESTIGATES
→ INNER STATE IDENTIFICATION → GITA KNOWLEDGE RETRIEVAL → GITA TEACHING
→ MODERN EXPLANATION → REFLECTION → TINY PRACTICE → USER CONFIRMATION
→ HABIT / PRACTICE CREATED → REMINDER → PRACTICE → REFLECTION
→ PATTERN HISTORY → FUTURE GEMINI CONTEXT
```

## 9. The Inner Reaction Model

```
EVENT → PERCEPTION → THOUGHT → DESIRE → ATTACHMENT / AVERSION
→ INNER STATE / EMOTION → IMPULSE → ACTION → CONSEQUENCE
→ REFLECTION → LEARNING → NEW PRACTICE
```

This prevents reducing everything to "You felt angry." Instead it asks: what happened before the anger?

## 10. Inner State Model

The system distinguishes:

- **Emotion** — anger, fear, sadness, frustration, envy
- **Desire** — what the person wants (recognition, control, approval, comfort, success, certainty)
- **Attachment** — what the person's peace has become dependent upon
- **Aversion** — what the person strongly wants to avoid
- **Impulse** — what they feel compelled to do
- **Action** — what they actually do

## 11. Gita Knowledge Engine

The source-of-truth layer. Gemini must not independently invent Gita teachings.

```
GITA SOURCE → CURATED KNOWLEDGE → RETRIEVAL → GEMINI → USER RESPONSE
```

The initial textual foundation uses authoritative/curated sources such as IIT Kanpur's Gita Supersite.

## 12. Knowledge Classification

Every piece of knowledge carries a source classification:

| Class | Meaning |
|---|---|
| `DIRECT` | Explicitly stated by the Gita |
| `DERIVED` | Textual inference; reasonable relationship derived from multiple verses |
| `COMMENTARIAL` | Interpretation from a recognized commentary/tradition |
| `MODERN_APPLICATION` | Contemporary practical interpretation |
| `AI_GENERATED` | Generated wording only |

AI-generated content must never become the source of truth.

## 13. Initial Gita Concept Engine

First module: **Inner Reaction Engine**. Concepts: Dhyāna, Saṅga, Kāma, Krodha, Sammoha, Smṛti-vibhrama, Buddhi-nāśa, Praṇaśyati, Rāga, Dveṣa, Lobha, Ahaṅkāra.

Primary causal chain (Gita 2.62–2.63):

**Dhyāna → Saṅga → Kāma → Krodha → Sammoha → Smṛti-vibhrama → Buddhi-nāśa → Praṇaśyati**

Other relationships: Kāma → Krodha; kāma/krodha and rajas; the kāma–krodha–lobha grouping in Chapter 16.

## 14. Three-Level Concept Mapping

Every important concept has three layers:

- **A — Sanskrit concept:** e.g. Krodha
- **B — Human experience:** anger, irritation, resentment, frustration, rage
- **C — Observable signals:** tension, raised voice, blame, urge to retaliate, hostile thoughts, desire to prove oneself

This lets Gemini understand natural language while staying grounded in the source concept.

## 15. Guṇa Engine

Eventually models:

- **Sattva** — clarity, knowledge, purity, serenity
- **Rajas** — passion, craving, restless activity, attachment to results
- **Tamas** — dullness, negligence, delusion, inactivity

The system must not classify people simplistically. "You woke up late, therefore you are Tamasic" is unacceptable. Instead: "This particular behavior may resemble a Tamas-associated pattern of inertia or negligence." Guṇa framework is drawn primarily from Chapters 14, 17 and 18.

## 16. Guṇa Progression

```
REDUCE DESTRUCTIVE TAMAS → REGULATE / TRANSFORM RAJAS → CULTIVATE SATTVA
→ REDUCE IDENTIFICATION WITH ALL THREE → GUṆĀTĪTA
```

Presented as a philosophical progression, not a scoring system.

## 17. 18-Chapter Knowledge Roadmap

| Chapter | Product focus |
|---|---|
| 1 | Crisis, confusion, human struggle |
| 2 | Self, equanimity, attachment, desire |
| 3 | Action, motivation, senses |
| 4 | Knowledge, action, wisdom |
| 5 | Renunciation and action |
| 6 | Mind, meditation, self-mastery |
| 7 | Knowledge and divine reality |
| 8 | Ultimate reality and remembrance |
| 9 | Devotion and relationship with the Divine |
| 10 | Divine manifestations |
| 11 | Universal form |
| 12 | Bhakti and qualities of a devotee |
| 13 | Field, knower, Prakṛti/Puruṣa |
| 14 | Sattva, Rajas, Tamas |
| 15 | Purushottama and transcendence |
| 16 | Daivī and Āsurī qualities |
| 17 | Faith, food, speech, discipline, charity |
| 18 | Knowledge, action, doer, intellect, determination, happiness, renunciation |

## 18. AI Personality

Calm, thoughtful, respectful, compassionate, intelligent, non-judgmental, grounded, concise, reflective.

Not: robotic, preachy, overly mystical, overly motivational, a therapist impersonation, or Krishna literally speaking through AI.

Prefer "Based on the Gita's teaching…" over "Krishna says to you…", unless directly presenting a properly sourced verse.

## 19. Gemini's Role

- **Understanding:** user intent, situation, emotional language, context
- **Investigation:** follow-up questions; identify desire, attachment, aversion, possible Guṇa patterns
- **Retrieval orchestration:** query the Gita knowledge engine; select relevant concepts and verses
- **Explanation:** explain teachings, give modern examples, connect to the user's situation
- **Practice generation:** suggest one practical intervention
- **Reflection:** ask follow-ups; analyze the user's experience over time

Gemini is not the authoritative source for Gita doctrine.

## 20. Gemini Structured Output

```json
{
  "situation": "User became angry after feeling ignored",
  "possible_inner_states": ["attachment", "desire", "anger"],
  "confidence": "medium",
  "possible_desire": "to be taken seriously",
  "possible_attachment": "expectation of being listened to",
  "relevant_gita_verses": ["2.62", "2.63", "3.37"],
  "guna_pattern": "rajas-associated",
  "interpretation": "...",
  "reflection_question": "...",
  "recommended_intervention_type": "pause",
  "habit_candidate": "...",
  "requires_confirmation": true
}
```

## 21. Confidence System

Gemini never pretends certainty about someone's inner state.

- **HIGH** — strong evidence from the user's own description
- **MEDIUM** — plausible interpretation, needs confirmation
- **LOW** — possible interpretation requiring exploration

"This may involve attachment to being recognized." — not "You are attached to recognition."

## 22. Intervention Engine

Not every situation needs a habit. Types: Awareness, Pause, Reframe, Replacement, Deliberate Practice, Reflection, Habit.

- Anger → **Pause**: "Take one breath before responding."
- Result attachment → **Awareness + pause**: "After finishing important work, notice the urge to repeatedly check the outcome."
- Procrastination → **Tiny action**: "Work on the task for two minutes."

## 23. Habit Engine

```
GITA PRINCIPLE → INNER STATE → TRIGGER → DESIRED QUALITY → TINY ACTION → REPETITION → REFLECTION
```

Habit sizes: **FULL** (normal), **TINY** (minimum viable action), **RECOVERY** (what to do after missing the practice).

Modern habit-building principles are the behavioral mechanism and are presented as such, not as Gita teachings.

## 24. Habit Confirmation (mandatory)

Gemini: "I have one small practice for you." → "When you notice anger rising, take one slow breath before replying. Create this practice?" Buttons: **Create Practice** / **Not Now**.

Only after Create Practice may the app save it, schedule it, create a reminder, and add it to the practice list. The AI must never silently create habits.

## 25. Audio System

English-only in V1, using Gemini TTS (controllable style, accent, pace and tone; test in Google AI Studio). Models: Gemini 3.8 Flash TTS and Gemini 3.8 Flash-Lite TTS. Voice selection and custom voice design are available via Google's Voices API.

| Category | Length |
|---|---|
| A. Gita Explanation | 30–90 s |
| B. Guided Reflection | 30–90 s |
| C. Daily Practice | 15–30 s |
| D. Evening Reflection | 30–60 s |
| E. Habit Guidance | 10–30 s |

## 26. GitaSetu Voice

English, Indian/neutral accent, mature, calm, warm, trustworthy, natural, moderate pace, subtle pauses, emotionally grounded; not theatrical, not "guru-like". The user should feel "Someone is calmly helping me reflect," not "A robot is reading a paragraph."

## 27. Audio Architecture

```
USER → GEMINI → GITA KNOWLEDGE ENGINE → RESPONSE SCRIPT
→ AUDIO DIRECTOR PROMPT → GEMINI TTS → AUDIO FILE → STORAGE → MOBILE AUDIO PLAYER
```

Longer audio is generated in manageable segments, since TTS quality/consistency can drift over long outputs.

## 28. Audio UI

Every appropriate AI explanation has a **▶ Listen** control. Player shows title, scrubber, elapsed/total time. Controls: play/pause, 0.75×, 1×, 1.25×, 1.5×, replay.

## 29. Navigation

Bottom nav: **Home | Explore | Practice | Reflect | Profile**

## 30. Home

Modern and calm, not a traditional religious app. Greeting ("Good morning — take a moment before you begin"), today's reflection with Listen, today's Gita insight (verse reference + short explanation), today's practice, and progress ("2 of 3 practices completed").

## 31. Explore

Topics: Anger, Desire, Attachment, Fear, Discipline, Relationships, Work, Stress, Comparison, Ego, Detachment, Equanimity, Sattva, Rajas, Tamas, Dharma, Bhakti.

## 32. Gita Study

Topic → relevant verses → original verse → English translation → key concepts → explanation → modern application → reflection.

Clearly separate **Gita says** / **GitaSetu interpretation** / **Practical application**.

## 33. Practice

Shows active practices, e.g. *Pause Before Reacting* — Trigger: "When I notice anger rising." Practice: "Take one breath before responding." Progress: 4/7 days. Buttons: **Done**, **Skip**, **Reflect**.

## 34. Reflection

One of the most important screens. Prompts: What happened? What did you feel? What did you want? What were you afraid of losing? What did you do? What happened afterward? What would you like to practice next time? The system gradually builds a pattern history.

## 35. Pattern History

Shows "Patterns you've noticed" (e.g. Recognition ×6, Result anxiety ×4, Anger after unmet expectations ×3) — never "Your personality," and no simplistic psychological diagnosis.

## 36. Personal Growth Model

No "Sattva Score: 82". Show **qualities you're practicing** (Patience, Equanimity, Self-control, Discipline, Compassion, Detachment, Clarity) and counts such as "Practiced 8 times this month". This measures behavior, not spiritual worth.

## 37. Daily Experience

- **Morning (1–3 min):** Gita insight, audio, reflection, today's practice
- **During the day:** Pause & Reflect — user enters "I got really angry" and Gemini investigates
- **Evening (2 min):** What happened? What did you notice? Did you practice? What did you learn?

## 38. "Talk to GitaSetu"

The central AI screen. Users type naturally ("I'm jealous of my friend's success", "I keep procrastinating", "I can't stop checking whether someone replied"). Gemini investigates rather than giving generic advice.

## 39. AI Conversation Rules

**Do:** ask relevant questions, use the user's language, stay grounded, cite relevant verses, distinguish source from interpretation, offer one practical step, ask for confirmation, remember patterns when appropriate.

**Don't:** diagnose, shame, moralize, pretend to be Krishna, invent verses, invent Sanskrit meanings, make absolute claims about the user, create habits without permission.

## 40. Safety

GitaSetu is a self-reflection and spiritual practice app, not a medical or mental-health diagnostic service. For serious situations it must not imply a Gita explanation substitutes for professional help — e.g. "This sounds difficult. GitaSetu can help you reflect on the situation, but it isn't a replacement for professional support." Exact safety handling is specified separately.

## 41. User Account (V1)

Email/password, Google login, basic profile, preferences, notification settings, audio preferences, practice history, reflection history.

## 42. User Data

User → Profile, Conversations, Reflections, Practices, Practice Completions, Patterns, Gita Topics, Preferences.

## 43. Suggested Data Model

- **User:** id, name, email, created_at, preferences
- **GitaVerse:** id, chapter, verse, sanskrit, transliteration, translation, source
- **Concept:** id, name_sanskrit, transliteration, primary_english, category, definition, direct_verses[], related_concepts[], guna_relationship, source_type, confidence
- **Teaching:** id, verse_id, principle, explanation, source_type
- **InnerState:** id, name, sanskrit_term, category, description, signals[], triggers[], related_states[]
- **Practice:** id, user_id, principle_id, title, trigger, action, frequency, status, created_at
- **Reflection:** id, user_id, practice_id, state_before, state_after, difficulty, observation, learning, created_at
- **Pattern:** id, user_id, trigger, thought, desire, attachment, emotion, impulse, action, consequence
- **Audio:** id, content_id, script, voice_id, model, duration, audio_url, created_at

## 44. Technical Architecture

```
MOBILE APP → API / BACKEND → { GEMINI | GITA ENGINE | USER DATA }
→ RESPONSE ENGINE → { TEXT RESPONSE | AUDIO SCRIPT → GEMINI TTS → AUDIO STORAGE }
```

## 45. Recommended Stack

| Layer | Choice |
|---|---|
| Mobile | Flutter |
| Backend | Supabase (auth, Postgres, storage, scheduled jobs) |
| AI | Gemini API |
| Audio | Gemini TTS |
| Retrieval | Supabase/Postgres + vector search (pgvector) |
| Storage | Supabase Storage |

## 46. RAG Architecture

Verse → concepts (Saṅga, Kāma, Dhyāna) → related teaching → modern examples → reflection questions → practices. Gemini retrieves relevant context before responding.

## 47. Retrieval Priority

1. Direct Gita verses
2. Curated concepts
3. Curated interpretations
4. Modern applications
5. Gemini-generated wording

This prevents hallucinated scripture.

## 48. Gita Citation UI

Whenever the AI uses a specific verse, show "Bhagavad Gita 2.62" with a **Read verse** action opening the full verse context.

## 49. AI Response Example

> User: "I keep checking my phone waiting for someone's reply."
> GitaSetu: "Let's look underneath the habit for a moment. What are you hoping that reply will give you?"
> User: "I want to know they care."
> GitaSetu: "That suggests the phone checking may not be only about the message. There may also be an attachment to receiving reassurance."
> **Gita connection:** Gita 2.62 describes how repeated dwelling can lead to attachment and desire.
> **Practice:** "When you notice the urge to check, wait for 60 seconds before opening the message." — Create this practice? `[Create Practice]`

## 50. Notifications

Gentle, not addictive: "A small practice is waiting." / "Take one quiet minute with today's Gita reflection." / "Notice before you react." Avoid streak-anxiety copy like "🔥 Don't break your streak!".

## 51. Gamification

Minimal. Avoid leaderboards, competitive spirituality, aggressive streaks, "Sattva points", spiritual levels, ranking. Allowed: practice consistency, reflection count, qualities practiced, personal milestones.

## 52. Monetization

Not needed for V1. Possible later: Free (core knowledge, limited AI conversations/audio) vs Premium (unlimited AI reflection, advanced patterns, guided audio library, deeper courses, advanced practice plans) — only after product validation.

## 53. V1 Scope (must have)

Onboarding, home, Gita knowledge base, AI conversation, inner-state investigation, verse retrieval, Gita explanation, reflection questions, tiny practice recommendation, confirmation before creating a practice, practice tracking, reminders, English AI audio, basic reflection history, profile/settings.

## 54. V1 Must Not Include

Social network, community, leaderboards, multi-language, voice conversation, Sanskrit audio, complex spiritual scoring, advanced gamification, dozens of voice options, marketplace, guru marketplace, live teachers, complicated courses.

## 55. Phase 2

- **Knowledge:** complete 18-chapter mapping, deeper commentarial context, advanced topic navigation
- **AI:** long-term pattern recognition, personalized practice programs, deeper conversation memory
- **Audio:** personalized guided sessions, longer guided reflections, curated audio journeys
- **Practice:** multi-week programs, quality-focused plans, adaptive habits

## 56. Phase 3

Voice conversations, multilingual support, Sanskrit verse audio, advanced Gita study, teacher/mentor mode, family practice, curated courses, offline Gita library.

## 57. Success Metrics

Activation (first reflection), AI engagement (first Gita-guided conversation), practice conversion (accepted recommended practice), practice completion, reflection retention, audio engagement, long-term (meaningful practice after 7/30 days).

Eventual north star: **users who repeatedly convert insight into real-world practice.**

## 58. Product Success Definition

A user can say: "Something happened." → "I understood what was happening inside me." → "I understood how the Gita relates to it." → "I tried one small practice." → "I noticed what happened next time."

## 59. Most Important UX Principle

Don't overwhelm the user with scripture. For "I'm angry", don't give 8 verses, 4 Sanskrit concepts, 3 Guṇas and 12 paragraphs. Give: **Understand** (one question) → **Gita** (one relevant teaching) → **Practice** (one tiny action) → **Reflect** (one question). Depth is available, not forced.

## 60. Product Identity

Ancient wisdom × modern psychology-inspired behavior design × AI personalization × guided audio. Hierarchy: **Gita → Understanding → Practice**, not AI → Gita quotes.

## 61. Final Product Architecture

GitaSetu = Gita Knowledge + Gemini AI + Practice Engine, joined by the Inner Reaction Engine (Notice / Understand / Reflect) → Practice → Habit → Audio → Daily life.

The core loop remains **Notice → Name → Understand → Pause → Choose → Practice → Reflect** — the heart of GitaSetu, rather than a chatbot or a Gita reader.
