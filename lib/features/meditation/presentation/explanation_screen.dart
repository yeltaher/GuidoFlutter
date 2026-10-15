import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';
import '../../../core/audio/audio_resolver_service.dart';
import '../../vr_experiences/vr_experiences_feature.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'session_launch_helper.dart';

class ExplanationScreen extends ConsumerStatefulWidget {
  final String title;
  final String voicePath;
  final String ambientPath;
  final String? breathingAudioPath;
  final String? sceneName;
  final double durationSeconds;

  const ExplanationScreen({
    super.key,
    required this.title,
    required this.voicePath,
    required this.ambientPath,
    this.breathingAudioPath,
    this.sceneName,
    this.durationSeconds = 300.0,
  });

  @override
  ConsumerState<ExplanationScreen> createState() => _ExplanationScreenState();
}

class _ExplanationScreenState extends ConsumerState<ExplanationScreen> {
  @override
  void initState() {
    super.initState();
    try {
      WakelockPlus.enable();
    } catch (_) {}
  }

  @override
  void dispose() {
    try {
      WakelockPlus.disable();
    } catch (_) {}
    super.dispose();
  }

  String _getExplanation(bool isIt) {
    final t = widget.title.toLowerCase();
    if (t.contains('acqua') || t.contains('water')) {
      return isIt
          ? "In questa esperienza esplorerai il potere rilassante dell'acqua. \n\nSeguirai un flusso continuo che spazza via le tensioni per rigenerare lo spirito. Lascia che ogni espirazione ti liberi dallo stress, mentre ogni inspirazione infonda nuova calma."
          : "In this experience, you will explore the relaxing power of water. \n\nYou will follow a continuous flow that washes away tension to regenerate your spirit. Let every exhale release stress, while every inhale brings new calm.";
    } else if (t.contains('fuoco') || t.contains('fire')) {
      return isIt
          ? "Il fuoco rappresenta l'energia, la forza vitale e la trasformazione profonda. \n\nLascia che la fiamma interiore riscaldi il tuo corpo e sciolga le ansie. Ritrova la tua vitalità sopita."
          : "Fire represents energy, vital force, and deep transformation. \n\nLet the inner flame warm your body and melt away anxiety. Rediscover your dormant vitality.";
    } else if (t.contains('aria') || t.contains('air')) {
      return isIt
          ? "Leggero e invisibile, l'elemento aria ti insegnerà a respirare profondamente. \n\nConcediti uno spazio di leggerezza, elevandoti al di sopra dei pensieri quotidiani verso una pura consapevolezza."
          : "Light and invisible, the air element will teach you to breathe deeply. \n\nAllow yourself a space of lightness, rising above daily thoughts towards pure awareness.";
    } else if (t.contains('terra') || t.contains('earth')) {
      return isIt
          ? "Radicati profondamente nella stabilità millenaria della terra. \n\nTrova equilibrio, centratura e una calma incrollabile. Una meditazione profonda per ritrovare il proprio baricentro."
          : "Root yourself deeply in the ancient stability of the earth. \n\nFind balance, centering, and unshakeable calm. A deep meditation to regain your core balance.";
    } else {
      return isIt
          ? "Preparati a vivere un'esperienza unica di rilassamento profondo. \n\nSegui la guida, respira lentamente e lasciati andare completamente al momento presente. Trova il tuo equilibrio interiore."
          : "Get ready to experience deep relaxation. \n\nFollow the guide, breathe slowly, and completely let go to the present moment. Find your inner balance.";
    }
  }

  void _launchExperience({required bool isVr}) {
    ref.read(settingsProvider.notifier).toggleVrMode(isVr);

    // Forza orientamento orizzontale e fullscreen immersivo immediato
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final vrMatch = VrExperienceType.fromSceneOrTitle(
          sceneName: widget.sceneName,
          title: widget.title,
        ) ??
        VrExperienceType.fromSessionId(widget.sceneName) ??
        VrExperienceType.fromSessionId(widget.title);

    if (vrMatch != null) {
      context.pushReplacement(
        '/vr-experience',
        extra: {
          'experienceId': vrMatch.id,
          'isVrMode': isVr,
          'autoStart': true,
        },
      );
      return;
    }

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
        'isVrMode': isVr,
        'voicePath': bundle.voicePath,
        'ambientPath': bundle.ambientPath,
      },
    );
  }

  void _onProceed() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      barrierDismissible: true,
      builder: (context) => SessionLaunchDialog(
        title: widget.title,
        voicePath: widget.voicePath,
        ambientPath: widget.ambientPath,
        breathingAudioPath: widget.breathingAudioPath,
        sceneName: widget.sceneName,
        durationSeconds: widget.durationSeconds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final isIt = settings.language == 0;

    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      _getExplanation(isIt),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16.5,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                        color: textColor.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Selettore Voce Guida Japandi (Michela / Luigi)
              Column(
                children: [
                  Text(
                    isIt ? 'VOCE GUIDA' : 'GUIDE VOICE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: textColor.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildVoiceOption(
                          label: isIt ? 'Michela (Femminile)' : 'Michela (Female)',
                          isSelected: settings.voiceSex == 1,
                          accentColor: accentColor,
                          textColor: textColor,
                          onTap: () {
                            ref.read(settingsProvider.notifier).changeVoiceSex(1);
                            HapticFeedback.selectionClick();
                          },
                        ),
                        const SizedBox(width: 4),
                        _buildVoiceOption(
                          label: isIt ? 'Luigi (Maschile)' : 'Luigi (Male)',
                          isSelected: settings.voiceSex == 0,
                          accentColor: accentColor,
                          textColor: textColor,
                          onTap: () {
                            ref.read(settingsProvider.notifier).changeVoiceSex(0);
                            HapticFeedback.selectionClick();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              // Quick Launch: Avvio Immersivo Diretto & Avvio Visore VR
              ElevatedButton.icon(
                onPressed: () => _launchExperience(isVr: false),
                icon: const Icon(Icons.stay_current_landscape_rounded, size: 22),
                label: Text(
                  isIt ? 'AVVIA ESPERIENZA IMMERSIVA' : 'LAUNCH IMMERSIVE EXPERIENCE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _launchExperience(isVr: true),
                icon: Icon(Icons.view_in_ar_rounded, size: 22, color: accentColor),
                label: Text(
                  isIt ? 'AVVIA IN VISORE VR' : 'LAUNCH IN VR HEADSET',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: textColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: accentColor.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: _onProceed,
                  child: Text(
                    isIt ? 'Opzioni avanzate' : 'Advanced options',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: textColor.withValues(alpha: 0.45),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceOption({
    required String label,
    required bool isSelected,
    required Color accentColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : textColor.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
