import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';

class VrDisclaimerView extends ConsumerWidget {
  const VrDisclaimerView({super.key});

  static const String prefKey = 'has_accepted_vr_disclaimer';

  Future<void> _onAccept(BuildContext context, WidgetRef ref) async {
    HapticFeedback.mediumImpact();
    final prefs = ref.read(sharedPrefsProvider);
    if (prefs != null) {
      await prefs.setBool(prefKey, true);
    }
    if (context.mounted) {
      context.go('/login');
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Sfondo a gradiente Japandi dinamico
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.getGradientByTime(isDark),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Luce d'atmosfera Japandi soffusa
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: isDark ? 0.08 : 0.12),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: const SizedBox.shrink(),
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                final horizontalPadding =
                    isWide ? constraints.maxWidth * 0.22 : 24.0;

                return Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 24.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Icona elegante visore VR
                        Center(
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  accentColor.withValues(
                                    alpha: isDark ? 0.22 : 0.28,
                                  ),
                                  accentColor.withValues(alpha: 0.04),
                                ],
                              ),
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.35),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withValues(
                                    alpha: isDark ? 0.18 : 0.12,
                                  ),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.view_in_ar_rounded,
                              size: 46,
                              color: accentColor,
                            ),
                          ),
                        ).animate().scale(
                              duration: 500.ms,
                              curve: Curves.easeOutBack,
                            ),

                        const SizedBox(height: 20),

                        // Titolo Japandi Serif
                        Text(
                          isIt
                              ? "Sicurezza e Visore VR"
                              : "VR Headset Safety",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                            letterSpacing: -0.5,
                          ),
                        ).animate().fadeIn(delay: 150.ms),

                        const SizedBox(height: 8),

                        Text(
                          isIt
                              ? "Prima di accedere a Guido, leggi attentamente le seguenti indicazioni per vivere al meglio l'esperienza immersiva."
                              : "Before accessing Guido, please review the following guidelines for a safe immersive experience.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: subTextColor,
                            height: 1.45,
                          ),
                        ).animate().fadeIn(delay: 250.ms),

                        const SizedBox(height: 24),

                        // Schede delle avvertenze
                        _buildWarningCard(
                          icon: Icons.timer_outlined,
                          title: isIt
                              ? "Durata sessioni e pause"
                              : "Session duration & breaks",
                          description: isIt
                              ? "Consigliamo sessioni da 5 a 15 minuti. Fai una pausa di almeno 10 minuti tra un'esperienza e l'altra per non affaticare la vista."
                              : "We recommend 5-15 minute sessions. Take at least a 10-minute break between sessions to rest your eyes.",
                          isDark: isDark,
                          accentColor: accentColor,
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.08),

                        const SizedBox(height: 12),

                        _buildWarningCard(
                          icon: Icons.chair_outlined,
                          title: isIt
                              ? "Spazio fisico e stabilità"
                              : "Physical space & seating",
                          description: isIt
                              ? "Liberati da ostacoli circostanti. Ti raccomandiamo caldamente di restare comodamente seduto durante l'utilizzo del visore."
                              : "Clear surrounding obstacles. We strongly advise remaining seated comfortably while wearing the headset.",
                          isDark: isDark,
                          accentColor: accentColor,
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.08),

                        const SizedBox(height: 12),

                        _buildWarningCard(
                          icon: Icons.warning_amber_rounded,
                          title: isIt
                              ? "Vertigini e cinetosi"
                              : "Motion sickness & dizziness",
                          description: isIt
                              ? "Rimuovi subito il visore qualora avvertissi capogiri, nausea o disorientamento. Respira lentamente tornando all'ambiente reale."
                              : "Immediately remove the headset if you feel dizzy, nauseous, or disoriented. Breathe slowly back in your space.",
                          isDark: isDark,
                          accentColor: accentColor,
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.08),

                        const SizedBox(height: 12),

                        _buildWarningCard(
                          icon: Icons.family_restroom_rounded,
                          title: isIt
                              ? "Età consigliata"
                              : "Recommended age",
                          description: isIt
                              ? "L'utilizzo del visore per realtà virtuale è raccomandato a partire dai 13 anni in su."
                              : "The use of VR headsets is recommended for individuals aged 13 and older.",
                          isDark: isDark,
                          accentColor: accentColor,
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ).animate().fadeIn(delay: 650.ms).slideY(begin: 0.08),

                        const SizedBox(height: 28),

                        // Pulsante di conferma primario
                        Semantics(
                          button: true,
                          label: isIt
                              ? "Ho compreso e accetto le linee guida VR"
                              : "I understand and accept VR guidelines",
                          child: GestureDetector(
                            onTap: () => _onAccept(context, ref),
                            child: Container(
                              width: double.infinity,
                              height: 54,
                              decoration: BoxDecoration(
                                color: AppColors.successAccent,
                                borderRadius: BorderRadius.circular(27),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.successAccent.withValues(
                                      alpha: isDark ? 0.35 : 0.25,
                                    ),
                                    blurRadius: 14,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  isIt
                                      ? "Ho compreso e accetto"
                                      : "I understand and accept",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 750.ms).scale(begin: const Offset(0.96, 0.96)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
    required Color accentColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Container(
      decoration: AppColors.japandiCardDecoration(
        isDark,
        borderRadius: 20.0,
        opacity: 0.65,
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withValues(alpha: isDark ? 0.12 : 0.16),
            ),
            child: Icon(
              icon,
              size: 22,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: subTextColor,
                    height: 1.4,
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
