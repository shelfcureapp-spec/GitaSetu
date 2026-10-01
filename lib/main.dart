import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme.dart';
import 'screens/intro_screens.dart';
import 'screens/shell.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(GitaSetuApp(state: AppState(prefs)));
}

class GitaSetuApp extends StatelessWidget {
  const GitaSetuApp({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state,
      child: MaterialApp(
        title: 'GitaSetu',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        themeMode: ThemeMode.light,
        home: Consumer<AppState>(
          builder: (_, s, _) => s.onboarded ? const Shell() : const IntroFlow(),
        ),
      ),
    );
  }
}
