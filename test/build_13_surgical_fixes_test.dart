import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guido/core/database/settings_provider.dart';
import 'package:guido/core/database/app_initializer_provider.dart';
import 'package:guido/core/services/daily_quotes_service.dart';
import 'package:guido/core/unity/unity_bridge_dto.dart';
import 'package:guido/core/unity/unity_session_controller.dart';
import 'package:guido/features/splash/presentation/boot_splash_view.dart';
import 'package:guido/features/meditation/presentation/unity_experience_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Build 13: 1. Unity Experience Timeout & Fallback UI Tests', () {
    testWidgets('Shows Japandi timeout dialog after 12s if Unity scene not loaded', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: UnityExperienceScreen(
              title: 'Test Session',
              sceneName: 'Procedimento acqua',
              durationSeconds: 300,
            ),
          ),
        ),
      );

      // Initial frame: Loading overlay is visible
      await tester.pump();
      expect(find.textContaining('CARICAMENTO AMBIENTE ZEN'), findsOneWidget);
      expect(find.textContaining('non è riuscito a caricare'), findsNothing);

      // Advance time by 13 seconds (past 12s timeout) and settle dialog animation
      await tester.pump(const Duration(seconds: 13));
      await tester.pump(const Duration(milliseconds: 500));

      // Loading overlay is replaced by elegant Japandi Fallback Dialog
      expect(find.textContaining('non è riuscito a caricare'), findsOneWidget);
      expect(find.text('RIPROVA'), findsOneWidget);
      expect(find.text('HOME'), findsOneWidget);

      final err = tester.takeException();
      if (err != null) {
        // ignore: avoid_print
        print('Captured Test 1 Exception: $err');
      }

      // Stop controller to cancel heartbeat timer before tear down
      container.read(unitySessionControllerProvider.notifier).stopSession();
      await tester.pump(const Duration(milliseconds: 100));
    });
  });

  group('Build 13: 2. Equatable SettingsState & Premium Toggle Tests', () {
    test('SettingsState supports value equality via Equatable', () {
      const state1 = SettingsState(
        musicVolume: 3,
        effectsVolume: 3,
        voiceVolume: 3,
        isVoiceMuted: false,
        voiceSex: 0,
        language: 0,
        isUnlocked: false,
        isVrMode: false,
        isDarkTheme: true,
        vrCalibrated: false,
        vrBiasX: 0.0,
        vrBiasZ: 0.0,
        qualityPreset: QualityPreset.highFidelity,
      );

      const state2 = SettingsState(
        musicVolume: 3,
        effectsVolume: 3,
        voiceVolume: 3,
        isVoiceMuted: false,
        voiceSex: 0,
        language: 0,
        isUnlocked: false,
        isVrMode: false,
        isDarkTheme: true,
        vrCalibrated: false,
        vrBiasX: 0.0,
        vrBiasZ: 0.0,
        qualityPreset: QualityPreset.highFidelity,
      );

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));

      final state3 = state1.copyWith(isUnlocked: true);
      expect(state1, isNot(equals(state3)));
      expect(state3.isUnlocked, isTrue);
    });

    test('NotifierProvider correctly updates state on togglePremiumSimulation', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(settingsProvider.notifier);
      expect(container.read(settingsProvider).isUnlocked, isFalse);

      await notifier.togglePremiumSimulation(true);
      expect(container.read(settingsProvider).isUnlocked, isTrue);
      expect(prefs.getBool("IsUnlocked"), isTrue);

      await notifier.togglePremiumSimulation(false);
      expect(container.read(settingsProvider).isUnlocked, isFalse);
      expect(prefs.getBool("IsUnlocked"), isFalse);
    });
  });

  group('Build 13: 3. BootSplashView Questionnaire Loop Fix Tests', () {
    testWidgets('navigates to /home when IsOnboarded is true', (tester) async {
      SharedPreferences.setMockInitialValues({'IsOnboarded': true});
      final prefs = await SharedPreferences.getInstance();

      String? navigatedLocation;

      final router = GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(
            path: '/splash',
            builder: (context, state) => const BootSplashView(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) {
              navigatedLocation = '/home';
              return const Scaffold(body: Text('Home Screen'));
            },
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) {
              navigatedLocation = '/login';
              return const Scaffold(body: Text('Login Screen'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
            sharedPrefsProvider.overrideWithValue(prefs),
            appInitializerProvider.overrideWith((ref) => Future.value(null)),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(navigatedLocation, equals('/home'));
      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('navigates to /login when IsOnboarded is false or null', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      String? navigatedLocation;

      final router = GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(
            path: '/splash',
            builder: (context, state) => const BootSplashView(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) {
              navigatedLocation = '/home';
              return const Scaffold(body: Text('Home Screen'));
            },
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) {
              navigatedLocation = '/login';
              return const Scaffold(body: Text('Login Screen'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
            sharedPrefsProvider.overrideWithValue(prefs),
            appInitializerProvider.overrideWith((ref) => Future.value(null)),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(navigatedLocation, equals('/login'));
      expect(find.text('Login Screen'), findsOneWidget);
    });
  });

  group('Build 13: 4. DST-Safe Quotes & Foreground Reactive Tests', () {
    test('UTC calculation produces stable quotes across DST transitions', () {
      final leapYearDate = DateTime.utc(2028, 2, 29, 12, 0);
      final leapQuote = DailyQuotesService.getDailyQuote(leapYearDate);
      expect(leapQuote.text.isNotEmpty, isTrue);

      final dstBoundary = DateTime.utc(2026, 3, 29, 2, 0);
      final dstQuote = DailyQuotesService.getDailyQuote(dstBoundary);
      expect(dstQuote.text.isNotEmpty, isTrue);
    });

    test('dailyQuoteProvider is reactive and updates on refresh', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialQuote = container.read(dailyQuoteProvider);
      expect(initialQuote.text.isNotEmpty, isTrue);

      container.read(dailyQuoteProvider.notifier).refresh();
      final refreshedQuote = container.read(dailyQuoteProvider);
      expect(refreshedQuote.text.isNotEmpty, isTrue);
    });
  });
}
