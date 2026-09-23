import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_unity_widget_2/flutter_unity_widget_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/audio/audio_resolver_service.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/custom_button_widget.dart';
import '../../../core/vr/vr_orientation_service.dart';
import '../../../core/database/settings_provider.dart';
import '../../../core/database/repositories/user_repository.dart';
import '../../../core/unity/unity_bridge_dto.dart';
import '../../../core/unity/unity_session_controller.dart';

/// Embedded Unity UaaL hosting screen with glassmorphic overlays,
/// tactile feedback sync, and lifecycle management.
class UnityExperienceScreen extends ConsumerStatefulWidget {
  final String title;
  final String sceneName;
  final double durationSeconds;
  final bool isVrMode;
  final String? voicePath;
  final String? ambientPath;

  const UnityExperienceScreen({
    super.key,
    required this.title,
    required this.sceneName,
    this.durationSeconds = 300.0,
    this.isVrMode = false,
    this.voicePath,
    this.ambientPath,
  });

  @override
  ConsumerState<UnityExperienceScreen> createState() =>
      _UnityExperienceScreenState();
}

class _UnityExperienceScreenState
    extends ConsumerState<UnityExperienceScreen> {
  bool _showExitConfirm = false;
  bool _showLoadTimeoutDialog = false;
  Timer? _loadTimeoutTimer;
  /// Guard against setState-after-dispose race conditions.
  /// The timer callback may fire in the microtask queue after dispose()
  /// has already run but before the Timer is garbage-collected.
  bool _isDisposed = false;
  bool _isRecoveryDialogOpen = false;
  bool _isTearingDown = false;

  UnitySessionController? _sessionNotifier;
  GuidoAudioService? _audioService;

  @override
  void initState() {
    super.initState();
    try {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      WakelockPlus.enable();

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      if (widget.isVrMode) {
        VrOrientationService.enterVr();
      }
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore configurazione orientamento: $e');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSession();
    });
  }

  void _initializeSession({bool isRepeat = false}) {
    if (_isDisposed) return;

    _isTearingDown = false;
    _loadTimeoutTimer?.cancel();
    setState(() {
      _showLoadTimeoutDialog = false;
    });

    final settings = ref.read(settingsProvider);
    final bundle = AudioResolverService.resolveBundle(
      title: widget.title,
      sceneName: widget.sceneName,
      voiceSex: settings.voiceSex,
      language: settings.language,
      customVoicePath: widget.voicePath,
      customAmbientPath: widget.ambientPath,
      durationSeconds: widget.durationSeconds,
    );

    final config = SessionConfigDto(
      sceneName: bundle.sceneName,
      language: settings.language,
      durationSeconds: bundle.durationSeconds,
      isVrMode: widget.isVrMode,
      qualityPreset: settings.qualityPreset.value,
    );

    _sessionNotifier = ref.read(unitySessionControllerProvider.notifier);
    _sessionNotifier?.startSession(config);
    _startAudio(bundle, isRepeat: isRepeat);

    // Watchdog timer di 10 secondi per il caricamento dell'ambiente 3D
    _loadTimeoutTimer = Timer(const Duration(seconds: 10), () {
      if (_isDisposed || !mounted) return;
      final isLoaded =
          ref.read(unitySessionControllerProvider).isSceneLoaded;
      if (!isLoaded) {
        setState(() {
          _showLoadTimeoutDialog = true;
        });
        _showRecoveryDialog(
          errorMessage: ref.read(settingsProvider).language == 0
              ? 'Timeout caricamento 3D: la sessione non ha risposto entro 10 secondi.'
              : '3D loading timeout: the session did not respond within 10 seconds.',
        );
      }
    });
  }

  void _showRecoveryDialog({String? errorMessage}) {
    if (_isDisposed || !mounted || _isRecoveryDialogOpen) return;
    _isRecoveryDialogOpen = true;
    _loadTimeoutTimer?.cancel();

    final isIt = ref.read(settingsProvider).language == 0;
    final message = errorMessage ??
        (isIt
            ? 'Timeout caricamento 3D: l\'esperienza non ha risposto entro il tempo limite.'
            : '3D loading timeout: the session did not respond within the time limit.');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFF1E1E1E),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.goldAccent,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                isIt ? 'Attenzione' : 'Warning',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _isRecoveryDialogOpen = false;
                _retryLoading();
              },
              child: Text(
                isIt ? 'Riprova' : 'Retry',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.goldAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _isRecoveryDialogOpen = false;
                _restoreOrientationAndGoHome();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dangerAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isIt ? 'Torna alla Home' : 'Back to Home',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      _isRecoveryDialogOpen = false;
    });
  }

  Future<void> _teardownAudioAndSession() async {
    if (_isTearingDown) return;
    _isTearingDown = true;
    _loadTimeoutTimer?.cancel();
    _loadTimeoutTimer = null;

    // Inviare lo stop a Unity prima di abbandonare la route
    try {
      await ref.read(unitySessionControllerProvider.notifier).stopSession();
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore stopSession: $e');
    }

    // Arrestare e disattivare l'audio nativo via _audioService
    try {
      await _audioService?.stopAll();
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore stop _audioService: $e');
    }

    // Fallback Riverpod: arrestare e disattivare l'audio nativo se l'istanza è diversa
    try {
      final audioService = ref.read(audioServiceProvider).valueOrNull;
      if (audioService != null && !identical(audioService, _audioService)) {
        await audioService.stopAll();
      }
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore stop audioServiceProvider: $e');
    }
  }

  void _restoreOrientationAndGoHome() async {
    await _teardownAudioAndSession();
    try {
      WakelockPlus.disable();
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore wakelock: $e');
    }

    try {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore ripristino orientamento: $e');
    }

    if (widget.isVrMode) {
      try {
        VrOrientationService.exitVr();
      } catch (e) {
        debugPrint('[UnityExperienceScreen] Errore uscita VR: $e');
      }
    }

    if (mounted) {
      context.go('/home');
    }
  }

  void _retryLoading() {
    _initializeSession();
  }

  Future<void> _startAudio(
    AudioExperienceBundle bundle, {
    bool isRepeat = false,
  }) async {
    try {
      final audioService = await ref.read(audioServiceProvider.future);
      if (_isDisposed || !mounted) return;
      _audioService = audioService;
      final settings = ref.read(settingsProvider);

      audioService.setVoiceVolume(settings.voiceVolume);
      audioService.setVoiceMute(settings.isVoiceMuted);
      audioService.setAmbientVolume(settings.musicVolume);
      audioService.setEffectsVolume(settings.effectsVolume);

      if (bundle.ambientPath.isNotEmpty) {
        if (_isDisposed || !mounted) return;
        await audioService.playAmbient(bundle.ambientPath);
      }
      if (!isRepeat && bundle.voicePath.isNotEmpty && !settings.isVoiceMuted) {
        if (_isDisposed || !mounted) return;
        await audioService.playVoice(bundle.voicePath);
      }
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore riproduzione audio: $e');
    }
  }

  void _togglePlayPause() async {
    final sessionState = ref.read(unitySessionControllerProvider);
    final controller = ref.read(unitySessionControllerProvider.notifier);
    final audioService = ref.read(audioServiceProvider).valueOrNull;

    if (sessionState.isPlaying) {
      controller.pauseSession();
      await audioService?.pauseAll();
      try {
        WakelockPlus.disable();
      } catch (e) {
        debugPrint('[UnityExperienceScreen] Errore wakelock: $e');
      }
    } else {
      controller.resumeSession();
      await audioService?.resumeAll();
      try {
        WakelockPlus.enable();
      } catch (e) {
        debugPrint('[UnityExperienceScreen] Errore wakelock: $e');
      }
    }
  }

  void _requestExit() {
    setState(() {
      _showExitConfirm = true;
    });
  }

  void _cancelExit() {
    setState(() {
      _showExitConfirm = false;
    });
  }

  void _confirmExit() async {
    try {
      WakelockPlus.disable();
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore wakelock: $e');
    }
    final elapsedSeconds =
        ref.read(unitySessionControllerProvider).elapsedSeconds;

    await _teardownAudioAndSession();

    try {
      // Reset VR mode and record session (moved from VrConfirmationScreen's
      // pushReplacement .then() callback for GoRouter compatibility)
      ref.read(settingsProvider.notifier).toggleVrMode(false);
      if (elapsedSeconds >= 60) {
        final minutes = elapsedSeconds ~/ 60;
        await ref.read(userRepositoryProvider)?.recordSession(
              widget.title,
              widget.sceneName.contains('resp') ? "Respirazione" : "Meditazione",
              durationMinutes: minutes,
            );
      }
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore salvataggio sessione: $e');
    }

    try {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore ripristino orientamento in exit: $e');
    }

    if (widget.isVrMode) {
      if (mounted) {
        context.go('/remove-vr-headset');
      }
    } else {
      if (mounted) {
        context.go('/home');
      }
    }
  }

  void _repeatSession() async {
    try {
      WakelockPlus.enable();
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore wakelock: $e');
    }
    final audioService = ref.read(audioServiceProvider).valueOrNull;
    await audioService?.stopVoice();
    _initializeSession(isRepeat: true);
  }

  @override
  void dispose() {
    // Set guard FIRST so any in-flight timer callbacks skip setState.
    _isDisposed = true;

    _loadTimeoutTimer?.cancel();
    _loadTimeoutTimer = null;

    // Immediate, safe, synchronous/defensive teardown call of _audioService?.stopAll()
    // before deallocating controllers and widgets.
    try {
      _audioService?.stopAll();
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore stop audio in dispose: $e');
    }

    if (!_isTearingDown) {
      final sessionNotifier = _sessionNotifier;
      if (sessionNotifier != null) {
        scheduleMicrotask(() {
          try {
            sessionNotifier.stopSession();
          } catch (e) {
            debugPrint('[UnityExperienceScreen] Errore stop sessionNotifier in dispose: $e');
          }
        });
      }
    }

    try {
      WakelockPlus.disable();
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore disable wakelock in dispose: $e');
    }

    try {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    } catch (e) {
      debugPrint('[UnityExperienceScreen] Errore orientamento in dispose: $e');
    }

    if (widget.isVrMode) {
      try {
        VrOrientationService.exitVr();
      } catch (e) {
        debugPrint('[UnityExperienceScreen] Errore uscita VR in dispose: $e');
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UnitySessionState>(unitySessionControllerProvider, (prev, next) {
      if (_isDisposed) return;
      if (next.isSceneLoaded && _loadTimeoutTimer?.isActive == true) {
        _loadTimeoutTimer?.cancel();
        if (_showLoadTimeoutDialog) {
          setState(() {
            _showLoadTimeoutDialog = false;
          });
        }
      }
      if (next.isCompleted && !(prev?.isCompleted ?? false)) {
        try {
          WakelockPlus.disable();
        } catch (e) {
          debugPrint('[UnityExperienceScreen] Errore disable wakelock on completed: $e');
        }
      }
    });

    final sessionState = ref.watch(unitySessionControllerProvider);
    final sessionNotifier = ref.read(unitySessionControllerProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final isIt = settings.language == 0;

    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subTextColor = AppColors.getSubTextColor(isDark);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _teardownAudioAndSession();
          return;
        }
        if (sessionState.isCompleted) {
          _confirmExit();
        } else {
          _requestExit();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // 1. Embedded Unity Widget
            Positioned.fill(
              child: UnityWidget(
                onUnityCreated: (controller) {
                  try {
                    _loadTimeoutTimer?.cancel();
                    _loadTimeoutTimer = null;
                    if (_showLoadTimeoutDialog) {
                      setState(() {
                        _showLoadTimeoutDialog = false;
                      });
                    }
                    sessionNotifier.onUnityCreated(controller);
                    sessionNotifier.onUnitySceneLoaded(null);
                  } catch (e) {
                    debugPrint('[UnityExperienceScreen] Errore in onUnityCreated: $e');
                    _showRecoveryDialog(
                      errorMessage: 'Errore inizializzazione 3D: $e',
                    );
                  }
                },
                onUnityMessage: (message) {
                  try {
                    sessionNotifier.onUnityMessage(message);
                  } catch (e) {
                    debugPrint('[UnityExperienceScreen] Errore in onUnityMessage: $e');
                  }
                },
                onUnitySceneLoaded: (scene) {
                  try {
                    sessionNotifier.onUnitySceneLoaded(scene);
                  } catch (e) {
                    debugPrint('[UnityExperienceScreen] Errore in onUnitySceneLoaded: $e');
                    _showRecoveryDialog(
                      errorMessage: 'Errore caricamento scena 3D: $e',
                    );
                  }
                },
                onUnityUnloaded: () {
                  try {
                    sessionNotifier.onUnityUnloaded();
                  } catch (e) {
                    debugPrint('[UnityExperienceScreen] Errore in onUnityUnloaded: $e');
                  }
                },
                fullscreen: true,
                useAndroidViewSurface: true,
              ),
            ),

            // 2. Loading / Initializing HUD Overlay
            if ((!sessionState.isUnityLoaded || !sessionState.isSceneLoaded) &&
                !_showLoadTimeoutDialog)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.85),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              accentColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          isIt
                              ? 'CARICAMENTO AMBIENTE ZEN...'
                              : 'LOADING ZEN ENVIRONMENT...',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white.withValues(alpha: 0.9),
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          settings.qualityPreset.getDisplayName(isIt),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // 3. Active Session HUD Controls (Non-VR or VR Companion Overlay)
            if (sessionState.isSceneLoaded && !sessionState.isCompleted) ...[
              // Top Header Bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Close / Exit button
                        _buildGlassCircleButton(
                          icon: Icons.close_rounded,
                          color: AppColors.dangerAccent,
                          onTap: _requestExit,
                        ),

                        // Title & Quality Preset Pill
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title.toUpperCase(),
                              style: GoogleFonts.playfairDisplay(
                                fontSize: widget.isVrMode ? 12 : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withValues(alpha: 0.9),
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Semantics(
                              button: true,
                              label: 'Selettore qualità grafica',
                              child: GestureDetector(
                                onTap: () async {
                                  final nextPreset = settings.qualityPreset ==
                                          QualityPreset.highFidelity
                                      ? QualityPreset.balancedEco
                                      : QualityPreset.highFidelity;
                                  await ref
                                      .read(settingsProvider.notifier)
                                      .changeQualityPreset(nextPreset);
                                  await ref
                                      .read(
                                        unitySessionControllerProvider.notifier,
                                      )
                                      .setQualityPreset(nextPreset);
                                  HapticFeedback.selectionClick();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: accentColor.withValues(alpha: 0.35),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        settings.qualityPreset ==
                                                QualityPreset.highFidelity
                                            ? Icons.auto_awesome
                                            : Icons.eco_rounded,
                                        size: 11,
                                        color: accentColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        settings.qualityPreset ==
                                                QualityPreset.highFidelity
                                            ? 'PBR 60 FPS'
                                            : 'ECO SAVER',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: accentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Pause / Play button
                        _buildGlassCircleButton(
                          icon: sessionState.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: sessionState.isPlaying
                              ? Colors.white70
                              : AppColors.successAccent,
                          onTap: _togglePlayPause,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // 4. Session Completed Overlay
            if (sessionState.isCompleted)
              Positioned.fill(
                child: Container(
                  color: Colors.black87,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 64,
                            color: AppColors.successAccent,
                          ).animate().scale(
                            duration: 500.ms,
                            curve: Curves.elasticOut,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            isIt
                                ? 'SESSIONE COMPLETATA'
                                : 'SESSION COMPLETED',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isIt
                                ? 'Hai coltivato presenza e calma interiore.'
                                : 'You cultivated presence and inner calm.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.goldAccent.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.goldAccent.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.stars_rounded,
                                  color: AppColors.goldAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '+${sessionState.lastSummary?.xpEarned ?? 30} XP',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.goldAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomUnityButton(
                                text: isIt ? 'RIPETI' : 'REPEAT',
                                onTap: _repeatSession,
                                accentColor: accentColor,
                                width: 130,
                                requireHold: false,
                              ),
                              const SizedBox(width: 16),
                              CustomUnityButton(
                                text: isIt ? 'CONCLUDI' : 'FINISH',
                                onTap: _confirmExit,
                                accentColor: AppColors.successAccent,
                                width: 130,
                                requireHold: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms),
              ),

            // 5. Timeout Fallback Dialog Overlay
            if (_showLoadTimeoutDialog)
              Positioned.fill(
                child: Container(
                  color: Colors.black87,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 340),
                      padding: const EdgeInsets.all(28),
                      decoration: AppColors.japandiCardDecoration(
                        isDark,
                        borderRadius: 24.0,
                        opacity: 0.95,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.goldAccent,
                            size: 40,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            isIt
                                ? 'Caricamento non riuscito'
                                : 'Loading Failed',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isIt
                                ? 'L\'ambiente 3D non è riuscito a caricare. Vuoi riprovare o tornare alla Home?'
                                : 'The 3D environment failed to load. Would you like to retry or return to Home?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: subTextColor,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: CustomUnityButton(
                                  text: isIt ? 'RIPROVA' : 'RETRY',
                                  onTap: _retryLoading,
                                  accentColor: accentColor,
                                  requireHold: false,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomUnityButton(
                                  text: isIt ? 'HOME' : 'HOME',
                                  onTap: _confirmExit,
                                  accentColor: AppColors.dangerAccent,
                                  requireHold: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms),

            // 6. Exit Confirmation Dialog Overlay
            if (_showExitConfirm)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 340),
                      padding: const EdgeInsets.all(28),
                      decoration: AppColors.japandiCardDecoration(
                        isDark,
                        borderRadius: 24.0,
                        opacity: 0.9,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.exit_to_app_rounded,
                            color: AppColors.dangerAccent,
                            size: 36,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            isIt
                                ? 'Vuoi uscire dall\'esperienza?'
                                : 'Do you want to exit session?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isIt
                                ? 'I tuoi progressi fino ad ora verranno salvati.'
                                : 'Your progress so far will be saved.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: subTextColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: CustomUnityButton(
                                  text: isIt ? 'CONTINUA' : 'STAY',
                                  onTap: _cancelExit,
                                  accentColor: accentColor,
                                  requireHold: false,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomUnityButton(
                                  text: isIt ? 'ESCI' : 'EXIT',
                                  onTap: _confirmExit,
                                  accentColor: AppColors.dangerAccent,
                                  requireHold: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 200.ms),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCircleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: "Interactive button",
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.4),
                border: Border.all(
                  color: color.withValues(alpha: 0.35),
                  width: 1.0,
                ),
              ),
              child: Center(child: Icon(icon, color: color, size: 22)),
            ),
          ),
        ),
      ),
    );
  }
}
