import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'remove_vr_headset_view.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/custom_button_widget.dart';
import '../../../core/theme/glb_viewer_widget.dart';
import '../../../core/theme/vr_gaze_button.dart';
import '../../../core/vr/vr_host_screen.dart';
import '../../../core/database/settings_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class MeditationView extends ConsumerStatefulWidget {
  final String title;
  final String voicePath;
  final String ambientPath;

  const MeditationView({
    Key? key,
    required this.title,
    required this.voicePath,
    required this.ambientPath,
  }) : super(key: key);

  @override
  ConsumerState<MeditationView> createState() => _MeditationViewState();
}

class _MeditationViewState extends ConsumerState<MeditationView> {
  String _typedText = '';
  bool _isTypewriterComplete = false;
  bool _isPlaying = true;
  Timer? _typewriterTimer;
  int _vrRandomSeed = 0;
  bool _showExitConfirm = false;

  // Controller gaze — creato solo in VR mode, gestito dal VrHostScreen
  VrGazeController? _gazeController;

  final String _itaIntro =
      'Trova una posizione comoda...\nChiudi delicatamente gli occhi...\n\nInizia a respirare profondamente, liberando la mente da ogni preoccupazione. Lasciati cullare dal suono e dalla mia voce.';
  final String _engIntro =
      'Find a comfortable position...\nGently close your eyes...\n\nBegin to breathe deeply, freeing your mind from all worries. Let yourself be lulled by the sound and my voice.';

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();

    final settings = ref.read(settingsProvider);
    if (settings.isVrMode) {
      _vrRandomSeed = DateTime.now().millisecondsSinceEpoch;
      // Crea il controller — VrHostScreen si occupa di landscape + fullscreen
      _gazeController = VrGazeController(
        sensitivity: 220.0,
        dwellTime: const Duration(seconds: 2),
        maxOffset: 140.0,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioService = ref.read(audioServiceProvider);
      audioService.playAmbient(widget.ambientPath);
      audioService.playVoice(widget.voicePath);
      _startTypewriter();
    });
  }

  void _startTypewriter() {
    final isIt = ref.read(settingsProvider).language == 0;
    final textToType = isIt ? _itaIntro : _engIntro;
    int index = 0;

    _typewriterTimer =
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        if (index < textToType.length) {
          setState(() {
            _typedText += textToType[index];
            index++;
          });
        } else {
          timer.cancel();
          setState(() => _isTypewriterComplete = true);
        }
      }
    });
  }

  void _togglePlay() {
    final audioService = ref.read(audioServiceProvider);
    if (_isPlaying) {
      audioService.pauseAll();
    } else {
      audioService.resumeAll();
    }
    setState(() => _isPlaying = !_isPlaying);
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
    _typewriterTimer?.cancel();
    ref.read(audioServiceProvider).stopAll();
    final isVr = ref.read(settingsProvider).isVrMode;
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
    _typewriterTimer?.cancel();
    _gazeController?.dispose();
    WakelockPlus.disable();
    // VrHostScreen chiama già VrOrientationService.exitVr() nel suo dispose.
    // Qui non servono chiamate dirette ad AppOrientation.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isVrMode = settings.isVrMode;

    Widget content;
    if (isVrMode) {
      final ctrl = _gazeController;
      if (ctrl == null) {
        content = const Scaffold(
            backgroundColor: Colors.black, body: SizedBox.shrink());
      } else {
        // VrHostScreen gestisce: landscape + fullscreen + VrGazeScope + split-screen
        content = VrHostScreen(
          gazeController: ctrl,
          eyeBuilder: (ctx, isLeft) => _buildSingleEyeView(
            context,
            vrOffset: isLeft ? -4.5 : 4.5,
            isLeft: isLeft,
            isActiveEye: isLeft,
          ),
        );
      }
    } else {
      // Modalità flat standard
      content = Scaffold(
        body: _buildSingleEyeView(
          context,
          vrOffset: 0.0,
          isLeft: true,
          isActiveEye: true,
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _requestExit();
      },
      child: content,
    );
  }

  Widget _buildSingleEyeView(
    BuildContext context, {
    required double vrOffset,
    required bool isLeft,
    required bool isActiveEye,
  }) {
    final settings = ref.watch(settingsProvider);
    final isIt = settings.language == 0;
    final isVr = settings.isVrMode;
    final isDark = settings.isDarkTheme;
    final textColor = AppColors.getTextColor(isDark);

    final double portalSize = isVr ? 160.0 : 300.0;
    final double titleFontSize = isVr ? 12.0 : 20.0;
    final double textFontSize = isVr ? 9.5 : 14.0;
    final double buttonWidth = isVr ? 130.0 : 220.0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.getGradientByTime(isDark),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                  child: Hero(
                    tag: 'meditation_portal',
                    child: SizedBox(
                      width: portalSize,
                      height: portalSize,
                      child: const GlbViewerWidget(
                        src: 'assets/models/portal.glb',
                        autoRotate: true,
                        cameraControls: false,
                      ),
                    ),
                  ),
              ),
            ),
          ),

          if (isVr) ...[
            // Pulsante Uscita VR (in alto a sinistra, piccolo e fuori dallo scope centrale)
            Positioned(
              top: 16,
              left: 16,
              child: VrGazableButton(
                id: 'med_close_vr',
                label: '', // Nessuna etichetta per renderlo meno ingombrante
                icon: Icons.close_rounded,
                color: AppColors.dangerAccent,
                size: 32,
                hitRadius: 36,
                isActiveEye: isActiveEye,
                onTriggered: _requestExit,
              ),
            ),
            // Pulsante Pausa/Riprendi VR (in alto a destra, piccolo e fuori dallo scope centrale)
            Positioned(
              top: 16,
              right: 16,
              child: VrGazableButton(
                id: 'med_pause_vr',
                label: '', // Nessuna etichetta per renderlo meno ingombrante
                icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: _isPlaying ? AppColors.getSubTextColor(isDark).withOpacity(0.5) : AppColors.successAccent,
                size: 32,
                hitRadius: 36,
                isActiveEye: isActiveEye,
                onTriggered: _togglePlay,
              ),
            ),
          ],

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

                  Expanded(
                    child: Center(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(isVr ? 14 : 26),
                        child: BackdropFilter(
                          filter:
                              ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            constraints: BoxConstraints(
                                maxHeight: isVr ? 140 : 280),
                            padding:
                                EdgeInsets.all(isVr ? 12 : 24),
                            decoration: AppColors.japandiCardDecoration(
                              isDark,
                              borderRadius: isVr ? 14.0 : 26.0,
                              opacity: 0.38,
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                _typedText,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: textFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: textColor.withOpacity(0.35),
                                  height: isVr ? 1.45 : 1.7,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      if (_isTypewriterComplete && !isVr) ...[
                        CustomUnityButton(
                          text: _isPlaying
                              ? (isIt ? 'PAUSA' : 'PAUSE')
                              : (isIt ? 'RIPRENDI' : 'RESUME'),
                          onTap: _togglePlay,
                          accentColor: _isPlaying
                              ? AppColors.getSubTextColor(isDark)
                                  .withOpacity(0.5)
                              : AppColors.successAccent,
                          width: buttonWidth,
                        ).animate().fadeIn(duration: 400.ms),
                        SizedBox(height: 16),
                      ],
                      if (!isVr)
                        CustomUnityButton(
                          text: isIt ? 'Chiudi sessione' : 'Close session',
                          onTap: _requestExit,
                          accentColor: AppColors.dangerAccent,
                          width: buttonWidth,
                        ),
                      SizedBox(height: isVr ? 4 : 10),
                    ],
                  ),
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
                        id: 'exit_no_vr',
                        label: isIt ? 'NO' : 'NO',
                        icon: Icons.close_rounded,
                        color: AppColors.getActiveAccentColor(isDark),
                        size: 40,
                        hitRadius: 40,
                        isActiveEye: isActiveEye,
                        onTriggered: _cancelExit,
                      )
                    : CustomUnityButton(
                        text: isIt ? 'NO' : 'NO',
                        onTap: _cancelExit,
                        accentColor: AppColors.getActiveAccentColor(isDark),
                        width: buttonWidth,
                      ),
                  SizedBox(width: isVr ? 24 : 32),
                  isVr
                    ? VrGazableButton(
                        id: 'exit_yes_vr',
                        label: isIt ? 'SÌ' : 'YES',
                        icon: Icons.check_rounded,
                        color: AppColors.dangerAccent,
                        size: 40,
                        hitRadius: 40,
                        isActiveEye: isActiveEye,
                        onTriggered: _confirmExit,
                      )
                    : CustomUnityButton(
                        text: isIt ? 'SÌ' : 'YES',
                        onTap: _confirmExit,
                        accentColor: AppColors.dangerAccent,
                        width: buttonWidth,
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
