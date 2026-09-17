import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/audio/audio_resolver_service.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/custom_button_widget.dart';
import '../../../core/vr/vr_orientation_service.dart';
import '../../../core/database/settings_provider.dart';
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

  UnitySessionController? _sessionNotifier;
  GuidoAudioService? _audioService;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WakelockPlus.enable();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    if (widget.isVrMode) {
      VrOrientationService.enterVr();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSession();
    });
  }

  void _initializeSession({bool isRepeat = false}) {
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

    // Timeout a 12 secondi se l'ambiente Unity non si carica
    _loadTimeoutTimer = Timer(const Duration(seconds: 12), () {
      if (mounted) {
        final isLoaded = ref.read(unitySessionControllerProvider).isSceneLoaded;
        if (!isLoaded) {
          setState(() {
            _showLoadTimeoutDialog = true;
          });
        }
      }
    });
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
      _audioService = audioService;
      final settings = ref.read(settingsProvider);

      audioService.setVoiceVolume(settings.voiceVolume);
      audioService.setVoiceMute(settings.isVoiceMuted);
      audioService.setAmbientVolume(settings.musicVolume);
      audioService.setEffectsVolume(settings.effectsVolume);

      if (bundle.ambientPath.isNotEmpty) {
        await audioService.playAmbient(bundle.ambientPath);
      }
      if (!isRepeat && bundle.voicePath.isNotEmpty && !settings.isVoiceMuted) {
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
    } else {
      controller.resumeSession();
      await audioService?.resumeAll();
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
    _loadTimeoutTimer?.cancel();
    final controller = ref.read(unitySessionControllerProvider.notifier);
    controller.stopSession();

    final audioService = ref.read(audioServiceProvider).valueOrNull;
    await audioService?.stopAll();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

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
    final audioService = ref.read(audioServiceProvider).valueOrNull;
    await audioService?.stopVoice();
    _initializeSession(isRepeat: true);
  }

  @override
  void dispose() {
    _loadTimeoutTimer?.cancel();
    _loadTimeoutTimer = null;

    final sessionNotifier = _sessionNotifier;
    if (sessionNotifier != null) {
      sessionNotifier.detachUnityWidgetController();
      Future.microtask(() => sessionNotifier.stopSession());
    }
    _audioService?.stopAll();

    WakelockPlus.disable();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (widget.isVrMode) {
      VrOrientationService.exitVr();
    }

    super.dispose();
  }

  String _formatDuration(double seconds) {
    final int totalSec = seconds.toInt();
    final int min = totalSec ~/ 60;
    final int sec = totalSec % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UnitySessionState>(unitySessionControllerProvider, (prev, next) {
      if (next.isSceneLoaded && _loadTimeoutTimer?.isActive == true) {
        _loadTimeoutTimer?.cancel();
        if (_showLoadTimeoutDialog) {
          setState(() {
            _showLoadTimeoutDialog = false;
          });
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
        if (didPop) return;
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
                onUnityCreated: sessionNotifier.onUnityCreated,
                onUnityMessage: sessionNotifier.onUnityMessage,
                onUnitySceneLoaded: sessionNotifier.onUnitySceneLoaded,
                onUnityUnloaded: sessionNotifier.onUnityUnloaded,
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

              // Bottom Progress & Breathing Phase Pill
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Respiration Phase Pill
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: accentColor.withValues(alpha: 0.3),
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: accentColor,
                                    ),
                                  ).animate(
                                    onPlay: (c) => c.repeat(reverse: true),
                                  ).scale(
                                    begin: const Offset(0.8, 0.8),
                                    end: const Offset(1.4, 1.4),
                                    duration: 1200.ms,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    sessionState.currentBreathingPhase
                                        .getLocalizedLabel(isIt),
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).animate(
                          target: sessionState
                              .currentBreathingPhase
                              .value
                              .toDouble(),
                        ).scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1.0, 1.0),
                          duration: 300.ms,
                        ),

                        const SizedBox(height: 16),

                        // Progress Bar & Timer
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white10,
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    _formatDuration(
                                      sessionState.elapsedSeconds,
                                    ),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: sessionState.progressNormalized
                                            .clamp(0.0, 1.0),
                                        backgroundColor: Colors.white12,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          accentColor,
                                        ),
                                        minHeight: 4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _formatDuration(
                                      sessionState.totalDurationSeconds,
                                    ),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                              ),
                              const SizedBox(width: 16),
                              CustomUnityButton(
                                text: isIt ? 'CONCLUDI' : 'FINISH',
                                onTap: _confirmExit,
                                accentColor: AppColors.successAccent,
                                width: 130,
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
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomUnityButton(
                                  text: isIt ? 'HOME' : 'HOME',
                                  onTap: _confirmExit,
                                  accentColor: AppColors.dangerAccent,
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
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomUnityButton(
                                  text: isIt ? 'ESCI' : 'EXIT',
                                  onTap: _confirmExit,
                                  accentColor: AppColors.dangerAccent,
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
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 44,
              height: 44,
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
