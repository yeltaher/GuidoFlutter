import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';
import '../../../core/database/repositories/user_repository.dart';
import '../../../core/services/daily_quotes_service.dart';
import '../../../core/unity/unity_bridge_dto.dart';
import '../../meditation/meditation_feature.dart';

class HomeJapandiTab extends ConsumerStatefulWidget {
  final bool isActive;
  const HomeJapandiTab({super.key, this.isActive = true});

  @override
  ConsumerState<HomeJapandiTab> createState() => _HomeJapandiTabState();
}

class _HomeJapandiTabState extends ConsumerState<HomeJapandiTab> {
  // 0 = Tutti, 1 = Acqua, 2 = Fuoco, 3 = Terra, 4 = Aria
  int _selectedElementFilter = 0;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final isIt = settings.language == 0;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subTextColor = AppColors.getSubTextColor(isDark);

    final dailyQuote = ref.watch(dailyQuoteProvider);

    final prefs = ref.watch(sharedPrefsProvider);
    if (prefs == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final heroTitle =
        prefs.getString("QuizRecommendedTitle") ?? "Il Respiro dell'Alba";
    final heroDesc =
        prefs.getString("QuizRecommendedDesc") ??
        "Sintonizza il ritmo polmonare con la terra";
    final heroBadge =
        prefs.getString("QuizRecommendedBadge") ?? "RITUALE DEL GIORNO";

    final statsAsync = ref.watch(userStatsStreamProvider);
    final stats = statsAsync.valueOrNull;
    final int totalSessions = stats?.totalSessions ?? 0;
    final int currentStreak = stats?.effectiveCurrentStreak ?? 0;

    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          // 1. NEBULA ZEN AMBIENTE (Loop di nebbia luminosa pulsante)
          Positioned(
            top: 100,
            left: -50,
            child: Container(
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
                // Intestazione e Overview
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // INTESTAZIONE MINIMAL JAPANDI
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/logo_transparent.png',
                                  height: 34,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    "Guido",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                      color: textColor,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.04)
                                    : Colors.black.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      isDark ? Colors.white10 : Colors.black12,
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
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
                                  Flexible(
                                    child: Text(
                                      "ARIA LIBERA • 18°C",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            subTextColor.withValues(alpha: 0.9),
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: AppColors.goldAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "$currentStreak ${isIt ? 'giorni streak' : 'days streak'} • $totalSessions ${isIt ? 'sessioni totali' : 'total sessions'}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: subTextColor,
                              ),
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
                        // BANNER PACCHETTO PREMIUM JAPANDI
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Semantics(
                            button: true,
                            label: "Pacchetto Premium Guido",
                            child: GestureDetector(
                              onTap: () => context.push('/premium'),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.goldAccent.withValues(
                                        alpha: isDark ? 0.22 : 0.15,
                                      ),
                                      AppColors.sageAccent.withValues(
                                        alpha: isDark ? 0.15 : 0.08,
                                      ),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.goldAccent.withValues(
                                      alpha: 0.35,
                                    ),
                                    width: 1.0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.goldAccent.withValues(
                                          alpha: 0.2,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.workspace_premium_rounded,
                                        color: AppColors.goldAccent,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            settings.isUnlocked
                                                ? (isIt
                                                    ? "GUIDO PREMIUM ATTIVO"
                                                    : "GUIDO PREMIUM ACTIVE")
                                                : (isIt
                                                    ? "SCOPRI GUIDO PREMIUM"
                                                    : "DISCOVER GUIDO PREMIUM"),
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w800,
                                              color: textColor,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            settings.isUnlocked
                                                ? (isIt
                                                    ? "Tutte le esperienze e percorsi VR sbloccati"
                                                    : "All VR experiences and paths unlocked")
                                                : (isIt
                                                    ? "Accedi a tutti i 4 elementi e alle meditazioni"
                                                    : "Access all 4 elements & full meditations"),
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w500,
                                              color: subTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 13,
                                      color: AppColors.goldAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // SEZIONE IN ALTO: PERCORSI CONSIGLIATI
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  isIt
                                      ? "Percorsi Consigliati"
                                      : "Recommended Paths",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                context,
                                "🎵 Suoni Zen",
                                false,
                                isDark,
                                accentColor,
                                textColor,
                                subTextColor,
                                () => context.push('/zen-sound-mixer'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // DAILY HERO CARD: RITUALE DEL MATTINO
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Semantics(
                            button: true,
                            label: heroTitle,
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
                                  sceneName: UnityScenes.waterMeditation,
                                  durationSeconds: 900.0,
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
                                    Positioned(
                                      right: -10,
                                      bottom: -15,
                                      child: Container(
                                        width: 140,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              accentColor.withValues(
                                                alpha: isDark ? 0.09 : 0.15,
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
                                                controller.repeat(reverse: true),
                                          )
                                          .scale(
                                            begin: const Offset(0.78, 0.78),
                                            end: const Offset(1.22, 1.22),
                                            duration: 4.seconds,
                                            curve: Curves.easeInOutCubic,
                                          ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(22.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                          const SizedBox(height: 12),
                                          Text(
                                            heroTitle,
                                            style: GoogleFonts.playfairDisplay(
                                              fontSize: 23,
                                              fontWeight: FontWeight.w700,
                                              color: textColor,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            heroDesc,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: subTextColor,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.self_improvement_rounded,
                                                    size: 16,
                                                    color: const Color(0xFF38BDF8),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    "15 MIN • ACQUA",
                                                    style:
                                                        GoogleFonts.plusJakartaSans(
                                                      fontSize: 10.5,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: subTextColor,
                                                      letterSpacing: 0.4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 38,
                                                height: 38,
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
                                                      offset:
                                                          const Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  Icons.play_arrow_rounded,
                                                  color: isDark
                                                      ? Colors.black
                                                      : Colors.white,
                                                  size: 22,
                                                ),
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
                        const SizedBox(height: 14),

                        // DECK ORIZZONTALE CONSIGLIATI
                        SizedBox(
                          height: 185,
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
                                isBreathing: false,
                                voice:
                                    'assets/audio/real/Meditazioni/Acqua/Meditazione del Mattino_Procedimento.m4a',
                                ambient:
                                    'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione MATTINO.m4a',
                                isDark: isDark,
                                accentColor: AppColors.successAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                                sceneName: UnityScenes.waterMeditation,
                                durationSeconds: 900.0,
                                isPremium: false,
                              ),
                              const SizedBox(width: 14),
                              _buildDeckCard(
                                context: context,
                                ref: ref,
                                title: "Percorso Acqua",
                                desc: "Lascia scorrere i pensieri",
                                time: "15 min",
                                tag: "FLUIDITÀ",
                                isBreathing: false,
                                voice:
                                    'assets/audio/real/Meditazioni/Acqua/Meditazione-del-Pomeriggio.m4a',
                                ambient:
                                    'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione POMERIGGIO.m4a',
                                isDark: isDark,
                                accentColor: const Color(0xFF38BDF8),
                                textColor: textColor,
                                subTextColor: subTextColor,
                                sceneName: UnityScenes.waterMeditation,
                                durationSeconds: 900.0,
                                isPremium: false,
                              ),
                              const SizedBox(width: 14),
                              _buildDeckCard(
                                context: context,
                                ref: ref,
                                title: "Starlight Sleep",
                                desc: "Rilassa la mente per la notte",
                                time: "25 min",
                                tag: "SONNO",
                                isBreathing: false,
                                voice:
                                    'assets/audio/real/Meditazioni/Acqua/Meditazione-della-Sera.m4a',
                                ambient:
                                    'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione SERA.m4a',
                                isDark: isDark,
                                accentColor: AppColors.goldAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                                sceneName: UnityScenes.waterMeditationEvening,
                                durationSeconds: 1500.0,
                                isPremium: true,
                              ),
                              const SizedBox(width: 14),
                              _buildDeckCard(
                                context: context,
                                ref: ref,
                                title: "Percorso Fuoco",
                                desc: "Trasforma la tensione in forza",
                                time: "15 min",
                                tag: "ENERGIA",
                                isBreathing: false,
                                voice: '',
                                ambient: '',
                                isDark: isDark,
                                accentColor: const Color(0xFFF97316),
                                textColor: textColor,
                                subTextColor: subTextColor,
                                sceneName: UnityScenes.fireMeditation,
                                durationSeconds: 900.0,
                                isPremium: true,
                              ),
                              const SizedBox(width: 14),
                              _buildDeckCard(
                                context: context,
                                ref: ref,
                                title: "Percorso Aria",
                                desc: "Eleva la mente con leggerezza",
                                time: "15 min",
                                tag: "ESPANSIONE",
                                isBreathing: false,
                                voice: '',
                                ambient: '',
                                isDark: isDark,
                                accentColor: const Color(0xFF06B6D4),
                                textColor: textColor,
                                subTextColor: subTextColor,
                                sceneName: UnityScenes.airMeditation,
                                durationSeconds: 900.0,
                                isPremium: true,
                              ),
                              const SizedBox(width: 14),
                              _buildDeckCard(
                                context: context,
                                ref: ref,
                                title: "Percorso Terra",
                                desc: "Radicamento e stabilità",
                                time: "20 min",
                                tag: "STABILITÀ",
                                isBreathing: false,
                                voice: '',
                                ambient: '',
                                isDark: isDark,
                                accentColor: const Color(0xFF84CC16),
                                textColor: textColor,
                                subTextColor: subTextColor,
                                sceneName: UnityScenes.earthMeditation,
                                durationSeconds: 1200.0,
                                isPremium: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // SEZIONE PRINCIPALE: PERCORSI PER ELEMENTO
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isIt
                                    ? "I Percorsi degli Elementi"
                                    : "Elemental Paths",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: textColor,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isIt
                                    ? "Esplora meditazioni e respirazioni guidate in 3D & VR"
                                    : "Explore 3D & VR guided meditations and breathings",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: subTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // SELETTORE ELEMENTI (FILTRO CHIPS ORIZZONTALE)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                _buildElementFilterPill(
                                  label: isIt ? "Tutti" : "All",
                                  index: 0,
                                  icon: Icons.auto_awesome_rounded,
                                  color: accentColor,
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                                const SizedBox(width: 8),
                                _buildElementFilterPill(
                                  label: isIt ? "Acqua" : "Water",
                                  index: 1,
                                  icon: Icons.water_drop_rounded,
                                  color: const Color(0xFF38BDF8),
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                                const SizedBox(width: 8),
                                _buildElementFilterPill(
                                  label: isIt ? "Fuoco" : "Fire",
                                  index: 2,
                                  icon: Icons.local_fire_department_rounded,
                                  color: const Color(0xFFF97316),
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                                const SizedBox(width: 8),
                                _buildElementFilterPill(
                                  label: isIt ? "Terra" : "Earth",
                                  index: 3,
                                  icon: Icons.forest_rounded,
                                  color: const Color(0xFF84CC16),
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                                const SizedBox(width: 8),
                                _buildElementFilterPill(
                                  label: isIt ? "Aria" : "Air",
                                  index: 4,
                                  icon: Icons.air_rounded,
                                  color: const Color(0xFF06B6D4),
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 1. ELEMENTO ACQUA
                        if (_selectedElementFilter == 0 ||
                            _selectedElementFilter == 1) ...[
                          _buildElementSectionHeader(
                            title: isIt ? "Elemento Acqua" : "Water Element",
                            subtitle: isIt
                                ? "Fluidità, quiete e rilassamento profondo"
                                : "Flow, stillness, and deep restoration",
                            elementIcon: Icons.water_drop_rounded,
                            elementColor: const Color(0xFF38BDF8),
                            isDark: isDark,
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                // Respirazione Acqua (Gratis)
                                _buildElementPathCard(
                                  context: context,
                                  ref: ref,
                                  title: isIt
                                      ? "Respirazione Acqua"
                                      : "Water Breathing",
                                  desc: isIt
                                      ? "Respira seguendo il flusso delle onde per ritrovare equilibrio e quiete interiore."
                                      : "Breathe with the gentle wave rhythm to restore inner balance.",
                                  duration: "5 MIN",
                                  isBreathing: true,
                                  elementColor: const Color(0xFF38BDF8),
                                  isPremium: false,
                                  onTap: () {
                                    launchZenSession(
                                      context: context,
                                      ref: ref,
                                      title: "Respirazione Acqua",
                                      breathingAudioPath:
                                          'assets/audio/real/Respirazioni/Acqua/Respirazione acqua.m4a',
                                      sceneName: UnityScenes.waterBreathing,
                                      durationSeconds: 300.0,
                                      isPremium: false,
                                    );
                                  },
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                                const SizedBox(height: 12),
                                // Meditazione Generale (Gratis)
                                _buildElementPathCard(
                                  context: context,
                                  ref: ref,
                                  title: isIt
                                      ? "Meditazione Generale"
                                      : "General Meditation",
                                  desc: isIt
                                      ? "Consapevolezza e rilassamento aperto nello spazio panoramico zen."
                                      : "Open awareness and relaxation in the panoramic zen space.",
                                  duration: "10 MIN",
                                  isBreathing: false,
                                  elementColor: const Color(0xFF38BDF8),
                                  isPremium: false,
                                  onTap: () {
                                    launchZenSession(
                                      context: context,
                                      ref: ref,
                                      title: "Meditazione Generale",
                                      voicePath:
                                          'assets/audio/voci/it/meditazione_percorso_acqua_procedimento_it.m4a',
                                      ambientPath:
                                          'assets/audio/ambient/musica_eterea.m4a',
                                      sceneName: UnityScenes.generalMeditation,
                                      durationSeconds: 600.0,
                                      isPremium: false,
                                    );
                                  },
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                                const SizedBox(height: 12),
                                // Mattina (Badge Premium)
                                _buildElementPathCard(
                                  context: context,
                                  ref: ref,
                                  title: isIt
                                      ? "Percorso Acqua (Mattina)"
                                      : "Water Path (Morning)",
                                  desc: isIt
                                      ? "Risveglia i tuoi sensi dolcemente con la luce limpida del mattino."
                                      : "Gently awaken your senses with the soft morning light.",
                                  duration: "15 MIN",
                                  isBreathing: false,
                                  elementColor: const Color(0xFF38BDF8),
                                  isPremium: true,
                                  onTap: () {
                                    launchZenSession(
                                      context: context,
                                      ref: ref,
                                      title: "Percorso Acqua (Mattina)",
                                      voicePath:
                                          'assets/audio/real/Meditazioni/Acqua/Meditazione del Mattino_Procedimento.m4a',
                                      ambientPath:
                                          'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione MATTINO.m4a',
                                      sceneName: UnityScenes.waterMeditation,
                                      durationSeconds: 900.0,
                                      isPremium: true,
                                    );
                                  },
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                                const SizedBox(height: 12),
                                // Pomeriggio (Badge Premium)
                                _buildElementPathCard(
                                  context: context,
                                  ref: ref,
                                  title: isIt
                                      ? "Percorso Acqua (Pomeriggio)"
                                      : "Water Path (Afternoon)",
                                  desc: isIt
                                      ? "Lascia scorrere le tensioni per rigenerarti a metà giornata."
                                      : "Let tensions wash away to refresh your focus mid-day.",
                                  duration: "15 MIN",
                                  isBreathing: false,
                                  elementColor: const Color(0xFF38BDF8),
                                  isPremium: true,
                                  onTap: () {
                                    launchZenSession(
                                      context: context,
                                      ref: ref,
                                      title: "Percorso Acqua (Pomeriggio)",
                                      voicePath:
                                          'assets/audio/real/Meditazioni/Acqua/Meditazione-del-Pomeriggio.m4a',
                                      ambientPath:
                                          'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione POMERIGGIO.m4a',
                                      sceneName:
                                          UnityScenes.waterMeditationAfternoon,
                                      durationSeconds: 900.0,
                                      isPremium: true,
                                    );
                                  },
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                                const SizedBox(height: 12),
                                // Sera (Badge Premium)
                                _buildElementPathCard(
                                  context: context,
                                  ref: ref,
                                  title: isIt
                                      ? "Percorso Acqua (Sera)"
                                      : "Water Path (Evening)",
                                  desc: isIt
                                      ? "Culla la mente per prepararti a un riposo notturno sereno e profondo."
                                      : "Soothe your mind to transition smoothly into restful sleep.",
                                  duration: "25 MIN",
                                  isBreathing: false,
                                  elementColor: const Color(0xFF38BDF8),
                                  isPremium: true,
                                  onTap: () {
                                    launchZenSession(
                                      context: context,
                                      ref: ref,
                                      title: "Percorso Acqua (Sera)",
                                      voicePath:
                                          'assets/audio/real/Meditazioni/Acqua/Meditazione-della-Sera.m4a',
                                      ambientPath:
                                          'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione SERA.m4a',
                                      sceneName:
                                          UnityScenes.waterMeditationEvening,
                                      durationSeconds: 1500.0,
                                      isPremium: true,
                                    );
                                  },
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // 2. ELEMENTO FUOCO
                        if (_selectedElementFilter == 0 ||
                            _selectedElementFilter == 2) ...[
                          _buildElementSectionHeader(
                            title: isIt ? "Elemento Fuoco" : "Fire Element",
                            subtitle: isIt
                                ? "Energia vitale, concentrazione e trasformazione"
                                : "Vital energy, focus, and inner flame",
                            elementIcon: Icons.local_fire_department_rounded,
                            elementColor: const Color(0xFFF97316),
                            isDark: isDark,
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                // Respirazione Fuoco (Badge Premium)
                                _buildElementPathCard(
                                  context: context,
                                  ref: ref,
                                  title: isIt
                                      ? "Respirazione Fuoco"
                                      : "Fire Breathing",
                                  desc: isIt
                                      ? "Box Breathing a 4 tempi per riscaldare il corpo e accendere la concentrazione."
                                      : "4-phase box breathing to warm the body and sharpen alertness.",
                                  duration: "5 MIN",
                                  isBreathing: true,
                                  elementColor: const Color(0xFFF97316),
                                  isPremium: true,
                                  onTap: () {
                                    launchZenSession(
                                      context: context,
                                      ref: ref,
                                      title: "Respirazione Fuoco",
                                      sceneName: UnityScenes.fireMeditation,
                                      durationSeconds: 300.0,
                                      isPremium: true,
                                    );
                                  },
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                                const SizedBox(height: 12),
                                // Meditazione Fuoco (Badge Premium)
                                _buildElementPathCard(
                                  context: context,
                                  ref: ref,
                                  title: isIt
                                      ? "Percorso Fuoco (Meditazione)"
                                      : "Fire Path (Meditation)",
                                  desc: isIt
                                      ? "Trasforma le tensioni accumulate in pura forza vitale e determinazione."
                                      : "Channel inner tension into unshakeable vitality and focus.",
                                  duration: "15 MIN",
                                  isBreathing: false,
                                  elementColor: const Color(0xFFF97316),
                                  isPremium: true,
                                  onTap: () {
                                    launchZenSession(
                                      context: context,
                                      ref: ref,
                                      title: "Percorso Fuoco",
                                      sceneName: UnityScenes.fireMeditation,
                                      durationSeconds: 900.0,
                                      isPremium: true,
                                    );
                                  },
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // 3. ELEMENTO TERRA
                        if (_selectedElementFilter == 0 ||
                            _selectedElementFilter == 3) ...[
                          _buildElementSectionHeader(
                            title: isIt ? "Elemento Terra" : "Earth Element",
                            subtitle: isIt
                                ? "Radicamento millenario, equilibrio e stabilità"
                                : "Ancient grounding, balance, and stability",
                            elementIcon: Icons.forest_rounded,
                            elementColor: const Color(0xFF84CC16),
                            isDark: isDark,
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                // Respirazione Terra (Badge Premium)
                                _buildElementPathCard(
                                  context: context,
                                  ref: ref,
                                  title: isIt
                                      ? "Respirazione Terra"
                                      : "Earth Breathing",
                                  desc: isIt
                                      ? "Ritmo polmonare profondo a 432 Hz per ancorare mente e corpo alla gravità."
                                      : "Deep 432 Hz grounding breath to center body and mind firmly.",
                                  duration: "5 MIN",
                                  isBreathing: true,
                                  elementColor: const Color(0xFF84CC16),
                                  isPremium: true,
                                  onTap: () {
                                    launchZenSession(
                                      context: context,
                                      ref: ref,
                                      title: "Respirazione Terra",
                                      sceneName: UnityScenes.earthMeditation,
                                      durationSeconds: 300.0,
                                      isPremium: true,
                                    );
                                  },
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                                const SizedBox(height: 12),
                                // Meditazione Terra (Badge Premium)
                                _buildElementPathCard(
                                  context: context,
                                  ref: ref,
                                  title: isIt
                                      ? "Percorso Terra (Meditazione)"
                                      : "Earth Path (Meditation)",
                                  desc: isIt
                                      ? "Stabilità incrollabile: ritrova il tuo centro e la tua forza silente."
                                      : "Unshakeable core stability: rediscover quiet, enduring strength.",
                                  duration: "20 MIN",
                                  isBreathing: false,
                                  elementColor: const Color(0xFF84CC16),
                                  isPremium: true,
                                  onTap: () {
                                    launchZenSession(
                                      context: context,
                                      ref: ref,
                                      title: "Percorso Terra",
                                      sceneName: UnityScenes.earthMeditation,
                                      durationSeconds: 1200.0,
                                      isPremium: true,
                                    );
                                  },
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // 4. ELEMENTO ARIA
                        if (_selectedElementFilter == 0 ||
                            _selectedElementFilter == 4) ...[
                          _buildElementSectionHeader(
                            title: isIt ? "Elemento Aria" : "Air Element",
                            subtitle: isIt
                                ? "Leggerezza, ampiezza e pura consapevolezza"
                                : "Lightness, clarity, and open perspective",
                            elementIcon: Icons.air_rounded,
                            elementColor: const Color(0xFF06B6D4),
                            isDark: isDark,
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                // Respirazione Aria (Badge Premium)
                                _buildElementPathCard(
                                  context: context,
                                  ref: ref,
                                  title: isIt
                                      ? "Respirazione Aria"
                                      : "Air Breathing",
                                  desc: isIt
                                      ? "Coerenza cardiaca guidata con la mongolfiera zen per liberare il respiro."
                                      : "Guided heart coherence to elevate breath and clear tension.",
                                  duration: "5 MIN",
                                  isBreathing: true,
                                  elementColor: const Color(0xFF06B6D4),
                                  isPremium: true,
                                  onTap: () {
                                    launchZenSession(
                                      context: context,
                                      ref: ref,
                                      title: "Respirazione Aria",
                                      sceneName: UnityScenes.airMeditation,
                                      durationSeconds: 300.0,
                                      isPremium: true,
                                    );
                                  },
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                                const SizedBox(height: 12),
                                // Meditazione Aria (Badge Premium)
                                _buildElementPathCard(
                                  context: context,
                                  ref: ref,
                                  title: isIt
                                      ? "Percorso Aria (Meditazione)"
                                      : "Air Path (Meditation)",
                                  desc: isIt
                                      ? "Eleva i tuoi pensieri oltre la quotidianità verso una visione aperta e luminosa."
                                      : "Rise above daily turbulence toward expansive awareness.",
                                  duration: "15 MIN",
                                  isBreathing: false,
                                  elementColor: const Color(0xFF06B6D4),
                                  isPremium: true,
                                  onTap: () {
                                    launchZenSession(
                                      context: context,
                                      ref: ref,
                                      title: "Percorso Aria",
                                      sceneName: UnityScenes.airMeditation,
                                      durationSeconds: 900.0,
                                      isPremium: true,
                                    );
                                  },
                                  isDark: isDark,
                                  textColor: textColor,
                                  subTextColor: subTextColor,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // CITAZIONE ZEN DI CHIUSURA
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
                                Positioned(
                                  left: -20,
                                  top: -10,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.goldAccent
                                          .withValues(alpha: 0.04),
                                    ),
                                  ),
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
                                      "\"${dailyQuote.text}\"",
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
                                      "- ${dailyQuote.author} -",
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
                                      dailyQuote.subtitle ??
                                          (isIt
                                              ? "Riflessione Zen di oggi"
                                              : "Today's Zen reflection"),
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

  /// Costruisce il pill di filtro rapido per gli Elementi
  Widget _buildElementFilterPill({
    required String label,
    required int index,
    required IconData icon,
    required Color color,
    required bool isDark,
    required Color textColor,
    required Color subTextColor,
  }) {
    final isSelected = _selectedElementFilter == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedElementFilter = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: isDark ? 0.22 : 0.16)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : Colors.black.withValues(alpha: 0.03)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.5)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.08)),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? color : subTextColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: isSelected ? textColor : subTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Costruisce l'intestazione di ciascun Elemento
  Widget _buildElementSectionHeader({
    required String title,
    required String subtitle,
    required IconData elementIcon,
    required Color elementColor,
    required bool isDark,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: elementColor.withValues(alpha: isDark ? 0.14 : 0.18),
            ),
            child: Icon(
              elementIcon,
              size: 18,
              color: elementColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: subTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Costruisce una card percorso Japandi per un elemento con icone rigorosamente congrue:
  /// - Meditazione: Icons.self_improvement_rounded (omino che medita)
  /// - Respirazione: Icons.air_rounded (soffio/vento)
  Widget _buildElementPathCard({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String desc,
    required String duration,
    required bool isBreathing,
    required Color elementColor,
    required bool isPremium,
    required VoidCallback onTap,
    required bool isDark,
    required Color textColor,
    required Color subTextColor,
  }) {
    final settings = ref.watch(settingsProvider);
    final isLocked = isPremium && !settings.isUnlocked;

    // Regola icone congrue per tipologia:
    // Meditazione -> omino zen che medita (Icons.self_improvement_rounded)
    // Respirazione -> soffio/vento (Icons.air_rounded)
    final typeIcon = isBreathing
        ? Icons.air_rounded
        : Icons.self_improvement_rounded;
    final typeLabel = isBreathing ? "RESPIRAZIONE" : "MEDITAZIONE";

    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          if (isLocked) {
            context.push('/premium');
          } else {
            onTap();
          }
        },
        child: Container(
          width: double.infinity,
          decoration: AppColors.japandiCardDecoration(
            isDark,
            borderRadius: 22.0,
            opacity: 0.60,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icona congrua con alone dell'elemento
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: elementColor.withValues(alpha: isDark ? 0.14 : 0.18),
                  border: Border.all(
                    color: elementColor.withValues(alpha: 0.35),
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  typeIcon,
                  size: 24,
                  color: elementColor,
                ),
              ),
              const SizedBox(width: 14),

              // Contenuto testuale
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag tipologia e Badge Premium/Gratis
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            typeLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.0,
                              fontWeight: FontWeight.w800,
                              color: elementColor,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: (isPremium
                                    ? AppColors.goldAccent
                                    : AppColors.successAccent)
                                .withValues(alpha: isDark ? 0.14 : 0.18),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isLocked) ...[
                                const Icon(
                                  Icons.lock_rounded,
                                  size: 10,
                                  color: AppColors.goldAccent,
                                ),
                                const SizedBox(width: 3),
                              ],
                              Text(
                                isPremium ? "PREMIUM" : "GRATIS",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 8.0,
                                  fontWeight: FontWeight.w800,
                                  color: isPremium
                                      ? AppColors.goldAccent
                                      : AppColors.successAccent,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Titolo
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Descrizione
                    Text(
                      desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: subTextColor,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Durata
                    Row(
                      children: [
                        Icon(
                          Icons.query_builder_rounded,
                          size: 12,
                          color: subTextColor.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          duration,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w700,
                            color: subTextColor.withValues(alpha: 0.85),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Tasto Play o Lucchetto
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLocked
                      ? AppColors.goldAccent.withValues(alpha: 0.15)
                      : elementColor.withValues(alpha: isDark ? 0.20 : 0.15),
                  border: Border.all(
                    color: isLocked
                        ? AppColors.goldAccent.withValues(alpha: 0.4)
                        : elementColor.withValues(alpha: 0.35),
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  isLocked
                      ? Icons.lock_outline_rounded
                      : Icons.play_arrow_rounded,
                  color: isLocked ? AppColors.goldAccent : elementColor,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
              fontSize: 11.0,
              fontWeight: FontWeight.bold,
              color:
                  isSelected ? textColor : subTextColor.withValues(alpha: 0.8),
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
    required bool isBreathing,
    required String voice,
    required String ambient,
    required bool isDark,
    required Color accentColor,
    required Color textColor,
    required Color subTextColor,
    String? sceneName,
    double durationSeconds = 900.0,
    bool isPremium = false,
  }) {
    final settings = ref.watch(settingsProvider);
    final isLocked = isPremium && !settings.isUnlocked;

    // Icona congrua per la card
    final typeIcon = isBreathing
        ? Icons.air_rounded
        : Icons.self_improvement_rounded;

    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        onTap: () {
          if (isLocked) {
            context.push('/premium');
          } else {
            launchZenSession(
              context: context,
              ref: ref,
              title: title,
              voicePath: voice,
              ambientPath: ambient,
              sceneName: sceneName,
              durationSeconds: durationSeconds,
              isPremium: isPremium,
            );
          }
        },
        child: Container(
          width: 220,
          decoration: AppColors.japandiCardDecoration(
            isDark,
            borderRadius: 24.0,
            opacity: 0.55,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                typeIcon,
                                size: 14,
                                color: accentColor,
                              ),
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: (isLocked
                                          ? AppColors.goldAccent
                                          : accentColor)
                                      .withValues(
                                    alpha: isDark ? 0.08 : 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tag,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 8.0,
                                    fontWeight: FontWeight.bold,
                                    color: isLocked
                                        ? AppColors.goldAccent
                                        : accentColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isLocked)
                          const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.goldAccent,
                            size: 16,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
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
                    ),
                  ],
                ),
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
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isLocked
                            ? AppColors.goldAccent.withValues(alpha: 0.8)
                            : textColor.withValues(alpha: 0.8),
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      isLocked
                          ? Icons.lock_outline_rounded
                          : Icons.play_arrow_rounded,
                      color: isLocked ? AppColors.goldAccent : textColor,
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
