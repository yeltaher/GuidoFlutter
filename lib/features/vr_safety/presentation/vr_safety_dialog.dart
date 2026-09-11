import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';

/// Mostra il dialogo con le linee guida di sicurezza per l'uso del visore VR Cardboard.
Future<void> showVrSafetyDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    barrierDismissible: true,
    builder: (context) => const VrSafetyDialog(),
  );
}

class VrSafetyDialog extends ConsumerWidget {
  const VrSafetyDialog({super.key});

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
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 440),
          decoration: AppColors.japandiCardDecoration(
            isDark,
            borderRadius: 28.0,
            opacity: 0.95,
          ),
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icona header
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withValues(alpha: isDark ? 0.12 : 0.16),
                    ),
                    child: Icon(
                      Icons.health_and_safety_outlined,
                      color: accentColor,
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Titolo
                Text(
                  isIt ? "Linee Guida Sicurezza VR" : "VR Safety Guidelines",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  isIt
                      ? "Per un'esperienza immersiva sicura e rigenerante, ti invitiamo a seguire queste semplici indicazioni:"
                      : "For a safe and restorative immersive experience, please follow these guidelines:",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: subTextColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // Sezione 1: Durata raccomandata
                _buildGuidelineTile(
                  icon: Icons.timer_outlined,
                  title: isIt ? "Durata consigliata (5-15 min)" : "Recommended Duration (5-15 min)",
                  description: isIt
                      ? "Sessioni brevi tra 5 e 15 minuti favoriscono la concentrazione senza affaticare gli occhi."
                      : "Short sessions between 5 and 15 minutes promote focus without straining your eyes.",
                  accentColor: accentColor,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),

                // Sezione 2: Pause e ascolto del corpo
                _buildGuidelineTile(
                  icon: Icons.pause_circle_outline,
                  title: isIt ? "Pause regolari" : "Regular Pauses",
                  description: isIt
                      ? "In caso di vertigini, nausea o affaticamento visivo, interrompi immediatamente la sessione e sfila il visore."
                      : "In case of dizziness, nausea, or visual fatigue, discontinue immediately and remove the headset.",
                  accentColor: accentColor,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),

                // Sezione 3: Controindicazioni
                _buildGuidelineTile(
                  icon: Icons.warning_amber_rounded,
                  title: isIt ? "Controindicazioni mediche" : "Medical Contraindications",
                  description: isIt
                      ? "L'uso è sconsigliato a chi soffre di epilessia fotosensibile o gravi disturbi dell'equilibrio."
                      : "Not recommended for individuals with photosensitive epilepsy or balance disorders.",
                  accentColor: AppColors.dangerAccent,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),

                // Sezione 4: Età minima
                _buildGuidelineTile(
                  icon: Icons.family_restroom_outlined,
                  title: isIt ? "Età minima raccomandata" : "Minimum Age Recommendation",
                  description: isIt
                      ? "L'utilizzo del visore VR è consigliato a partire dai 13 anni di età."
                      : "VR headset usage is recommended for ages 13 and above.",
                  accentColor: accentColor,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 24),

                // Pulsante Ho capito / Chiudi
                Semantics(
                  button: true,
                  label: "Dismiss dialog",
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      isIt ? "HO CAPITO" : "UNDERSTOOD",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
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

  Widget _buildGuidelineTile({
    required IconData icon,
    required String title,
    required String description,
    required Color accentColor,
    required Color textColor,
    required Color subTextColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: subTextColor.withValues(alpha: 0.9),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
