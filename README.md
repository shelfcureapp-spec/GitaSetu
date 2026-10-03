# GitaSetu

*From wisdom to practice.* A mobile companion that connects the Bhagavad Gita with everyday situations and turns understanding into small, repeatable practice.

- Product requirements: [docs/PRD.md](docs/PRD.md)
- Planned stack: Flutter, Supabase (Postgres + pgvector), Gemini API, Gemini TTS

## Running

```bash
flutter pub get
flutter run                                   # offline guided mode
flutter run --dart-define=GEMINI_API_KEY=...  # Gemini mode
# optional: --dart-define=GEMINI_MODEL=<model id>
flutter test
```

## Status (V1 in progress)

Built (UI follows the design reference): splash and onboarding, Home, Explore (topics, chapters,
audio list), topic pages with Gita / interpretation / application kept separate, Gita Study with
Sanskrit where loaded, "Talk to GitaSetu" (question-first, Gemini or offline fallback, verse
citations limited to the curated store), review-and-confirm practice creation, My Practice,
Evening Reflection, Your Journey (patterns, insights, growth), settings, safety screen, local storage.
Calm motion throughout (lib/core/motion.dart), switched off when the OS "reduce motion" setting is on.

Not yet: Gemini TTS audio (Listen buttons are placeholders), real push reminders (time is stored
only), Supabase auth/sync, pgvector retrieval, verified Sanskrit/translations for all verses,
photographic imagery (illustrations are drawn in code).
