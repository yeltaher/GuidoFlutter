import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:guido/core/session/zen_session_dto.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Session DTO Unit Tests', () {
    test('SessionConfigDto serialization and deserialization matches schema', () {
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

    test('SessionProgressDto serialization and deserialization matches schema', () {
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

    test('SessionSummaryDto serialization and deserialization matches schema', () {
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

    test('SessionConfigDto correctly serializes isVrMode true and false for stereo and mono rendering', () {
      final vrConfig = SessionConfigDto(
        sceneName: 'Procedimento acqua',
        language: 0,
        durationSeconds: 300.0,
        isVrMode: true,
        qualityPreset: 0,
      );
      expect(vrConfig.isVrMode, true);
      expect(vrConfig.toJson()['isVrMode'], true);

      final monoConfig = SessionConfigDto(
        sceneName: 'Procedimento acqua',
        language: 0,
        durationSeconds: 300.0,
        isVrMode: false,
        qualityPreset: 0,
      );
      expect(monoConfig.isVrMode, false);
      expect(monoConfig.toJson()['isVrMode'], false);
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

    test('ZenScenes resolveSceneName canonical mappings', () {
      expect(ZenScenes.resolveSceneName(title: 'Meditazione Mattino'), ZenScenes.waterMeditationMorning);
      expect(ZenScenes.resolveSceneName(title: 'Respirazione Acqua', isBreathing: true), ZenScenes.waterBreathing);
      expect(ZenScenes.resolveSceneName(title: 'Respirazione Fuoco', isBreathing: true), ZenScenes.fireBreathing);
      expect(ZenScenes.resolveSceneName(title: 'Respirazione Aria', isBreathing: true), ZenScenes.airBreathing);
      expect(ZenScenes.resolveSceneName(title: 'Respirazione Terra', isBreathing: true), ZenScenes.earthBreathing);
      expect(ZenScenes.resolveSceneName(title: 'Meditazione Sera'), ZenScenes.waterMeditationEvening);
      expect(ZenScenes.resolveSceneName(title: 'Meditazione Pomeriggio'), ZenScenes.waterMeditationAfternoon);
      expect(ZenScenes.resolveSceneName(title: 'Meditazione Generale'), ZenScenes.generalMeditation);
    });

    test('BreathPhaseEventDto serialization and deserialization', () {
      const event = BreathPhaseEventDto(
        phase: BreathingPhase.holdIn,
        element: BreathingElement.water,
        phaseDurationSeconds: 4.5,
        cycleIndex: 2,
      );
      final json = event.toJson();
      final fromJson = BreathPhaseEventDto.fromJson(json);

      expect(fromJson.phase, BreathingPhase.holdIn);
      expect(fromJson.element, BreathingElement.water);
      expect(fromJson.phaseDurationSeconds, 4.5);
      expect(fromJson.cycleIndex, 2);
    });

    test('CameraRotationDto serialization matches schema', () {
      const rot = CameraRotationDto(dx: 12.5, dy: -4.2);
      final json = rot.toJson();
      final fromJson = CameraRotationDto.fromJson(json);

      expect(fromJson.dx, 12.5);
      expect(fromJson.dy, -4.2);
    });
  });
}
