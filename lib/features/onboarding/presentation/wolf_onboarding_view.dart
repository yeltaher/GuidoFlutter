import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';

/// Schermata Onboarding del Lupo Guido: 5 schede interattive skippabili
/// con personaggio cartoon 3D stilizzato in estetica Japandi.
class WolfOnboardingView extends ConsumerStatefulWidget {
  const WolfOnboardingView({super.key});

  static const String prefKey = 'has_seen_wolf_onboarding';

  @override
  ConsumerState<WolfOnboardingView> createState() => _WolfOnboardingViewState();
}

class _WolfOnboardingViewState extends ConsumerState<WolfOnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  static const int _pageCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    HapticFeedback.mediumImpact();
    final prefs = ref.read(sharedPrefsProvider);
    if (prefs != null) {
      await prefs.setBool(WolfOnboardingView.prefKey, true);
    }
    if (!mounted) return;
    final isOnboarded = prefs?.getBool("IsOnboarded") ?? false;
    if (isOnboarded) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  void _nextPage() {
    if (_currentIndex < _pageCount - 1) {
      HapticFeedback.selectionClick();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // Sfondo Japandi a gradiente dinamico
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

          // Luce soffusa ambientale
          Positioned(
            top: 60,
            left: -40,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: isDark ? 0.09 : 0.14),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: const SizedBox.shrink(),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Barra superiore con pulsante "Salta"
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo Guido
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo_transparent.png',
                            height: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Guido",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      // Tasto Salta sempre visibile
                      Semantics(
                        button: true,
                        label: isIt ? "Salta introduzione" : "Skip introduction",
                        child: TextButton(
                          onPressed: _completeOnboarding,
                          style: TextButton.styleFrom(
                            foregroundColor: subTextColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            isIt ? "Salta" : "Skip",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: subTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Contenuto PageView con le 5 schede del Lupo
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Scheda 1: Benvenuto
                      _buildPageCard(
                        pageIndex: 0,
                        pose: WolfPose.greeting,
                        badge: isIt ? "BENVENUTO" : "WELCOME",
                        title: isIt
                            ? "Ciao! Sono Guido"
                            : "Hi! I am Guido",
                        subtitle: isIt
                            ? "Il tuo compagno saggio e premuroso per ritrovare equilibrio e quiete interiore."
                            : "Your mindful companion on the journey to inner calm and balance.",
                        isDark: isDark,
                        accentColor: accentColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
                      // Scheda 2: Esperienze VR
                      _buildPageCard(
                        pageIndex: 1,
                        pose: WolfPose.vrHeadset,
                        badge: isIt ? "IMMERSIONE TOTALE" : "FULL IMMERSION",
                        title: isIt
                            ? "Esperienze VR negli Elementi"
                            : "VR in the Elements",
                        subtitle: isIt
                            ? "Vivi meditazioni e respirazioni tridimensionali a 360° attraverso Acqua, Fuoco, Terra e Aria."
                            : "Experience 360° immersive journeys through Water, Fire, Earth, and Air.",
                        isDark: isDark,
                        accentColor: const Color(0xFF38BDF8),
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
                      // Scheda 3: Respirazione Consapevole
                      _buildPageCard(
                        pageIndex: 2,
                        pose: WolfPose.breathing,
                        badge: isIt ? "RITMO NATURALE" : "NATURAL RHYTHM",
                        title: isIt
                            ? "Respirazione Consapevole"
                            : "Mindful Breathing",
                        subtitle: isIt
                            ? "Lasciati guidare dal battito delle onde e dal soffio del vento per allentare lo stress in pochi minuti."
                            : "Follow the gentle flow of breath to melt stress and restore clarity in minutes.",
                        isDark: isDark,
                        accentColor: AppColors.sageAccent,
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
                      // Scheda 4: Diario Emotivo
                      _buildPageCard(
                        pageIndex: 3,
                        pose: WolfPose.journal,
                        badge: isIt ? "CONSAPEVOLEZZA" : "AWARENESS",
                        title: isIt
                            ? "Diario Emotivo Zen"
                            : "Zen Emotional Journal",
                        subtitle: isIt
                            ? "Ascolta il tuo cuore: annota il tuo stato d'animo e custodisci le tue riflessioni giorno dopo giorno."
                            : "Listen to your heart: record your mood and reflect on your daily emotional landscape.",
                        isDark: isDark,
                        accentColor: AppColors.goldAccent,
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
                      // Scheda 5: Pronto per iniziare?
                      _buildPageCard(
                        pageIndex: 4,
                        pose: WolfPose.ready,
                        badge: isIt ? "INIZIAMO" : "LET'S BEGIN",
                        title: isIt
                            ? "Pronto per iniziare?"
                            : "Ready to start?",
                        subtitle: isIt
                            ? "Mettiti comodo, indossa il visore o usa semplicemente lo smartphone. Il tuo viaggio comincia ora."
                            : "Make yourself comfortable, put on your headset or use your phone. Your journey begins now.",
                        isDark: isDark,
                        accentColor: AppColors.successAccent,
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
                    ],
                  ),
                ),

                // Indicatori a puntini e Pulsante Azione
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Puntini di progressione
                      Row(
                        children: List.generate(_pageCount, (index) {
                          final isActive = index == _currentIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            width: isActive ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? accentColor
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.2)
                                      : Colors.black.withValues(alpha: 0.15)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),

                      // Pulsante Avanti / Inizia
                      Semantics(
                        button: true,
                        label: _currentIndex == _pageCount - 1
                            ? (isIt ? "Inizia esperienza" : "Start experience")
                            : (isIt ? "Scheda successiva" : "Next slide"),
                        child: GestureDetector(
                          onTap: _nextPage,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 26,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: _currentIndex == _pageCount - 1
                                  ? AppColors.successAccent
                                  : accentColor,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: (_currentIndex == _pageCount - 1
                                          ? AppColors.successAccent
                                          : accentColor)
                                      .withValues(alpha: isDark ? 0.35 : 0.25),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _currentIndex == _pageCount - 1
                                      ? (isIt ? "Inizia" : "Start")
                                      : (isIt ? "Avanti" : "Next"),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  _currentIndex == _pageCount - 1
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageCard({
    required int pageIndex,
    required WolfPose pose,
    required String badge,
    required String title,
    required String subtitle,
    required bool isDark,
    required Color accentColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Personaggio Lupo Guido Cartoon 3D
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accentColor.withValues(alpha: isDark ? 0.18 : 0.22),
                      accentColor.withValues(alpha: 0.0),
                    ],
                  ),
                ),
                child: Center(
                  child: WolfCartoonWidget(
                    pose: pose,
                    accentColor: accentColor,
                    isDark: isDark,
                  ),
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .moveY(
                    begin: -5,
                    end: 5,
                    duration: 2400.ms,
                    curve: Curves.easeInOutSine,
                  ),

              const SizedBox(height: 24),

              // Badge Categoria
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.15 : 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Titolo Card
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  letterSpacing: -0.4,
                ),
              ),

              const SizedBox(height: 10),

              // Sottotitolo descrittivo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: subTextColor,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pose del Lupo Guido per le diverse schede
enum WolfPose {
  greeting,
  vrHeadset,
  breathing,
  journal,
  ready,
}

/// Widget cartoon 3D stilizzato Japandi per il Lupo Guido disegnato con CustomPainter
class WolfCartoonWidget extends StatelessWidget {
  final WolfPose pose;
  final Color accentColor;
  final bool isDark;

  const WolfCartoonWidget({
    super.key,
    required this.pose,
    required this.accentColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: _WolfCartoonPainter(
          pose: pose,
          accentColor: accentColor,
          isDark: isDark,
        ),
      ),
    );
  }
}

class _WolfCartoonPainter extends CustomPainter {
  final WolfPose pose;
  final Color accentColor;
  final bool isDark;

  _WolfCartoonPainter({
    required this.pose,
    required this.accentColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + size.height * 0.04);
    final radius = size.width * 0.40;

    // Palette Lupo Nordico / Artico (ispirata al logo ufficiale di Guido)
    final furCapDark =
        isDark ? const Color(0xFF2B3340) : const Color(0xFF334155);
    final furSlateDark =
        isDark ? const Color(0xFF3E4859) : const Color(0xFF475569);
    final furSilverMid =
        isDark ? const Color(0xFF64748B) : const Color(0xFF64748B);
    final furSilverLight =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFFCBD5E1);
    final furSnow =
        isDark ? const Color(0xFFE2E8F0) : const Color(0xFFF8FAFC);
    final furInnerEar =
        isDark ? const Color(0xFFCBD5E1) : const Color(0xFFF1F5F9);
    final noseColor = const Color(0xFF0F172A);
    final amberLight = const Color(0xFFFDE047);
    final amberMid = const Color(0xFFF59E0B);
    final amberDeep = const Color(0xFFB45309);

    // -------------------------------------------------------------------------
    // 1. CODA FOLTA DA LUPO ARTICO (dietro a sinistra con punta bianca/argento)
    // -------------------------------------------------------------------------
    final tailPath = Path()
      ..moveTo(center.dx - radius * 0.45, center.dy + radius * 0.95)
      ..cubicTo(
        center.dx - radius * 0.95,
        center.dy + radius * 0.92,
        center.dx - radius * 1.24,
        center.dy + radius * 0.48,
        center.dx - radius * 1.12,
        center.dy + radius * 0.05,
      )
      ..lineTo(center.dx - radius * 1.00, center.dy + radius * 0.16)
      ..lineTo(center.dx - radius * 0.96, center.dy + radius * 0.02)
      ..cubicTo(
        center.dx - radius * 0.80,
        center.dy + radius * 0.32,
        center.dx - radius * 0.72,
        center.dy + radius * 0.65,
        center.dx - radius * 0.35,
        center.dy + radius * 0.88,
      )
      ..close();

    final tailPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [furCapDark, furSilverMid, furSnow],
        stops: const [0.0, 0.62, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.2));
    canvas.drawPath(tailPath, tailPaint);

    // -------------------------------------------------------------------------
    // 2. SPALLE E COLLO DA LUPO + SCIARPA ZEN + PETTO FOLTO BIANCO A CIOCCHE
    // -------------------------------------------------------------------------
    final torsoPath = Path()
      ..moveTo(center.dx - radius * 0.56, center.dy + radius * 0.62)
      ..lineTo(center.dx - radius * 0.74, center.dy + radius * 1.15)
      ..quadraticBezierTo(
        center.dx,
        center.dy + radius * 1.28,
        center.dx + radius * 0.74,
        center.dy + radius * 1.15,
      )
      ..lineTo(center.dx + radius * 0.56, center.dy + radius * 0.62)
      ..close();

    final torsoPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [furSlateDark, furCapDark],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.2));
    canvas.drawPath(torsoPath, torsoPaint);

    // Sciarpa Zen al collo
    final scarfPaint = Paint()..color = accentColor;
    final scarfPath = Path()
      ..moveTo(center.dx - radius * 0.66, center.dy + radius * 0.74)
      ..quadraticBezierTo(
        center.dx,
        center.dy + radius * 0.98,
        center.dx + radius * 0.66,
        center.dy + radius * 0.74,
      )
      ..lineTo(center.dx + radius * 0.60, center.dy + radius * 1.04)
      ..quadraticBezierTo(
        center.dx,
        center.dy + radius * 1.20,
        center.dx - radius * 0.60,
        center.dy + radius * 1.04,
      )
      ..close();
    canvas.drawPath(scarfPath, scarfPaint);

    // Ciuffo pettorale folto bianco/argento a punte (tipico del lupo)
    final chestTuftPath = Path()
      ..moveTo(center.dx - radius * 0.34, center.dy + radius * 0.66)
      ..lineTo(center.dx - radius * 0.24, center.dy + radius * 0.96)
      ..lineTo(center.dx - radius * 0.12, center.dy + radius * 0.84)
      ..lineTo(center.dx, center.dy + radius * 1.06)
      ..lineTo(center.dx + radius * 0.12, center.dy + radius * 0.84)
      ..lineTo(center.dx + radius * 0.24, center.dy + radius * 0.96)
      ..lineTo(center.dx + radius * 0.34, center.dy + radius * 0.66)
      ..close();
    canvas.drawPath(chestTuftPath, Paint()..color = furSnow);

    // -------------------------------------------------------------------------
    // 3. ORECCHIE ALTE, APPUNTITE E TRIANGOLARI DA LUPO
    // -------------------------------------------------------------------------
    final leftEarOuter = Path()
      ..moveTo(center.dx - radius * 0.66, center.dy - radius * 0.34)
      ..lineTo(center.dx - radius * 0.82, center.dy - radius * 1.18)
      ..lineTo(center.dx - radius * 0.20, center.dy - radius * 0.66)
      ..close();

    final rightEarOuter = Path()
      ..moveTo(center.dx + radius * 0.66, center.dy - radius * 0.34)
      ..lineTo(center.dx + radius * 0.82, center.dy - radius * 1.18)
      ..lineTo(center.dx + radius * 0.20, center.dy - radius * 0.66)
      ..close();

    final earOuterPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [furCapDark, furSlateDark],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.2));

    canvas.drawPath(leftEarOuter, earOuterPaint);
    canvas.drawPath(rightEarOuter, earOuterPaint);

    // Peluria interna chiara delle orecchie (argento/crema con ciocche)
    final leftEarInner = Path()
      ..moveTo(center.dx - radius * 0.58, center.dy - radius * 0.42)
      ..lineTo(center.dx - radius * 0.73, center.dy - radius * 1.04)
      ..lineTo(center.dx - radius * 0.30, center.dy - radius * 0.64)
      ..close();

    final rightEarInner = Path()
      ..moveTo(center.dx + radius * 0.58, center.dy - radius * 0.42)
      ..lineTo(center.dx + radius * 0.73, center.dy - radius * 1.04)
      ..lineTo(center.dx + radius * 0.30, center.dy - radius * 0.64)
      ..close();

    canvas.drawPath(leftEarInner, Paint()..color = furInnerEar);
    canvas.drawPath(rightEarInner, Paint()..color = furInnerEar);

    // -------------------------------------------------------------------------
    // 4. CRANIO SCOLPITO E FOLTA CRINIERA LATERALE A CIOCCHE APPUNTITE (CHEEK RUFF)
    // -------------------------------------------------------------------------
    final wolfHeadPath = Path()
      // Sommità cranica tra le orecchie
      ..moveTo(center.dx - radius * 0.28, center.dy - radius * 0.72)
      ..quadraticBezierTo(
        center.dx,
        center.dy - radius * 0.80,
        center.dx + radius * 0.28,
        center.dy - radius * 0.72,
      )
      // Lato destro superiore verso lo zigomo
      ..lineTo(center.dx + radius * 0.68, center.dy - radius * 0.42)
      ..lineTo(center.dx + radius * 0.82, center.dy - radius * 0.14)
      // Criniera laterale destra: 3 ciocche appuntite da lupo
      ..lineTo(center.dx + radius * 1.12, center.dy - radius * 0.02)
      ..lineTo(center.dx + radius * 0.90, center.dy + radius * 0.08)
      ..lineTo(center.dx + radius * 1.18, center.dy + radius * 0.22)
      ..lineTo(center.dx + radius * 0.90, center.dy + radius * 0.30)
      ..lineTo(center.dx + radius * 1.04, center.dy + radius * 0.44)
      // Mascella inferiore che converge verso il muso affusolato
      ..lineTo(center.dx + radius * 0.46, center.dy + radius * 0.62)
      ..quadraticBezierTo(
        center.dx,
        center.dy + radius * 0.78,
        center.dx - radius * 0.46,
        center.dy + radius * 0.62,
      )
      // Criniera laterale sinistra: 3 ciocche appuntite simmetriche
      ..lineTo(center.dx - radius * 1.04, center.dy + radius * 0.44)
      ..lineTo(center.dx - radius * 0.90, center.dy + radius * 0.30)
      ..lineTo(center.dx - radius * 1.18, center.dy + radius * 0.22)
      ..lineTo(center.dx - radius * 0.90, center.dy + radius * 0.08)
      ..lineTo(center.dx - radius * 1.12, center.dy - radius * 0.02)
      ..lineTo(center.dx - radius * 0.82, center.dy - radius * 0.14)
      ..lineTo(center.dx - radius * 0.68, center.dy - radius * 0.42)
      ..close();

    final headBasePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [furCapDark, furSlateDark, furSilverMid],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.15));

    canvas.drawPath(wolfHeadPath, headBasePaint);

    // -------------------------------------------------------------------------
    // 5. MASCHERA FACCIALE BIANCO ARTICO E CALOTTA FRONTALE A "V" DA LUPO
    // -------------------------------------------------------------------------
    // Maschera chiara che avvolge guance inferiori, lati del muso e arcate sopraccigliari
    final lightMaskPath = Path()
      // Punta centrale tra le sopracciglia (sotto la V scura)
      ..moveTo(center.dx, center.dy + radius * 0.06)
      // Arcata sopraccigliare sinistra
      ..cubicTo(
        center.dx - radius * 0.14,
        center.dy - radius * 0.24,
        center.dx - radius * 0.48,
        center.dy - radius * 0.28,
        center.dx - radius * 0.68,
        center.dy - radius * 0.04,
      )
      // Ciocche chiare sulle guance sinistre
      ..lineTo(center.dx - radius * 0.96, center.dy + radius * 0.18)
      ..lineTo(center.dx - radius * 0.78, center.dy + radius * 0.26)
      ..lineTo(center.dx - radius * 0.88, center.dy + radius * 0.39)
      ..lineTo(center.dx - radius * 0.42, center.dy + radius * 0.58)
      // Mento e mandibola inferiore
      ..quadraticBezierTo(
        center.dx,
        center.dy + radius * 0.76,
        center.dx + radius * 0.42,
        center.dy + radius * 0.58,
      )
      // Ciocche chiare sulle guance destre
      ..lineTo(center.dx + radius * 0.88, center.dy + radius * 0.39)
      ..lineTo(center.dx + radius * 0.78, center.dy + radius * 0.26)
      ..lineTo(center.dx + radius * 0.96, center.dy + radius * 0.18)
      ..lineTo(center.dx + radius * 0.68, center.dy - radius * 0.04)
      // Arcata sopraccigliare destra che torna alla V centrale
      ..cubicTo(
        center.dx + radius * 0.48,
        center.dy - radius * 0.28,
        center.dx + radius * 0.14,
        center.dy - radius * 0.24,
        center.dx,
        center.dy + radius * 0.06,
      )
      ..close();

    final maskPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [furSnow, furInnerEar],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawPath(lightMaskPath, maskPaint);

    // Calotta frontale scura a "V" (Widow's peak) che scende sul ponte nasale
    final foreheadVPath = Path()
      ..moveTo(center.dx - radius * 0.36, center.dy - radius * 0.68)
      ..quadraticBezierTo(
        center.dx,
        center.dy - radius * 0.76,
        center.dx + radius * 0.36,
        center.dy - radius * 0.68,
      )
      ..lineTo(center.dx + radius * 0.22, center.dy - radius * 0.26)
      ..lineTo(center.dx, center.dy + radius * 0.12)
      ..lineTo(center.dx - radius * 0.22, center.dy - radius * 0.26)
      ..close();

    canvas.drawPath(
      foreheadVPath,
      Paint()..color = furCapDark.withValues(alpha: 0.92),
    );

    // -------------------------------------------------------------------------
    // 6. MUSO ALLUNGATO E AFFUSOLATO DA LUPO + PONTE NASALE DRITTO + TARTUFO
    // -------------------------------------------------------------------------
    final snoutWedgePath = Path()
      ..moveTo(center.dx - radius * 0.18, center.dy - radius * 0.08)
      ..lineTo(center.dx - radius * 0.32, center.dy + radius * 0.34)
      ..quadraticBezierTo(
        center.dx,
        center.dy + radius * 0.66,
        center.dx + radius * 0.32,
        center.dy + radius * 0.34,
      )
      ..lineTo(center.dx + radius * 0.18, center.dy - radius * 0.08)
      ..close();

    canvas.drawPath(
      snoutWedgePath,
      Paint()..color = Colors.white.withValues(alpha: isDark ? 0.92 : 0.98),
    );

    // Ponte nasale dorsale dritto e scolpito (canna nasale grigio-argento)
    final nasalBridgePath = Path()
      ..moveTo(center.dx - radius * 0.11, center.dy - radius * 0.14)
      ..lineTo(center.dx + radius * 0.11, center.dy - radius * 0.14)
      ..lineTo(center.dx + radius * 0.15, center.dy + radius * 0.28)
      ..lineTo(center.dx - radius * 0.15, center.dy + radius * 0.28)
      ..close();

    final nasalBridgePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [furSlateDark, furSilverLight],
      ).createShader(
        Rect.fromLTWH(
          center.dx - radius * 0.16,
          center.dy - radius * 0.14,
          radius * 0.32,
          radius * 0.44,
        ),
      );
    canvas.drawPath(nasalBridgePath, nasalBridgePaint);

    // Tartufo nero triangolare/poligonale da lupo
    final noseCenter = Offset(center.dx, center.dy + radius * 0.31);
    final nosePath = Path()
      ..moveTo(noseCenter.dx - radius * 0.17, noseCenter.dy - radius * 0.06)
      ..quadraticBezierTo(
        noseCenter.dx,
        noseCenter.dy - radius * 0.11,
        noseCenter.dx + radius * 0.17,
        noseCenter.dy - radius * 0.06,
      )
      ..lineTo(noseCenter.dx + radius * 0.13, noseCenter.dy + radius * 0.04)
      ..lineTo(noseCenter.dx, noseCenter.dy + radius * 0.13)
      ..lineTo(noseCenter.dx - radius * 0.13, noseCenter.dy + radius * 0.04)
      ..close();

    canvas.drawPath(nosePath, Paint()..color = noseColor);

    // Riflesso nitido sul tartufo
    final noseHighlight = Path()
      ..moveTo(noseCenter.dx - radius * 0.10, noseCenter.dy - radius * 0.05)
      ..lineTo(noseCenter.dx + radius * 0.06, noseCenter.dy - radius * 0.05)
      ..lineTo(noseCenter.dx - radius * 0.02, noseCenter.dy - radius * 0.01)
      ..close();
    canvas.drawPath(
      noseHighlight,
      Paint()..color = Colors.white.withValues(alpha: 0.45),
    );

    // Rima labiale fiera e composta da lupo (senza blush rosa)
    final muzzleLinePaint = Paint()
      ..color = noseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final mouthPath = Path()
      ..moveTo(noseCenter.dx, noseCenter.dy + radius * 0.12)
      ..lineTo(noseCenter.dx, noseCenter.dy + radius * 0.21)
      ..moveTo(noseCenter.dx - radius * 0.20, noseCenter.dy + radius * 0.25)
      ..quadraticBezierTo(
        noseCenter.dx - radius * 0.09,
        noseCenter.dy + radius * 0.29,
        noseCenter.dx,
        noseCenter.dy + radius * 0.21,
      )
      ..quadraticBezierTo(
        noseCenter.dx + radius * 0.09,
        noseCenter.dy + radius * 0.29,
        noseCenter.dx + radius * 0.20,
        noseCenter.dy + radius * 0.25,
      );
    canvas.drawPath(mouthPath, muzzleLinePaint);

    // -------------------------------------------------------------------------
    // 7. OCCHI DA LUPO A MANDORLA OBLIQUI COLOR AMBRA / ORO INTENSO
    // -------------------------------------------------------------------------
    final leftEyeCenter =
        Offset(center.dx - radius * 0.34, center.dy - radius * 0.07);
    final rightEyeCenter =
        Offset(center.dx + radius * 0.34, center.dy - radius * 0.07);

    if (pose == WolfPose.breathing) {
      // Occhi chiusi in concentrazione zen con taglio obliquo da lupo
      final closedEyePaint = Paint()
        ..color = noseColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      final leftClosed = Path()
        ..moveTo(leftEyeCenter.dx - radius * 0.15, leftEyeCenter.dy - radius * 0.05)
        ..quadraticBezierTo(
          leftEyeCenter.dx,
          leftEyeCenter.dy + radius * 0.05,
          leftEyeCenter.dx + radius * 0.14,
          leftEyeCenter.dy + radius * 0.02,
        );
      final rightClosed = Path()
        ..moveTo(rightEyeCenter.dx - radius * 0.14, rightEyeCenter.dy + radius * 0.02)
        ..quadraticBezierTo(
          rightEyeCenter.dx,
          rightEyeCenter.dy + radius * 0.05,
          rightEyeCenter.dx + radius * 0.15,
          rightEyeCenter.dy - radius * 0.05,
        );
      canvas.drawPath(leftClosed, closedEyePaint);
      canvas.drawPath(rightClosed, closedEyePaint);
    } else {
      _drawWolfEye(
        canvas: canvas,
        eyeCenter: leftEyeCenter,
        radius: radius,
        isLeft: true,
        outlineColor: noseColor,
        amberLight: amberLight,
        amberMid: amberMid,
        amberDeep: amberDeep,
      );
      _drawWolfEye(
        canvas: canvas,
        eyeCenter: rightEyeCenter,
        radius: radius,
        isLeft: false,
        outlineColor: noseColor,
        amberLight: amberLight,
        amberMid: amberMid,
        amberDeep: amberDeep,
      );
    }

    // Arcate sopraccigliari fiere bianco ghiaccio sopra gli occhi
    final browPaint = Paint()
      ..color = furSnow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    final leftBrow = Path()
      ..moveTo(leftEyeCenter.dx - radius * 0.16, leftEyeCenter.dy - radius * 0.13)
      ..lineTo(leftEyeCenter.dx + radius * 0.13, leftEyeCenter.dy - radius * 0.06);
    final rightBrow = Path()
      ..moveTo(rightEyeCenter.dx - radius * 0.13, rightEyeCenter.dy - radius * 0.06)
      ..lineTo(rightEyeCenter.dx + radius * 0.16, rightEyeCenter.dy - radius * 0.13);
    canvas.drawPath(leftBrow, browPaint);
    canvas.drawPath(rightBrow, browPaint);

    // -------------------------------------------------------------------------
    // 8. ACCESSORI SPECIFICI PER LE 5 POSE DELL'ONBOARDING
    // -------------------------------------------------------------------------
    switch (pose) {
      case WolfPose.greeting:
        // Zampa anteriore da lupo sollevata in segno di benvenuto (con cuscinetti ardesia)
        final pawCenter =
            Offset(center.dx + radius * 0.94, center.dy - radius * 0.04);
        canvas.drawCircle(pawCenter, 14, Paint()..color = furSnow);
        canvas.drawCircle(
          pawCenter,
          14,
          Paint()
            ..color = furSlateDark
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0,
        );
        final padPaint = Paint()..color = furCapDark;
        canvas.drawCircle(Offset(pawCenter.dx, pawCenter.dy + 2), 5.2, padPaint);
        canvas.drawCircle(
          Offset(pawCenter.dx - 5.5, pawCenter.dy - 5.5),
          2.4,
          padPaint,
        );
        canvas.drawCircle(
          Offset(pawCenter.dx, pawCenter.dy - 7.5),
          2.4,
          padPaint,
        );
        canvas.drawCircle(
          Offset(pawCenter.dx + 5.5, pawCenter.dy - 5.5),
          2.4,
          padPaint,
        );
        break;

      case WolfPose.vrHeadset:
        // Visore VR elegante sollevato sulla fronte del lupo
        final headsetPaint = Paint()..color = const Color(0xFF1E293B);
        final vrRect = Rect.fromCenter(
          center: Offset(center.dx, center.dy - radius * 0.44),
          width: radius * 1.22,
          height: radius * 0.42,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(vrRect, const Radius.circular(12)),
          headsetPaint,
        );
        final visorPaint = Paint()..color = const Color(0xFF06B6D4);
        final visorRect = Rect.fromCenter(
          center: Offset(center.dx, center.dy - radius * 0.44),
          width: radius * 0.94,
          height: radius * 0.24,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(visorRect, const Radius.circular(8)),
          visorPaint,
        );
        final strapPaint = Paint()
          ..color = const Color(0xFF334155)
          ..strokeWidth = 4.5
          ..style = PaintingStyle.stroke;
        canvas.drawLine(
          Offset(center.dx - radius * 0.61, center.dy - radius * 0.44),
          Offset(center.dx - radius * 0.84, center.dy - radius * 0.34),
          strapPaint,
        );
        canvas.drawLine(
          Offset(center.dx + radius * 0.61, center.dy - radius * 0.44),
          Offset(center.dx + radius * 0.84, center.dy - radius * 0.34),
          strapPaint,
        );
        break;

      case WolfPose.breathing:
        // Onde armoniche di respiro consapevole
        final wavePaint = Paint()
          ..color = accentColor.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;
        for (int i = 0; i < 3; i++) {
          final wavePath = Path()
            ..moveTo(center.dx - 22, center.dy + radius * 0.54 + (i * 8))
            ..quadraticBezierTo(
              center.dx,
              center.dy + radius * 0.48 + (i * 8),
              center.dx + 22,
              center.dy + radius * 0.54 + (i * 8),
            );
          canvas.drawPath(wavePath, wavePaint);
        }
        break;

      case WolfPose.journal:
        // Taccuino del diario zen
        final bookPaint = Paint()..color = const Color(0xFFD97706);
        final bookRect = Rect.fromCenter(
          center: Offset(center.dx + radius * 0.76, center.dy + radius * 0.48),
          width: 32,
          height: 38,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(bookRect, const Radius.circular(6)),
          bookPaint,
        );
        final pagePaint = Paint()..color = Colors.white;
        canvas.drawRect(
          Rect.fromLTWH(bookRect.left + 4, bookRect.top + 4, 10, 30),
          pagePaint,
        );
        canvas.drawRect(
          Rect.fromLTWH(bookRect.left + 16, bookRect.top + 4, 12, 30),
          pagePaint,
        );
        break;

      case WolfPose.ready:
        // Stelline zen dorate attorno al lupo
        final starPaint = Paint()..color = AppColors.goldAccent;
        _drawStar(
          canvas,
          Offset(center.dx - radius * 0.88, center.dy - radius * 0.74),
          6,
          starPaint,
        );
        _drawStar(
          canvas,
          Offset(center.dx + radius * 0.88, center.dy - radius * 0.74),
          7,
          starPaint,
        );
        _drawStar(
          canvas,
          Offset(center.dx + radius * 1.02, center.dy + radius * 0.08),
          5,
          starPaint,
        );
        break;
    }
  }

  /// Disegna un occhio da lupo a mandorla obliquo con iride ambra/oro e pupilla nitida
  void _drawWolfEye({
    required Canvas canvas,
    required Offset eyeCenter,
    required double radius,
    required bool isLeft,
    required Color outlineColor,
    required Color amberLight,
    required Color amberMid,
    required Color amberDeep,
  }) {
    final double dir = isLeft ? 1.0 : -1.0;
    final double w = radius * 0.17;
    final double h = radius * 0.10;

    // Forma a mandorla obliqua tipica del lupo (angolo esterno più alto, angolo interno più basso)
    final almondPath = Path()
      ..moveTo(eyeCenter.dx - dir * w, eyeCenter.dy - h * 0.45)
      ..quadraticBezierTo(
        eyeCenter.dx,
        eyeCenter.dy - h * 1.15,
        eyeCenter.dx + dir * w,
        eyeCenter.dy + h * 0.35,
      )
      ..quadraticBezierTo(
        eyeCenter.dx,
        eyeCenter.dy + h * 1.10,
        eyeCenter.dx - dir * w,
        eyeCenter.dy - h * 0.45,
      )
      ..close();

    // Contorno esterno scuro (eyeliner naturale da lupo)
    canvas.drawPath(
      almondPath,
      Paint()
        ..color = outlineColor
        ..style = PaintingStyle.fill,
    );

    canvas.save();
    canvas.clipPath(almondPath);

    // Iride ambra / oro magnetico
    final irisRadius = radius * 0.115;
    final irisPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.2),
        colors: [amberLight, amberMid, amberDeep],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: eyeCenter, radius: irisRadius));
    canvas.drawCircle(eyeCenter, irisRadius, irisPaint);

    // Pupilla scura nitida
    canvas.drawCircle(
      eyeCenter,
      radius * 0.052,
      Paint()..color = outlineColor,
    );

    // Riflesso cristallino di luce
    canvas.drawCircle(
      Offset(eyeCenter.dx - radius * 0.028, eyeCenter.dy - radius * 0.028),
      radius * 0.024,
      Paint()..color = Colors.white,
    );

    canvas.restore();

    // Bordo superiore marcato per lo sguardo fiero
    canvas.drawPath(
      almondPath,
      Paint()
        ..color = outlineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final double angle = -math.pi / 2 + (i * 4 * math.pi / 5);
      final x = center.dx + size * math.cos(angle);
      final y = center.dy + size * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WolfCartoonPainter oldDelegate) {
    return oldDelegate.pose != pose ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.isDark != isDark;
  }
}
