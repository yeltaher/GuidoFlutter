import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/vr_gaze_button.dart';
import '../../../core/vr/vr_host_screen.dart';
import '../../../core/database/settings_provider.dart';
import 'session_launch_helper.dart';

/// Schermata di calibrazione VR.
///
/// Fasi:
/// • Fase 0: Campionamento giroscopio (2.5s) → bias sempre impostato a 0.0
///   (puro giroscopio, nessuna forzatura)
/// • Fase 1: Conferma centratura gaze — guarda il pulsante centrale
/// • Fase 2: Successo → naviga alla schermata successiva
///
/// Usa [VrHostScreen] come wrapper: gestisce landscape + fullscreen + gaze scope.
class VrCalibrationScreen extends ConsumerStatefulWidget {
  final bool isFromSettings;
  final String? title;
  final String? voicePath;
  final String? ambientPath;
  final String? breathingAudioPath;

  const VrCalibrationScreen({
    super.key,
    this.isFromSettings = false,
    this.title,
    this.voicePath,
    this.ambientPath,
    this.breathingAudioPath,
  });

  @override
  ConsumerState<VrCalibrationScreen> createState() =>
      _VrCalibrationScreenState();
}

class _VrCalibrationScreenState extends ConsumerState<VrCalibrationScreen> {
  // 0 = Campionamento giroscopio, 1 = Conferma gaze, 2 = Successo
  int _phase = 0;
  double _calibrationProgress = 0.0;

  StreamSubscription<GyroscopeEvent>? _gyroSub;
  Timer? _countdownTimer;
  DateTime? _phase0StartTime;
  static const double _phase0DurationMs = 2500.0;

  // Controller gaze — creato in fase 1, condiviso con VrHostScreen
  late final VrGazeController _gazeController;

  @override
  void initState() {
    super.initState();
    // Crea il controller subito — VrHostScreen lo userà quando mountato.
    // Il controller NON avvia il giroscopio finché VrGazeScope.initState non
    // chiama controller.start(). La calibrazione usa il proprio _gyroSub.
    _gazeController = VrGazeController(
      sensitivity: 220.0,
      dwellTime: const Duration(milliseconds: 1500),
      maxOffset: 140.0,
    );

    _startDriftCalibration();
  }

  @override
  void dispose() {
    _gyroSub?.cancel();
    _countdownTimer?.cancel();
    _gazeController.dispose();
    super.dispose();
  }

  void _startDriftCalibration() {
    _gyroSub?.cancel();
    _countdownTimer?.cancel();
    _calibrationProgress = 0.0;
    _phase = 0;
    _phase0StartTime = DateTime.now();

    // Campionamento per UI — il bias viene sempre impostato a 0.0 (puro giroscopio)
    _gyroSub = gyroscopeEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen((_) {}, onError: (_) {});

    _countdownTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted || _phase0StartTime == null) {
        timer.cancel();
        return;
      }
      final elapsed = DateTime.now()
          .difference(_phase0StartTime!)
          .inMilliseconds;
      setState(() {
        _calibrationProgress = (elapsed / _phase0DurationMs).clamp(0.0, 1.0);
      });
      if (elapsed >= _phase0DurationMs) {
        timer.cancel();
        _completeDriftPhase();
      }
    });
  }

  void _completeDriftPhase() {
    _gyroSub?.cancel();
    _gyroSub = null;

    // Bias sempre 0.0: il giroscopio è usato puro, senza correzione artificiale
    ref.read(settingsProvider.notifier).saveVrCalibration(0.0, 0.0);

    setState(() {
      _phase = 1;
      _gazeController.recenter();
    });
  }

  void _finishCalibration() {
    if (widget.isFromSettings) {
      context.pop();
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              VrConfirmationScreen(
                title: widget.title ?? '',
                voicePath: widget.voicePath ?? '',
                ambientPath: widget.ambientPath ?? '',
                breathingAudioPath: widget.breathingAudioPath,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final isIt = settings.language == 0;

    return VrHostScreen(
      gazeController: _gazeController,
      eyeBuilder: (ctx, isLeft) {
        switch (_phase) {
          case 0:
            return _buildDriftEyeContent(isIt, isDark);
          case 1:
            return _buildGazeEyeContent(isIt, isDark, isActiveEye: isLeft);
          default:
            return _buildSuccessEyeContent(isIt, isDark);
        }
      },
    );
  }

  // ── FASE 0: Campionamento drift ────────────────────────────────────────────

  Widget _buildDriftEyeContent(bool isIt, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.getGradientByTime(isDark),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.vibration_rounded,
            color: AppColors.getActiveAccentColor(
              isDark,
            ).withValues(alpha: 0.85),
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            isIt ? 'CALIBRAZIONE IN CORSO' : 'CALIBRATING SENSORS',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.getTextColor(isDark),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              isIt
                  ? 'Tieni il telefono completamente fermo\no appoggialo su una superficie piana.'
                  : 'Hold the phone completely still\nor place it on a flat surface.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
                color: AppColors.getTextColor(isDark).withValues(alpha: 0.65),
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: 130,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _calibrationProgress,
                    backgroundColor: AppColors.getTextColor(
                      isDark,
                    ).withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.getActiveAccentColor(isDark),
                    ),
                    minHeight: 5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(_calibrationProgress * 100).toInt()}%',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextColor(
                      isDark,
                    ).withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Semantics(
            button: true,
            label: "Interactive element",
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Text(
                isIt ? 'ANNULLA' : 'CANCEL',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9.0,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextColor(isDark).withValues(alpha: 0.30),
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── FASE 1: Verifica gaze ──────────────────────────────────────────────────

  Widget _buildGazeEyeContent(
    bool isIt,
    bool isDark, {
    required bool isActiveEye,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.getGradientByTime(isDark),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.center_focus_strong_rounded,
            color: AppColors.getActiveAccentColor(
              isDark,
            ).withValues(alpha: 0.85),
            size: 26,
          ),
          const SizedBox(height: 10),
          Text(
            isIt ? 'CENTRA LO SGUARDO' : 'CENTER YOUR GAZE',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.getTextColor(isDark),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              isIt
                  ? 'Guarda dritto davanti a te e fissa il\npulsante verde al centro per completare.'
                  : 'Look straight ahead and gaze at the\ngreen button in the center to complete.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                color: AppColors.getTextColor(isDark).withValues(alpha: 0.65),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Occhio sinistro: bottone attivo (isActiveEye=true)
          // Occhio destro: copia passiva (isActiveEye=false) → nessun hit-test
          VrGazableButton(
            id: 'calib_recenter',
            label: isIt ? 'GUARDA QUI' : 'LOOK HERE',
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.successAccent,
            size: 70,
            hitRadius: 52,
            isActiveEye: isActiveEye,
            onTriggered: () {
              if (mounted) {
                setState(() => _phase = 2);
                Future.delayed(const Duration(milliseconds: 900), () {
                  if (mounted) _finishCalibration();
                });
              }
            },
          ),

          const SizedBox(height: 14),
          Semantics(
            button: true,
            label: "Interactive element",
            child: GestureDetector(
              onTap: () {
                _gazeController.recenter();
                _startDriftCalibration();
              },
              child: Text(
                isIt ? 'RIPETI RILEVAMENTO' : 'REDO DETECTION',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextColor(isDark).withValues(alpha: 0.30),
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── FASE 2: Successo ───────────────────────────────────────────────────────

  Widget _buildSuccessEyeContent(bool isIt, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.getGradientByTime(isDark),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x1F5E8C7A),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.successAccent,
              size: 36,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            isIt ? 'CALIBRAZIONE RIUSCITA!' : 'CALIBRATION SUCCESSFUL!',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.getTextColor(isDark),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isIt
                ? 'Il giroscopio è ora calibrato.\nPreparati alla sessione...'
                : 'Gyroscope is now calibrated.\nPreparing your session...',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
              color: AppColors.getTextColor(isDark).withValues(alpha: 0.65),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
