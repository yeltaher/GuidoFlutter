// ignore_for_file: unused_local_variable, deprecated_member_use, use_build_context_synchronously, curly_braces_in_flow_control_structures, unused_element, unused_field
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guido/core/vr/vr_host_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/vr_gaze_button.dart';
import '../../../core/database/settings_provider.dart';
import '../../../core/unity/unity_bridge_dto.dart';
import '../../../core/audio/audio_resolver_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Funzione globale di utilità per avviare qualsiasi sessione di meditazione o respirazione
/// chiedendo prima l'esperienza Flat vs VR ed effettuando la conferma del visore.
void launchZenSession({
  required BuildContext context,
  required WidgetRef ref,
  required String title,
  String voicePath = '',
  String ambientPath = '',
  String? breathingAudioPath,
  String? sceneName,
  double durationSeconds = 300.0,
  bool isPremium = false,
}) {
  final settings = ref.read(settingsProvider);

  // Guard centralizzata: se l'esperienza è premium e l'utente non ha sbloccato il pacchetto premium,
  // apre direttamente il paywall e blocca l'apertura di ExplanationScreen.
  if (isPremium && !settings.isUnlocked) {
    context.push('/premium');
    return;
  }

  final resolvedScene = UnityScenes.resolveSceneName(
    explicitSceneName: sceneName,
    title: title,
    isBreathing: breathingAudioPath != null,
  );

  context.push(
    '/explanation',
    extra: {
      'title': title,
      'voicePath': voicePath,
      'ambientPath': ambientPath,
      'breathingAudioPath': breathingAudioPath,
      'sceneName': resolvedScene,
      'durationSeconds': durationSeconds,
    },
  );
}

/// Avvia direttamente un'esperienza Unity UaaL 3D / VR fotorealistica con bundle audio sincronizzato.
void launchUnityExperience({
  required BuildContext context,
  required WidgetRef ref,
  required String title,
  required String sceneName,
  double durationSeconds = 300.0,
  bool isVrMode = false,
  String? voicePath,
  String? ambientPath,
}) {
  final settings = ref.read(settingsProvider);
  final bundle = AudioResolverService.resolveBundle(
    title: title,
    sceneName: sceneName,
    voiceSex: settings.voiceSex,
    language: settings.language,
    customVoicePath: voicePath,
    customAmbientPath: ambientPath,
    durationSeconds: durationSeconds,
  );

  context.push(
    '/unity-experience',
    extra: {
      'title': title,
      'sceneName': bundle.sceneName,
      'durationSeconds': bundle.durationSeconds,
      'isVrMode': isVrMode,
      'voicePath': bundle.voicePath,
      'ambientPath': bundle.ambientPath,
    },
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
  final String? sceneName;
  final double durationSeconds;

  const SessionLaunchDialog({
    super.key,
    required this.title,
    required this.voicePath,
    required this.ambientPath,
    this.breathingAudioPath,
    this.sceneName,
    this.durationSeconds = 300.0,
  });

  void _startFlatSession(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    ref.read(settingsProvider.notifier).toggleVrMode(false);

    final settings = ref.read(settingsProvider);
    final bundle = AudioResolverService.resolveBundle(
      title: title,
      sceneName: sceneName,
      voiceSex: settings.voiceSex,
      language: settings.language,
      customVoicePath:
          voicePath.isNotEmpty ? voicePath : (breathingAudioPath ?? ''),
      customAmbientPath: ambientPath,
      durationSeconds: durationSeconds,
    );

    router.pop();

    router.pushReplacement(
      '/unity-experience',
      extra: {
        'title': title,
        'sceneName': bundle.sceneName,
        'durationSeconds': bundle.durationSeconds,
        'isVrMode': false,
        'voicePath': bundle.voicePath,
        'ambientPath': bundle.ambientPath,
      },
    );
  }

  void _goToVrConfirm(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    ref.read(settingsProvider.notifier).toggleVrMode(true);

    final settings = ref.read(settingsProvider);
    final bundle = AudioResolverService.resolveBundle(
      title: title,
      sceneName: sceneName,
      voiceSex: settings.voiceSex,
      language: settings.language,
      customVoicePath:
          voicePath.isNotEmpty ? voicePath : (breathingAudioPath ?? ''),
      customAmbientPath: ambientPath,
      durationSeconds: durationSeconds,
    );

    router.pop();

    if (!settings.vrCalibrated) {
      // Se non calibrato, prima calibrazione poi conferma
      router.pushReplacement(
        '/vr-calibration',
        extra: {
          'isFromSettings': false,
          'title': title,
          'voicePath': bundle.voicePath,
          'ambientPath': bundle.ambientPath,
          'breathingAudioPath': breathingAudioPath,
          'sceneName': bundle.sceneName,
          'durationSeconds': bundle.durationSeconds,
        },
      );
    } else {
      // Già calibrato: vai direttamente alla conferma del visore
      router.pushReplacement(
        '/vr-confirmation',
        extra: {
          'title': title,
          'voicePath': bundle.voicePath,
          'ambientPath': bundle.ambientPath,
          'breathingAudioPath': breathingAudioPath,
          'sceneName': bundle.sceneName,
          'durationSeconds': bundle.durationSeconds,
        },
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
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: AppColors.japandiCardDecoration(
            isDark,
            borderRadius: 28.0,
            opacity: 0.85,
          ),
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
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
                    color: subTextColor.withValues(alpha: 0.9),
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
                      color: subTextColor.withValues(alpha: 0.7),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
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
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.06),
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
                color: accentColor.withValues(alpha: isDark ? 0.08 : 0.12),
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
                      color: subTextColor.withValues(alpha: 0.85),
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
  final String? sceneName;
  final double durationSeconds;

  const VrConfirmationScreen({
    super.key,
    required this.title,
    required this.voicePath,
    required this.ambientPath,
    this.breathingAudioPath,
    this.sceneName,
    this.durationSeconds = 300.0,
  });

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
    try {
      WakelockPlus.enable();
    } catch (_) {}
    _gazeController = VrGazeController(
      sensitivity: 220.0,
      dwellTime: const Duration(seconds: 2),
      maxOffset: 140.0,
    );
  }

  @override
  void dispose() {
    _gazeController.dispose();
    try {
      WakelockPlus.disable();
    } catch (_) {}
    super.dispose();
  }

  void _startVrSession() {
    if (_sessionStarting) return;
    _sessionStarting = true;
    ref.read(settingsProvider.notifier).toggleVrMode(true);

    final settings = ref.read(settingsProvider);
    final bundle = AudioResolverService.resolveBundle(
      title: widget.title,
      sceneName: widget.sceneName,
      voiceSex: settings.voiceSex,
      language: settings.language,
      customVoicePath: widget.voicePath.isNotEmpty
          ? widget.voicePath
          : (widget.breathingAudioPath ?? ''),
      customAmbientPath: widget.ambientPath,
      durationSeconds: widget.durationSeconds,
    );

    context.pushReplacement(
      '/unity-experience',
      extra: {
        'title': widget.title,
        'sceneName': bundle.sceneName,
        'durationSeconds': bundle.durationSeconds,
        'isVrMode': true,
        'voicePath': bundle.voicePath,
        'ambientPath': bundle.ambientPath,
      },
    );

    // NOTE: VR mode toggle (false) and session recording are now handled
    // by UnityExperienceScreen._confirmExit() to avoid GoRouter stack issues.
    // The original pushReplacement .then() callback was unreliable with GoRouter.
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

  Widget _buildEyeContent(bool isIt, bool isDark, {required bool isActiveEye}) {
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
            color: AppColors.goldAccent.withValues(alpha: 0.85),
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
                color: AppColors.getTextColor(isDark).withValues(alpha: 0.65),
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Occhio sinistro: bottone attivo — occhio destro: passivo (nessun hit-test)
          VrGazableButton(
            id: 'vr_confirm',
            label: isIt
                ? 'GUARDA QUI\nPER CONFERMARE'
                : 'LOOK HERE\nTO CONFIRM',
            icon: Icons.check_rounded,
            color: AppColors.successAccent,
            size: 72,
            hitRadius: 52,
            isActiveEye: isActiveEye,
            onTriggered: _startVrSession,
          ),

          const SizedBox(height: 22),

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
}

// ---------------------------------------------------------------------------
// _SpringAnimationWrapper: micro animazione elastica al tocco
// ---------------------------------------------------------------------------

class _SpringAnimationWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _SpringAnimationWrapper({required this.child, required this.onTap});

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
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: "Interactive element",
      child: GestureDetector(
        onTapDown: (_) => _controller.animateTo(
          1.0,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
        ),
        onTapUp: (_) {
          _controller.animateTo(
            0.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.elasticOut,
          );
          widget.onTap();
        },
        onTapCancel: () => _controller.animateTo(
          0.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        ),
        child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
      ),
    );
  }
}
