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

Built: onboarding, Home, Explore + topic study, "Talk to GitaSetu" (question-first investigation,
Gemini or offline fallback, verse citations limited to the curated store), confirm-before-create
practices, practice tracking, reflections, safety screen, local persistence.

Not yet: Gemini TTS audio, real push reminders (reminder time is stored only), Supabase auth/sync,
pgvector retrieval, full verse text (Sanskrit/translations) ingested from the curated source.
