import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';
import '../../meditation/meditation_feature.dart';

class HomeTab extends ConsumerWidget {
  final bool isActive;
  const HomeTab({Key? key, this.isActive = true}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final accentColor = AppColors.getActiveAccentColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subTextColor = AppColors.getSubTextColor(isDark);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.getGradientByTime(isDark),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              // 1. BRAND HEADER IN SERIF PLAYFAIR DISPLAY
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
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ).animate(target: isActive ? 1.0 : 0.0).fadeIn(duration: 500.ms).slideY(begin: -0.05, end: 0),
              
              const SizedBox(height: 18),
              
              // 2. WELCOME HERO SECTION
              Text(
                "Benvenuto in Guido.\nRespira e inizia il tuo viaggio.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  height: 1.35,
                  letterSpacing: -0.4,
                ),
              ).animate(target: isActive ? 1.0 : 0.0).fadeIn(delay: 150.ms, duration: 500.ms),
              
              const SizedBox(height: 8),
              
              Text(
                "Focus di oggi: Presenza",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: subTextColor,
                  letterSpacing: 0.1,
                ),
              ).animate(target: isActive ? 1.0 : 0.0).fadeIn(delay: 250.ms, duration: 500.ms),
              
              const SizedBox(height: 24),
              
              // 3. FEATURED MEDITATION TITLE
              Text(
                "Meditazioni consigliate",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  letterSpacing: 0.1,
                ),
              ).animate(target: isActive ? 1.0 : 0.0).fadeIn(delay: 350.ms, duration: 500.ms),
              
              const SizedBox(height: 12),
              
              // 4. LARGE FEATURED CARD WITH SAGE HAND-DRAWN CONTOUR WAVES
              Semantics(button: true, label: "Interactive element", child: GestureDetector(
                onTap: () {
                  launchZenSession(
                    context: context,
                    ref: ref,
                    title: "Morning Flow",
                    voicePath: 'assets/audio/real/Meditazioni/Acqua/Meditazione del Mattino_Procedimento.m4a',
                    ambientPath: 'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione MATTINO.m4a',
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 146,
                  decoration: AppColors.japandiCardDecoration(isDark, borderRadius: 24.0, opacity: 0.65),
                  child: Stack(
                    children: [
                      // Onde vettoriali disegnate a mano libera (Contour Waves) sulla destra della card
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        width: 170,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(24.0),
                            bottomRight: Radius.circular(24.0),
                          ),
                          child: CustomPaint(
                            painter: SageWavePainter(isDark: isDark),
                          ),
                        ),
                      ),
                      
                      // Testo della card
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Morning Flow",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  "15 min",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: subTextColor,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Inizia la giornata con calma",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Sabbia",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: subTextColor,
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
              )).animate(target: isActive ? 1.0 : 0.0).fadeIn(delay: 450.ms, duration: 600.ms).scale(begin: const Offset(0.97, 0.97), end: const Offset(1, 1), curve: Curves.easeOutCubic),
              
              const SizedBox(height: 26),
              
              // 5. GRID DISCOVER & MINDFULNESS ROW (2 COLUMN LAYOUT)
              Row(
                children: [
                  Expanded(
                    child: _buildGridCard(
                      context: context,
                      title: "Scopri",
                      activity: "Focus",
                      time: "15 min",
                      desc: "Inizia il tuo cammino montano",
                      icon: Icons.landscape_outlined,
                      isDark: isDark,
                      accentColor: accentColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      onTap: () {
                        launchZenSession(
                          context: context,
                          ref: ref,
                          title: "Concentrazione",
                          voicePath: 'assets/audio/real/Meditazioni/Acqua/Meditazione del Mattino_Procedimento.m4a',
                          ambientPath: 'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione MATTINO.m4a',
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGridCard(
                      context: context,
                      title: "Consapevolezza",
                      activity: "Riposo",
                      time: "20 min",
                      desc: "Respira nel momento presente",
                      icon: Icons.nature_people_outlined,
                      isDark: isDark,
                      accentColor: accentColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      onTap: () {
                        launchZenSession(
                          context: context,
                          ref: ref,
                          title: "Riposo",
                          voicePath: 'assets/audio/real/Meditazioni/Acqua/Meditazione-del-Pomeriggio.m4a',
                          ambientPath: 'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione POMERIGGIO.m4a',
                        );
                      },
                    ),
                  ),
                ],
              ).animate(target: isActive ? 1.0 : 0.0).fadeIn(delay: 550.ms, duration: 600.ms),
              
              const SizedBox(height: 28),
              
              // 6. QUICK LIST SELECTIONS
              _buildListRow("Calm Mind", "10 min", isDark, textColor, subTextColor),
              _buildListRow("Stress Release", "20 min", isDark, textColor, subTextColor),
              _buildListRow("Deep Sleep", "30 min", isDark, textColor, subTextColor),
              _buildListRow("Present Awareness", "15 min", isDark, textColor, subTextColor),
              
              const SizedBox(height: 28),
              
              // 7. BEGIN YOUR SESSION PILL BUTTON WITH OUTLINE PLAY ICON
              Semantics(button: true, label: "Interactive element", child: GestureDetector(
                onTap: () {
                  launchZenSession(
                    context: context,
                    ref: ref,
                    title: settings.language == 0 ? "Present Awareness" : "Present Awareness",
                    voicePath: 'assets/audio/real/Meditazioni/Acqua/Meditazione-della-Sera.m4a',
                    ambientPath: 'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione SERA.m4a',
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF282E37).withOpacity(0.85) : const Color(0xFFF0EBE0).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: isDark ? accentColor.withOpacity(0.08) : accentColor.withOpacity(0.12),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.15 : 0.02),
                        blurRadius: 16,
                        spreadRadius: -2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 24), // Spacer per centrare il testo
                        Text(
                          "Inizia Sessione",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: textColor.withOpacity(0.9), width: 1.5),
                          ),
                          child: Icon(
                            Icons.play_arrow_outlined,
                            size: 20,
                            color: textColor.withOpacity(0.95),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )).animate(target: isActive ? 1.0 : 0.0).fadeIn(delay: 750.ms, duration: 600.ms),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Disegna una scheda Discover/Mindfulness a doppia riga
  Widget _buildGridCard({
    required BuildContext context,
    required String title,
    required String activity,
    required String time,
    required String desc,
    required IconData icon,
    required bool isDark,
    required Color accentColor,
    required Color textColor,
    required Color subTextColor,
    required VoidCallback onTap,
  }) {
    return Semantics(button: true, label: "Interactive element", child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: AppColors.japandiCardDecoration(isDark, borderRadius: 24.0, opacity: 0.65),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: subTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  icon,
                  size: 22,
                  color: accentColor.withOpacity(0.7),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      activity,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: subTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: subTextColor.withOpacity(0.85),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  /// Riga delle meditazioni veloci sotto la griglia
  Widget _buildListRow(String name, String time, bool isDark, Color textColor, Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                time,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: subTextColor.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 1.0,
            color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter per disegnare le onde di contorno salvia a mano libera, come da mockup
class SageWavePainter extends CustomPainter {
  final bool isDark;

  SageWavePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final waveColor = isDark 
        ? AppColors.goldAccent.withOpacity(0.18) 
        : AppColors.sageAccent.withOpacity(0.24);

    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.15);
    path1.cubicTo(size.width * 0.25, size.height * 0.05, size.width * 0.6, size.height * 0.45, size.width * 1.0, size.height * 0.42);
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.23);
    path2.cubicTo(size.width * 0.25, size.height * 0.13, size.width * 0.65, size.height * 0.53, size.width * 1.0, size.height * 0.5);
    canvas.drawPath(path2, paint);

    final path3 = Path();
    path3.moveTo(0, size.height * 0.31);
    path3.cubicTo(size.width * 0.25, size.height * 0.21, size.width * 0.7, size.height * 0.61, size.width * 1.0, size.height * 0.58);
    canvas.drawPath(path3, paint);

    final path4 = Path();
    path4.moveTo(0, size.height * 0.39);
    path4.cubicTo(size.width * 0.25, size.height * 0.29, size.width * 0.75, size.height * 0.69, size.width * 1.0, size.height * 0.66);
    canvas.drawPath(path4, paint);

    final path5 = Path();
    path5.moveTo(0, size.height * 0.47);
    path5.cubicTo(size.width * 0.25, size.height * 0.37, size.width * 0.8, size.height * 0.77, size.width * 1.0, size.height * 0.74);
    canvas.drawPath(path5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
