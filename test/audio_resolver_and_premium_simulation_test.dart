import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guido/core/audio/audio_resolver_service.dart';
import 'package:guido/core/database/settings_provider.dart';
import 'package:guido/core/database/app_initializer_provider.dart';
import 'package:guido/core/unity/unity_bridge_dto.dart';
import 'package:guido/features/menu/presentation/settings_tab.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioResolverService Unit Tests', () {
    test('Aria Breathing resolves Luigi for voiceSex 0 and Michela for voiceSex 1', () {
      final luigiBundle = AudioResolverService.resolveBundle(
        title: 'Respirazione Aria',
        voiceSex: 0,
      );
      expect(luigiBundle.voiceActorName, 'Luigi');
      expect(luigiBundle.voicePath, contains('Voce_Luigi'));
      expect(luigiBundle.voicePath, contains('percorso aria'));
      expect(luigiBundle.sceneName, UnityScenes.airBreathing);
      expect(luigiBundle.ambientPath, contains('RespAria.mp3'));

      final michelaBundle = AudioResolverService.resolveBundle(
        title: 'Respirazione Aria',
        voiceSex: 1,
      );
      expect(michelaBundle.voiceActorName, 'Michela');
      expect(michelaBundle.voicePath, contains('Respirazioni/Aria'));
      expect(michelaBundle.sceneName, UnityScenes.airBreathing);
    });

    test('Fuoco Breathing resolves Luigi for voiceSex 0 and Michela for voiceSex 1', () {
      final luigiBundle = AudioResolverService.resolveBundle(
        title: 'Respirazione Fuoco',
        voiceSex: 0,
      );
      expect(luigiBundle.voiceActorName, 'Luigi');
      expect(luigiBundle.voicePath, contains('Voce_Luigi'));
      expect(luigiBundle.voicePath, contains('Fuoco'));
      expect(luigiBundle.sceneName, UnityScenes.fireBreathing);

      final michelaBundle = AudioResolverService.resolveBundle(
        title: 'Respirazione Fuoco',
        voiceSex: 1,
      );
      expect(michelaBundle.voiceActorName, 'Michela');
      expect(michelaBundle.voicePath, contains('Respirazioni/Fuoco'));
      expect(michelaBundle.sceneName, UnityScenes.fireBreathing);
    });

    test('Terra Breathing resolves Luigi for voiceSex 0 and Michela for voiceSex 1', () {
      final luigiBundle = AudioResolverService.resolveBundle(
        title: 'Respirazione Terra',
        voiceSex: 0,
      );
      expect(luigiBundle.voiceActorName, 'Luigi');
      expect(luigiBundle.voicePath, contains('Voce_Luigi'));
      expect(luigiBundle.voicePath, contains('terra'));
      expect(luigiBundle.sceneName, UnityScenes.earthBreathing);

      final michelaBundle = AudioResolverService.resolveBundle(
        title: 'Respirazione Terra',
        voiceSex: 1,
      );
      expect(michelaBundle.voiceActorName, 'Michela');
      expect(michelaBundle.voicePath, contains('Respirazioni/Terra'));
      expect(michelaBundle.sceneName, UnityScenes.earthBreathing);
    });

    test('Acqua Breathing falls back gracefully on Michela for voiceSex 0', () {
      final bundle = AudioResolverService.resolveBundle(
        title: 'Respirazione Acqua',
        voiceSex: 0,
      );
      expect(bundle.voiceActorName, 'Michela');
      expect(bundle.voicePath, contains('Respirazione acqua.mp3'));
      expect(bundle.sceneName, UnityScenes.waterBreathing);
    });

    test('Procedimento resolution selects procedural voice tracks', () {
      final terraProcedimento = AudioResolverService.resolveBundle(
        title: 'Procedimento Terra',
        voiceSex: 0,
      );
      expect(terraProcedimento.voicePath, contains('procedimento'));
      expect(terraProcedimento.sceneName, UnityScenes.earthMeditation);

      final fuocoProcedimento = AudioResolverService.resolveBundle(
        title: 'Procedimento Fuoco',
        voiceSex: 1,
      );
      expect(fuocoProcedimento.voicePath, contains('Procedimento'));
      expect(fuocoProcedimento.sceneName, UnityScenes.fireMeditation);
    });

    test('General and Moment Meditations resolve correctly', () {
      final generalBundle = AudioResolverService.resolveBundle(
        title: 'Meditazione Generale',
      );
      expect(generalBundle.sceneName, UnityScenes.generalMeditation);
      expect(generalBundle.durationSeconds, 600.0);

      final morningBundle = AudioResolverService.resolveBundle(
        title: 'Meditazione del Mattino',
      );
      expect(morningBundle.sceneName, UnityScenes.waterMeditation);
      expect(morningBundle.ambientPath, contains('MATTINO.mp3'));
    });
  });

  group('Premium Simulation and Settings Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('togglePremiumSimulation switches isUnlocked state and persists', () async {
      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
        ],
      );

      final notifier = container.read(settingsProvider.notifier);
      expect(container.read(settingsProvider).isUnlocked, false);

      await notifier.togglePremiumSimulation();
      expect(container.read(settingsProvider).isUnlocked, true);
      expect(prefs.getBool("IsUnlocked"), true);

      await notifier.togglePremiumSimulation();
      expect(container.read(settingsProvider).isUnlocked, false);
      expect(prefs.getBool("IsUnlocked"), false);

      await notifier.togglePremiumSimulation(true);
      expect(container.read(settingsProvider).isUnlocked, true);
    });

    testWidgets('SettingsTab renders Premium Simulator switch and Premium button', (tester) async {
      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: SettingsTab(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('SIMULATORE PACCHETTO PREMIUM'), findsOneWidget);
      expect(find.byType(Switch), findsWidgets);
      expect(find.textContaining('PACCHETTI PREMIUM'), findsOneWidget);
    });
  });
}
