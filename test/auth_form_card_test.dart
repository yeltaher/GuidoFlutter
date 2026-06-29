import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guido/features/splash/presentation/splash_view.dart';
import 'package:guido/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets('AuthFormCard renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('it', ''), Locale('en', '')],
          home: Scaffold(
            body: AuthFormCard(
              isDark: false,
              textColor: Colors.black,
              subTextColor: Colors.grey,
              accentColor: Colors.blue,
              onLoginSuccess: () {},
            ),
          ),
        ),
      ),
    );

    // Verify if AuthFormCard is rendered
    expect(find.byType(AuthFormCard), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
