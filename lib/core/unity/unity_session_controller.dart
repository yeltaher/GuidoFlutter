import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_unity_widget_2/flutter_unity_widget_2.dart';
import '../database/repositories/user_repository.dart';
import 'unity_bridge_dto.dart';

/// State representation for an active or preparing Unity UaaL session.
class UnitySessionState {
  final bool isUnityLoaded;
  final bool isSceneLoaded;
  final bool isPlaying;
  final bool isCompleted;
  final bool isWaitingForUnity;
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
    this.isWaitingForUnity = false,
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
    bool? isWaitingForUnity,
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
      isWaitingForUnity: isWaitingForUnity ?? this.isWaitingForUnity,
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
///
/// FIXES APPLIED:
/// - [Bug #7] Race condition in startSession(): defers heartbeat until Unity
///   confirms receipt via first progress message; adds ready-timeout watchdog.
/// - [Bug #8] Force unwrap eliminated: _postToUnity captures controller in a
///   local variable before null-check, preventing TOCTOU race with detach.
/// - [Issue #5] Lifecycle management: WidgetsBindingObserver pauses heartbeat
///   and watchdog when the app goes to background, resumes on foreground.
/// - [Issue #6] Watchdog timer: tracks last message timestamp from Unity and
///   fails the session gracefully if no message arrives within the timeout.
/// - [Issue #7] detachUnityWidgetController() now resets isUnityLoaded,
///   isSceneLoaded, stops heartbeat/watchdog, and clears isWaitingForUnity.
class UnitySessionController extends Notifier<UnitySessionState>
    with WidgetsBindingObserver {
  UnityWidgetController? _unityWidgetController;
  Timer? _heartbeatTimer;
  Timer? _watchdogTimer;
  Timer? _readyTimeoutTimer;
  DateTime? _lastUnityMessageAt;
  DateTime? _startTime;
  double _accumulatedElapsedSeconds = 0.0;
  bool _isAppPaused = false;

  static const String _unityBridgeGameObjectName = 'FlutterBridgeManager';
  static const String _unityBridgeMethodName = 'OnFlutterMessage';

  /// Maximum seconds to wait for Unity to acknowledge a session-start command
  /// before failing the session.  Covers the cold-start and scene-load window.
  static const Duration _readyTimeout = Duration(seconds: 15);

  /// If no message is received from Unity for this duration the session is
  /// considered dead (Unity crashed or hung) and will be failed gracefully.
  static const Duration _watchdogTimeout = Duration(seconds: 30);

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  UnitySessionState build() {
    ref.onDispose(_cleanup);
    WidgetsBinding.instance.addObserver(this);
    return const UnitySessionState();
  }

  void _cleanup() {
    WidgetsBinding.instance.removeObserver(this);
    _stopHeartbeat();
    _stopWatchdog();
    _stopReadyTimeout();
    _startTime = null;
    _accumulatedElapsedSeconds = 0.0;
    _unityWidgetController = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Transition from non-resumed → resumed
    if (state == AppLifecycleState.resumed && _isAppPaused) {
      _isAppPaused = false;
      if (this.state.isPlaying && !this.state.isCompleted && this.state.isUnityLoaded) {
        _startTime = DateTime.now();
        _startHeartbeat();
        _startWatchdog();
        debugPrint('[UnitySessionController] App resumed — heartbeat & watchdog restarted.');
      }
      return;
    }

    // Transition to any non-resumed state (paused / inactive / detached / hidden)
    if (state != AppLifecycleState.resumed && !_isAppPaused) {
      _isAppPaused = true;
      if (this.state.isPlaying && !this.state.isCompleted) {
        if (_startTime != null) {
          _accumulatedElapsedSeconds +=
              DateTime.now().difference(_startTime!).inMicroseconds / 1000000.0;
          _startTime = null;
        }
        _stopHeartbeat();
        _stopWatchdog();
        debugPrint('[UnitySessionController] App paused — heartbeat & watchdog suspended.');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Heartbeat — session timer & breathing-phase synchronisation
  // ---------------------------------------------------------------------------

  void _startHeartbeat() {
    _stopHeartbeat();
    if (_startTime == null && state.isPlaying && !_isAppPaused) {
      _startTime = DateTime.now();
    }
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isPlaying || state.isCompleted || _isAppPaused) {
        timer.cancel();
        return;
      }
      final double currentDelta = _startTime != null
          ? DateTime.now().difference(_startTime!).inMicroseconds / 1000000.0
          : 0.0;
      final newElapsed = _accumulatedElapsedSeconds + currentDelta;
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

  // ---------------------------------------------------------------------------
  // Watchdog — detects Unity crash / silence and fails the session
  // ---------------------------------------------------------------------------

  void _startWatchdog() {
    _stopWatchdog();
    _lastUnityMessageAt = DateTime.now();
    _watchdogTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!state.isPlaying || state.isCompleted || _isAppPaused) {
        timer.cancel();
        return;
      }
      final last = _lastUnityMessageAt;
      if (last != null && DateTime.now().difference(last) > _watchdogTimeout) {
        timer.cancel();
        debugPrint('[UnitySessionController] Watchdog triggered — no Unity message for ${_watchdogTimeout.inSeconds}s.');
        _failSession(
          'Unity non risponde da ${_watchdogTimeout.inSeconds}s. Sessione interrotta.',
        );
      }
    });
  }

  void _stopWatchdog() {
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
  }

  // ---------------------------------------------------------------------------
  // Ready timeout — fails session if Unity never becomes ready after startSession
  // ---------------------------------------------------------------------------

  void _startReadyTimeout() {
    _stopReadyTimeout();
    _readyTimeoutTimer = Timer(_readyTimeout, () {
      if (state.isWaitingForUnity && !_isAppPaused) {
        debugPrint('[UnitySessionController] Ready timeout — Unity did not respond within ${_readyTimeout.inSeconds}s.');
        _failSession(
          'Unity non è entro il timeout di ${_readyTimeout.inSeconds}s. Sessione annullata.',
        );
      }
    });
  }

  void _stopReadyTimeout() {
    _readyTimeoutTimer?.cancel();
    _readyTimeoutTimer = null;
  }

  // ---------------------------------------------------------------------------
  // Graceful failure
  // ---------------------------------------------------------------------------

  void _failSession(String message) {
    _stopHeartbeat();
    _stopWatchdog();
    _stopReadyTimeout();
    state = state.copyWith(
      isPlaying: false,
      isCompleted: true,
      isWaitingForUnity: false,
      errorMessage: message,
    );
    debugPrint('[UnitySessionController] Session failed: $message');
  }

  // ---------------------------------------------------------------------------
  // Unity Widget lifecycle callbacks
  // ---------------------------------------------------------------------------

  /// Called when UnityWidget is attached and controller is ready.
  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
    state = state.copyWith(isUnityLoaded: true, isSceneLoaded: true);
    debugPrint('[UnitySessionController] Unity Widget Controller attached.');

    // If a session was queued before Unity finished loading, send it now
    if (state.isWaitingForUnity && state.activeConfig != null) {
      _stopReadyTimeout();
      state = state.copyWith(isPlaying: true, isWaitingForUnity: false);
      _startTime = DateTime.now();
      _accumulatedElapsedSeconds = 0.0;
      _sendStartSessionToUnity(state.activeConfig!);
      _startHeartbeat();
      _startWatchdog();
      debugPrint('[UnitySessionController] Queued session dispatched to newly-ready Unity.');
    }
  }

  /// Detaches the controller reference upon screen unmount.
  ///
  /// FIX [Issue #7]: now fully resets loading/playing/waiting flags and
  /// stops all timers so stale state never lingers synchronously without nested microtasks.
  void detachUnityWidgetController() {
    _unityWidgetController = null;
    _stopHeartbeat();
    _stopWatchdog();
    _stopReadyTimeout();
    _startTime = null;
    _accumulatedElapsedSeconds = 0.0;
    state = state.copyWith(
      isUnityLoaded: false,
      isSceneLoaded: false,
      isPlaying: false,
      isWaitingForUnity: false,
    );
    debugPrint('[UnitySessionController] Unity Widget Controller detached — state reset.');
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
    _stopWatchdog();
    _stopReadyTimeout();
    _startTime = null;
    _accumulatedElapsedSeconds = 0.0;
    state = state.copyWith(
      isUnityLoaded: false,
      isSceneLoaded: false,
      isPlaying: false,
      isWaitingForUnity: false,
    );
  }

  // ---------------------------------------------------------------------------
  // Message handling (Unity → Flutter)
  // ---------------------------------------------------------------------------

  /// Primary message handler parsing events and telemetry incoming from Unity.
  void onUnityMessage(dynamic message) {
    if (message == null) return;
    final String rawStr = message.toString().trim();
    if (rawStr.isEmpty) return;

    // FIX [Issue #6]: refresh the watchdog timestamp on every message.
    _lastUnityMessageAt = DateTime.now();

    debugPrint('[UnitySessionController <- Unity] $rawStr');

    try {
      final decoded = jsonDecode(rawStr);
      if (decoded is Map) {
        final map = Map<String, dynamic>.from(decoded);
        // 1. JSON-RPC 2.0 format
        if (map.containsKey('method')) {
          _handleRpcMethod(
            map['method'] as String? ?? '',
            map['params'] ?? '',
          );
          return;
        }

        // 2. Direct telemetry format
        if (map.containsKey('sessionId') &&
            map.containsKey('progressNormalized')) {
          final progress = SessionProgressDto.fromJson(map);
          _applySessionProgress(progress);
          return;
        }

        // 3. Direct summary format
        if (map.containsKey('completedSuccessfully')) {
          final summary = SessionSummaryDto.fromJson(map);
          _applySessionSummary(summary);
          return;
        }
      } else if (decoded is String) {
        _handleSimpleStringMessage(decoded);
        return;
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

  // ---------------------------------------------------------------------------
  // State application helpers
  // ---------------------------------------------------------------------------

  void _applySessionProgress(SessionProgressDto progress) {
    final previousPhase = state.currentBreathingPhase;
    final newPhase = progress.breathingPhase;

    // FIX [Bug #7]: First progress from Unity confirms the session-start
    // command was received.  Transition from waiting → playing.
    if (state.isWaitingForUnity) {
      _stopReadyTimeout();
      debugPrint('[UnitySessionController] Unity confirmed session receipt — heartbeat started.');
    }

    state = state.copyWith(
      currentProgress: progress,
      elapsedSeconds: progress.elapsedSeconds,
      totalDurationSeconds: progress.totalDurationSeconds > 0
          ? progress.totalDurationSeconds
          : state.totalDurationSeconds,
      progressNormalized: progress.progressNormalized,
      currentBreathingPhase: newPhase,
      isPlaying: true,
      isWaitingForUnity: false,
    );

    // FIX [Bug #7]: Start heartbeat + watchdog on the very first progress
    // confirmation if they weren't already running.
    if (_heartbeatTimer == null && !_isAppPaused) {
      _startHeartbeat();
      _startWatchdog();
    }

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
    _stopWatchdog();
    state = state.copyWith(
      lastSummary: summary,
      isCompleted: true,
      isPlaying: false,
      isWaitingForUnity: false,
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

      await userRepo?.recordSession(
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

      await userRepo?.recordSession(
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

  // ---------------------------------------------------------------------------
  // RPC Command Dispatchers (Flutter → Unity)
  // ---------------------------------------------------------------------------

  /// Starts a new session by sending SessionConfigDto via JSON-RPC.
  ///
  /// FIX [Bug #7]: no longer sets isPlaying=true or starts the heartbeat
  /// immediately.  If Unity is ready the command is dispatched right away and
  /// the heartbeat + watchdog start on the first progress confirmation from
  /// Unity.  If Unity is NOT ready the session config is queued and a
  /// ready-timeout watchdog is started; onUnityCreated() will dispatch the
  /// queued command once Unity attaches.
  Future<void> startSession(SessionConfigDto config) async {
    // Always stop any previous timers
    _stopHeartbeat();
    _stopWatchdog();
    _startTime = null;
    _accumulatedElapsedSeconds = 0.0;

    state = state.copyWith(
      activeConfig: config,
      isPlaying: false,
      isCompleted: false,
      isWaitingForUnity: false,
      elapsedSeconds: 0.0,
      totalDurationSeconds: config.durationSeconds,
      progressNormalized: 0.0,
      errorMessage: null,
    );

    if (_unityWidgetController != null && state.isUnityLoaded) {
      // Unity is ready — send immediately; heartbeat starts on first progress.
      state = state.copyWith(isPlaying: true);
      _sendStartSessionToUnity(config);
      // Start a ready-timeout so the session fails if Unity never sends back
      // a progress message (e.g. scene load failed silently).
      _startReadyTimeout();
      _startWatchdog();
    } else {
      // Unity NOT ready — queue the config and wait for onUnityCreated.
      state = state.copyWith(isWaitingForUnity: true);
      _startReadyTimeout();
      debugPrint('[UnitySessionController] Unity not ready — session config queued.');
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
    _stopWatchdog();
    if (_startTime != null) {
      _accumulatedElapsedSeconds +=
          DateTime.now().difference(_startTime!).inMicroseconds / 1000000.0;
      _startTime = null;
    }
    state = state.copyWith(isPlaying: false);
    final rpc = const JsonRpcRequestDto(method: 'pauseSession', id: 2);
    _postToUnity(rpc.toJsonString());
  }

  /// Resumes the paused Unity session.
  Future<void> resumeSession() async {
    _startTime = DateTime.now();
    state = state.copyWith(isPlaying: true);
    _startHeartbeat();
    _startWatchdog();
    _lastUnityMessageAt = DateTime.now();
    final rpc = const JsonRpcRequestDto(method: 'resumeSession', id: 3);
    _postToUnity(rpc.toJsonString());
  }

  /// Stops and terminates the current Unity session.
  Future<void> stopSession() async {
    _stopHeartbeat();
    _stopWatchdog();
    _stopReadyTimeout();
    if (state.elapsedSeconds >= 15.0 && !state.isCompleted) {
      await recordPartialSession();
    }
    _startTime = null;
    _accumulatedElapsedSeconds = 0.0;
    state = state.copyWith(isPlaying: false, isWaitingForUnity: false);
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
    _stopWatchdog();
    _stopReadyTimeout();
    _lastUnityMessageAt = null;
    _startTime = null;
    _accumulatedElapsedSeconds = 0.0;
    state = const UnitySessionState();
  }

  /// Posts a JSON message to the Unity bridge via Platform Channel.
  ///
  /// FIX [Bug #8]: captures the controller reference in a local variable *before*
  /// the null-check so that a concurrent [detachUnityWidgetController] on another
  /// micro-task cannot null it out between the guard and the `.postMessage()` call
  /// (classic TOCTOU / force-unwrap race).
  void _postToUnity(String message) {
    final controller = _unityWidgetController;
    if (controller == null) {
      debugPrint('[UnitySessionController] Warning: Cannot post message, controller is null.');
      return;
    }

    try {
      controller.postMessage(
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
