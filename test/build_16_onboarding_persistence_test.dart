import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guido/core/database/settings_provider.dart';
import 'package:guido/core/database/app_initializer_provider.dart';
import 'package:guido/features/onboarding/presentation/onboarding_wizard_view.dart';
import 'package:guido/features/splash/presentation/boot_splash_view.dart';
import 'package:guido/features/splash/presentation/splash_view.dart';
import 'package:guido/features/menu/presentation/settings_tab.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Build 16: 1. OnboardingWizardView Completion & Navigation Tests', () {
    testWidgets('Completing onboarding sets IsOnboarded: true and navigates to /home', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      String? currentRoute;

      final router = GoRouter(
        initialLocation: '/onboarding',
        routes: [
          GoRoute(
            path: '/onboarding',
            builder: (context, state) => const OnboardingWizardView(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) {
              currentRoute = '/home';
              return const Scaffold(body: Text('Home Screen Target'));
            },
          ),
        ],
      );

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
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // 1. Fill Name
      final nameField = find.byType(TextFormField);
      expect(nameField, findsOneWidget);
      await tester.enterText(nameField, 'Yehia');
      await tester.pump();

      // Step through all questions (Steps 0 to 7)
      for (int i = 0; i < 8; i++) {
        final avantiButton = find.text(i == 7 ? 'SCOPRI IL TUO SENTIERO' : 'AVANTI');
        expect(avantiButton, findsOneWidget);
        await tester.tap(avantiButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));
      }

      // Step 8: Processing animation (2.5 seconds)
      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pump(const Duration(milliseconds: 500));

      // Step 9: Final recommendation card and completion button
      final completeButton = find.text('ENTRA NELLO SPAZIO ZEN');
      expect(completeButton, findsOneWidget);

      // Verify IsOnboarded is not yet set before tapping complete
      expect(prefs.getBool('IsOnboarded'), isNull);

      // Tap completion button
      await tester.tap(completeButton);
      await tester.pumpAndSettle();

      // Verify SharedPreferences has IsOnboarded = true
      expect(prefs.getBool('IsOnboarded'), isTrue);
      expect(prefs.getString('ProfileName'), 'Yehia');

      // Verify router navigated to /home
      expect(currentRoute, '/home');
      expect(find.text('Home Screen Target'), findsOneWidget);
    });
  });

  group('Build 16: 2. BootSplashView Routing Tests', () {
    testWidgets('BootSplashView redirects to /home when IsOnboarded is true', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({'IsOnboarded': true});
      final prefs = await SharedPreferences.getInstance();

      String? currentRoute;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const BootSplashView(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) {
              currentRoute = '/home';
              return const Scaffold(body: Text('Home Destination'));
            },
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) {
              currentRoute = '/login';
              return const Scaffold(body: Text('Login Destination'));
            },
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
          sharedPrefsProvider.overrideWithValue(prefs),
          appInitializerProvider.overrideWith((ref) async => {}),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(currentRoute, '/home');
      expect(find.text('Home Destination'), findsOneWidget);
    });

    testWidgets('BootSplashView redirects to /login when IsOnboarded is false or missing', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({'IsOnboarded': false});
      final prefs = await SharedPreferences.getInstance();

      String? currentRoute;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const BootSplashView(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) {
              currentRoute = '/home';
              return const Scaffold(body: Text('Home Destination'));
            },
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) {
              currentRoute = '/login';
              return const Scaffold(body: Text('Login Destination'));
            },
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
          sharedPrefsProvider.overrideWithValue(prefs),
          appInitializerProvider.overrideWith((ref) async => {}),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(currentRoute, '/login');
      expect(find.text('Login Destination'), findsOneWidget);
    });
  });

  group('Build 16: 3. SplashView (Login) Routing Tests', () {
    testWidgets('SplashView routes to /home after login if already onboarded', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({'IsOnboarded': true});
      final prefs = await SharedPreferences.getInstance();

      String? currentRoute;

      final router = GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const SplashView(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) {
              currentRoute = '/home';
              return const Scaffold(body: Text('Home Target'));
            },
          ),
          GoRoute(
            path: '/onboarding',
            builder: (context, state) {
              currentRoute = '/onboarding';
              return const Scaffold(body: Text('Onboarding Target'));
            },
          ),
        ],
      );

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
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter guest mode to route directly
      final guestButton = find.text('ENTRA COME OSPITE');
      expect(guestButton, findsOneWidget);
      await tester.tap(guestButton);
      await tester.pumpAndSettle();

      expect(currentRoute, '/home');
      expect(find.text('Home Target'), findsOneWidget);
    });

    testWidgets('SplashView routes to /onboarding after login if not yet onboarded', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({'IsOnboarded': false});
      final prefs = await SharedPreferences.getInstance();

      String? currentRoute;

      final router = GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const SplashView(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) {
              currentRoute = '/home';
              return const Scaffold(body: Text('Home Target'));
            },
          ),
          GoRoute(
            path: '/onboarding',
            builder: (context, state) {
              currentRoute = '/onboarding';
              return const Scaffold(body: Text('Onboarding Target'));
            },
          ),
        ],
      );

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
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter guest mode to route directly
      final guestButton = find.text('ENTRA COME OSPITE');
      expect(guestButton, findsOneWidget);
      await tester.tap(guestButton);
      await tester.pumpAndSettle();

      expect(currentRoute, '/onboarding');
      expect(find.text('Onboarding Target'), findsOneWidget);
    });
  });

  group('Build 16: 4. SettingsTab Safe LOGOUT Tests', () {
    testWidgets('Tapping LOGOUT does NOT clear IsOnboarded and routes safely to /login', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({'IsOnboarded': true});
      final prefs = await SharedPreferences.getInstance();

      String? currentRoute;

      final router = GoRouter(
        initialLocation: '/settings',
        routes: [
          GoRoute(
            path: '/settings',
            builder: (context, state) => const Scaffold(
              body: SettingsTab(),
            ),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) {
              currentRoute = '/login';
              return const Scaffold(body: Text('Login Screen After Logout'));
            },
          ),
        ],
      );

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
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final logoutBtn = find.text('LOGOUT');
      expect(logoutBtn, findsOneWidget);

      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();

      // Crucial verification: IsOnboarded MUST remain true!
      expect(prefs.getBool('IsOnboarded'), isTrue);

      // Navigation must have cleanly switched to /login
      expect(currentRoute, '/login');
      expect(find.text('Login Screen After Logout'), findsOneWidget);
    });
  });

  }
