import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:guido/features/vr_experiences/domain/vr_experience_type.dart';
import 'package:guido/features/vr_experiences/application/local_vr_server_service.dart';
import 'package:guido/core/unity/unity_bridge_dto.dart';
import 'package:guido/core/database/settings_provider.dart';
import 'package:guido/core/database/app_initializer_provider.dart';
import 'package:guido/features/meditation/presentation/session_launch_helper.dart';
import 'package:guido/features/meditation/presentation/explanation_screen.dart';
import 'package:guido/features/vr_experiences/presentation/vr_experience_screen.dart';
import 'package:guido/features/onboarding/presentation/wolf_onboarding_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VrExperienceType Domain Tests', () {
    test('Defines all 8 offline WebXR modules correctly', () {
      expect(VrExperienceType.values.length, 8);

      final aria = VrExperienceType.respirazioneAria;
      expect(aria.id, 'respirazione_aria');
      expect(aria.folderName, 'respirazione_aria');
      expect(aria.element, 'Aria');
      expect(aria.isBreathing, isTrue);

      final acqua = VrExperienceType.respirazioneAcqua;
      expect(acqua.id, 'respirazione_acqua');
      expect(acqua.element, 'Acqua');
      expect(acqua.isBreathing, isTrue);

      final fuoco = VrExperienceType.respirazioneFuoco;
      expect(fuoco.id, 'respirazione_fuoco');
      expect(fuoco.element, 'Fuoco');
      expect(fuoco.isBreathing, isTrue);

      final terra = VrExperienceType.respirazioneTerra;
      expect(terra.id, 'respirazione_terra');
      expect(terra.element, 'Terra');
      expect(terra.isBreathing, isTrue);

      final mattino = VrExperienceType.meditazioneMattinoAcqua;
      expect(mattino.id, 'meditazione_mattino_acqua');
      expect(mattino.element, 'Acqua');
      expect(mattino.isBreathing, isFalse);

      final pomeriggio = VrExperienceType.meditazionePomeriggioAcqua;
      expect(pomeriggio.id, 'meditazione_pomeriggio_acqua');
      expect(pomeriggio.folderName, 'meditazione_pomeriggio_acqua');
      expect(pomeriggio.title, 'Meditazione del Pomeriggio • Acqua');
      expect(pomeriggio.titleEn, 'Afternoon Meditation • Water');
      expect(pomeriggio.subtitle, 'Percorso Guidato • 432 Hz');
      expect(pomeriggio.element, 'Acqua');
      expect(pomeriggio.isBreathing, isFalse);

      final sera = VrExperienceType.meditazioneSeraAcqua;
      expect(sera.id, 'meditazione_sera_acqua');
      expect(sera.folderName, 'meditazione_sera_acqua');
      expect(sera.title, 'Meditazione della Sera • Acqua');
      expect(sera.element, 'Acqua');
      expect(sera.isBreathing, isFalse);

      final generale = VrExperienceType.meditazioneGeneraleAcqua;
      expect(generale.id, 'meditazione_generale_acqua');
      expect(generale.folderName, 'meditazione_generale_acqua');
      expect(generale.title, 'Meditazione Generale • Acqua');
      expect(generale.titleEn, 'General Meditation • Water');
      expect(generale.subtitle, 'Consapevolezza Zen • 432 Hz');
      expect(generale.element, 'Acqua');
      expect(generale.isBreathing, isFalse);
    });

    test('fromId correctly resolves with safe fallback', () {
      expect(
        VrExperienceType.fromId('respirazione_aria'),
        VrExperienceType.respirazioneAria,
      );
      expect(
        VrExperienceType.fromId('respirazione_fuoco'),
        VrExperienceType.respirazioneFuoco,
      );
      expect(
        VrExperienceType.fromId('meditazione_sera_acqua'),
        VrExperienceType.meditazioneSeraAcqua,
      );
      expect(
        VrExperienceType.fromId('meditazione_pomeriggio_acqua'),
        VrExperienceType.meditazionePomeriggioAcqua,
      );
      expect(
        VrExperienceType.fromId('waterMeditationAfternoon'),
        VrExperienceType.meditazionePomeriggioAcqua,
      );
      expect(
        VrExperienceType.fromId('waterMeditationEvening'),
        VrExperienceType.meditazioneSeraAcqua,
      );
      expect(
        VrExperienceType.fromId('meditazione_generale_acqua'),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
      expect(
        VrExperienceType.fromId('generalMeditation'),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
      expect(
        VrExperienceType.fromId('unknown_id'),
        VrExperienceType.respirazioneAria,
      );
    });

    test('fromSessionId resolves evening, morning, afternoon and other sessions accurately', () {
      expect(
        VrExperienceType.fromSessionId('generalMeditation'),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('meditazione_generale_acqua'),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('meditazionegenerale'),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('water_general'),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('general'),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('focus_zen'),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('waterMeditationEvening'),
        VrExperienceType.meditazioneSeraAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('water_evening'),
        VrExperienceType.meditazioneSeraAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('meditazione_sera_acqua'),
        VrExperienceType.meditazioneSeraAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('waterMeditationAfternoon'),
        VrExperienceType.meditazionePomeriggioAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('water_afternoon'),
        VrExperienceType.meditazionePomeriggioAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('meditazione_pomeriggio_acqua'),
        VrExperienceType.meditazionePomeriggioAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('meditazionepomeriggio'),
        VrExperienceType.meditazionePomeriggioAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('water_pom'),
        VrExperienceType.meditazionePomeriggioAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('water_meditation_afternoon'),
        VrExperienceType.meditazionePomeriggioAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('waterMeditationMorning'),
        VrExperienceType.meditazioneMattinoAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('water_breathing'),
        VrExperienceType.respirazioneAcqua,
      );
      expect(
        VrExperienceType.fromSessionId('air_breathing'),
        VrExperienceType.respirazioneAria,
      );
      expect(
        VrExperienceType.fromSessionId('fire_breathing'),
        VrExperienceType.respirazioneFuoco,
      );
      expect(
        VrExperienceType.fromSessionId('earth_breathing'),
        VrExperienceType.respirazioneTerra,
      );
      expect(
        VrExperienceType.fromSessionId(null),
        isNull,
      );
      expect(
        VrExperienceType.fromSessionId(''),
        isNull,
      );
    });

    test('fromSceneOrTitle correctly matches WebXR scenes and fallback', () {
      // 4 Respirazioni
      expect(
        VrExperienceType.fromSceneOrTitle(sceneName: UnityScenes.airBreathing),
        VrExperienceType.respirazioneAria,
      );
      expect(
        VrExperienceType.fromSceneOrTitle(sceneName: UnityScenes.waterBreathing),
        VrExperienceType.respirazioneAcqua,
      );
      expect(
        VrExperienceType.fromSceneOrTitle(sceneName: UnityScenes.fireBreathing),
        VrExperienceType.respirazioneFuoco,
      );
      expect(
        VrExperienceType.fromSceneOrTitle(sceneName: UnityScenes.earthBreathing),
        VrExperienceType.respirazioneTerra,
      );

      // Meditazione Mattino Acqua
      expect(
        VrExperienceType.fromSceneOrTitle(
          sceneName: UnityScenes.waterMeditationMorning,
        ),
        VrExperienceType.meditazioneMattinoAcqua,
      );
      expect(
        VrExperienceType.fromSceneOrTitle(
          title: 'Meditazione del Mattino (Acqua)',
        ),
        VrExperienceType.meditazioneMattinoAcqua,
      );

      // Meditazione Pomeriggio Acqua
      expect(
        VrExperienceType.fromSceneOrTitle(
          sceneName: UnityScenes.waterMeditationAfternoon,
        ),
        VrExperienceType.meditazionePomeriggioAcqua,
      );
      expect(
        VrExperienceType.fromSceneOrTitle(
          title: 'Meditazione del Pomeriggio • Acqua',
        ),
        VrExperienceType.meditazionePomeriggioAcqua,
      );
      expect(
        VrExperienceType.fromSceneOrTitle(
          title: 'Percorso Acqua (Pomeriggio)',
        ),
        VrExperienceType.meditazionePomeriggioAcqua,
      );
      expect(
        VrExperienceType.fromSceneOrTitle(
          sceneName: UnityScenes.waterMeditation,
          title: 'Meditazione Pomeriggio',
        ),
        VrExperienceType.meditazionePomeriggioAcqua,
      );

      // Meditazione Sera Acqua
      expect(
        VrExperienceType.fromSceneOrTitle(
          sceneName: UnityScenes.waterMeditationEvening,
        ),
        VrExperienceType.meditazioneSeraAcqua,
      );
      expect(
        VrExperienceType.fromSceneOrTitle(
          title: 'Meditazione della Sera • Acqua',
        ),
        VrExperienceType.meditazioneSeraAcqua,
      );
      expect(
        VrExperienceType.fromSceneOrTitle(
          title: 'Percorso Acqua (Sera)',
        ),
        VrExperienceType.meditazioneSeraAcqua,
      );

      // Meditazione Generale Acqua
      expect(
        VrExperienceType.fromSceneOrTitle(
          sceneName: UnityScenes.generalMeditation,
        ),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
      expect(
        VrExperienceType.fromSceneOrTitle(
          sceneName: UnityScenes.generalMeditation,
          title: 'Meditazione Generale',
        ),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
      expect(
        VrExperienceType.fromSceneOrTitle(
          title: 'Meditazione Generale • Acqua',
        ),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
      expect(
        VrExperienceType.fromSceneOrTitle(
          title: 'General Meditation (Free)',
        ),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
      expect(
        VrExperienceType.fromSceneOrTitle(
          title: 'Focus Zen Acqua',
        ),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
    });
  });

  group('LocalVrServerService URL Building Tests', () {
    test('Constructs local URL on port 8085 with query parameters', () {
      final service = LocalVrServerService(port: 8085);

      final urlFlat = service.getExperienceUrl(
        VrExperienceType.respirazioneAria,
        isVrMode: false,
        autoStart: true,
      );
      expect(
        urlFlat,
        'http://localhost:8085/vr_experiences/respirazione_aria/index.html?autostart=true',
      );

      final urlVr = service.getExperienceUrl(
        VrExperienceType.meditazioneMattinoAcqua,
        isVrMode: true,
        autoStart: true,
      );
      expect(
        urlVr,
        'http://localhost:8085/vr_experiences/meditazione_mattino_acqua/index.html?vr=true&autostart=true',
      );

      final urlCacheBusted = service.getExperienceUrl(
        VrExperienceType.meditazioneMattinoAcqua,
        isVrMode: true,
        autoStart: true,
        cacheBust: true,
      );
      expect(urlCacheBusted.contains('v='), isTrue);
      expect(urlCacheBusted.contains('vr=true'), isTrue);
      expect(urlCacheBusted.contains('autostart=true'), isTrue);

      final urlMale = service.getExperienceUrl(
        VrExperienceType.respirazioneAria,
        voiceSex: 0,
      );
      expect(urlMale.contains('voice=m'), isTrue);

      final urlFemale = service.getExperienceUrl(
        VrExperienceType.respirazioneAria,
        voiceSex: 1,
      );
      expect(urlFemale.contains('voice=f'), isTrue);

      // Verifiche per tutte le 4 meditazioni dell'acqua con voce Luigi (0) e Michela (1)
      final meditationTypes = [
        VrExperienceType.meditazioneMattinoAcqua,
        VrExperienceType.meditazionePomeriggioAcqua,
        VrExperienceType.meditazioneSeraAcqua,
        VrExperienceType.meditazioneGeneraleAcqua,
      ];

      for (final medType in meditationTypes) {
        final medMaleUrl = service.getExperienceUrl(medType, voiceSex: 0);
        expect(medMaleUrl.contains('voice=m'), isTrue,
            reason: '${medType.folderName} must include voice=m for Luigi');

        final medFemaleUrl = service.getExperienceUrl(medType, voiceSex: 1);
        expect(medFemaleUrl.contains('voice=f'), isTrue,
            reason: '${medType.folderName} must include voice=f for Michela');
      }
    });
  });

  group('SessionLaunchDialog WebXR Routing Tests', () {
    testWidgets('Air breathing routes to /vr-experience with respirazione_aria',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic>? vrExtra;
      final router = GoRouter(
        initialLocation: '/dialog-host',
        routes: [
          GoRoute(
            path: '/dialog-host',
            builder: (context, state) => Scaffold(
              body: Center(
                child: Builder(
                  builder: (ctx) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: ctx,
                        builder: (_) => const SessionLaunchDialog(
                          title: 'Respirazione Aria',
                          voicePath: '',
                          ambientPath: '',
                          sceneName: UnityScenes.airBreathing,
                          durationSeconds: 300.0,
                        ),
                      );
                    },
                    child: const Text('OPEN DIALOG'),
                  ),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/vr-experience',
            builder: (context, state) {
              vrExtra = state.extra as Map<String, dynamic>?;
              return const Scaffold(body: Text('VR Experience Target'));
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
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      expect(find.text('Modalità Standard'), findsOneWidget);

      // Tap Modalità Standard per Respirazione Aria
      await tester.tap(find.text('Modalità Standard'));
      await tester.pumpAndSettle();

      expect(vrExtra, isNotNull);
      expect(vrExtra!['experienceId'], 'respirazione_aria');
      expect(vrExtra!['isVrMode'], isFalse);
    });

    testWidgets(
        'Morning water meditation routes to /vr-experience with meditazione_mattino_acqua',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic>? vrExtra;
      final router = GoRouter(
        initialLocation: '/dialog-host',
        routes: [
          GoRoute(
            path: '/dialog-host',
            builder: (context, state) => Scaffold(
              body: Center(
                child: Builder(
                  builder: (ctx) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: ctx,
                        builder: (_) => const SessionLaunchDialog(
                          title: 'Meditazione Mattino • Acqua',
                          voicePath: '',
                          ambientPath: '',
                          sceneName: UnityScenes.waterMeditationMorning,
                          durationSeconds: 300.0,
                        ),
                      );
                    },
                    child: const Text('OPEN DIALOG'),
                  ),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/vr-experience',
            builder: (context, state) {
              vrExtra = state.extra as Map<String, dynamic>?;
              return const Scaffold(body: Text('VR Experience Target'));
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
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Modalità Standard'));
      await tester.pumpAndSettle();

      expect(vrExtra, isNotNull);
      expect(vrExtra!['experienceId'], 'meditazione_mattino_acqua');
      expect(vrExtra!['isVrMode'], isFalse);
    });

    testWidgets(
        'Fire and Earth breathing route correctly to /vr-experience',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic>? vrExtra;
      final router = GoRouter(
        initialLocation: '/dialog-host',
        routes: [
          GoRoute(
            path: '/dialog-host',
            builder: (context, state) => Scaffold(
              body: Center(
                child: Builder(
                  builder: (ctx) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: ctx,
                        builder: (_) => const SessionLaunchDialog(
                          title: 'Respirazione Fuoco',
                          voicePath: '',
                          ambientPath: '',
                          sceneName: UnityScenes.fireBreathing,
                          durationSeconds: 300.0,
                        ),
                      );
                    },
                    child: const Text('OPEN DIALOG'),
                  ),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/vr-experience',
            builder: (context, state) {
              vrExtra = state.extra as Map<String, dynamic>?;
              return const Scaffold(body: Text('VR Experience Target'));
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
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Modalità Standard'));
      await tester.pumpAndSettle();

      expect(vrExtra, isNotNull);
      expect(vrExtra!['experienceId'], 'respirazione_fuoco');
      expect(vrExtra!['isVrMode'], isFalse);
    });

    testWidgets(
        'Evening water meditation routes to /vr-experience with meditazione_sera_acqua',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic>? vrExtra;
      final router = GoRouter(
        initialLocation: '/dialog-host',
        routes: [
          GoRoute(
            path: '/dialog-host',
            builder: (context, state) => Scaffold(
              body: Center(
                child: Builder(
                  builder: (ctx) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: ctx,
                        builder: (_) => const SessionLaunchDialog(
                          title: 'Meditazione della Sera • Acqua',
                          voicePath: '',
                          ambientPath: '',
                          sceneName: UnityScenes.waterMeditationEvening,
                          durationSeconds: 332.0,
                        ),
                      );
                    },
                    child: const Text('OPEN DIALOG'),
                  ),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/vr-experience',
            builder: (context, state) {
              vrExtra = state.extra as Map<String, dynamic>?;
              return const Scaffold(body: Text('VR Experience Target'));
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
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Modalità Standard'));
      await tester.pumpAndSettle();

      expect(vrExtra, isNotNull);
      expect(vrExtra!['experienceId'], 'meditazione_sera_acqua');
      expect(vrExtra!['isVrMode'], isFalse);
    });

    testWidgets(
        'Afternoon water meditation routes to /vr-experience with meditazione_pomeriggio_acqua',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic>? vrExtra;
      final router = GoRouter(
        initialLocation: '/dialog-host',
        routes: [
          GoRoute(
            path: '/dialog-host',
            builder: (context, state) => Scaffold(
              body: Center(
                child: Builder(
                  builder: (ctx) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: ctx,
                        builder: (_) => const SessionLaunchDialog(
                          title: 'Percorso Acqua (Pomeriggio)',
                          voicePath: '',
                          ambientPath: '',
                          sceneName: UnityScenes.waterMeditationAfternoon,
                          durationSeconds: 900.0,
                        ),
                      );
                    },
                    child: const Text('OPEN DIALOG'),
                  ),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/vr-experience',
            builder: (context, state) {
              vrExtra = state.extra as Map<String, dynamic>?;
              return const Scaffold(body: Text('VR Experience Target'));
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
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Modalità Standard'));
      await tester.pumpAndSettle();

      expect(vrExtra, isNotNull);
      expect(vrExtra!['experienceId'], 'meditazione_pomeriggio_acqua');
      expect(vrExtra!['isVrMode'], isFalse);
    });

    testWidgets(
        'General water meditation routes to /vr-experience with meditazione_generale_acqua',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic>? vrExtra;
      final router = GoRouter(
        initialLocation: '/dialog-host',
        routes: [
          GoRoute(
            path: '/dialog-host',
            builder: (context, state) => Scaffold(
              body: Center(
                child: Builder(
                  builder: (ctx) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: ctx,
                        builder: (_) => const SessionLaunchDialog(
                          title: 'Meditazione Generale',
                          voicePath: '',
                          ambientPath: '',
                          sceneName: UnityScenes.generalMeditation,
                          durationSeconds: 600.0,
                        ),
                      );
                    },
                    child: const Text('OPEN DIALOG'),
                  ),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/vr-experience',
            builder: (context, state) {
              vrExtra = state.extra as Map<String, dynamic>?;
              return const Scaffold(body: Text('VR Experience Target'));
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
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Modalità Standard'));
      await tester.pumpAndSettle();

      expect(vrExtra, isNotNull);
      expect(vrExtra!['experienceId'], 'meditazione_generale_acqua');
      expect(vrExtra!['isVrMode'], isFalse);
    });
  });

  group('VrExperienceType Extended Domain & Helper Tests', () {
    test('tryFromId returns correct enum or null', () {
      expect(
        VrExperienceType.tryFromId('respirazione_aria'),
        VrExperienceType.respirazioneAria,
      );
      expect(
        VrExperienceType.tryFromId('respirazione_acqua'),
        VrExperienceType.respirazioneAcqua,
      );
      expect(
        VrExperienceType.tryFromId('respirazione_fuoco'),
        VrExperienceType.respirazioneFuoco,
      );
      expect(
        VrExperienceType.tryFromId('respirazione_terra'),
        VrExperienceType.respirazioneTerra,
      );
      expect(
        VrExperienceType.tryFromId('meditazione_mattino_acqua'),
        VrExperienceType.meditazioneMattinoAcqua,
      );
      expect(
        VrExperienceType.tryFromId('meditazione_pomeriggio_acqua'),
        VrExperienceType.meditazionePomeriggioAcqua,
      );
      expect(
        VrExperienceType.tryFromId('meditazione_sera_acqua'),
        VrExperienceType.meditazioneSeraAcqua,
      );
      expect(
        VrExperienceType.tryFromId('meditazione_generale_acqua'),
        VrExperienceType.meditazioneGeneraleAcqua,
      );
      expect(VrExperienceType.tryFromId('non_esistente'), isNull);
      expect(VrExperienceType.tryFromId(null), isNull);
      expect(VrExperienceType.tryFromId(''), isNull);
    });

    test('localizedTitle and subtitles are valid', () {
      final aria = VrExperienceType.respirazioneAria;
      expect(aria.localizedTitle(true), 'Respirazione Aria');
      expect(aria.localizedTitle(false), 'Air Breathing');

      final acqua = VrExperienceType.respirazioneAcqua;
      expect(acqua.localizedTitle(true), 'Respirazione Acqua');
      expect(acqua.localizedTitle(false), 'Water Breathing');

      final mattino = VrExperienceType.meditazioneMattinoAcqua;
      expect(mattino.localizedTitle(true), 'Meditazione Mattino • Acqua');
      expect(mattino.localizedTitle(false), 'Morning Meditation • Water');

      final pomeriggio = VrExperienceType.meditazionePomeriggioAcqua;
      expect(pomeriggio.localizedTitle(true), 'Meditazione del Pomeriggio • Acqua');
      expect(pomeriggio.localizedTitle(false), 'Afternoon Meditation • Water');
      expect(pomeriggio.subtitle, 'Percorso Guidato • 432 Hz');

      final sera = VrExperienceType.meditazioneSeraAcqua;
      expect(sera.localizedTitle(true), 'Meditazione della Sera • Acqua');
      expect(sera.localizedTitle(false), 'Evening Meditation • Water');

      final generale = VrExperienceType.meditazioneGeneraleAcqua;
      expect(generale.localizedTitle(true), 'Meditazione Generale • Acqua');
      expect(generale.localizedTitle(false), 'General Meditation • Water');
      expect(generale.subtitle, 'Consapevolezza Zen • 432 Hz');
    });

    test('isOfflineVrSupported helper returns true only for supported experiences', () {
      expect(
        VrExperienceType.isOfflineVrSupported(sceneName: UnityScenes.airBreathing),
        isTrue,
      );
      expect(
        VrExperienceType.isOfflineVrSupported(sceneName: UnityScenes.waterBreathing),
        isTrue,
      );
      expect(
        VrExperienceType.isOfflineVrSupported(sceneName: UnityScenes.fireBreathing),
        isTrue,
      );
      expect(
        VrExperienceType.isOfflineVrSupported(sceneName: UnityScenes.earthBreathing),
        isTrue,
      );
      expect(
        VrExperienceType.isOfflineVrSupported(
          sceneName: UnityScenes.waterMeditationMorning,
        ),
        isTrue,
      );
      expect(
        VrExperienceType.isOfflineVrSupported(
          sceneName: UnityScenes.waterMeditationAfternoon,
        ),
        isTrue,
      );
      expect(
        VrExperienceType.isOfflineVrSupported(
          title: 'Meditazione del Pomeriggio • Acqua',
        ),
        isTrue,
      );
      expect(
        VrExperienceType.isOfflineVrSupported(
          title: 'Percorso Acqua (Pomeriggio)',
        ),
        isTrue,
      );
      expect(
        VrExperienceType.isOfflineVrSupported(
          sceneName: UnityScenes.waterMeditationEvening,
        ),
        isTrue,
      );
      expect(
        VrExperienceType.isOfflineVrSupported(
          title: 'Meditazione della Sera • Acqua',
        ),
        isTrue,
      );
      expect(
        VrExperienceType.isOfflineVrSupported(
          sceneName: UnityScenes.generalMeditation,
        ),
        isTrue,
      );
      expect(
        VrExperienceType.isOfflineVrSupported(
          title: 'Meditazione Generale • Acqua',
        ),
        isTrue,
      );
      expect(
        VrExperienceType.isOfflineVrSupported(
          sceneName: 'NonExistentScene',
          title: 'NonExistentTitle',
        ),
        isFalse,
      );
    });
  });

  group('WebXR HTML Templates Immersion & Quality Gates', () {
    final experienceDirs = [
      'respirazione_aria',
      'respirazione_acqua',
      'respirazione_fuoco',
      'respirazione_terra',
      'meditazione_mattino_acqua',
    ];

    test('All 5 templates have clean floating UI with headers, bottom bars, audio gates and rotate hints hidden', () {
      for (final dir in experienceDirs) {
        final file = File('assets/vr_experiences/$dir/index.html');
        expect(file.existsSync(), isTrue, reason: 'index.html in $dir must exist');
        final content = file.readAsStringSync();

        // 1. Nessun widget invasivo: header-bar nascosto
        expect(
          content.contains('.header-bar') && content.contains('display: none !important'),
          isTrue,
          reason: '$dir must hide .header-bar',
        );

        // 2. Bottom bar o bottom dock nascosta
        final hasHiddenBottom = (content.contains('.bottom-bar') || content.contains('.bottom-dock')) &&
            content.contains('display: none !important');
        expect(hasHiddenBottom, isTrue, reason: '$dir must hide bottom control bar/dock');

        // 3. Audio gate bypassato/nascosto per mobile app
        expect(
          content.contains('#audio-gate') && content.contains('display: none !important'),
          isTrue,
          reason: '$dir must hide #audio-gate',
        );

        // 4. Rotate hint prompt nascosto/disattivato
        expect(
          content.contains('#rotate-hint') && content.contains('display: none !important'),
          isTrue,
          reason: '$dir must hide #rotate-hint',
        );

        // 5. Testo 3D fluttuante visibile in VR Cardboard (Sprite / Billboard)
        final hasVr3dText = content.contains('THREE.Sprite') || content.contains('billboardMesh');
        expect(hasVr3dText, isTrue, reason: '$dir must define 3D floating text in Three.js scene');
      }
    });
  });

  group('ExplanationScreen Quick Launch & Orientation Tests', () {
    final List<MethodCall> systemChromeCalls = [];

    setUp(() {
      systemChromeCalls.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (MethodCall methodCall) async {
        systemChromeCalls.add(methodCall);
        return null;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    testWidgets('Quick Launch buttons are immediately visible and launch immersive flat experience on 1 tap', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic>? vrTargetExtra;
      final router = GoRouter(
        initialLocation: '/explanation',
        routes: [
          GoRoute(
            path: '/explanation',
            builder: (context, state) => const ExplanationScreen(
              title: 'Respirazione Aria',
              voicePath: '',
              ambientPath: '',
              sceneName: UnityScenes.airBreathing,
              durationSeconds: 300.0,
            ),
          ),
          GoRoute(
            path: '/vr-experience',
            builder: (context, state) {
              vrTargetExtra = state.extra as Map<String, dynamic>?;
              return const Scaffold(body: Text('VR Target View'));
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

      // Quick Launch buttons are immediately visible without waiting for typewriter
      final immersiveBtn = find.text('AVVIA ESPERIENZA IMMERSIVA');
      final vrBtn = find.text('AVVIA IN VISORE VR');
      expect(immersiveBtn, findsOneWidget);
      expect(vrBtn, findsOneWidget);

      // Tap 1: direct launch into immersive flat mode
      await tester.tap(immersiveBtn);
      await tester.pumpAndSettle();

      expect(vrTargetExtra, isNotNull);
      expect(vrTargetExtra!['experienceId'], 'respirazione_aria');
      expect(vrTargetExtra!['isVrMode'], isFalse);
      expect(vrTargetExtra!['autoStart'], isTrue);

      // Verify orientation was set to landscape
      final orientationCalls = systemChromeCalls
          .where((call) => call.method == 'SystemChrome.setPreferredOrientations')
          .toList();
      expect(orientationCalls.isNotEmpty, isTrue);
      final lastOrientationArgs = orientationCalls.last.arguments as List;
      expect(
        lastOrientationArgs.contains('DeviceOrientation.landscapeLeft') ||
        lastOrientationArgs.contains('DeviceOrientation.landscapeRight'),
        isTrue,
      );
    });

    testWidgets('Quick Launch VR button launches directly into VR Cardboard on 1 tap', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic>? vrTargetExtra;
      final router = GoRouter(
        initialLocation: '/explanation',
        routes: [
          GoRoute(
            path: '/explanation',
            builder: (context, state) => const ExplanationScreen(
              title: 'Meditazione del Mattino (Acqua)',
              voicePath: '',
              ambientPath: '',
              sceneName: UnityScenes.waterMeditationMorning,
              durationSeconds: 600.0,
            ),
          ),
          GoRoute(
            path: '/vr-experience',
            builder: (context, state) {
              vrTargetExtra = state.extra as Map<String, dynamic>?;
              return const Scaffold(body: Text('VR Target View'));
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

      final vrBtn = find.text('AVVIA IN VISORE VR');
      expect(vrBtn, findsOneWidget);

      await tester.tap(vrBtn);
      await tester.pumpAndSettle();

      expect(vrTargetExtra, isNotNull);
      expect(vrTargetExtra!['experienceId'], 'meditazione_mattino_acqua');
      expect(vrTargetExtra!['isVrMode'], isTrue);
      expect(vrTargetExtra!['autoStart'], isTrue);
    });

    testWidgets('Quick Launch for General Meditation routes to meditazione_generale_acqua', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic>? vrTargetExtra;
      final router = GoRouter(
        initialLocation: '/explanation',
        routes: [
          GoRoute(
            path: '/explanation',
            builder: (context, state) => const ExplanationScreen(
              title: 'Meditazione Generale (Gratis)',
              voicePath: '',
              ambientPath: '',
              sceneName: UnityScenes.generalMeditation,
              durationSeconds: 600.0,
            ),
          ),
          GoRoute(
            path: '/vr-experience',
            builder: (context, state) {
              vrTargetExtra = state.extra as Map<String, dynamic>?;
              return const Scaffold(body: Text('VR Target View'));
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

      final vrBtn = find.text('AVVIA IN VISORE VR');
      expect(vrBtn, findsOneWidget);

      await tester.tap(vrBtn);
      await tester.pumpAndSettle();

      expect(vrTargetExtra, isNotNull);
      expect(vrTargetExtra!['experienceId'], 'meditazione_generale_acqua');
      expect(vrTargetExtra!['isVrMode'], isTrue);
      expect(vrTargetExtra!['autoStart'], isTrue);
    });
  });

  group('Samsung Galaxy S24 (Android 16) Gyroscope & 3D Reticle Tests', () {
    final experienceDirs = [
      'respirazione_aria',
      'respirazione_acqua',
      'respirazione_fuoco',
      'respirazione_terra',
      'meditazione_mattino_acqua',
    ];

    test('All 5 WebXR templates implement unified quaternion orientation & getScreenOrientationAngle', () {
      for (final dir in experienceDirs) {
        final file = File('assets/vr_experiences/$dir/index.html');
        expect(file.existsSync(), isTrue, reason: 'index.html in $dir must exist');
        final content = file.readAsStringSync();

        // 1. getScreenOrientationAngle definita con fallback 90 gradi per landscape
        expect(
          content.contains('function getScreenOrientationAngle()'),
          isTrue,
          reason: '$dir must implement getScreenOrientationAngle',
        );
        expect(
          content.contains('innerWidth > window.innerHeight') && content.contains('return 90'),
          isTrue,
          reason: '$dir must safely fallback to 90 degrees in landscape',
        );

        // 2. Moltiplicazione per _q1 (-PI/2 attorno ad X) e _q0 (-orient attorno a Z)
        expect(
          content.contains('_q1') && content.contains('camera.quaternion.multiply(_q1)'),
          isTrue,
          reason: '$dir must multiply by _q1 to align camera forward vector',
        );
        expect(
          content.contains('_q0') && content.contains('camera.quaternion.multiply(_q0)'),
          isTrue,
          reason: '$dir must multiply by _q0 to compensate screen orientation',
        );

        // 3. 3D Reticle (initVRReticle) presente e 2D crosshair rimosso
        expect(
          content.contains('function initVRReticle()'),
          isTrue,
          reason: '$dir must define initVRReticle() in Three.js',
        );
        expect(
          content.contains('vr-crosshair left') || content.contains('vr-crosshair right'),
          isFalse,
          reason: '$dir must NOT contain 2D .vr-crosshair divs in HTML (causes diplopia)',
        );
        expect(
          content.contains('VR_Gaze_Reticle'),
          isTrue,
          reason: '$dir must add VR_Gaze_Reticle 3D group to camera',
        );

        // 4. API window.GuidoVR.recenter e setDeviceOrientation presenti
        expect(
          content.contains('recenter: function()') || content.contains('recenter: function ()'),
          isTrue,
          reason: '$dir must expose window.GuidoVR.recenter',
        );
        expect(
          content.contains('setDeviceOrientation: function') || content.contains('setDeviceOrientation: function ('),
          isTrue,
          reason: '$dir must expose window.GuidoVR.setDeviceOrientation for native sensor injection',
        );

        // 5. Rimozione totale del pulsante Esci da VR al centro di vr-overlay sia in HTML che CSS
        expect(
          content.contains('btn-exit-vr') || content.contains('vr-exit-btn'),
          isFalse,
          reason: '$dir must NOT contain btn-exit-vr or .vr-exit-btn (destroys Cardboard stereopsis)',
        );
      }
    });

    test('All 5 WebXR templates implement Hands-Free Gaze Dwell (2.0s) & 3D Stereoscopic Completion Popup', () {
      for (final dir in experienceDirs) {
        final file = File('assets/vr_experiences/$dir/index.html');
        final content = file.readAsStringSync();

        // 1. updateGazeInteraction definita e chiamata nel loop
        expect(
          content.contains('function updateGazeInteraction('),
          isTrue,
          reason: '$dir must define updateGazeInteraction',
        );
        expect(
          content.contains('updateGazeInteraction(deltaSec)'),
          isTrue,
          reason: '$dir must invoke updateGazeInteraction(deltaSec) in animation loop',
        );

        // 2. 3D Completion Popup con pulsanti ESCI e RIPETI
        expect(
          content.contains('function createVRCompletionPopup()'),
          isTrue,
          reason: '$dir must define createVRCompletionPopup',
        );
        expect(
          content.contains('VR_Completion_Popup'),
          isTrue,
          reason: '$dir must name popup group VR_Completion_Popup',
        );
        expect(
          content.contains("'ESCI'") || content.contains('"ESCI"'),
          isTrue,
          reason: '$dir must include ESCI 3D button',
        );
        expect(
          content.contains("'RIPETI'") || content.contains('"RIPETI"'),
          isTrue,
          reason: '$dir must include RIPETI 3D button',
        );

        // 3. Funzioni di visibilità popup e bridge GuidoVR
        expect(
          content.contains('function showVRCompletionPopup()') && content.contains('function hideVRCompletionPopup()'),
          isTrue,
          reason: '$dir must define showVRCompletionPopup and hideVRCompletionPopup',
        );
        expect(
          content.contains('showCompletionPopup:') && content.contains('hideCompletionPopup:'),
          isTrue,
          reason: '$dir must expose showCompletionPopup and hideCompletionPopup in window.GuidoVR',
        );
      }
    });

    test('All 5 WebXR templates implement Samsung S24 High-DPI Retina (DPR 2.0), FOV 72 & GC-Free Gaze', () {
      for (final dir in experienceDirs) {
        final file = File('assets/vr_experiences/$dir/index.html');
        final content = file.readAsStringSync();

        // 1. .vr-divider 1px senza box-shadow per rendering stereoscopico edge-to-edge
        expect(
          content.contains('box-shadow: none !important;'),
          isTrue,
          reason: '$dir must eliminate box-shadow on .vr-divider for edge-to-edge rendering',
        );
        expect(
          content.contains('width: 1px;'),
          isTrue,
          reason: '$dir must use 1px width for .vr-divider',
        );

        // 2. Calibrazione ottica FOV a 72° in modalità VR (senza distorsioni anamorfiche)
        expect(
          content.contains('camera.fov = 72'),
          isTrue,
          reason: '$dir must calibrate camera.fov to 72 in VR mode to eliminate distortion',
        );

        // 3. Risoluzione Retina High-DPI (DPR fino a 2.0x) per eliminare pixelatura
        expect(
          content.contains('renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2.0))'),
          isTrue,
          reason: '$dir must set High-DPI pixel ratio capped at 2.0 for razor-sharp rendering',
        );

        // 4. Pre-allocazione statica _gazeForwardDir per azzerare GC thrashing a 120 FPS
        expect(
          content.contains('const _gazeForwardDir = new THREE.Vector3();') ||
              content.contains('let _gazeForwardDir = new THREE.Vector3();') ||
              content.contains('_gazeForwardDir = new THREE.Vector3();'),
          isTrue,
          reason: '$dir must pre-allocate _gazeForwardDir statically outside the render loop',
        );

        // 5. Spazio colore sRGB e ACES Filmic Tone Mapping per fedeltà fotorealistica
        expect(
          content.contains('ACESFilmicToneMapping'),
          isTrue,
          reason: '$dir must enable ACESFilmicToneMapping for photorealistic dynamic range',
        );
        expect(
          content.contains('sRGBEncoding') || content.contains('SRGBColorSpace'),
          isTrue,
          reason: '$dir must configure sRGB encoding for vibrant deep contrasts',
        );

        // 6. Auto-focus per interazione zero-touch
        expect(
          content.contains('window.focus()'),
          isTrue,
          reason: '$dir must call window.focus() on DOMContentLoaded',
        );
      }
    });

    test('Meditazione Mattino Acqua implements monotonic clock, Promontory Camera (Z=42, Y=8.2) & Hierarchy Bugfix', () {
      final file = File('assets/vr_experiences/meditazione_mattino_acqua/index.html');
      final content = file.readAsStringSync();

      // 1. Monotonic clock decoupled from audio micro-drift
      expect(
        content.contains('state.currentTime += deltaSec'),
        isTrue,
        reason: 'meditazione_mattino_acqua must advance time monotonically via deltaSec',
      );
      expect(
        content.contains('Math.abs(drift) > 1.2'),
        isTrue,
        reason: 'meditazione_mattino_acqua must only apply hard sync when drift exceeds 1.2s',
      );
      expect(
        content.contains('Math.abs(drift) > 0.02'),
        isFalse,
        reason: 'meditazione_mattino_acqua must NOT perform jittery micro-drift adjustments per frame',
      );

      // 2. Shoreline Promontory Camera (Z=42.0, Y=8.2; dry ground Y=6.5; 1.7m eye height)
      expect(
        content.contains('cameraRig.position.set(0, 8.2, 42.0)'),
        isTrue,
        reason: 'meditazione_mattino_acqua must position cameraRig at (0, 8.2, 42.0) on elevated dry promontory',
      );
      expect(
        content.contains('camera.position.set(0, 0, 0)'),
        isTrue,
        reason: 'meditazione_mattino_acqua must center camera at (0, 0, 0) inside rig for zero neck eccentricity',
      );

      // 3. Three.js Hierarchy Bugfix: camera is strictly a child of cameraRig, NOT scene
      expect(
        content.contains('scene.add(camera)'),
        isFalse,
        reason: 'meditazione_mattino_acqua must NEVER call scene.add(camera) which detaches camera from cameraRig',
      );
      expect(
        content.contains('camera.getWorldPosition(_gazeOrigin)'),
        isTrue,
        reason: 'meditazione_mattino_acqua must use camera.getWorldPosition for VR raycasting',
      );

      // 4. Confinamento geometrico rigido di waterMesh a Z <= 15m (zero acqua sotto i piedi)
      expect(
        content.contains('waterMesh.position.set(0, 0, -415)'),
        isTrue,
        reason: 'meditazione_mattino_acqua must position waterMesh at Z=-415 to terminate strictly at Z=+15',
      );

      // 5. Massi erratici di ancoraggio visivo su altopiano asciutto
      expect(
        content.contains('Foreground Dry Promontory Plateau'),
        isTrue,
        reason: 'meditazione_mattino_acqua must include tactile boulders on dry promontory around observer',
      );
    });

    test('Comfortable view distances for Balloon, Droplet, and Bonfire', () {
      final aria = File('assets/vr_experiences/respirazione_aria/index.html').readAsStringSync();
      expect(aria.contains('BALLOON_BASE_Z: -11.0') || aria.contains('BALLOON_BASE_Z: -11'), isTrue);

      final acqua = File('assets/vr_experiences/respirazione_acqua/index.html').readAsStringSync();
      expect(acqua.contains('DROP_BASE_Z: -4.8'), isTrue);

      final fuoco = File('assets/vr_experiences/respirazione_fuoco/index.html').readAsStringSync();
      expect(fuoco.contains('CAM_INIT_POS_Z: 6.8'), isTrue);
    });

    testWidgets('VrExperienceScreen displays Recenter button when in VR mode', (tester) async {
      tester.view.physicalSize = const Size(2400, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

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
            home: VrExperienceScreen(
              experienceId: 'respirazione_aria',
              isVrMode: true,
              autoStart: true,
            ),
          ),
        ),
      );

      await tester.pump();

      // Recenter button is visible in VR mode
      final recenterBtn = find.byTooltip('Ricalibra Centro');
      expect(recenterBtn, findsOneWidget);

      // Tap on recenter button triggers haptic feedback without exception
      await tester.tap(recenterBtn, warnIfMissed: false);
      await tester.pump();
    });

    test('VrExperienceScreen enforces zero-caching and cache-busting', () {
      final file = File('lib/features/vr_experiences/presentation/vr_experience_screen.dart');
      final content = file.readAsStringSync();

      expect(content.contains('cacheBust: true'), isTrue);
      expect(content.contains('cacheEnabled: false'), isTrue);
      expect(content.contains('cacheMode: CacheMode.LOAD_NO_CACHE'), isTrue);
      expect(content.contains('InAppWebViewController.clearAllCache()'), isTrue);
    });

    testWidgets(
        'VrExperienceScreen displays native Japandi completion overlay with ESCI and RIPETI in normal mode',
        (tester) async {
      tester.view.physicalSize = const Size(2400, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

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
            home: VrExperienceScreen(
              experienceId: 'meditazione_mattino_acqua',
              isVrMode: false,
              autoStart: true,
            ),
          ),
        ),
      );

      await tester.pump();

      // Before completion, overlay is not present
      expect(find.byKey(const Key('vr_session_completion_overlay')), findsNothing);

      // Simulate completion event
      final state = tester.state<VrExperienceScreenState>(find.byType(VrExperienceScreen));
      state.simulateSessionCompleteForTesting({'duration': 420});
      await tester.pump(const Duration(milliseconds: 100));

      // Overlay is now visible with title and buttons
      expect(find.byKey(const Key('vr_session_completion_overlay')), findsOneWidget);
      expect(find.text('Esperienza Completata'), findsOneWidget);
      expect(find.byKey(const Key('btn_completion_exit')), findsOneWidget);
      expect(find.byKey(const Key('btn_completion_repeat')), findsOneWidget);
      expect(find.text('ESCI'), findsOneWidget);
      expect(find.text('RIPETI'), findsOneWidget);

      // Tap on RIPETI hides overlay and resets session completion flag
      await tester.tap(find.byKey(const Key('btn_completion_repeat')), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 100));

      expect(state.isSessionCompletedForTesting, isFalse);
      expect(find.byKey(const Key('vr_session_completion_overlay')), findsNothing);
    });

    testWidgets(
        'VrExperienceScreen displays fallback bar in VR mode upon session completion',
        (tester) async {
      tester.view.physicalSize = const Size(2400, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

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
            home: VrExperienceScreen(
              experienceId: 'respirazione_aria',
              isVrMode: true,
              autoStart: true,
            ),
          ),
        ),
      );

      await tester.pump();

      final state = tester.state<VrExperienceScreenState>(find.byType(VrExperienceScreen));
      state.simulateSessionCompleteForTesting({'cyclesCompleted': 5});
      await tester.pump(const Duration(milliseconds: 100));

      // In VR mode, the fallback bar is visible
      expect(find.byKey(const Key('vr_fallback_completion_bar')), findsOneWidget);
      expect(find.byKey(const Key('btn_vr_fallback_exit')), findsOneWidget);
      expect(find.byKey(const Key('btn_vr_fallback_repeat')), findsOneWidget);

      // Tap on repeat
      await tester.tap(find.byKey(const Key('btn_vr_fallback_repeat')), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 100));

      expect(state.isSessionCompletedForTesting, isFalse);
      expect(find.byKey(const Key('vr_fallback_completion_bar')), findsNothing);
    });

    test('meditazione_mattino_acqua notifyFlutter supports both direct callHandler and GuidoFlutterBridge', () {
      final content = File('assets/vr_experiences/meditazione_mattino_acqua/index.html').readAsStringSync();
      expect(content.contains('window.flutter_inappwebview.callHandler(eventName, data)'), isTrue);
      expect(content.contains('window.GuidoFlutterBridge.postMessage'), isTrue);
    });

    testWidgets(
        'VrExperienceScreen renders identical uniform HUD buttons across all meditations and breathings in both Standard and VR modes',
        (tester) async {
      tester.view.physicalSize = const Size(2400, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      for (final expType in VrExperienceType.values) {
        final container = ProviderContainer(
          overrides: [
            sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
            sharedPrefsProvider.overrideWithValue(prefs),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: VrExperienceScreen(
                experienceId: expType.id,
                isVrMode: false,
                autoStart: true,
              ),
            ),
          ),
        );
        await tester.pump();

        // Verify all 5 uniform HUD buttons exist for every single meditation & breathing
        expect(find.byTooltip('Esci'), findsOneWidget, reason: '${expType.id} must show Esci button');
        expect(find.byTooltip('Pausa'), findsOneWidget, reason: '${expType.id} must show Pausa button');
        expect(find.byTooltip('Muto'), findsOneWidget, reason: '${expType.id} must show Muto button');
        expect(find.byTooltip('Ricalibra Centro'), findsOneWidget, reason: '${expType.id} must show Ricalibra Centro button');
        expect(find.byTooltip('Modalità VR'), findsOneWidget, reason: '${expType.id} must show Modalità VR button');

        container.dispose();
      }
    });

    test('Native Keep-Screen-On (Android FLAG_KEEP_SCREEN_ON & iOS isIdleTimerDisabled) and t=0s Gyroscope are configured', () {
      final mainActivity = File('android/app/src/main/kotlin/com/codepulse/guido/guido/MainActivity.kt').readAsStringSync();
      expect(mainActivity.contains('WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON'), isTrue);
      expect(mainActivity.contains('keepScreenOn'), isTrue);

      final appDelegate = File('ios/Runner/AppDelegate.swift').readAsStringSync();
      expect(appDelegate.contains('isIdleTimerDisabled = true'), isTrue);
      expect(appDelegate.contains('applicationDidBecomeActive'), isTrue);

      final vrScreen = File('lib/features/vr_experiences/presentation/vr_experience_screen.dart').readAsStringSync();
      expect(vrScreen.contains('_guidoApplyNativeOrientation'), isTrue);
      expect(vrScreen.contains('_guidoGyroHooked'), isTrue);
      expect(vrScreen.contains('#mobile-controls-bar, #minimal-controls'), isTrue);
      expect(vrScreen.contains("navigator.wakeLock.request('screen')"), isTrue);
    });

    testWidgets('WolfCartoonWidget renders Nordic/Arctic Wolf across all 5 WolfPose states without error', (tester) async {
      for (final pose in WolfPose.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: WolfCartoonWidget(
                  pose: pose,
                  accentColor: const Color(0xFF06B6D4),
                  isDark: true,
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(WolfCartoonWidget), findsOneWidget);
      }
    });

    test('All 8 WebXR templates suppress gyroscope camera rotation when isVRMode is false', () {
      final templates = [
        'meditazione_mattino_acqua',
        'meditazione_pomeriggio_acqua',
        'meditazione_sera_acqua',
        'meditazione_generale_acqua',
        'respirazione_acqua',
        'respirazione_aria',
        'respirazione_fuoco',
        'respirazione_terra',
      ];

      for (final tmpl in templates) {
        final filePath = 'assets/vr_experiences/$tmpl/index.html';
        final content = File(filePath).readAsStringSync();

        // 1. setDeviceOrientation deve verificare che state.isVRMode sia true
        expect(
          content.contains('setDeviceOrientation') &&
              (content.contains('if (!state.isVRMode) return;') ||
                  content.contains('if (!state.isVRMode) return;')),
          isTrue,
          reason: '$filePath must guard setDeviceOrientation with state.isVRMode check',
        );

        // 2. updateCameraRotation deve applicare la rotazione giroscopica solo se state.isVRMode è true
        expect(
          content.contains('updateCameraRotation') &&
              (content.contains('state.isVRMode') || content.contains('&& state.isVRMode')),
          isTrue,
          reason: '$filePath must guard updateCameraRotation with state.isVRMode',
        );
      }
    });

    testWidgets('VrExperienceScreen displays Japandi VR headset insertion prompt when launched in VR mode', (tester) async {
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
            home: VrExperienceScreen(
              experienceId: 'respirazione_fuoco',
              isVrMode: true,
              autoStart: true,
            ),
          ),
        ),
      );
      await tester.pump();

      // Il popup Japandi per l'inserimento del visore VR deve essere visibile
      expect(find.byKey(const Key('vr_headset_prompt_overlay')), findsOneWidget);
      expect(find.byKey(const Key('vr_headset_prompt_dialog')), findsOneWidget);
      expect(find.byKey(const Key('btn_vr_prompt_back_2d')), findsOneWidget);
      expect(find.byKey(const Key('btn_vr_prompt_start_vr')), findsOneWidget);
      expect(find.text('Inserisci il telefono nel visore'), findsOneWidget);

      final state = tester.state<VrExperienceScreenState>(find.byType(VrExperienceScreen));
      expect(state.isVrHeadsetPromptVisibleForTesting, isTrue);
    });

    testWidgets('VrExperienceScreen dismissing VR headset prompt switches to 2D mode and hides dialog', (tester) async {
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
            home: VrExperienceScreen(
              experienceId: 'respirazione_acqua',
              isVrMode: true,
              autoStart: true,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('vr_headset_prompt_overlay')), findsOneWidget);

      // Tap su Torna in 2D
      await tester.tap(find.byKey(const Key('btn_vr_prompt_back_2d')));
      await tester.pump(const Duration(milliseconds: 100));

      // Il dialog scompare e l'esperienza passa in modalità 2D
      expect(find.byKey(const Key('vr_headset_prompt_overlay')), findsNothing);
      final state = tester.state<VrExperienceScreenState>(find.byType(VrExperienceScreen));
      expect(state.isVrHeadsetPromptVisibleForTesting, isFalse);
    });

    testWidgets('VrExperienceScreen confirming VR headset prompt keeps VR mode and dismisses dialog', (tester) async {
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
            home: VrExperienceScreen(
              experienceId: 'respirazione_terra',
              isVrMode: true,
              autoStart: true,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('vr_headset_prompt_overlay')), findsOneWidget);

      // Tap su "Sono pronto • Inizia VR"
      await tester.tap(find.byKey(const Key('btn_vr_prompt_start_vr')));
      await tester.pump(const Duration(milliseconds: 100));

      // Il popup scompare e si resta in VR
      expect(find.byKey(const Key('vr_headset_prompt_overlay')), findsNothing);
      final state = tester.state<VrExperienceScreenState>(find.byType(VrExperienceScreen));
      expect(state.isVrHeadsetPromptVisibleForTesting, isFalse);
    });

    testWidgets('VrExperienceScreen launching in 2D does NOT display VR headset prompt, pressing VR button displays prompt', (tester) async {
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
            home: VrExperienceScreen(
              experienceId: 'meditazione_mattino_acqua',
              isVrMode: false,
              autoStart: true,
            ),
          ),
        ),
      );
      await tester.pump();

      // In modalità 2D all'avvio, nessun popup di inserimento visore
      expect(find.byKey(const Key('vr_headset_prompt_overlay')), findsNothing);

      // Simula il completamento del caricamento della WebView
      final state = tester.state<VrExperienceScreenState>(find.byType(VrExperienceScreen));
      state.simulateWebReadyForTesting();
      await tester.pump(const Duration(milliseconds: 700));

      // Tap sul pulsante VR nell'HUD
      expect(find.byKey(const Key('btn_hud_vr_mode')), findsOneWidget);
      await tester.tap(find.byKey(const Key('btn_hud_vr_mode')));
      await tester.pump(const Duration(milliseconds: 100));

      // Ora il popup Japandi di conferma inserimento visore compare
      expect(find.byKey(const Key('vr_headset_prompt_overlay')), findsOneWidget);
      expect(find.byKey(const Key('btn_vr_prompt_start_vr')), findsOneWidget);
      expect(state.isVrHeadsetPromptVisibleForTesting, isTrue);
    });

    test('All 8 Experiences Dual-Voice and Audio Balance Quality Gate', () {
      final experiences = [
        {'folder': 'meditazione_mattino_acqua', 'isMed': true},
        {'folder': 'meditazione_pomeriggio_acqua', 'isMed': true},
        {'folder': 'meditazione_sera_acqua', 'isMed': true},
        {'folder': 'meditazione_generale_acqua', 'isMed': true},
        {'folder': 'respirazione_acqua', 'isMed': false},
        {'folder': 'respirazione_aria', 'isMed': false},
        {'folder': 'respirazione_fuoco', 'isMed': false},
        {'folder': 'respirazione_terra', 'isMed': false},
      ];

      for (final exp in experiences) {
        final folder = exp['folder'] as String;
        final isMed = exp['isMed'] as bool;
        final femaleFileName = isMed ? 'voice_it.mp3' : 'voice_f.mp3';

        // 1. Verifica file voce maschile (voice_m.mp3)
        final voiceM = File('assets/vr_experiences/$folder/audio/voice_m.mp3');
        expect(voiceM.existsSync(), isTrue, reason: '$folder must contain audio/voice_m.mp3');
        expect(voiceM.lengthSync(), greaterThan(500000), reason: '$folder voice_m.mp3 must be a valid audio file');

        // 2. Verifica file voce femminile (voice_it.mp3 / voice_f.mp3)
        final voiceF = File('assets/vr_experiences/$folder/audio/$femaleFileName');
        expect(voiceF.existsSync(), isTrue, reason: '$folder must contain audio/$femaleFileName');
        expect(voiceF.lengthSync(), greaterThan(500000), reason: '$folder $femaleFileName must be a valid audio file');

        // 3. I file maschile e femminile NON devono essere identici
        final bytesM = voiceM.readAsBytesSync();
        final bytesF = voiceF.readAsBytesSync();
        expect(listEquals(bytesM, bytesF), isFalse,
            reason: '$folder voice_m.mp3 and $femaleFileName must not be identical');

        // 4. Verifica template HTML per selezione voce, caricamento e bilanciamento volumi
        final htmlFile = File('assets/vr_experiences/$folder/index.html');
        expect(htmlFile.existsSync(), isTrue);
        final html = htmlFile.readAsStringSync();

        // Nessun src hardcoded nell'elemento audio-voice (evita preload forzato della voce femminile)
        expect(html.contains('<audio id="audio-voice" src="') ||
               html.contains('<audio id="audio-voice" preload="auto" playsinline src="'), isFalse,
            reason: '$folder audio-voice tag must not contain hardcoded src attribute');

        // Chiamata audioVoice.load() presente
        expect(html.contains('audioVoice.load()'), isTrue,
            reason: '$folder must call audioVoice.load() when rebinding voice source');

        // Parametro query voice e switch a voice_m.mp3
        expect(html.contains("urlParams.get('voice')") || html.contains('urlParams.get("voice")'), isTrue,
            reason: '$folder index.html must parse URL query voice parameter');
        expect(html.contains('audio/voice_m.mp3'), isTrue,
            reason: '$folder index.html must support audio/voice_m.mp3');

        // Volumi bilanciati: voce a 0.95, musica sottofondo a 0.25
        expect(html.contains('0.95'), isTrue,
            reason: '$folder must balance voice volume to 0.95');
        expect(html.contains('0.25'), isTrue,
            reason: '$folder must balance background music volume to 0.25');

        // Giroscopio protetto solo per modalità VR
        expect(html.contains('isVRMode'), isTrue,
            reason: '$folder must guard gyroscope controls with isVRMode');
      }
    });

    test('SettingsState defaults to Femminile (1) and toggles cleanly', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
        ],
      );

      final state = container.read(settingsProvider);
      expect(state.voiceSex, 1, reason: 'Default voiceSex must be 1 (Michela / Femminile)');

      final notifier = container.read(settingsProvider.notifier);
      await notifier.changeVoiceSex(0);
      expect(container.read(settingsProvider).voiceSex, 0, reason: 'voiceSex must switch to 0 (Luigi / Maschile)');
      expect(prefs.getInt('VoiceSex'), 0);

      await notifier.changeVoiceSex(1);
      expect(container.read(settingsProvider).voiceSex, 1, reason: 'voiceSex must switch to 1 (Michela / Femminile)');
      expect(prefs.getInt('VoiceSex'), 1);
    });
  });
}

