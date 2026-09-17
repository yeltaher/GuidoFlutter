import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget_2/flutter_unity_widget.dart';
import '../database/repositories/user_repository.dart';
import 'unity_bridge_dto.dart';

/// State representation for an active or preparing Unity UaaL session.
class UnitySessionState {
  final bool isUnityLoaded;
  final bool isSceneLoaded;
  final bool isPlaying;
  final bool isCompleted;
  final SessionConfigDto? activeConfig;
  final SessionProgressDto? currentProgress;
  final BreathingPhase currentBreathingPhase;
  final SessionSummaryDto? lastSummary;
  final String? errorMessage;
  final double elapsedSeconds;
  final double totalDurationSeconds;
  final double progressNormalized;

  const UnitySessionState({
    this.isUnityLoaded = false,
    this.isSceneLoaded = false,
    this.isPlaying = false,
    this.isCompleted = false,
    this.activeConfig,
    this.currentProgress,
    this.currentBreathingPhase = BreathingPhase.inhale,
    this.lastSummary,
    this.errorMessage,
    this.elapsedSeconds = 0.0,
    this.totalDurationSeconds = 0.0,
    this.progressNormalized = 0.0,
  });

  UnitySessionState copyWith({
    bool? isUnityLoaded,
    bool? isSceneLoaded,
    bool? isPlaying,
    bool? isCompleted,
    SessionConfigDto? activeConfig,
    SessionProgressDto? currentProgress,
    BreathingPhase? currentBreathingPhase,
    SessionSummaryDto? lastSummary,
    String? errorMessage,
    double? elapsedSeconds,
    double? totalDurationSeconds,
    double? progressNormalized,
  }) {
    return UnitySessionState(
      isUnityLoaded: isUnityLoaded ?? this.isUnityLoaded,
      isSceneLoaded: isSceneLoaded ?? this.isSceneLoaded,
      isPlaying: isPlaying ?? this.isPlaying,
      isCompleted: isCompleted ?? this.isCompleted,
      activeConfig: activeConfig ?? this.activeConfig,
      currentProgress: currentProgress ?? this.currentProgress,
      currentBreathingPhase:
          currentBreathingPhase ?? this.currentBreathingPhase,
      lastSummary: lastSummary ?? this.lastSummary,
      errorMessage: errorMessage,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      progressNormalized: progressNormalized ?? this.progressNormalized,
    );
  }
}

/// Riverpod Controller managing Unity UaaL lifecycle, RPC dispatching,
/// real-time telemetry, haptic sync, and database persistence.
class UnitySessionController extends Notifier<UnitySessionState> {
  UnityWidgetController? _unityWidgetController;
  Timer? _heartbeatTimer;

  static const String _unityBridgeGameObjectName = 'FlutterBridgeManager';
  static const String _unityBridgeMethodName = 'OnFlutterMessage';

  @override
  UnitySessionState build() {
    ref.onDispose(_stopHeartbeat);
    return const UnitySessionState();
  }

  void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isPlaying || state.isCompleted) {
        timer.cancel();
        return;
      }
      final newElapsed = state.elapsedSeconds + 1.0;
      final total = state.totalDurationSeconds > 0
          ? state.totalDurationSeconds
          : 300.0;
      final progress = (newElapsed / total).clamp(0.0, 1.0);

      // Sincronizzazione respirazione 4-4-4-4 automatica se non fornita da Unity
      BreathingPhase phase = state.currentBreathingPhase;
      final scene = state.activeConfig?.sceneName.toLowerCase() ?? '';
      final isBreathing = scene.contains('resp') || scene.contains('breath');
      if (isBreathing) {
        final cycle = newElapsed.toInt() % 16;
        if (cycle < 4) {
          phase = BreathingPhase.inhale;
        } else if (cycle < 8) {
          phase = BreathingPhase.holdIn;
        } else if (cycle < 12) {
          phase = BreathingPhase.exhale;
        } else {
          phase = BreathingPhase.holdOut;
        }
        if (phase != state.currentBreathingPhase) {
          _triggerHapticFeedbackForPhase(phase);
        }
      }

      state = state.copyWith(
        elapsedSeconds: newElapsed,
        progressNormalized: progress,
        currentBreathingPhase: phase,
      );

      if (newElapsed >= total) {
        timer.cancel();
        _applySessionSummary(
          SessionSummaryDto(
            sessionId: 'sess_${DateTime.now().millisecondsSinceEpoch}',
            sceneName: state.activeConfig?.sceneName ?? 'Sessione Zen 3D',
            totalDurationSeconds: newElapsed,
            completedSuccessfully: true,
            xpEarned: (total / 60).ceil() * 2 + 10,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Called when UnityWidget is attached and controller is ready.
  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
    state = state.copyWith(isUnityLoaded: true);
    debugPrint('[UnitySessionController] Unity Widget Controller attached.');

    // If an activeConfig was queued before Unity finished loading, send it now
    if (state.activeConfig != null) {
      _sendStartSessionToUnity(state.activeConfig!);
    }
  }

  /// Detaches the controller reference upon screen unmount.
  void detachUnityWidgetController() {
    _unityWidgetController = null;
    debugPrint('[UnitySessionController] Unity Widget Controller detached.');
  }

  /// Called by UnityWidget onUnitySceneLoaded callback.
  void onUnitySceneLoaded(SceneLoaded? scene) {
    debugPrint('[UnitySessionController] Scene loaded in Unity: ${scene?.name}');
    state = state.copyWith(isSceneLoaded: true);
  }

  /// Called by UnityWidget onUnityUnloaded callback.
  void onUnityUnloaded() {
    debugPrint('[UnitySessionController] Unity engine unloaded.');
    _stopHeartbeat();
    state = state.copyWith(
      isUnityLoaded: false,
      isSceneLoaded: false,
      isPlaying: false,
    );
  }

  /// Primary message handler parsing events and telemetry incoming from Unity.
  void onUnityMessage(dynamic message) {
    if (message == null) return;
    final String rawStr = message.toString().trim();
    if (rawStr.isEmpty) return;

    debugPrint('[UnitySessionController <- Unity] $rawStr');

    try {
      final decoded = jsonDecode(rawStr);
      if (decoded is Map<String, dynamic>) {
        // 1. JSON-RPC 2.0 format
        if (decoded.containsKey('method')) {
          _handleRpcMethod(
            decoded['method'] as String? ?? '',
            decoded['params'] ?? '',
          );
          return;
        }

        // 2. Direct telemetry format
        if (decoded.containsKey('sessionId') &&
            decoded.containsKey('progressNormalized')) {
          final progress = SessionProgressDto.fromJson(decoded);
          _applySessionProgress(progress);
          return;
        }

        // 3. Direct summary format
        if (decoded.containsKey('completedSuccessfully')) {
          final summary = SessionSummaryDto.fromJson(decoded);
          _applySessionSummary(summary);
          return;
        }
      }
    } catch (e) {
      // Non-JSON simple string tokens
      _handleSimpleStringMessage(rawStr);
    }
  }

  void _handleRpcMethod(String method, dynamic params) {
    switch (method) {
      case 'onSessionProgress':
        try {
          final paramMap = params is String
              ? jsonDecode(params) as Map<String, dynamic>
              : (params as Map<String, dynamic>);
          final progress = SessionProgressDto.fromJson(paramMap);
          _applySessionProgress(progress);
        } catch (e) {
          debugPrint('[UnitySessionController] Error parsing onSessionProgress: $e');
        }
        break;

      case 'onSessionSummary':
      case 'onSessionCompleted':
        try {
          final paramMap = params is String
              ? jsonDecode(params) as Map<String, dynamic>
              : (params as Map<String, dynamic>);
          final summary = SessionSummaryDto.fromJson(paramMap);
          _applySessionSummary(summary);
        } catch (e) {
          debugPrint('[UnitySessionController] Error parsing onSessionSummary: $e');
        }
        break;

      case 'onBreathingPhaseChanged':
        try {
          final paramMap = params is String
              ? jsonDecode(params) as Map<String, dynamic>
              : (params as Map<String, dynamic>);
          final event = BreathPhaseEventDto.fromJson(paramMap);
          _applyBreathingPhase(event.phase);
        } catch (e) {
          if (params is int) {
            _applyBreathingPhase(BreathingPhase.fromValue(params));
          }
        }
        break;

      case 'onUnityReady':
      case 'UNITY_READY':
        state = state.copyWith(isUnityLoaded: true);
        break;

      case 'onSceneLoaded':
      case 'SCENE_LOADED':
        state = state.copyWith(isSceneLoaded: true);
        break;

      default:
        debugPrint('[UnitySessionController] Unhandled RPC method: $method');
    }
  }

  void _handleSimpleStringMessage(String raw) {
    final lower = raw.toLowerCase();
    if (lower == 'unity_ready' || lower == 'ready') {
      state = state.copyWith(isUnityLoaded: true);
    } else if (lower.startsWith('scene_loaded') || lower == 'sceneloaded') {
      state = state.copyWith(isSceneLoaded: true);
    } else if (lower.contains('inhale')) {
      _applyBreathingPhase(BreathingPhase.inhale);
    } else if (lower.contains('holdin') || lower.contains('hold in')) {
      _applyBreathingPhase(BreathingPhase.holdIn);
    } else if (lower.contains('exhale')) {
      _applyBreathingPhase(BreathingPhase.exhale);
    } else if (lower.contains('holdout') || lower.contains('hold out')) {
      _applyBreathingPhase(BreathingPhase.holdOut);
    }
  }

  void _applySessionProgress(SessionProgressDto progress) {
    final previousPhase = state.currentBreathingPhase;
    final newPhase = progress.breathingPhase;

    state = state.copyWith(
      currentProgress: progress,
      elapsedSeconds: progress.elapsedSeconds,
      totalDurationSeconds: progress.totalDurationSeconds > 0
          ? progress.totalDurationSeconds
          : state.totalDurationSeconds,
      progressNormalized: progress.progressNormalized,
      currentBreathingPhase: newPhase,
      isPlaying: true,
    );

    if (previousPhase != newPhase) {
      _triggerHapticFeedbackForPhase(newPhase);
    }
  }

  void _applyBreathingPhase(BreathingPhase phase) {
    if (state.currentBreathingPhase != phase) {
      state = state.copyWith(currentBreathingPhase: phase);
      _triggerHapticFeedbackForPhase(phase);
    }
  }

  /// Triggers physiological tactile cues corresponding to the breath phase.
  void _triggerHapticFeedbackForPhase(BreathingPhase phase) {
    switch (phase) {
      case BreathingPhase.inhale:
        HapticFeedback.mediumImpact();
        break;
      case BreathingPhase.holdIn:
        HapticFeedback.lightImpact();
        break;
      case BreathingPhase.exhale:
        HapticFeedback.heavyImpact();
        break;
      case BreathingPhase.holdOut:
        HapticFeedback.selectionClick();
        break;
    }
  }

  /// Automatically persists completed session into Isar DB.
  Future<void> _applySessionSummary(SessionSummaryDto summary) async {
    _stopHeartbeat();
    state = state.copyWith(
      lastSummary: summary,
      isCompleted: true,
      isPlaying: false,
      progressNormalized: 1.0,
      elapsedSeconds: summary.totalDurationSeconds,
    );

    try {
      final userRepo = ref.read(userRepositoryProvider);
      final isBreathing = summary.sceneName.toLowerCase().contains('respir') ||
          summary.sceneName.toLowerCase().contains('breath') ||
          summary.sceneName.toLowerCase().contains('resp');
      final sessionType = isBreathing ? 'Respirazione' : 'Meditazione';
      final minutes = (summary.totalDurationSeconds / 60).ceil().clamp(1, 120);

      await userRepo.recordSession(
        summary.sceneName.isNotEmpty ? summary.sceneName : 'Sessione Zen 3D',
        sessionType,
        durationMinutes: minutes,
        xp: summary.xpEarned > 0 ? summary.xpEarned : minutes * 2,
      );
      debugPrint('[UnitySessionController] Session successfully recorded in Isar DB ($minutes min).');
    } catch (e) {
      debugPrint('[UnitySessionController] Failed to record session in Isar DB: $e');
    }
  }

  /// Persists partial progress if user terminates session early but spent at least 15s.
  Future<void> recordPartialSession() async {
    if (state.elapsedSeconds < 15.0 || state.isCompleted) return;

    try {
      final userRepo = ref.read(userRepositoryProvider);
      final scene = state.activeConfig?.sceneName ?? 'Sessione Zen 3D';
      final isBreathing = scene.toLowerCase().contains('respir') ||
          scene.toLowerCase().contains('breath') ||
          scene.toLowerCase().contains('resp');
      final sessionType = isBreathing ? 'Respirazione' : 'Meditazione';
      final minutes = (state.elapsedSeconds / 60).ceil().clamp(1, 120);

      await userRepo.recordSession(
        scene,
        sessionType,
        durationMinutes: minutes,
        xp: minutes * 2,
      );
      debugPrint('[UnitySessionController] Partial session recorded in Isar DB ($minutes min).');
    } catch (e) {
      debugPrint('[UnitySessionController] Failed to record partial session: $e');
    }
  }

  // --- RPC Command Dispatchers (Flutter -> Unity) ---

  /// Starts a new session by sending SessionConfigDto via JSON-RPC.
  Future<void> startSession(SessionConfigDto config) async {
    state = state.copyWith(
      activeConfig: config,
      isPlaying: true,
      isCompleted: false,
      elapsedSeconds: 0.0,
      totalDurationSeconds: config.durationSeconds,
      progressNormalized: 0.0,
      errorMessage: null,
    );

    _startHeartbeat();

    if (_unityWidgetController != null && state.isUnityLoaded) {
      _sendStartSessionToUnity(config);
    }
  }

  void _sendStartSessionToUnity(SessionConfigDto config) {
    final rpcRequest = JsonRpcRequestDto(
      method: 'startSession',
      params: config.toJsonString(),
      id: 1,
    );
    _postToUnity(rpcRequest.toJsonString());
  }

  /// Pauses the current active Unity session.
  Future<void> pauseSession() async {
    _stopHeartbeat();
    state = state.copyWith(isPlaying: false);
    final rpc = const JsonRpcRequestDto(method: 'pauseSession', id: 2);
    _postToUnity(rpc.toJsonString());
  }

  /// Resumes the paused Unity session.
  Future<void> resumeSession() async {
    state = state.copyWith(isPlaying: true);
    _startHeartbeat();
    final rpc = const JsonRpcRequestDto(method: 'resumeSession', id: 3);
    _postToUnity(rpc.toJsonString());
  }

  /// Stops and terminates the current Unity session.
  Future<void> stopSession() async {
    _stopHeartbeat();
    if (state.elapsedSeconds >= 15.0 && !state.isCompleted) {
      await recordPartialSession();
    }
    state = state.copyWith(isPlaying: false);
    final rpc = const JsonRpcRequestDto(method: 'stopSession', id: 4);
    _postToUnity(rpc.toJsonString());
  }

  /// Dynamically updates the URP quality preset in Unity at runtime.
  Future<void> setQualityPreset(QualityPreset preset) async {
    final rpc = JsonRpcRequestDto(
      method: 'setQualityPreset',
      params: preset.value.toString(),
      id: 5,
    );
    _postToUnity(rpc.toJsonString());
  }

  /// Dynamically switches language in Unity guidance systems.
  Future<void> setLanguage(AppLanguage language) async {
    final rpc = JsonRpcRequestDto(
      method: 'setLanguage',
      params: language.value.toString(),
      id: 6,
    );
    _postToUnity(rpc.toJsonString());
  }

  /// Recalibrates VR gyroscope origin in Unity XR.
  Future<void> recalibrateVR() async {
    final rpc = const JsonRpcRequestDto(method: 'recalibrateVR', id: 7);
    _postToUnity(rpc.toJsonString());
  }

  /// Resets controller state when exiting experience.
  void resetSession() {
    _stopHeartbeat();
    state = const UnitySessionState();
  }

  void _postToUnity(String message) {
    if (_unityWidgetController == null) {
      debugPrint('[UnitySessionController] Warning: Cannot post message, controller is null.');
      return;
    }

    try {
      _unityWidgetController!.postMessage(
        _unityBridgeGameObjectName,
        _unityBridgeMethodName,
        message,
      );
      debugPrint('[UnitySessionController -> Unity] Posted: $message');
    } catch (e) {
      debugPrint('[UnitySessionController] Error posting to Unity: $e');
    }
  }
}

/// Global Riverpod Provider for Unity Session Controller
final unitySessionControllerProvider =
    NotifierProvider<UnitySessionController, UnitySessionState>(
      UnitySessionController.new,
    );
