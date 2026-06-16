import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';
import '../../meditation/meditation_feature.dart';
import '../../premium/premium_feature.dart';

class MeditateTab extends ConsumerStatefulWidget {
  const MeditateTab({Key? key}) : super(key: key);

  @override
  ConsumerState<MeditateTab> createState() => _MeditateTabState();
}

class _MeditateTabState extends ConsumerState<MeditateTab> {
  int _selectedCategory = 0; // 0 = All, 1 = Meditations, 2 = Breathings

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subTextColor = AppColors.getSubTextColor(isDark);

    return Container(
      color: Colors.transparent, // Rende il tab al 100% trasparente per mostrare lo sfondo globale fluttuante
      child: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Serif
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 20.0, bottom: 10.0),
              child: Text(
                settings.language == 0 ? "Percorsi Zen" : "Zen Paths",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // Orizzontale Category Pill Selector (All, Meditate, Breathe)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                children: [
                  _buildCategoryPill("ALL", 0, isDark, accentColor),
                  const SizedBox(width: 8),
                  _buildCategoryPill(settings.language == 0 ? "MEDITAZIONI" : "MEDITATIONS", 1, isDark, accentColor),
                  const SizedBox(width: 8),
                  _buildCategoryPill(settings.language == 0 ? "RESPIRAZIONI" : "BREATHINGS", 2, isDark, accentColor),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Lista scorrevole dei percorsi
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 100.0), // Spazio extra in basso per consentire al contenuto di scorrere completamente sopra la barra fluttuante
                children: [
                  if (_selectedCategory == 0 || _selectedCategory == 1) ...[
                    _buildSectionHeader(settings.language == 0 ? "Meditazioni Guidate" : "Guided Meditations", isDark),
                    _buildPathCard(
                      context: context,
                      title: settings.language == 0 ? "Percorso Acqua (Mattina)" : "Water Path (Morning)",
                      desc: settings.language == 0
                          ? "Una meditazione fluida per ritrovare calma e centratura nel presente."
                          : "A flowing meditation to recover calm and presence in the moment.",
                      duration: "15 MIN",
                      isPremium: false,
                      isLocked: false,
                      isDark: isDark,
                      accentColor: accentColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      onTap: () {
                        launchZenSession(
                          context: context,
                          ref: ref,
                          title: settings.language == 0 ? "Percorso Acqua" : "Water Path",
                          voicePath: 'assets/audio/real/Meditazioni/Acqua/Meditazione del Mattino_Procedimento.m4a',
                          ambientPath: 'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione MATTINO.m4a',
                        );
                      },
                    ),
                    _buildPathCard(
                      context: context,
                      title: settings.language == 0 ? "Percorso Acqua (Pomeriggio)" : "Water Path (Afternoon)",
                      desc: settings.language == 0
                          ? "Lascia scorrere i pensieri per rigenerarti a metà giornata."
                          : "Let your thoughts flow to recharge mid-day.",
                      duration: "15 MIN",
                      isPremium: false,
                      isLocked: false,
                      isDark: isDark,
                      accentColor: accentColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      onTap: () {
                        launchZenSession(
                          context: context,
                          ref: ref,
                          title: settings.language == 0 ? "Percorso Acqua (Pomeriggio)" : "Water Path (Afternoon)",
                          voicePath: 'assets/audio/real/Meditazioni/Acqua/Meditazione-del-Pomeriggio.m4a',
                          ambientPath: 'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione POMERIGGIO.m4a',
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildPathCard(
                      context: context,
                      title: settings.language == 0 ? "Percorso Acqua (Sera)" : "Water Path (Evening)",
                      desc: settings.language == 0
                          ? "Rilassa la mente per prepararti a un riposo profondo."
                          : "Relax your mind to prepare for deep rest.",
                      duration: "25 MIN",
                      isPremium: false,
                      isLocked: false,
                      isDark: isDark,
                      accentColor: accentColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      onTap: () {
                        launchZenSession(
                          context: context,
                          ref: ref,
                          title: settings.language == 0 ? "Percorso Acqua (Sera)" : "Water Path (Evening)",
                          voicePath: 'assets/audio/real/Meditazioni/Acqua/Meditazione-della-Sera.m4a',
                          ambientPath: 'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione SERA.m4a',
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (_selectedCategory == 0 || _selectedCategory == 2) ...[
                    _buildSectionHeader(settings.language == 0 ? "Esercizi di Respirazione" : "Breathing Sessions", isDark),
                    _buildPathCard(
                      context: context,
                      title: settings.language == 0 ? "Respirazione Acqua (Gratis)" : "Water Breath (Free)",
                      desc: settings.language == 0
                          ? "Respira con il fluire dell'acqua per calmare la mente."
                          : "Breathe with the flow of water to calm your mind.",
                      duration: "5 MIN",
                      isPremium: false,
                      isLocked: false,
                      isDark: isDark,
                      accentColor: accentColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      onTap: () {
                        launchZenSession(
                          context: context,
                          ref: ref,
                          title: settings.language == 0 ? "Respirazione Acqua" : "Water Breath",
                          breathingAudioPath: 'assets/audio/real/Respirazioni/Acqua/Respirazione acqua.m4a',
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildPathCard(
                      context: context,
                      title: settings.language == 0 ? "Respirazione Aria (Gratis)" : "Air Breath (Free)",
                      desc: settings.language == 0
                          ? "Sincronizza il tuo ritmo vitale con il soffio dell'aria."
                          : "Synchronize your vital rhythm with the blowing of the air.",
                      duration: "5 MIN",
                      isPremium: false,
                      isLocked: false,
                      isDark: isDark,
                      accentColor: accentColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      onTap: () {
                        launchZenSession(
                          context: context,
                          ref: ref,
                          title: settings.language == 0 ? "Respirazione Aria" : "Air Breath",
                          breathingAudioPath: 'assets/audio/real/Respirazioni/Aria/Respirazione aria.m4a',
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildPathCard(
                      context: context,
                      title: settings.language == 0 ? "Respirazione Fuoco (Premium)" : "Fire Breath (Premium)",
                      desc: settings.language == 0
                          ? "Accendi la tua energia interiore con la respirazione quadrata."
                          : "Ignite your inner energy with square breathing.",
                      duration: "5 MIN",
                      isPremium: true,
                      isLocked: !settings.isUnlocked,
                      isDark: isDark,
                      accentColor: accentColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      onTap: () {
                        if (settings.isUnlocked) {
                          launchZenSession(
                            context: context,
                            ref: ref,
                            title: settings.language == 0 ? "Respirazione Fuoco" : "Fire Breath",
                            breathingAudioPath: 'assets/audio/real/Respirazioni/Fuoco/percorso fuoco quadrato Esercizio fix tempo.m4a',
                          );
                        } else {
                          _showPurchaseDialog(context);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildPathCard(
                      context: context,
                      title: settings.language == 0 ? "Respirazione Terra (Premium)" : "Earth Breath (Premium)",
                      desc: settings.language == 0
                          ? "Radicati nel presente con una respirazione profonda."
                          : "Ground yourself in the present with deep breathing.",
                      duration: "5 MIN",
                      isPremium: true,
                      isLocked: !settings.isUnlocked,
                      isDark: isDark,
                      accentColor: accentColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      onTap: () {
                        if (settings.isUnlocked) {
                          launchZenSession(
                            context: context,
                            ref: ref,
                            title: settings.language == 0 ? "Respirazione Terra" : "Earth Breath",
                            breathingAudioPath: 'assets/audio/real/Respirazioni/Terra/Respirazione terra.m4a',
                          );
                        } else {
                          _showPurchaseDialog(context);
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPill(String label, int index, bool isDark, Color accentColor) {
    final isSelected = _selectedCategory == index;
    return Semantics(button: true, label: "Interactive element", child: GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : (isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? accentColor : (isDark ? Colors.white12 : Colors.black12),
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: isSelected ? (isDark ? Colors.black : Colors.white) : AppColors.getSubTextColor(isDark),
            letterSpacing: 0.5,
          ),
        ),
      ),
    ));
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
          color: AppColors.getSubTextColor(isDark),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildPathCard({
    required BuildContext context,
    required String title,
    required String desc,
    required String duration,
    required bool isPremium,
    required bool isLocked,
    required bool isDark,
    required Color accentColor,
    required Color textColor,
    required Color subTextColor,
    required VoidCallback onTap,
  }) {
    return Semantics(button: true, label: "Interactive element", child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: AppColors.japandiCardDecoration(isDark, borderRadius: 24.0, opacity: 0.65),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isPremium ? Icons.stars_rounded : Icons.spa_outlined,
                      size: 20,
                      color: isPremium ? AppColors.goldAccent : accentColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      duration,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: subTextColor,
                      ),
                    ),
                  ],
                ),
                if (isLocked)
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 18,
                    color: AppColors.goldAccent,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18.5,
                fontWeight: FontWeight.w800,
                color: textColor,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              desc,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: subTextColor.withOpacity(0.9),
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _showPurchaseDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PremiumPaywallView()),
    );
  }
}
