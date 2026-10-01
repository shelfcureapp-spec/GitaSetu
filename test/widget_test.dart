import 'package:flutter_test/flutter_test.dart';
import 'package:gitasetu/main.dart';
import 'package:gitasetu/models/models.dart';
import 'package:gitasetu/services/conversation_engine.dart';
import 'package:gitasetu/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppState> makeState() async {
  SharedPreferences.setMockInitialValues({});
  return AppState(await SharedPreferences.getInstance(), engine: LocalGuidedEngine());
}

void main() {
  test('offline flow asks questions first, then teaches with an offer', () async {
    final s = await makeState();
    await s.send('I keep getting angry at my wife');
    expect(s.messages.last.offer, isNull);
    await s.send('She does not listen to me');
    expect(s.messages.last.offer, isNull);
    await s.send('I wanted her to take me seriously');
    final last = s.messages.last;
    expect(last.verseRefs, isNotEmpty);
    expect(last.offer, isNotNull);
    expect(s.practices, isEmpty, reason: 'must not create practices silently');
  });

  test('practice is only created via explicit createPractice', () async {
    final s = await makeState();
    await s.send('angry');
    await s.send('x');
    await s.send('y');
    final m = s.messages.last;
    s.createPractice(m.id, m.offer!, reminder: '08:00');
    expect(s.practices.length, 1);
    expect(s.messages.last.offerState, OfferState.created);
    s.markDone(s.practices.first.id);
    s.markDone(s.practices.first.id);
    expect(s.practices.first.completions.length, 1, reason: 'once per day');
  });

  test('safety screen short-circuits', () async {
    final r = await RoutingEngine().respond(
        [const ChatMessage(id: '1', fromUser: true, text: 'I want to end my life')]);
    expect(r.safety, isTrue);
    expect(r.offer, isNull);
  });

  test('Gemini output cannot cite verses outside the curated store', () {
    final t = GeminiEngine.parse(
      '{"text":"hi","verse_refs":["2.62","99.99"],"confidence":"medium","practice":null}',
      allowedRefs: {'2.62'},
    );
    expect(t.verseRefs, ['2.62']);
  });

  testWidgets('onboarding then shell', (tester) async {
    final s = await makeState();
    await tester.pumpWidget(GitaSetuApp(state: s));
    expect(find.text('Begin'), findsOneWidget);
    await tester.tap(find.text('Begin'));
    await tester.pumpAndSettle();
    expect(find.text('Take a moment before you begin.'), findsOneWidget);
  });
}
