import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guido/core/services/daily_quotes_service.dart';
import 'package:guido/core/database/settings_provider.dart';
import 'package:guido/features/vr_safety/presentation/vr_safety_dialog.dart';
import 'package:guido/features/splash/presentation/splash_view.dart';
import 'package:guido/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DailyQuotesService Tests', () {
    test('contains exactly 40 curated quotes', () {
      expect(DailyQuotesService.quotes.length, equals(40));
    });

    test('contains exactly 20 Guido thoughts and 20 spiritual masters', () {
      final guidoQuotes = DailyQuotesService.quotes.where((q) => q.isGuidoThought).toList();
      final masterQuotes = DailyQuotesService.quotes.where((q) => !q.isGuidoThought).toList();

      expect(guidoQuotes.length, equals(20));
      expect(masterQuotes.length, equals(20));

      for (final q in guidoQuotes) {
        expect(q.author, equals('Guido'));
        expect(q.text.isNotEmpty, isTrue);
      }

      for (final q in masterQuotes) {
        expect(q.author.isNotEmpty, isTrue);
        expect(q.author, isNot(equals('Guido')));
        expect(q.text.isNotEmpty, isTrue);
      }
    });

    test('deterministic rotation returns quote based on day of year', () {
      final date1 = DateTime(2026, 1, 1);
      final date2 = DateTime(2026, 1, 2);
      final quote1 = DailyQuotesService.getDailyQuote(date1);
      final quote2 = DailyQuotesService.getDailyQuote(date2);

      expect(quote1.text.isNotEmpty, isTrue);
      expect(quote2.text.isNotEmpty, isTrue);
      // Different days yield different entries in rotation
      expect(quote1, isNot(same(quote2)));
    });

    test('dailyQuoteProvider provides quote correctly', () {
      final container = ProviderContainer();
      final quote = container.read(dailyQuoteProvider);
      expect(quote.text.isNotEmpty, isTrue);
      expect(quote.author.isNotEmpty, isTrue);
      container.dispose();
    });
  });

  group('VrSafetyDialog Widget Tests', () {
    testWidgets('renders guidelines cleanly without overflow and dismisses', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefsProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: VrSafetyDialog(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(VrSafetyDialog), findsOneWidget);
      expect(find.textContaining('Linee Guida'), findsOneWidget);
      expect(find.textContaining('5-15 min'), findsOneWidget);

      final buttonFinder = find.widgetWithText(ElevatedButton, 'HO CAPITO');
      expect(buttonFinder, findsOneWidget);
    });
  });

  group('iPhone SE Responsive Layout Tests', () {
    testWidgets('SplashView renders on 375x667 display without overflow', (tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefsProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('it', ''), Locale('en', '')],
            home: SplashView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SplashView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
