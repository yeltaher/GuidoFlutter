import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';

import 'me_tab_provider.dart';

class MeTab extends ConsumerWidget {
  final bool isActive;
  const MeTab({Key? key, this.isActive = true}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subTextColor = AppColors.getSubTextColor(isDark);

    final dataAsync = ref.watch(meTabDataProvider);
    
    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Errore: $err')),
      data: (data) {
        final userName = data.userName;
        final quizProblems = data.quizProblems;
        final quizGoals = data.quizGoals;
        final quizStrengths = data.quizStrengths;
        final quizWeaknesses = data.quizWeaknesses;
        
        final List<String> styleNames = [
          "🎙️ Voce Guida",
          "🎵 Solo Musica",
          "🤫 Silenzio Zen",
          "🫁 Respirazione",
        ];
        final String chosenStyle = styleNames[data.profileStyle];

        // Calcola le iniziali dell'avatar
        String avatarInitials = "OZ";
        if (userName.trim().isNotEmpty) {
          final parts = userName.trim().split(RegExp(r'\s+'));
          if (parts.length >= 2) {
            avatarInitials = (parts[0][0] + parts[1][0]).toUpperCase();
          } else if (parts[0].length >= 2) {
            avatarInitials = parts[0].substring(0, 2).toUpperCase();
          } else if (parts[0].isNotEmpty) {
            avatarInitials = parts[0][0].toUpperCase();
          }
        }

        final stats = data.stats;
        final int minutesMeditated = stats?.totalMinutes ?? 0;
        final int sessionsCompleted = stats?.totalSessions ?? 0;
        final int currentStreak = stats?.currentStreak ?? 0;
        final int currentXp = stats?.profileXp ?? 0;

        final int currentLevel = (currentXp ~/ 600) + 1;
        final int xpInLevel = currentXp % 600;
        final List<String> levelTitles = [
          "Novizio",
          "Viaggiatore",
          "Cercatore",
          "Custode del Silenzio",
          "Maestro Zen",
        ];
        final String levelTitle = currentLevel <= levelTitles.length
            ? levelTitles[currentLevel - 1]
            : "Maestro Asceso";

        Set<int> meditatedDays = {};
        int currentMonth = DateTime.now().month;
        int currentYear = DateTime.now().year;
        int currentDay = DateTime.now().day;

        for (var record in data.timeline) {
          final ts = DateTime.fromMillisecondsSinceEpoch(record.timestamp);
          if (ts.month == currentMonth && ts.year == currentYear) {
            meditatedDays.add(ts.day);
          }
        }

        int totalMeditatedDaysCurrentMonth = meditatedDays.length;
        final int daysPassed = currentDay > 0 ? currentDay : 1;
        final int coerenzaZen =
            ((totalMeditatedDaysCurrentMonth / daysPassed) * 100).clamp(0, 100).toInt();

        final List<String> mesiItaliani = [
          "Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno",
          "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre",
        ];
        final String meseCorrenteText = "${mesiItaliani[currentMonth - 1]} $currentYear";

        final int daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;

        return Container(
      color: Colors
          .transparent, // Tab al 100% trasparente, eredita lo sfondo gradiente globale
      child: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Header Serif Principale (Fisso in alto)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "PROFILO ZEN",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 18),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  24.0,
                  0.0,
                  24.0,
                  110.0,
                ), // Spazio extra in basso per scorrere oltre la barra fluttuante
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. SCHEDA UTENTE PREMIUM CON LIVELLO (CLAYMORPHIC)
                    ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: AppColors.japandiCardDecoration(
                                isDark,
                                borderRadius: 26,
                                opacity: 0.38,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // Avatar minimalistico in stile Zen
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: accentColor.withOpacity(0.12),
                                          border: Border.all(
                                            color: accentColor.withOpacity(0.3),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            avatarInitials,
                                            style: GoogleFonts.playfairDisplay(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              color: accentColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Dati utente
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userName,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                    color: textColor,
                                                  ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              currentLevel > 2
                                                  ? "Praticante Esperto"
                                                  : "Praticante Novizio",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 12.5,
                                                    fontWeight: FontWeight.w600,
                                                    color: subTextColor,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 20),

                                  // Barra del Livello e XP
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Livello $currentLevel: $levelTitle",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                      Text(
                                        "$xpInLevel / 600 XP",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                          color: subTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: xpInLevel / 600,
                                      minHeight: 8,
                                      backgroundColor: isDark
                                          ? Colors.white.withOpacity(0.06)
                                          : Colors.black.withOpacity(0.06),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        accentColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .animate(target: isActive ? 1.0 : 0.0)
                        .fadeIn(duration: 400.ms)
                        .scale(
                          begin: const Offset(0.97, 0.97),
                          end: const Offset(1, 1),
                          curve: Curves.easeOutBack,
                        ),

                    // NUOVO PANNELLO PERSONALIZZAZIONE QUIZ
                    if (quizGoals.isNotEmpty ||
                        quizProblems.isNotEmpty ||
                        quizStrengths.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        "IL TUO SENTIERO DI CONSAPEVOLEZZA",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: subTextColor,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                            width: double.infinity,
                            decoration: AppColors.japandiCardDecoration(
                              isDark,
                              borderRadius: 24.0,
                              opacity: 0.65,
                            ),
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.route_rounded,
                                      color: AppColors.successAccent,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "La tua via",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  chosenStyle,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: subTextColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.spa_rounded,
                                      color: accentColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Il tuo obiettivo primario",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  quizGoals.isNotEmpty
                                      ? quizGoals.join(", ")
                                      : "Ritrovare la pace interiore",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: subTextColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.bolt_rounded,
                                      color: AppColors.goldAccent,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "I tuoi punti di forza",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  quizStrengths.isNotEmpty
                                      ? quizStrengths.join(", ")
                                      : "Apertura alle novità",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: subTextColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.favorite_rounded,
                                      color: AppColors.dangerAccent,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Aree di crescita (Fragilità)",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  quizWeaknesses.isNotEmpty
                                      ? quizWeaknesses.join(", ")
                                      : "Fatica a rilassarmi del tutto",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: subTextColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .animate(target: isActive ? 1.0 : 0.0)
                          .fadeIn(delay: 100.ms, duration: 500.ms),
                    ],

                    const SizedBox(height: 24),

                    // 2. GRIGLIA STATISTICHE 2x2
                    Text(
                      "STATISTICHE DI CONSAPEVOLEZZA",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: subTextColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                value: "$minutesMeditated min",
                                label: "TEMPO TOTALE",
                                icon: Icons.access_time_outlined,
                                isDark: isDark,
                                accentColor: accentColor,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMetricCard(
                                value: sessionsCompleted.toString(),
                                label: "SESSIONI",
                                icon: Icons.spa_outlined,
                                isDark: isDark,
                                accentColor: accentColor,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                            ),
                          ],
                        )
                        .animate(target: isActive ? 1.0 : 0.0)
                        .fadeIn(delay: 150.ms, duration: 550.ms),
                    const SizedBox(height: 12),
                    Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                value: "$currentStreak giorni 🔥",
                                label: "STREAK ATTIVO",
                                icon: Icons.local_fire_department_outlined,
                                isDark: isDark,
                                accentColor: AppColors.goldAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMetricCard(
                                value: "$coerenzaZen%",
                                label: "COERENZA ZEN",
                                icon: Icons.bubble_chart_outlined,
                                isDark: isDark,
                                accentColor: AppColors.successAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                            ),
                          ],
                        )
                        .animate(target: isActive ? 1.0 : 0.0)
                        .fadeIn(delay: 250.ms, duration: 550.ms),

                    const SizedBox(height: 28),

                    // 3. CALENDARIO FREQUENZA MEDITAZIONI
                    Text(
                      "CALENDARIO DI MEDITAZIONE",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: subTextColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                          width: double.infinity,
                          decoration: AppColors.japandiCardDecoration(
                            isDark,
                            borderRadius: 24.0,
                            opacity: 0.65,
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    meseCorrenteText,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: accentColor.withOpacity(0.8),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 7,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                    ),
                                itemCount: daysInMonth,
                                itemBuilder: (context, index) {
                                  final int day = index + 1;
                                  final bool hasMeditated = meditatedDays
                                      .contains(day);

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: hasMeditated
                                          ? accentColor.withOpacity(0.8)
                                          : (isDark
                                                ? Colors.white.withOpacity(0.02)
                                                : Colors.black.withOpacity(
                                                    0.02,
                                                  )),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: hasMeditated
                                            ? accentColor
                                            : Colors.transparent,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        day.toString(),
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11.5,
                                          fontWeight: hasMeditated
                                              ? FontWeight.w800
                                              : FontWeight.w500,
                                          color: hasMeditated
                                              ? (isDark
                                                    ? Colors.black
                                                    : Colors.white)
                                              : textColor.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                        .animate(target: isActive ? 1.0 : 0.0)
                        .fadeIn(delay: 350.ms, duration: 600.ms),

                    const SizedBox(height: 28),

                    // 4. TIMELINE DI ATTIVITÀ RECENTE
                    Text(
                      "ATTIVITÀ RECENTE",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: subTextColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                          width: double.infinity,
                          decoration: AppColors.japandiCardDecoration(
                            isDark,
                            borderRadius: 24.0,
                            opacity: 0.65,
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Builder(
                            builder: (context) {
                              final historyStr =
                                  ref.read(sharedPrefsProvider).getStringList("timeline_history") ?? [];
                              if (historyStr.isEmpty) {
                                return Text(
                                  "Nessuna sessione completata. Inizia a meditare!",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: subTextColor,
                                  ),
                                );
                              }

                              final List<Widget> timelineWidgets = [];
                              for (
                                int i = 0;
                                i < historyStr.length && i < 3;
                                i++
                              ) {
                                try {
                                  final record = jsonDecode(historyStr[i]);
                                  final ts =
                                      DateTime.fromMillisecondsSinceEpoch(
                                        record["timestamp"],
                                      );
                                  final timeStr =
                                      "${ts.day.toString().padLeft(2, '0')}/${ts.month.toString().padLeft(2, '0')} alle ${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}";

                                  timelineWidgets.add(
                                    _buildTimelineRow(
                                      session: record["title"] ?? "Sessione",
                                      type: record["type"] ?? "Meditazione",
                                      time: timeStr,
                                      duration: record["duration"] ?? "10 min",
                                      icon: record["type"] == "Respirazione"
                                          ? Icons.nature_people_outlined
                                          : Icons.spa_outlined,
                                      accentColor:
                                          record["type"] == "Respirazione"
                                          ? AppColors.successAccent
                                          : accentColor,
                                      textColor: textColor,
                                      subTextColor: subTextColor,
                                      isLast:
                                          i ==
                                          (historyStr.length > 3
                                              ? 2
                                              : historyStr.length - 1),
                                    ),
                                  );
                                } catch (e) {
                                  // skip invalid record
                                }
                              }
                              return Column(children: timelineWidgets);
                            },
                          ),
                        )
                        .animate(target: isActive ? 1.0 : 0.0)
                        .fadeIn(delay: 450.ms, duration: 600.ms),

                    const SizedBox(height: 28),

                    // 5. BACHECA TRAGUARDI ZEN (BADGES SHOWCASE)
                    Text(
                      "BADGE ZEN SBLOCCATI",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: subTextColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                          height: 110,
                          child: ListView(
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              _buildBadgeCard(
                                title: "Primo Respiro",
                                desc: "Prima sessione",
                                icon: Icons.water_drop_outlined,
                                isUnlocked: sessionsCompleted >= 1,
                                isDark: isDark,
                                accentColor: AppColors.successAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Alba Zen",
                                desc: "5 Sessioni",
                                icon: Icons.wb_twilight_rounded,
                                isUnlocked: sessionsCompleted >= 5,
                                isDark: isDark,
                                accentColor: AppColors.goldAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Abitudine",
                                desc: "10 Sessioni",
                                icon: Icons.repeat_rounded,
                                isUnlocked: sessionsCompleted >= 10,
                                isDark: isDark,
                                accentColor: accentColor,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Dedizione",
                                desc: "25 Sessioni",
                                icon: Icons.self_improvement_rounded,
                                isUnlocked: sessionsCompleted >= 25,
                                isDark: isDark,
                                accentColor: accentColor,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Maestria",
                                desc: "50 Sessioni",
                                icon: Icons.brightness_7_rounded,
                                isUnlocked: sessionsCompleted >= 50,
                                isDark: isDark,
                                accentColor: AppColors.goldAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Mente Libera",
                                desc: "15 Minuti totali",
                                icon: Icons.access_time_rounded,
                                isUnlocked: minutesMeditated >= 15,
                                isDark: isDark,
                                accentColor: subTextColor,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Pace Profonda",
                                desc: "60 Minuti totali",
                                icon: Icons.spa_outlined,
                                isUnlocked: minutesMeditated >= 60,
                                isDark: isDark,
                                accentColor: subTextColor,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Oceano di Calma",
                                desc: "120 Minuti totali",
                                icon: Icons.waves_rounded,
                                isUnlocked: minutesMeditated >= 120,
                                isDark: isDark,
                                accentColor: accentColor,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Saggezza",
                                desc: "500 Minuti totali",
                                icon: Icons.auto_awesome_rounded,
                                isUnlocked: minutesMeditated >= 500,
                                isDark: isDark,
                                accentColor: AppColors.goldAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Risveglio",
                                desc: "1000 Minuti",
                                icon: Icons.wb_sunny_rounded,
                                isUnlocked: minutesMeditated >= 1000,
                                isDark: isDark,
                                accentColor: AppColors.goldAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Fuoco Interiore",
                                desc: "3 Giorni streak",
                                icon: Icons.local_fire_department_outlined,
                                isUnlocked: currentStreak >= 3,
                                isDark: isDark,
                                accentColor: AppColors.dangerAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Costanza",
                                desc: "5 Giorni streak",
                                icon: Icons.local_fire_department_rounded,
                                isUnlocked: currentStreak >= 5,
                                isDark: isDark,
                                accentColor: AppColors.dangerAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Disciplina",
                                desc: "7 Giorni streak",
                                icon: Icons.bolt_rounded,
                                isUnlocked: currentStreak >= 7,
                                isDark: isDark,
                                accentColor: accentColor,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Impegno Assoluto",
                                desc: "14 Giorni streak",
                                icon: Icons.verified_rounded,
                                isUnlocked: currentStreak >= 14,
                                isDark: isDark,
                                accentColor: AppColors.goldAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                              const SizedBox(width: 12),
                              _buildBadgeCard(
                                title: "Armonia Mensile",
                                desc: "30 Giorni streak",
                                icon: Icons.stars_rounded,
                                isUnlocked: currentStreak >= 30,
                                isDark: isDark,
                                accentColor: AppColors.successAccent,
                                textColor: textColor,
                                subTextColor: subTextColor,
                              ),
                            ],
                          ),
                        )
                        .animate(target: isActive ? 1.0 : 0.0)
                        .fadeIn(delay: 550.ms, duration: 600.ms),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    });
  }

  Widget _buildMetricCard({
    required String value,
    required String label,
    required IconData icon,
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
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16),
      child: Column(
        children: [
          Icon(icon, size: 20, color: accentColor.withOpacity(0.85)),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: subTextColor.withOpacity(0.8),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineRow({
    required String session,
    required String type,
    required String time,
    required String duration,
    required IconData icon,
    required Color accentColor,
    required Color textColor,
    required Color subTextColor,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Indicatore verticale della timeline
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.1),
                border: Border.all(
                  color: accentColor.withOpacity(0.4),
                  width: 1.0,
                ),
              ),
              child: Icon(icon, color: accentColor, size: 16),
            ),
            if (!isLast)
              Container(
                width: 1.5,
                height: 32,
                color: accentColor.withOpacity(0.2),
              ),
          ],
        ),
        const SizedBox(width: 14),
        // Dati della sessione
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    session,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  Text(
                    duration,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: subTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1),
              Text(
                "$type • $time",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: subTextColor.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeCard({
    required String title,
    required String desc,
    required IconData icon,
    required bool isUnlocked,
    required bool isDark,
    required Color accentColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: AppColors.japandiCardDecoration(
        isDark,
        borderRadius: 20.0,
        opacity: 0.65,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color: isUnlocked ? accentColor : subTextColor.withOpacity(0.3),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isUnlocked ? textColor : textColor.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            desc,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              color: isUnlocked ? subTextColor : subTextColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
