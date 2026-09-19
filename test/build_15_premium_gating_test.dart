import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guido/core/database/settings_provider.dart';
import 'package:guido/core/database/app_initializer_provider.dart';
import 'package:guido/core/unity/unity_bridge_dto.dart';
import 'package:guido/features/meditation/presentation/session_launch_helper.dart';
import 'package:guido/features/meditation/presentation/explanation_screen.dart';
import 'package:guido/features/menu/presentation/meditate_tab.dart';
import 'package:guido/features/menu/presentation/home_japandi_tab.dart';
import 'package:guido/core/theme/custom_button_widget.dart';
import 'package:guido/features/premium/presentation/premium_paywall_view.dart';
import 'package:guido/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Build 15: 1. SettingsNotifier lockPremium & unlockPremium Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('unlockPremium sets isUnlocked: true and persists', () async {
      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(settingsProvider.notifier);
      expect(container.read(settingsProvider).isUnlocked, isFalse);

      await notifier.unlockPremium();
      expect(container.read(settingsProvider).isUnlocked, isTrue);
      expect(prefs.getBool("IsUnlocked"), isTrue);
    });

    test('lockPremium sets isUnlocked: false and persists', () async {
      SharedPreferences.setMockInitialValues({"IsUnlocked": true});
      final p = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => p),
          sharedPrefsProvider.overrideWithValue(p),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(settingsProvider.notifier);
      expect(container.read(settingsProvider).isUnlocked, isTrue);

      await notifier.lockPremium();
      expect(container.read(settingsProvider).isUnlocked, isFalse);
      expect(p.getBool("IsUnlocked"), isFalse);
    });
  });

  group('Build 15: 2. Centralized Guard in launchZenSession Tests', () {
    testWidgets('launchZenSession blocks premium experience when !isUnlocked and redirects to /premium', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      String? currentRoute;

      final router = GoRouter(
        initialLocation: '/test-launcher',
        routes: [
          GoRoute(
            path: '/test-launcher',
            builder: (context, state) => Consumer(
              builder: (context, ref, _) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      launchZenSession(
                        context: context,
                        ref: ref,
                        title: 'Percorso Fuoco',
                        sceneName: UnityScenes.fireMeditation,
                        isPremium: true,
                      );
                    },
                    child: const Text('Launch Premium'),
                  ),
                );
              },
            ),
          ),
          GoRoute(
            path: '/premium',
            builder: (context, state) {
              currentRoute = '/premium';
              return const Scaffold(body: Text('Premium Paywall'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
            sharedPrefsProvider.overrideWithValue(prefs),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Launch Premium'));
      await tester.pumpAndSettle();

      expect(currentRoute, equals('/premium'));
      expect(find.text('Premium Paywall'), findsOneWidget);
      expect(find.byType(ExplanationScreen), findsNothing);
    });

    testWidgets('launchZenSession allows premium experience when isUnlocked == true', (tester) async {
      SharedPreferences.setMockInitialValues({"IsUnlocked": true});
      final prefs = await SharedPreferences.getInstance();

      final router = GoRouter(
        initialLocation: '/test-launcher',
        routes: [
          GoRoute(
            path: '/test-launcher',
            builder: (context, state) => Consumer(
              builder: (context, ref, _) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      launchZenSession(
                        context: context,
                        ref: ref,
                        title: 'Percorso Fuoco',
                        sceneName: UnityScenes.fireMeditation,
                        isPremium: true,
                      );
                    },
                    child: const Text('Launch Premium'),
                  ),
                );
              },
            ),
          ),
          GoRoute(
            path: '/premium',
            builder: (context, state) => const Scaffold(body: Text('Premium Paywall')),
          ),
          GoRoute(
            path: '/explanation',
            builder: (context, state) => const ExplanationScreen(
              title: 'Test',
              sceneName: 'TestScene',
              voicePath: '',
              ambientPath: '',
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
            sharedPrefsProvider.overrideWithValue(prefs),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Launch Premium'));
      await tester.pumpAndSettle();

      expect(find.byType(ExplanationScreen), findsOneWidget);
    });

    testWidgets('launchZenSession allows free experience even when !isUnlocked', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final router = GoRouter(
        initialLocation: '/test-launcher',
        routes: [
          GoRoute(
            path: '/test-launcher',
            builder: (context, state) => Consumer(
              builder: (context, ref, _) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      launchZenSession(
                        context: context,
                        ref: ref,
                        title: 'Percorso Acqua (Mattina)',
                        sceneName: UnityScenes.waterMeditation,
                        isPremium: false,
                      );
                    },
                    child: const Text('Launch Free'),
                  ),
                );
              },
            ),
          ),
          GoRoute(
            path: '/premium',
            builder: (context, state) => const Scaffold(body: Text('Premium Paywall')),
          ),
          GoRoute(
            path: '/explanation',
            builder: (context, state) => const ExplanationScreen(
              title: 'Test',
              sceneName: 'TestScene',
              voicePath: '',
              ambientPath: '',
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
            sharedPrefsProvider.overrideWithValue(prefs),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Launch Free'));
      await tester.pumpAndSettle();

      expect(find.byType(ExplanationScreen), findsOneWidget);
    });
  });

  group('Build 15: 3. MeditateTab Cataloging & Gating Tests', () {
    testWidgets('MeditateTab shows Free badges for Acqua and Generale, and opens /premium for locked items', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      String? currentRoute;

      final router = GoRouter(
        initialLocation: '/meditate',
        routes: [
          GoRoute(
            path: '/meditate',
            builder: (context, state) => const Scaffold(body: MeditateTab()),
          ),
          GoRoute(
            path: '/premium',
            builder: (context, state) {
              currentRoute = '/premium';
              return const Scaffold(body: Text('Premium Paywall'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
            sharedPrefsProvider.overrideWithValue(prefs),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Free paths exist
      expect(find.text('Meditazione Generale (Gratis)'), findsOneWidget);
      expect(find.text('Percorso Acqua (Mattina)'), findsOneWidget);
      expect(find.text('Percorso Acqua (Pomeriggio)'), findsOneWidget);
      expect(find.text('Percorso Acqua (Sera)'), findsOneWidget);

      // Verify Premium paths exist
      expect(find.text('Percorso Aria (Meditazione)'), findsOneWidget);
      expect(find.text('Percorso Fuoco (Meditazione)'), findsOneWidget);
      expect(find.text('Percorso Terra (Meditazione)'), findsOneWidget);

      // Scroll to and tap locked Percorso Aria
      final ariaFinder = find.text('Percorso Aria (Meditazione)');
      await tester.ensureVisible(ariaFinder);
      await tester.pumpAndSettle();
      await tester.tap(ariaFinder);
      await tester.pumpAndSettle();

      expect(currentRoute, equals('/premium'));
    });
  });

  group('Build 15: 4. HomeJapandiTab Horizontal Deck Gating Tests', () {
    testWidgets('HomeJapandiTab displays lock icon for Terra/Aria/Fuoco and opens /premium on tap', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      String? currentRoute;

      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const Scaffold(body: HomeJapandiTab()),
          ),
          GoRoute(
            path: '/premium',
            builder: (context, state) {
              currentRoute = '/premium';
              return const Scaffold(body: Text('Premium Paywall'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
            sharedPrefsProvider.overrideWithValue(prefs),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Scroll to deck if needed and find locked card in horizontal deck: "Percorso Fuoco"
      final fuocoFinder = find.text('Percorso Fuoco');
      await tester.ensureVisible(fuocoFinder);
      await tester.pump(const Duration(milliseconds: 200));
      expect(fuocoFinder, findsOneWidget);

      await tester.tap(fuocoFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(currentRoute, equals('/premium'));
    });
  });

  group('Build 15: 5. PremiumPaywallView CTA & Restore Purchases Tests', () {
    testWidgets('Tapping ATTIVA ORA unlocks premium and shows SnackBar', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: '/premium',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Text('Root Screen')),
          ),
          GoRoute(
            path: '/premium',
            builder: (context, state) => const PremiumPaywallView(),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(container.read(settingsProvider).isUnlocked, isFalse);

      final activateBtn = find.byType(CustomUnityButton);
      await tester.ensureVisible(activateBtn);
      await tester.pumpAndSettle();
      expect(activateBtn, findsOneWidget);

      await tester.tap(activateBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(container.read(settingsProvider).isUnlocked, isTrue);
      expect(prefs.getBool("IsUnlocked"), isTrue);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Tapping Ripristina acquisti unlocks premium and shows SnackBar', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: '/premium',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Text('Root Screen')),
          ),
          GoRoute(
            path: '/premium',
            builder: (context, state) => const PremiumPaywallView(),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(container.read(settingsProvider).isUnlocked, isFalse);

      final restoreBtn = find.text('Ripristina acquisti');
      await tester.ensureVisible(restoreBtn);
      await tester.pumpAndSettle();
      expect(restoreBtn, findsOneWidget);

      await tester.tap(restoreBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(container.read(settingsProvider).isUnlocked, isTrue);
      expect(prefs.getBool("IsUnlocked"), isTrue);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
