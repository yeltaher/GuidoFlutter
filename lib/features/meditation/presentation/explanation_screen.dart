import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';
import 'session_launch_helper.dart';

class ExplanationScreen extends ConsumerStatefulWidget {
  final String title;
  final String voicePath;
  final String ambientPath;
  final String? breathingAudioPath;

  const ExplanationScreen({
    Key? key,
    required this.title,
    required this.voicePath,
    required this.ambientPath,
    this.breathingAudioPath,
  }) : super(key: key);

  @override
  ConsumerState<ExplanationScreen> createState() => _ExplanationScreenState();
}

class _ExplanationScreenState extends ConsumerState<ExplanationScreen> {
  bool _isTextFinished = false;

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

  void _onProceed() {
    Navigator.of(context).pop(); // Chiude la ExplanationScreen
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      barrierDismissible: true,
      builder: (context) => SessionLaunchDialog(
        title: widget.title,
        voicePath: widget.voicePath,
        ambientPath: widget.ambientPath,
        breathingAudioPath: widget.breathingAudioPath,
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
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 48),
              Expanded(
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        _getExplanation(isIt),
                        textAlign: TextAlign.center,
                        textStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                          color: textColor.withOpacity(0.9),
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                    ],
                    totalRepeatCount: 1,
                    displayFullTextOnTap: true,
                    onFinished: () {
                      if (mounted) {
                        setState(() {
                          _isTextFinished = true;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedOpacity(
                opacity: _isTextFinished ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: ElevatedButton(
                  onPressed: _isTextFinished ? _onProceed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    isIt ? 'PROCEDI' : 'PROCEED',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
