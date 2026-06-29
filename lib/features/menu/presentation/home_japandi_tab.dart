// ignore_for_file: unused_local_variable, deprecated_member_use, use_build_context_synchronously, curly_braces_in_flow_control_structures, unused_element, unused_field
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';
import '../../../core/constants/daily_quotes.dart';
import '../../meditation/meditation_feature.dart';
import 'zen_sound_mixer_view.dart';

class HomeJapandiTab extends ConsumerWidget {
  final bool isActive;
  const HomeJapandiTab({super.key, this.isActive = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subTextColor = AppColors.getSubTextColor(isDark);

    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final dailyQuote =
        DailyQuotes.quotes[dayOfYear % DailyQuotes.quotes.length];

    final prefs = ref.watch(sharedPrefsProvider);
    final heroTitle =
        prefs.getString("QuizRecommendedTitle") ?? "Il Respiro dell'Alba";
    final heroDesc =
        prefs.getString("QuizRecommendedDesc") ??
        "Sintonizza il ritmo polmonare con la terra";
    final heroBadge =
        prefs.getString("QuizRecommendedBadge") ?? "RITUALE DEL GIORNO";

    final historyStr = prefs.getStringList("timeline_history") ?? [];
    final int totalSessions = historyStr.length;
    final int totalMinutes = prefs.getInt("total_minutes") ?? 0;
    final int currentStreak = prefs.getInt("current_streak") ?? 0;

    return Container(
      color: Colors
          .transparent, // Tab al 100% trasparente, eredita lo sfondo gradiente globale
      child: Stack(
        children: [
          // 1. NEBULA ZEN AMBIENTE (Loop di nebbia luminosa pulsante sullo sfondo - Ottimizzato con RadialGradient)
          Positioned(
            top: 100,
            left: -50,
            child:
                Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            accentColor.withValues(alpha: isDark ? 0.12 : 0.18),
                            accentColor.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .fadeIn(duration: 4.seconds, curve: Curves.easeInOut)
                    .scale(
                      begin: const Offset(0.85, 0.85),
                      end: const Offset(1.15, 1.15),
                      duration: 4.seconds,
                      curve: Curves.easeInOut,
                    ),
          ),

          SafeArea(
            left: false,
            right: false,
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Intestazione e introduzione (Padded) e Overview
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. INTESTAZIONE MINIMAL JAPANDI
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/logo_transparent.png',
                                height: 34,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Guido",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  color: textColor,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : Colors.black.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? Colors.white10 : Colors.black12,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.successAccent,
                                      ),
                                    )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(reverse: true),
                                    )
                                    .fadeIn(duration: 1.seconds)
                                    .fadeOut(duration: 1.seconds),
                                const SizedBox(width: 6),
                                Text(
                                  "ARIA LIBERA • 18°C",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: subTextColor.withValues(alpha: 0.9),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            color: AppColors.goldAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$currentStreak giorni streak • $totalSessions sessioni totali",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: subTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 110.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 4. DAILY HERO CARD: RITUALE DEL MATTINO (con Loop di Respiro Polmonare) (Padded)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Semantics(
                            button: true,
                            label: "Interactive element",
                            child: GestureDetector(
                              onTap: () {
                                launchZenSession(
                                  context: context,
                                  ref: ref,
                                  title: "Il Respiro dell'Alba",
                                  voicePath:
                                      'assets/audio/real/Meditazioni/Acqua/Meditazione del Mattino_Procedimento.m4a',
                                  ambientPath:
                                      'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione MATTINO.m4a',
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: AppColors.japandiCardDecoration(
                                  isDark,
                                  borderRadius: 28.0,
                                  opacity: 0.58,
                                ),
                                child: Stack(
                                  children: [
                                    // Loop di espansione a onde luminose (Mandala di respiro polmonare)
                                    Positioned(
                                      right: -10,
                                      bottom: -15,
                                      child:
                                          Container(
                                                width: 140,
                                                height: 140,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: RadialGradient(
                                                    colors: [
                                                      accentColor.withValues(
                                                        alpha: isDark
                                                            ? 0.09
                                                            : 0.15,
                                                      ),
                                                      accentColor.withValues(
                                                        alpha: 0.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .animate(
                                                onPlay: (controller) =>
                                                    controller.repeat(
                                                      reverse: true,
                                                    ),
                                              )
                                              .scale(
                                                begin: const Offset(0.78, 0.78),
                                                end: const Offset(1.22, 1.22),
                                                duration: 4.seconds,
                                                curve: Curves.easeInOutCubic,
                                              )
                                              .fadeIn(duration: 4.seconds)
                                              .fadeOut(duration: 4.seconds),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Badge Rituale del Giorno
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: accentColor.withValues(
                                                alpha: isDark ? 0.08 : 0.15,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              heroBadge,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 9.0,
                                                    fontWeight: FontWeight.w800,
                                                    color: accentColor,
                                                    letterSpacing: 0.8,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(height: 14),
                                          Text(
                                            heroTitle,
                                            style: GoogleFonts.playfairDisplay(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700,
                                              color: textColor,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            heroDesc,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w500,
                                              color: subTextColor,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.query_builder_rounded,
                                                    size: 15,
                                                    color: subTextColor
                                                        .withValues(alpha: 0.8),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "10 MINUTI",
                                                    style:
                                                        GoogleFonts.plusJakartaSans(
                                                          fontSize: 10.5,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: subTextColor,
                                                          letterSpacing: 0.3,
                                                        ),
                                                  ),
                                                ],
                                              ),

                                              // Tasto Play con pulsazione luminosa
                                              Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: accentColor,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: accentColor
                                                              .withValues(
                                                                alpha: 0.25,
                                                              ),
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                            0,
                                                            3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Icon(
                                                      Icons.play_arrow_rounded,
                                                      color: isDark
                                                          ? Colors.black
                                                          : Colors.white,
                                                      size: 24,
                                                    ),
                                                  )
                                                  .animate(
                                                    onPlay: (controller) =>
                                                        controller.repeat(
                                                          reverse: true,
                                                        ),
                                                  )
                                                  .scale(
                                                    begin: const Offset(
                                                      0.95,
                                                      0.95,
                                                    ),
                                                    end: const Offset(
                                                      1.05,
                                                      1.05,
                                                    ),
                                                    duration: 2.seconds,
                                                    curve: Curves.easeInOut,
                                                  ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 5. CHIPS DI FILTRAGGIO RAPIDO ORIZZONTALE (Symmetrical Row - Solo Suoni Zen) (Padded)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: _buildFilterChip(
                            context,
                            "🎵 Suoni Zen",
                            true,
                            isDark,
                            accentColor,
                            textColor,
                            subTextColor,
                            () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const ZenSoundMixerView(),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return SlideTransition(
                                          position: animation.drive(
                                            Tween<Offset>(
                                              begin: const Offset(0.0, 1.0),
                                              end: Offset.zero,
                                            ).chain(
                                              CurveTween(
                                                curve: Curves.easeOutCubic,
                                              ),
                                            ),
                                          ),
                                          child: child,
                                        );
                                      },
                                  transitionDuration: const Duration(
                                    milliseconds: 500,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Titolo Sezione Consigliati (Padded)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            "Percorsi consigliati",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // 7. DECK ORIZZONTALE DI CARDS (Scorrevole a bordo schermo!)
                        SizedBox(
                          height: 190,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            children: [
                              _buildDeckCard(
                                context: context,
                                ref: ref,
                                title: "Morning Flow",
                                desc: "Risveglia i sensi dolcemente",
                                time: "15 min",
                                tag: "NATURA",
                                voice:
                                    'assets/audio/real/Meditazioni/Acqua/Meditazione del Mattino_Procedimento.m4a',
                                ambient:
                                    'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione MATTINO.m4a',
                                isDark: isDark,
                                accentColor: AppColors.successAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 16),
                              _buildDeckCard(
                                context: context,
                                ref: ref,
                                title: "Percorso Acqua",
                                desc: "Lascia scorrere i pensieri",
                                time: "15 min",
                                tag: "FLUIDITÀ",
                                voice:
                                    'assets/audio/real/Meditazioni/Acqua/Meditazione-del-Pomeriggio.m4a',
                                ambient:
                                    'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione POMERIGGIO.m4a',
                                isDark: isDark,
                                accentColor: accentColor,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 16),
                              _buildDeckCard(
                                context: context,
                                ref: ref,
                                title: "Starlight Sleep",
                                desc: "Rilassa la mente per la notte",
                                time: "25 min",
                                tag: "SONNO",
                                voice:
                                    'assets/audio/real/Meditazioni/Acqua/Meditazione-della-Sera.m4a',
                                ambient:
                                    'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione SERA.m4a',
                                isDark: isDark,
                                accentColor: AppColors.goldAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // 8. CITAZIONE ZEN DI CHIUSURA (Padded)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 22,
                            ),
                            decoration: AppColors.japandiCardDecoration(
                              isDark,
                              borderRadius: 24.0,
                              opacity: 0.38,
                            ),
                            child: Stack(
                              children: [
                                // Nebulosa Zen interna alla card per atmosfera
                                Positioned(
                                  left: -20,
                                  top: -10,
                                  child:
                                      Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.goldAccent
                                                  .withValues(alpha: 0.04),
                                            ),
                                          )
                                          .animate(
                                            onPlay: (controller) => controller
                                                .repeat(reverse: true),
                                          )
                                          .fadeIn(duration: 3.seconds)
                                          .fadeOut(duration: 3.seconds),
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.format_quote_rounded,
                                      color: AppColors.goldAccent.withValues(
                                        alpha: 0.8,
                                      ),
                                      size: 28,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "\"${dailyQuote['quote']}\"",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 15.5,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w600,
                                        color: textColor.withValues(alpha: 0.9),
                                        height: 1.45,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "- ${dailyQuote['author']} -",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w600,
                                        color: subTextColor.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Riflessione Zen di oggi",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.bold,
                                        color: subTextColor.withValues(
                                          alpha: 0.45,
                                        ),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Costruisce una chip di filtraggio Japandi
  Widget _buildFilterChip(
    BuildContext context,
    String text,
    bool isSelected,
    bool isDark,
    Color accentColor,
    Color textColor,
    Color subTextColor,
    VoidCallback onTap,
  ) {
    return OnboardingSpringButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: isDark ? 0.12 : 0.18)
              : (isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.black.withValues(alpha: 0.03)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? accentColor.withValues(alpha: 0.3)
                : (isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.06)),
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? textColor
                  : subTextColor.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }

  /// Costruisce una card sfogliabile per il deck consigliato
  Widget _buildDeckCard({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String desc,
    required String time,
    required String tag,
    required String voice,
    required String ambient,
    required bool isDark,
    required Color accentColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Semantics(
      button: true,
      label: "Interactive element",
      child: GestureDetector(
        onTap: () {
          launchZenSession(
            context: context,
            ref: ref,
            title: title,
            voicePath: voice,
            ambientPath: ambient,
          );
        },
        child: Container(
          width: 220,
          decoration: AppColors.japandiCardDecoration(
            isDark,
            borderRadius: 24.0,
            opacity: 0.55,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(
                        alpha: isDark ? 0.08 : 0.15,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 8.0,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 19.5,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: subTextColor.withValues(alpha: 0.9),
                      height: 1.35,
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.query_builder_rounded,
                        size: 13,
                        color: subTextColor.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        time,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: subTextColor.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),

                  // Pulsante Play minimal
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: textColor.withValues(alpha: 0.8),
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: textColor,
                      size: 16,
                    ),
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

class OnboardingSpringButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const OnboardingSpringButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<OnboardingSpringButton> createState() => _OnboardingSpringButtonState();
}

class _OnboardingSpringButtonState extends State<OnboardingSpringButton>
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
      end: 0.95,
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
            duration: const Duration(milliseconds: 300),
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
