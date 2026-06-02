import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/custom_button_widget.dart';
import '../../../core/theme/glb_viewer_widget.dart';
import '../../../core/vr/vr_360_video_widget.dart';
import '../../../core/vr/flat_video_widget.dart';
import '../../../core/theme/vr_gaze_button.dart';
import '../../../core/vr/vr_host_screen.dart';
import '../../../core/vr/vr_orientation_service.dart';
import '../../../core/vr/shared_sbs_video_widget.dart';
import '../../../core/database/settings_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:just_audio/just_audio.dart';
import '../../meditation/presentation/remove_vr_headset_view.dart';

class BreathingView extends ConsumerStatefulWidget {
  final String title;
  final String audioPath;

  const BreathingView({
    Key? key,
    required this.title,
    required this.audioPath,
  }) : super(key: key);

  @override
  ConsumerState<BreathingView> createState() => _BreathingViewState();
}

class _BreathingViewState extends ConsumerState<BreathingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _timer;
  int _secondsElapsed = 0;
  String _phaseText = '';
  bool _isPlaying = true;
  bool _isSessionFinished = false;
  StreamSubscription<PlayerState>? _audioStateSub;

  bool _isVrVideoReady = false;

  // Controller gaze — creato solo in VR mode, gestito da VrHostScreen
  VrGazeController? _gazeController;

  int _countdown = 3;
  bool _showCountdown = false;
  Timer? _countdownTimer;
  bool _showExitConfirm = false;

  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();

    final settings = ref.read(settingsProvider);
    if (settings.isVrMode) {
      // Crea il controller — VrHostScreen si occupa di landscape + fullscreen
      _gazeController = VrGazeController(
        sensitivity: 220.0,
        dwellTime: const Duration(seconds: 2),
        maxOffset: 140.0,
      );
    }

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _pulseController.repeat(reverse: true);

    if (settings.isVrMode) {
      _startExperience();
    } else {
      VrOrientationService.enterVr();
      _showCountdown = true;
      _startCountdownTimer();
    }

    _initVideo();
  }

  Future<void> _initVideo() async {
    final settings = ref.read(settingsProvider);
    final bool isWater = widget.title.toLowerCase().contains('acqua') || widget.title.toLowerCase().contains('water');
    if (isWater) {
      final assetPath = settings.isVrMode 
          ? 'assets/Esperienze_Guido/Video/Respirazioni/Acqua/Respirazione_Acqua_SBS.mp4'
          : 'assets/Esperienze_Guido/Video/Respirazioni/Acqua/Respirazione_Mono.mp4';
      _videoController = VideoPlayerController.asset(assetPath);
      await _videoController!.initialize();
      _videoController!.setVolume(0.0);
      _videoController!.setLooping(true); // LOOP INIFINITO
      if (mounted) {
        setState(() {
          _isVrVideoReady = true;
        });
      }
    }
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          _showCountdown = false;
          timer.cancel();
          _startExperience();
        }
      });
    });
  }

  void _startExperience() {
    final audioService = ref.read(audioServiceProvider);
    audioService.playEffect(widget.audioPath, loop: true); // Audio infinito come richiesto per non fermare il video
    _updatePhase();
    
    if (_videoController != null) {
      _videoController!.play();
    }

    _audioStateSub = audioService.effectsPlayerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted && !_isSessionFinished) {
          setState(() {
            _isSessionFinished = true;
            _isPlaying = false;
            _pulseController.stop();
          });
        }
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _isPlaying && !_isSessionFinished) {
        setState(() {
          _secondsElapsed += 4;
          _updatePhase();
        });
      }
    });
  }

  void _repeatSession() {
    setState(() {
      _isSessionFinished = false;
      _secondsElapsed = 0;
      _isPlaying = true;
      _updatePhase();
      _pulseController.repeat(reverse: true);
    });
    final audioService = ref.read(audioServiceProvider);
    audioService.playEffect(widget.audioPath, loop: false);
  }

  void _togglePlay() {
    final audioService = ref.read(audioServiceProvider);
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        audioService.resumeAll();
        _pulseController.repeat(reverse: true);
        _videoController?.play();
      } else {
        audioService.pauseAll();
        _pulseController.stop();
        _videoController?.pause();
      }
    });
  }

  void _updatePhase() {
    final isIt = ref.read(settingsProvider).language == 0;
    if (_secondsElapsed % 8 == 0) {
      _phaseText = isIt ? 'INSPIRA...' : 'BREATHE IN...';
    } else {
      _phaseText = isIt ? 'ESPIRA...' : 'BREATHE OUT...';
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

  void _confirmExit() {
    final isVr = ref.read(settingsProvider).isVrMode;
    ref.read(audioServiceProvider).stopAll();
    if (isVr) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RemoveVrHeadsetView()),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _audioStateSub?.cancel();
    _timer?.cancel();
    _countdownTimer?.cancel();
    _pulseController.dispose();
    _gazeController?.dispose();
    WakelockPlus.disable();
    // Qui non servono chiamate dirette ad AppOrientation.
    if (!ref.read(settingsProvider).isVrMode) {
      VrOrientationService.exitVr();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isVr = settings.isVrMode;
    final bool isWater = widget.title.toLowerCase().contains('acqua') || widget.title.toLowerCase().contains('water');

    Widget content;
    if (isVr) {
      final ctrl = _gazeController;
      if (ctrl == null) {
        content = const Scaffold(
            backgroundColor: Colors.black, body: SizedBox.shrink());
      } else {
        final host = VrHostScreen(
          gazeController: ctrl,
          backgroundColor: isWater ? Colors.transparent : Colors.black,
          eyeBuilder: (ctx, isLeft) => Stack(
            children: [
              if (isWater && _isVrVideoReady && _videoController != null)
                Positioned.fill(
                  child: SharedSbsVideoWidget(
                    controller: _videoController!,
                    isLeftEye: isLeft,
                    gazeController: ctrl,
                  ),
                ),
              _buildSingleEyeView(
                context,
                isLeft: isLeft,
                isActiveEye: isLeft,
                isWater: isWater,
              ),
            ],
          ),
        );

        content = host;
      }
    } else {
      final uiOverlay = _showCountdown 
          ? _buildCountdownOverlay(context)
          : _buildSingleEyeView(
              context,
              isLeft: true,
              isActiveEye: true,
              isWater: isWater,
            );

      content = Scaffold(
        backgroundColor: isWater ? Colors.transparent : Colors.black,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1200),
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          child: _showCountdown
              ? Stack(
                  key: const ValueKey('countdown_stack'),
                  children: [
                    Positioned.fill(child: uiOverlay),
                  ],
                )
              : Stack(
                  key: const ValueKey('experience_stack'),
                  children: [
                    if (isWater && _isVrVideoReady && _videoController != null)
                      Positioned.fill(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _videoController!.value.size.width,
                            height: _videoController!.value.size.height,
                            child: VideoPlayer(_videoController!),
                          ),
                        ),
                      ),
                    Positioned.fill(
                      child: uiOverlay,
                    ),
                  ],
                ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (!_isSessionFinished) {
          _requestExit();
        } else {
          _confirmExit();
        }
      },
      child: content,
    );
  }

  Widget _buildCountdownOverlay(BuildContext context) {
    final isDark = ref.watch(settingsProvider).isDarkTheme;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.getGradientByTime(isDark),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Effetto magico: bagliore pulsante al centro
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.25),
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withOpacity(isDark ? 0.15 : 0.25),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: const SizedBox.shrink(),
                  ),
                ),
              );
            },
          ),
          
          // Testo del conto alla rovescia animato fluidamente
          Text(
            '$_countdown',
            style: GoogleFonts.outfit(
              fontSize: 140,
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.9),
              shadows: [
                Shadow(
                  color: accentColor.withOpacity(0.6),
                  blurRadius: 40,
                  offset: const Offset(0, 0),
                )
              ],
            ),
          ).animate(key: ValueKey(_countdown))
           .fadeIn(duration: 400.ms, curve: Curves.easeOut)
           .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.1, 1.1), duration: 900.ms, curve: Curves.easeOutCubic)
           .fadeOut(delay: 700.ms, duration: 300.ms, curve: Curves.easeIn),
        ],
      ),
    );
  }

  Widget _buildSingleEyeView(
    BuildContext context, {
    required bool isLeft,
    required bool isActiveEye,
    required bool isWater,
  }) {
    final settings = ref.watch(settingsProvider);
    final isIt = settings.language == 0;
    final isVr = settings.isVrMode;
    final isDark = settings.isDarkTheme;
    final textColor = AppColors.getTextColor(isDark);
    final accentColor = AppColors.getActiveAccentColor(isDark);

    final double titleFontSize = isVr ? 12.0 : 20.0;
    final double buttonWidth = isVr ? 130.0 : 220.0;
    final double balloonSize = isVr ? 140.0 : 280.0;
    final bool isWater = widget.title.toLowerCase().contains('acqua') || widget.title.toLowerCase().contains('water');

    return Container(
      decoration: isWater ? null : BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.getGradientByTime(isDark),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: isVr ? 40 : 100,
            left: 0,
            right: 0,
            child: Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 1.15).animate(
                  CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
                ),
                child: Container(
                  key: ValueKey('breathing_ambient_glow_$isLeft'),
                  width: balloonSize * 1.5,
                  height: balloonSize * 1.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isWater ? Colors.transparent : accentColor.withOpacity(isDark ? 0.04 : 0.08),
                  ),
                  child: isWater
                      ? const SizedBox.shrink()
                      : BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                          child: const SizedBox.shrink(),
                        ),
                ),
              ),
            ),
          ),

          if (isVr && !_isSessionFinished) ...[
            // Pulsante Uscita (in alto a sinistra)
            Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: VrGazableButton(
                  id: 'breath_close_vr',
                  label: '', 
                  icon: Icons.close_rounded,
                  color: AppColors.dangerAccent,
                  size: 32,
                  hitRadius: 36,
                  isActiveEye: isActiveEye,
                  onTriggered: _requestExit,
                ),
              ),
            ),
            // Pulsante Pausa/Riprendi (in alto a destra)
            Positioned(
              top: 16,
              right: 16,
              child: SafeArea(
                child: VrGazableButton(
                  id: 'breath_pause_vr',
                  label: '', 
                  icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: _isPlaying ? AppColors.getSubTextColor(isDark).withOpacity(0.5) : AppColors.successAccent,
                  size: 32,
                  hitRadius: 36,
                  isActiveEye: isActiveEye,
                  onTriggered: _togglePlay,
                ),
              ),
            ),
          ],
          
          if (!isVr && !_isSessionFinished) ...[
            // Pulsante Uscita (in basso a sinistra)
            Positioned(
              bottom: 24,
              left: 24,
              child: SafeArea(
                child: _build2DButton(
                  label: '',
                  icon: Icons.close_rounded,
                  color: AppColors.dangerAccent,
                  onTap: _requestExit,
                  size: 48,
                ),
              ),
            ),
            // Pulsante Pausa/Riprendi (in basso a destra)
            Positioned(
              bottom: 24,
              right: 24,
              child: SafeArea(
                child: _build2DButton(
                  label: '',
                  icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: _isPlaying ? AppColors.getSubTextColor(isDark).withOpacity(0.5) : AppColors.successAccent,
                  onTap: _togglePlay,
                  size: 48,
                ),
              ),
            ),
          ],
          
          if (_isSessionFinished)
            Positioned.fill(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isVr
                      ? VrGazableButton(
                          id: 'breath_exit_vr',
                          label: isIt ? 'ESCI' : 'EXIT',
                          icon: Icons.close_rounded,
                          color: AppColors.dangerAccent,
                          size: 90,
                          hitRadius: 60,
                          isActiveEye: isActiveEye,
                          onTriggered: _confirmExit,
                        )
                      : _build2DButton(
                          label: isIt ? 'ESCI' : 'EXIT',
                          icon: Icons.close_rounded,
                          color: AppColors.dangerAccent,
                          onTap: _confirmExit,
                          size: 72,
                        ),
                    const SizedBox(width: 40),
                    isVr
                      ? VrGazableButton(
                          id: 'breath_repeat_vr',
                          label: isIt ? 'RIPETI' : 'REPEAT',
                          icon: Icons.replay_rounded,
                          color: AppColors.successAccent,
                          size: 90,
                          hitRadius: 60,
                          isActiveEye: isActiveEye,
                          onTriggered: _repeatSession,
                        )
                      : _build2DButton(
                          label: isIt ? 'RIPETI' : 'REPEAT',
                          icon: Icons.replay_rounded,
                          color: AppColors.successAccent,
                          onTap: _repeatSession,
                          size: 72,
                        ),
                  ],
                ),
              ),
            ),

          if (isVr && !_isVrVideoReady && isWater)
            Positioned.fill(
              child: Center(
                child: VrGazableButton(
                  id: 'breath_start_vr_video',
                  label: isIt ? 'PRONTO' : 'READY',
                  icon: Icons.visibility_rounded,
                  color: AppColors.successAccent,
                  size: 90,
                  hitRadius: 60,
                  isActiveEye: isActiveEye,
                  onTriggered: () {
                    setState(() {
                      _isVrVideoReady = true;
                    });
                  },
                ),
              ),
            ),

          if (!isVr || _isVrVideoReady || !isWater)
            SafeArea(
            left: !isVr,
            right: !isVr,
            top: !isVr,
            bottom: !isVr,
            child: Padding(
              padding: EdgeInsets.all(isVr ? 12.0 : 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w900,
                      color: textColor.withOpacity(0.35),
                      letterSpacing: isVr ? 1.5 : 3.0,
                    ),
                  ),
                  
                  if (!_isSessionFinished)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              if (isWater) {
                                return SizedBox(height: balloonSize); // Spazio vuoto, il video fa da sfondo
                              }
                              return SizedBox(
                                width: balloonSize,
                                height: balloonSize,
                                child: Transform.scale(
                                  scale: 1.0 + (_pulseController.value * 0.15),
                                  child: const GlbViewerWidget(
                                    src: 'assets/models/balloon.glb',
                                    autoRotate: false,
                                    cameraControls: false,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: isVr ? 18 : 36),

                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(isVr ? 12 : 24),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isVr ? 18 : 30,
                                  vertical: isVr ? 8 : 14,
                                ),
                                decoration:
                                    AppColors.japandiCardDecoration(
                                  isDark,
                                  borderRadius: isVr ? 12.0 : 24.0,
                                  opacity: 0.38,
                                ),
                                child: Text(
                                  _phaseText,
                                  style: GoogleFonts.outfit(
                                    fontSize: isVr ? 10 : 14,
                                    fontWeight: FontWeight.w800,
                                    color: textColor.withOpacity(0.35),
                                    letterSpacing: isVr ? 1.0 : 2.5,
                                  ),
                                ),
                              ),
                            ),
                          ).animate(
                              target: _phaseText.hashCode.toDouble()),
                        ],
                      ),
                    )
                  else if (isVr) 
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ),

          if (_showExitConfirm)
            Positioned.fill(
              child: _buildExitConfirmOverlay(context, isVr: isVr, isActiveEye: isActiveEye),
            ),
        ],
      ),
    );
  }

  Widget _buildExitConfirmOverlay(BuildContext context, {required bool isVr, required bool isActiveEye}) {
    final settings = ref.watch(settingsProvider);
    final isIt = settings.language == 0;
    final isDark = settings.isDarkTheme;
    final textColor = AppColors.getTextColor(isDark);

    final titleFontSize = isVr ? 12.0 : 20.0;
    final buttonWidth = isVr ? 100.0 : 160.0;

    return Container(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Container(
          padding: EdgeInsets.all(isVr ? 16 : 32),
          decoration: AppColors.japandiCardDecoration(
            isDark,
            borderRadius: isVr ? 16.0 : 28.0,
            opacity: 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isIt ? 'Vuoi uscire dall\'esperienza?' : 'Do you want to exit?',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: isVr ? 16 : 32),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isVr
                    ? VrGazableButton(
                        id: 'exit_no_vr_breath',
                        label: isIt ? 'NO' : 'NO',
                        icon: Icons.close_rounded,
                        color: AppColors.getActiveAccentColor(isDark),
                        size: 40,
                        hitRadius: 40,
                        isActiveEye: isActiveEye,
                        onTriggered: _cancelExit,
                      )
                    : _build2DButton(
                        label: isIt ? 'NO' : 'NO',
                        icon: Icons.close_rounded,
                        color: AppColors.getActiveAccentColor(isDark),
                        onTap: _cancelExit,
                        size: 40,
                      ),
                  SizedBox(width: isVr ? 24 : 32),
                  isVr
                    ? VrGazableButton(
                        id: 'exit_yes_vr_breath',
                        label: isIt ? 'SÌ' : 'YES',
                        icon: Icons.check_rounded,
                        color: AppColors.dangerAccent,
                        size: 40,
                        hitRadius: 40,
                        isActiveEye: isActiveEye,
                        onTriggered: _confirmExit,
                      )
                    : _build2DButton(
                        label: isIt ? 'SÌ' : 'YES',
                        icon: Icons.check_rounded,
                        color: AppColors.dangerAccent,
                        onTap: _confirmExit,
                        size: 40,
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _build2DButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double size = 60,
  }) {
    final isDark = ref.watch(settingsProvider).isDarkTheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: AppColors.japandiCardDecoration(
              isDark,
              borderRadius: size / 2,
              opacity: 0.3,
            ).copyWith(
              color: Colors.black.withOpacity(0.2), // Added slight background tint for contrast
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ]
            ),
            child: Center(
              child: Icon(icon, color: color, size: size * 0.5),
            ),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    blurRadius: 4,
                    color: Colors.black54,
                  )
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
