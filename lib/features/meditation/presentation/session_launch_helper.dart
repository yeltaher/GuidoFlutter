import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guido/core/vr/vr_host_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/vr_gaze_button.dart';
import '../../../core/database/settings_provider.dart';
import '../../../core/database/repositories/user_repository.dart';
import 'meditation_view.dart';
import '../../breathing/breathing_feature.dart';
import 'vr_calibration_screen.dart';

import 'explanation_screen.dart';

/// Funzione globale di utilità per avviare qualsiasi sessione di meditazione o respirazione
/// chiedendo prima l'esperienza Flat vs VR ed effettuando la conferma del visore.
void launchZenSession({
  required BuildContext context,
  required WidgetRef ref,
  required String title,
  String voicePath = '',
  String ambientPath = '',
  String? breathingAudioPath,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ExplanationScreen(
        title: title,
        voicePath: voicePath,
        ambientPath: ambientPath,
        breathingAudioPath: breathingAudioPath,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Dialog principale: Step 0 = Scelta Flat/VR
// ---------------------------------------------------------------------------

class SessionLaunchDialog extends ConsumerWidget {
  final String title;
  final String voicePath;
  final String ambientPath;
  final String? breathingAudioPath;

  const SessionLaunchDialog({
    Key? key,
    required this.title,
    required this.voicePath,
    required this.ambientPath,
    this.breathingAudioPath,
  }) : super(key: key);

  void _startFlatSession(BuildContext context, WidgetRef ref) {
    ref.read(settingsProvider.notifier).toggleVrMode(false);
    context.pop();
    if (breathingAudioPath != null) {
      context.push('/breathing', extra: {'title': title, 'audioPath': breathingAudioPath!});
    } else {
      context.push('/meditation', extra: {'title': title, 'voicePath': voicePath, 'ambientPath': ambientPath});
    }
  }

  void _goToVrConfirm(BuildContext context, WidgetRef ref) {
    context.pop();

    final settings = ref.read(settingsProvider);

    if (!settings.vrCalibrated) {
      // Se non calibrato, prima calibrazione poi conferma
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              VrCalibrationScreen(
            title: title,
            voicePath: voicePath,
            ambientPath: ambientPath,
            breathingAudioPath: breathingAudioPath,
          ),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } else {
      // Già calibrato: vai direttamente alla conferma del visore
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              VrConfirmationScreen(
            title: title,
            voicePath: voicePath,
            ambientPath: ambientPath,
            breathingAudioPath: breathingAudioPath,
          ),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final isIt = settings.language == 0;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subTextColor = AppColors.getSubTextColor(isDark);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: AppColors.japandiCardDecoration(isDark,
              borderRadius: 28.0, opacity: 0.85),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Icon(Icons.spa_outlined, color: accentColor, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                isIt ? "SCEGLI L'ESPERIENZA" : 'CHOOSE EXPERIENCE',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isIt
                    ? 'Come preferisci vivere questa meditazione?'
                    : 'How would you like to experience this session?',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                  color: subTextColor.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 24),

              _buildChoiceCard(
                icon: Icons.phone_android_rounded,
                title: isIt ? 'Modalità Standard' : 'Standard Mode',
                desc: isIt
                    ? 'Segui la meditazione direttamente sullo schermo dello smartphone.'
                    : 'Follow the meditation directly on your smartphone screen.',
                isDark: isDark,
                accentColor: accentColor,
                textColor: textColor,
                subTextColor: subTextColor,
                onTap: () => _startFlatSession(context, ref),
              ),

              const SizedBox(height: 14),

              _buildChoiceCard(
                icon: Icons.view_in_ar_rounded,
                title: isIt ? 'Modalità Visore VR 3D' : 'VR 3D Headset Mode',
                desc: isIt
                    ? 'Immergiti a 360° nel giardino zen inserendo il telefono in un visore VR Cardboard.'
                    : 'Immerse yourself 360° in the zen garden using a VR Cardboard headset.',
                isDark: isDark,
                accentColor: accentColor,
                textColor: textColor,
                subTextColor: subTextColor,
                onTap: () => _goToVrConfirm(context, ref),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  isIt ? 'ANNULLA' : 'CANCEL',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: subTextColor.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceCard({
    required IconData icon,
    required String title,
    required String desc,
    required bool isDark,
    required Color accentColor,
    required Color textColor,
    required Color subTextColor,
    required VoidCallback onTap,
  }) {
    return _SpringAnimationWrapper(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.03)
              : Colors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.06),
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(isDark ? 0.08 : 0.12),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: subTextColor.withOpacity(0.85),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// VrConfirmationScreen — usa VrHostScreen per landscape + gaze
// ---------------------------------------------------------------------------

class VrConfirmationScreen extends ConsumerStatefulWidget {
  final String title;
  final String voicePath;
  final String ambientPath;
  final String? breathingAudioPath;

  const VrConfirmationScreen({
    Key? key,
    required this.title,
    required this.voicePath,
    required this.ambientPath,
    this.breathingAudioPath,
  }) : super(key: key);

  @override
  ConsumerState<VrConfirmationScreen> createState() =>
      _VrConfirmationScreenState();
}

class _VrConfirmationScreenState extends ConsumerState<VrConfirmationScreen> {
  late final VrGazeController _gazeController;
  bool _sessionStarting = false;

  @override
  void initState() {
    super.initState();
    _gazeController = VrGazeController(
      sensitivity: 220.0,
      dwellTime: const Duration(seconds: 2),
      maxOffset: 140.0,
    );
  }

  @override
  void dispose() {
    _gazeController.dispose();
    super.dispose();
  }

  void _startVrSession() {
    if (_sessionStarting) return;
    _sessionStarting = true;
    ref.read(settingsProvider.notifier).toggleVrMode(true);
    Navigator.of(context)
        .pushReplacement(
      MaterialPageRoute(
        builder: (_) => widget.breathingAudioPath != null
            ? BreathingView(
                title: widget.title, audioPath: widget.breathingAudioPath!)
            : MeditationView(
                title: widget.title,
                voicePath: widget.voicePath,
                ambientPath: widget.ambientPath,
              ),
      ),
    )
        .then((_) async {
      ref.read(settingsProvider.notifier).toggleVrMode(false);
      final prefs = ref.read(sharedPrefsProvider);
      final sessionType = widget.breathingAudioPath != null ? "Respirazione" : "Meditazione";
      await ref.read(userRepositoryProvider).recordSession(widget.title, sessionType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final isIt = settings.language == 0;

    // VrHostScreen gestisce landscape + fullscreen + VrGazeScope
    return VrHostScreen(
      gazeController: _gazeController,
      eyeBuilder: (ctx, isLeft) =>
          _buildEyeContent(isIt, isDark, isActiveEye: isLeft),
    );
  }

  Widget _buildEyeContent(bool isIt, bool isDark,
      {required bool isActiveEye}) {
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
            Icons.screen_rotation_rounded,
            color: AppColors.goldAccent.withOpacity(0.85),
            size: 26,
          ),
          const SizedBox(height: 10),
          Text(
            isIt ? 'PREPARA IL VISORE' : 'PREPARE HEADSET',
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
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              isIt
                  ? 'Inserisci lo smartphone nel visore,\nindossalo e guarda il pulsante qui sotto.'
                  : 'Insert your phone in the headset,\nwear it and look at the button below.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
                color: AppColors.getTextColor(isDark).withOpacity(0.65),
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Occhio sinistro: bottone attivo — occhio destro: passivo (nessun hit-test)
          VrGazableButton(
            id: 'vr_confirm',
            label: isIt ? 'GUARDA QUI\nPER CONFERMARE' : 'LOOK HERE\nTO CONFIRM',
            icon: Icons.check_rounded,
            color: AppColors.successAccent,
            size: 72,
            hitRadius: 52,
            isActiveEye: isActiveEye,
            onTriggered: _startVrSession,
          ),

          const SizedBox(height: 22),

          Semantics(button: true, label: "Interactive element", child: GestureDetector(
            onTap: () => context.pop(),
            child: Text(
              isIt ? 'ANNULLA' : 'CANCEL',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9.0,
                fontWeight: FontWeight.w700,
                color: AppColors.getTextColor(isDark).withOpacity(0.30),
                letterSpacing: 1.5,
              ),
            ),
          )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SpringAnimationWrapper: micro animazione elastica al tocco
// ---------------------------------------------------------------------------

class _SpringAnimationWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _SpringAnimationWrapper({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_SpringAnimationWrapper> createState() =>
      _SpringAnimationWrapperState();
}

class _SpringAnimationWrapperState extends State<_SpringAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(button: true, label: "Interactive element", child: GestureDetector(
      onTapDown: (_) => _controller.animateTo(1.0,
          duration: const Duration(milliseconds: 80), curve: Curves.easeOut),
      onTapUp: (_) {
        _controller.animateTo(0.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.elasticOut);
        widget.onTap();
      },
      onTapCancel: () => _controller.animateTo(0.0,
          duration: const Duration(milliseconds: 150), curve: Curves.easeOut),
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    ));
  }
}
