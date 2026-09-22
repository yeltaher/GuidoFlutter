import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guido/app/router/app_router.dart';
import 'package:guido/core/unity/unity_bridge_dto.dart';
import 'package:guido/core/unity/unity_session_controller.dart';
import 'package:guido/features/meditation/presentation/unity_experience_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UnityBridge DTO Unit Tests', () {
    test('SessionConfigDto serialization and deserialization matches C# schema', () {
      final config = SessionConfigDto(
        sceneName: 'Procedimento acqua',
        language: 0,
        durationSeconds: 900.0,
        isVrMode: true,
        qualityPreset: 0,
      );

      final jsonMap = config.toJson();
      expect(jsonMap['sceneName'], 'Procedimento acqua');
      expect(jsonMap['language'], 0);
      expect(jsonMap['durationSeconds'], 900.0);
      expect(jsonMap['isVrMode'], true);
      expect(jsonMap['qualityPreset'], 0);

      final jsonStr = config.toJsonString();
      final decoded = SessionConfigDto.fromJson(
        jsonDecode(jsonStr) as Map<String, dynamic>,
      );

      expect(decoded.sceneName, config.sceneName);
      expect(decoded.language, config.language);
      expect(decoded.durationSeconds, config.durationSeconds);
      expect(decoded.isVrMode, config.isVrMode);
      expect(decoded.qualityPreset, config.qualityPreset);
      expect(decoded.quality, QualityPreset.highFidelity);
      expect(decoded.appLanguage, AppLanguage.italian);
    });

    test('SessionProgressDto serialization and deserialization matches C# schema', () {
      final progress = SessionProgressDto(
        sessionId: 'sess_123',
        sceneName: 'Respirazione acqua',
        elapsedSeconds: 45.5,
        totalDurationSeconds: 300.0,
        progressNormalized: 0.1516,
        currentPhase: 'Inhale',
        userHeartRateOrState: 68,
      );

      final jsonMap = progress.toJson();
      expect(jsonMap['sessionId'], 'sess_123');
      expect(jsonMap['sceneName'], 'Respirazione acqua');
      expect(jsonMap['elapsedSeconds'], 45.5);
      expect(jsonMap['totalDurationSeconds'], 300.0);
      expect(jsonMap['progressNormalized'], 0.1516);
      expect(jsonMap['currentPhase'], 'Inhale');
      expect(jsonMap['userHeartRateOrState'], 68);

      final jsonStr = progress.toJsonString();
      final decoded = SessionProgressDto.fromJson(
        jsonDecode(jsonStr) as Map<String, dynamic>,
      );

      expect(decoded.sessionId, progress.sessionId);
      expect(decoded.breathingPhase, BreathingPhase.inhale);
    });

    test('SessionSummaryDto serialization and deserialization matches C# schema', () {
      final summary = SessionSummaryDto(
        sessionId: 'sess_456',
        sceneName: 'Procedimento fuoco',
        totalDurationSeconds: 900.0,
        completedSuccessfully: true,
        xpEarned: 30,
        timestamp: 1773000000000,
      );

      final jsonMap = summary.toJson();
      expect(jsonMap['sessionId'], 'sess_456');
      expect(jsonMap['completedSuccessfully'], true);
      expect(jsonMap['xpEarned'], 30);

      final jsonStr = summary.toJsonString();
      final decoded = SessionSummaryDto.fromJson(
        jsonDecode(jsonStr) as Map<String, dynamic>,
      );

      expect(decoded.sessionId, summary.sessionId);
      expect(decoded.completedSuccessfully, true);
      expect(decoded.xpEarned, 30);
    });

    test('JsonRpcRequestDto and JsonRpcResponseDto follow JSON-RPC 2.0 specs', () {
      final req = JsonRpcRequestDto(
        method: 'startSession',
        params: '{"sceneName":"Procedimento aria"}',
        id: 1,
      );

      expect(req.jsonrpc, '2.0');
      expect(req.method, 'startSession');
      expect(req.id, 1);

      final res = JsonRpcResponseDto(
        jsonrpc: '2.0',
        result: 'ok',
        error: '',
        id: 1,
      );

      expect(res.isSuccess, true);
      expect(res.result, 'ok');
    });

    test('QualityPreset enum correctly distinguishes HighFidelity and BalancedEco', () {
      expect(QualityPreset.fromValue(0), QualityPreset.highFidelity);
      expect(QualityPreset.fromValue(1), QualityPreset.balancedEco);

      expect(QualityPreset.highFidelity.getDisplayName(true), contains('Alta Fedeltà'));
      expect(QualityPreset.balancedEco.getDisplayName(true), contains('Risparmio'));
    });

    test('BreathingPhase fromString handles diverse inputs', () {
      expect(BreathingPhase.fromString('inhale'), BreathingPhase.inhale);
      expect(BreathingPhase.fromString('INSPIRA'), BreathingPhase.inhale);
      expect(BreathingPhase.fromString('HoldIn'), BreathingPhase.holdIn);
      expect(BreathingPhase.fromString('exhale'), BreathingPhase.exhale);
      expect(BreathingPhase.fromString('hold out'), BreathingPhase.holdOut);
    });
  });

  group('UnitySessionController State Machine Tests', () {
    test('Initial state is empty and not loaded', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(unitySessionControllerProvider);
      expect(state.isUnityLoaded, false);
      expect(state.isSceneLoaded, false);
      expect(state.isPlaying, false);
      expect(state.isCompleted, false);
    });

    test('Receiving onSessionProgress updates state correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(unitySessionControllerProvider.notifier);

      final progressDto = SessionProgressDto(
        sessionId: 'sess_test',
        sceneName: 'Procedimento acqua',
        elapsedSeconds: 60.0,
        totalDurationSeconds: 600.0,
        progressNormalized: 0.1,
        currentPhase: 'Inhale',
      );

      final rpcMessage = jsonEncode({
        'jsonrpc': '2.0',
        'method': 'onSessionProgress',
        'params': progressDto.toJsonString(),
        'id': 0,
      });

      notifier.onUnityMessage(rpcMessage);

      final updatedState = container.read(unitySessionControllerProvider);
      expect(updatedState.elapsedSeconds, 60.0);
      expect(updatedState.totalDurationSeconds, 600.0);
      expect(updatedState.progressNormalized, 0.1);
      expect(updatedState.currentBreathingPhase, BreathingPhase.inhale);
      expect(updatedState.isPlaying, true);
    });

    test('startSession initializes activeConfig, isPlaying and duration', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(unitySessionControllerProvider.notifier);
      final config = const SessionConfigDto(
        sceneName: UnityScenes.fireBreathing,
        durationSeconds: 300.0,
        isVrMode: true,
      );

      await notifier.startSession(config);

      final state = container.read(unitySessionControllerProvider);
      expect(state.isWaitingForUnity, true);
      expect(state.isPlaying, false);
      expect(state.activeConfig?.sceneName, UnityScenes.fireBreathing);
      expect(state.totalDurationSeconds, 300.0);

      await notifier.pauseSession();
      expect(container.read(unitySessionControllerProvider).isPlaying, false);

      await notifier.resumeSession();
      expect(container.read(unitySessionControllerProvider).isPlaying, true);

      await notifier.stopSession();
      expect(container.read(unitySessionControllerProvider).isPlaying, false);

      notifier.resetSession();
      final resetState = container.read(unitySessionControllerProvider);
      expect(resetState.isPlaying, false);
      expect(resetState.isUnityLoaded, false);
      expect(resetState.elapsedSeconds, 0.0);
    });

    test('onUnityMessage handles JSON string tokens resiliently ("READY", "SCENE_LOADED")', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(unitySessionControllerProvider.notifier);

      // JSON encoded string token '"READY"'
      notifier.onUnityMessage('"READY"');
      expect(container.read(unitySessionControllerProvider).isUnityLoaded, true);

      // JSON encoded string token '"SCENE_LOADED"'
      notifier.onUnityMessage('"SCENE_LOADED"');
      expect(container.read(unitySessionControllerProvider).isSceneLoaded, true);

      // JSON encoded string breathing token '"inhale"'
      notifier.onUnityMessage('"inhale"');
      expect(
        container.read(unitySessionControllerProvider).currentBreathingPhase,
        BreathingPhase.inhale,
      );

      // Plain raw string tokens without JSON quotes
      notifier.onUnityMessage('holdIn');
      expect(
        container.read(unitySessionControllerProvider).currentBreathingPhase,
        BreathingPhase.holdIn,
      );

      // Malformed string should not throw and degrade gracefully
      notifier.onUnityMessage('{invalid json string}');
      expect(container.read(unitySessionControllerProvider).isSceneLoaded, true);
    });
  });

  group('UnityScenes 9 Canonical Scenes Mapping Tests', () {
    test('All 9 canonical scene constants match the user requirements exactly', () {
      expect(UnityScenes.waterBreathing, 'Acqua resp');
      expect(UnityScenes.waterMeditation, 'Procedimento acqua');
      expect(UnityScenes.airBreathing, 'Aria respirazione');
      expect(UnityScenes.airMeditation, 'Procedimento aria');
      expect(UnityScenes.fireBreathing, 'Fuoco resp');
      expect(UnityScenes.fireMeditation, 'Procedimento fuoco');
      expect(UnityScenes.earthBreathing, 'Respirazione terra');
      expect(UnityScenes.earthMeditation, 'Procedimento terra');
      expect(UnityScenes.generalMeditation, 'Med generale');

      expect(UnityScenes.allScenes.length, 9);
      expect(UnityScenes.allScenes, contains('Acqua resp'));
      expect(UnityScenes.allScenes, contains('Procedimento acqua'));
      expect(UnityScenes.allScenes, contains('Aria respirazione'));
      expect(UnityScenes.allScenes, contains('Procedimento aria'));
      expect(UnityScenes.allScenes, contains('Fuoco resp'));
      expect(UnityScenes.allScenes, contains('Procedimento fuoco'));
      expect(UnityScenes.allScenes, contains('Respirazione terra'));
      expect(UnityScenes.allScenes, contains('Procedimento terra'));
      expect(UnityScenes.allScenes, contains('Med generale'));
    });

    test('resolveSceneName resolves explicitly provided scenes', () {
      for (final scene in UnityScenes.allScenes) {
        expect(
          UnityScenes.resolveSceneName(
            explicitSceneName: scene,
            title: 'Qualsiasi Titolo',
          ),
          scene,
        );
      }
    });

    test('resolveSceneName correctly infers the 9 scenes from title and session type', () {
      // 1. Acqua respirazione
      expect(
        UnityScenes.resolveSceneName(title: 'Respirazione Acqua', isBreathing: true),
        UnityScenes.waterBreathing,
      );
      // 2. Acqua meditazione
      expect(
        UnityScenes.resolveSceneName(title: 'Percorso Acqua Mattina'),
        UnityScenes.waterMeditation,
      );
      expect(
        UnityScenes.resolveSceneName(title: 'Percorso Acqua (Pomeriggio)'),
        UnityScenes.waterMeditation,
      );
      expect(
        UnityScenes.resolveSceneName(title: 'Percorso Acqua (Sera)'),
        UnityScenes.waterMeditation,
      );
      expect(
        UnityScenes.resolveSceneName(title: 'Morning Flow'),
        UnityScenes.waterMeditation,
      );
      // 3. Aria respirazione
      expect(
        UnityScenes.resolveSceneName(title: 'Respirazione Aria', isBreathing: true),
        UnityScenes.airBreathing,
      );
      // 4. Aria meditazione
      expect(
        UnityScenes.resolveSceneName(title: 'Percorso Aria'),
        UnityScenes.airMeditation,
      );
      // 5. Fuoco respirazione
      expect(
        UnityScenes.resolveSceneName(title: 'Respirazione Fuoco', isBreathing: true),
        UnityScenes.fireBreathing,
      );
      // 6. Fuoco meditazione
      expect(
        UnityScenes.resolveSceneName(title: 'Percorso Fuoco'),
        UnityScenes.fireMeditation,
      );
      // 7. Terra respirazione
      expect(
        UnityScenes.resolveSceneName(title: 'Respirazione Terra', isBreathing: true),
        UnityScenes.earthBreathing,
      );
      // 8. Terra meditazione
      expect(
        UnityScenes.resolveSceneName(title: 'Percorso Terra'),
        UnityScenes.earthMeditation,
      );
      // 9. Meditazione generale
      expect(
        UnityScenes.resolveSceneName(title: 'Meditazione Generale'),
        UnityScenes.generalMeditation,
      );
    });
  });

  group('GoRouter Defensive Route Parameter Extraction Tests', () {
    testWidgets('Builds /unity-experience with string parameters from deep links without TypeError', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final router = container.read(appRouterProvider);
      router.go('/unity-experience?isVrMode=true&title=DeepLink+Session&durationSeconds=180&sceneName=Procedimento+acqua');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pump();

      final screen = tester.widget<UnityExperienceScreen>(find.byType(UnityExperienceScreen));
      expect(screen.title, 'DeepLink Session');
      expect(screen.isVrMode, true);
      expect(screen.durationSeconds, 180.0);
      expect(screen.sceneName, 'Procedimento acqua');
    });

    testWidgets('Builds /unity-experience with boolean string "1" and fallback defaults', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final router = container.read(appRouterProvider);
      router.go('/unity-experience?isVrMode=1');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pump();

      final screen = tester.widget<UnityExperienceScreen>(find.byType(UnityExperienceScreen));
      expect(screen.title, 'Esperienza Immersiva');
      expect(screen.isVrMode, true);
      expect(screen.durationSeconds, 300.0);
      expect(screen.sceneName, 'Scena Zen 3D');
    });

    testWidgets('Builds /unity-experience with Map<dynamic, dynamic> extra', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final router = container.read(appRouterProvider);
      router.go('/unity-experience', extra: <dynamic, dynamic>{
        'title': 'Dynamic Map Title',
        'isVrMode': false,
        'durationSeconds': 600,
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pump();

      final screen = tester.widget<UnityExperienceScreen>(find.byType(UnityExperienceScreen));
      expect(screen.title, 'Dynamic Map Title');
      expect(screen.isVrMode, false);
      expect(screen.durationSeconds, 600.0);
      expect(screen.sceneName, 'Scena Zen 3D');
    });
  });
}

