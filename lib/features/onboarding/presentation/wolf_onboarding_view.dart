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
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    // Palette Japandi per Guido
    final furDark = isDark ? const Color(0xFF4A4E5A) : const Color(0xFF6B7280);
    final furMid = isDark ? const Color(0xFF636A7A) : const Color(0xFF94A3B8);
    final furLight = isDark ? const Color(0xFF9CA3AF) : const Color(0xFFE2E8F0);
    final innerEarColor = const Color(0xFFFDA4AF);
    final scarfColor = accentColor;
    final noseColor = const Color(0xFF1E293B);

    // 1. Orecchie morbide da lupetto
    final leftEarPath = Path()
      ..moveTo(center.dx - radius * 0.7, center.dy - radius * 0.2)
      ..lineTo(center.dx - radius * 0.85, center.dy - radius * 0.95)
      ..quadraticBezierTo(
        center.dx - radius * 0.65,
        center.dy - radius * 0.85,
        center.dx - radius * 0.25,
        center.dy - radius * 0.6,
      )
      ..close();

    final rightEarPath = Path()
      ..moveTo(center.dx + radius * 0.7, center.dy - radius * 0.2)
      ..lineTo(center.dx + radius * 0.85, center.dy - radius * 0.95)
      ..quadraticBezierTo(
        center.dx + radius * 0.65,
        center.dy - radius * 0.85,
        center.dx + radius * 0.25,
        center.dy - radius * 0.6,
      )
      ..close();

    final earPaint = Paint()
      ..shader = LinearGradient(
        colors: [furDark, furMid],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(leftEarPath, earPaint);
    canvas.drawPath(rightEarPath, earPaint);

    // Interno orecchie (rosa tenue)
    final innerLeftEar = Path()
      ..moveTo(center.dx - radius * 0.62, center.dy - radius * 0.25)
      ..lineTo(center.dx - radius * 0.78, center.dy - radius * 0.85)
      ..lineTo(center.dx - radius * 0.32, center.dy - radius * 0.55)
      ..close();

    final innerRightEar = Path()
      ..moveTo(center.dx + radius * 0.62, center.dy - radius * 0.25)
      ..lineTo(center.dx + radius * 0.78, center.dy - radius * 0.85)
      ..lineTo(center.dx + radius * 0.32, center.dy - radius * 0.55)
      ..close();

    final innerEarPaint = Paint()
      ..color = innerEarColor.withValues(alpha: 0.75);
    canvas.drawPath(innerLeftEar, innerEarPaint);
    canvas.drawPath(innerRightEar, innerEarPaint);

    // 2. Testa morbida circolare con sfumatura 3D
    final headPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        colors: [furLight, furMid, furDark],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, headPaint);

    // Guance soffici laterali (ciuffetti di pelo da cartoon)
    final cheekLeftFluff = Path()
      ..moveTo(center.dx - radius * 0.88, center.dy)
      ..lineTo(center.dx - radius * 1.08, center.dy + radius * 0.15)
      ..lineTo(center.dx - radius * 0.82, center.dy + radius * 0.28)
      ..close();
    final cheekRightFluff = Path()
      ..moveTo(center.dx + radius * 0.88, center.dy)
      ..lineTo(center.dx + radius * 1.08, center.dy + radius * 0.15)
      ..lineTo(center.dx + radius * 0.82, center.dy + radius * 0.28)
      ..close();
    canvas.drawPath(cheekLeftFluff, headPaint);
    canvas.drawPath(cheekRightFluff, headPaint);

    // 3. Mascherina / Musetto bianco caldo
    final muzzleCenter = Offset(center.dx, center.dy + radius * 0.28);
    final muzzlePaint = Paint()
      ..color = isDark ? const Color(0xFFF1F5F9) : const Color(0xFFFFFFFF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: muzzleCenter,
          width: radius * 1.15,
          height: radius * 0.75,
        ),
        Radius.circular(radius * 0.4),
      ),
      muzzlePaint,
    );

    // Nasino triangolare arrotondato nero lucido
    final nosePath = Path()
      ..moveTo(muzzleCenter.dx - 12, muzzleCenter.dy - 12)
      ..lineTo(muzzleCenter.dx + 12, muzzleCenter.dy - 12)
      ..quadraticBezierTo(
        muzzleCenter.dx,
        muzzleCenter.dy + 4,
        muzzleCenter.dx - 12,
        muzzleCenter.dy - 12,
      );
    final nosePaint = Paint()..color = noseColor;
    canvas.drawPath(nosePath, nosePaint);

    // Punto luce sul nasino
    canvas.drawCircle(
      Offset(muzzleCenter.dx - 3, muzzleCenter.dy - 9),
      2.5,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );

    // Sorriso sereno
    final smilePaint = Paint()
      ..color = noseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final mouthPath = Path()
      ..moveTo(muzzleCenter.dx - 10, muzzleCenter.dy + 8)
      ..quadraticBezierTo(
        muzzleCenter.dx,
        muzzleCenter.dy + 16,
        muzzleCenter.dx + 10,
        muzzleCenter.dy + 8,
      );
    canvas.drawPath(mouthPath, smilePaint);

    // Rossore carino sulle guance (Blush)
    final blushPaint = Paint()
      ..color = const Color(0xFFF43F5E).withValues(alpha: 0.25);
    canvas.drawCircle(
      Offset(center.dx - radius * 0.58, center.dy + radius * 0.18),
      10,
      blushPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.58, center.dy + radius * 0.18),
      10,
      blushPaint,
    );

    // 4. Occhi in base alla posa
    if (pose == WolfPose.breathing) {
      // Occhi chiusi in meditazione serena (due archi felici)
      final eyeArcPaint = Paint()
        ..color = noseColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2
        ..strokeCap = StrokeCap.round;

      final leftEyePath = Path()
        ..moveTo(center.dx - radius * 0.42, center.dy - radius * 0.08)
        ..quadraticBezierTo(
          center.dx - radius * 0.30,
          center.dy - radius * 0.22,
          center.dx - radius * 0.18,
          center.dy - radius * 0.08,
        );
      final rightEyePath = Path()
        ..moveTo(center.dx + radius * 0.18, center.dy - radius * 0.08)
        ..quadraticBezierTo(
          center.dx + radius * 0.30,
          center.dy - radius * 0.22,
          center.dx + radius * 0.42,
          center.dy - radius * 0.08,
        );
      canvas.drawPath(leftEyePath, eyeArcPaint);
      canvas.drawPath(rightEyePath, eyeArcPaint);
    } else {
      // Occhi aperti cartoon vivaci con riflesso
      final eyeCenterLeft =
          Offset(center.dx - radius * 0.30, center.dy - radius * 0.1);
      final eyeCenterRight =
          Offset(center.dx + radius * 0.30, center.dy - radius * 0.1);

      final eyePaint = Paint()..color = noseColor;
      canvas.drawCircle(eyeCenterLeft, 8.5, eyePaint);
      canvas.drawCircle(eyeCenterRight, 8.5, eyePaint);

      // Riflessi di luce kawaii negli occhi
      final glintPaint = Paint()..color = Colors.white;
      canvas.drawCircle(
        Offset(eyeCenterLeft.dx - 2.5, eyeCenterLeft.dy - 2.5),
        3.0,
        glintPaint,
      );
      canvas.drawCircle(
        Offset(eyeCenterLeft.dx + 2.5, eyeCenterLeft.dy + 2.5),
        1.5,
        glintPaint,
      );

      canvas.drawCircle(
        Offset(eyeCenterRight.dx - 2.5, eyeCenterRight.dy - 2.5),
        3.0,
        glintPaint,
      );
      canvas.drawCircle(
        Offset(eyeCenterRight.dx + 2.5, eyeCenterRight.dy + 2.5),
        1.5,
        glintPaint,
      );
    }

    // 5. Bandana / Sciarpa Zen al collo
    final scarfPaint = Paint()..color = scarfColor;
    final scarfPath = Path()
      ..moveTo(center.dx - radius * 0.75, center.dy + radius * 0.85)
      ..quadraticBezierTo(
        center.dx,
        center.dy + radius * 1.15,
        center.dx + radius * 0.75,
        center.dy + radius * 0.85,
      )
      ..lineTo(center.dx + radius * 0.65, center.dy + radius * 1.18)
      ..quadraticBezierTo(
        center.dx,
        center.dy + radius * 1.35,
        center.dx - radius * 0.65,
        center.dy + radius * 1.18,
      )
      ..close();
    canvas.drawPath(scarfPath, scarfPaint);

    // 6. Accessori specifici per posa
    switch (pose) {
      case WolfPose.greeting:
        // Zampina sollevata che saluta
        final pawPaint = Paint()..color = furMid;
        final pawCenter =
            Offset(center.dx + radius * 0.95, center.dy - radius * 0.05);
        canvas.drawCircle(pawCenter, 14, pawPaint);
        // Cuscinetti rosa
        final padPaint = Paint()..color = innerEarColor;
        canvas.drawCircle(pawCenter, 6, padPaint);
        canvas.drawCircle(
          Offset(pawCenter.dx - 5, pawCenter.dy - 7),
          2.5,
          padPaint,
        );
        canvas.drawCircle(
          Offset(pawCenter.dx, pawCenter.dy - 9),
          2.5,
          padPaint,
        );
        canvas.drawCircle(
          Offset(pawCenter.dx + 5, pawCenter.dy - 7),
          2.5,
          padPaint,
        );
        break;

      case WolfPose.vrHeadset:
        // Visore VR elegante sollevato sulla fronte di Guido
        final headsetPaint = Paint()..color = const Color(0xFF1E293B);
        final vrRect = Rect.fromCenter(
          center: Offset(center.dx, center.dy - radius * 0.42),
          width: radius * 1.25,
          height: radius * 0.46,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(vrRect, const Radius.circular(12)),
          headsetPaint,
        );
        // Lenti e visiera luminosa ciano
        final visorPaint = Paint()..color = const Color(0xFF06B6D4);
        final visorRect = Rect.fromCenter(
          center: Offset(center.dx, center.dy - radius * 0.42),
          width: radius * 0.95,
          height: radius * 0.26,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(visorRect, const Radius.circular(8)),
          visorPaint,
        );
        // Cinturino VR laterale
        final strapPaint = Paint()
          ..color = const Color(0xFF334155)
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke;
        canvas.drawLine(
          Offset(center.dx - radius * 0.62, center.dy - radius * 0.42),
          Offset(center.dx - radius * 0.88, center.dy - radius * 0.32),
          strapPaint,
        );
        canvas.drawLine(
          Offset(center.dx + radius * 0.62, center.dy - radius * 0.42),
          Offset(center.dx + radius * 0.88, center.dy - radius * 0.32),
          strapPaint,
        );
        break;

      case WolfPose.breathing:
        // Onde di respiro / soffio zen dorate/verdi
        final wavePaint = Paint()
          ..color = accentColor.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;
        for (int i = 0; i < 3; i++) {
          final wavePath = Path()
            ..moveTo(center.dx - 20, center.dy + radius * 0.45 + (i * 9))
            ..quadraticBezierTo(
              center.dx,
              center.dy + radius * 0.40 + (i * 9),
              center.dx + 20,
              center.dy + radius * 0.45 + (i * 9),
            );
          canvas.drawPath(wavePath, wavePaint);
        }
        break;

      case WolfPose.journal:
        // Taccuino del diario zen con cuoricino
        final bookPaint = Paint()..color = const Color(0xFFD97706);
        final bookRect = Rect.fromCenter(
          center: Offset(center.dx + radius * 0.72, center.dy + radius * 0.45),
          width: 32,
          height: 38,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(bookRect, const Radius.circular(6)),
          bookPaint,
        );
        // Pagine bianche
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
        // Aureola / stelline zen dorate
        final starPaint = Paint()..color = AppColors.goldAccent;
        _drawStar(canvas, Offset(center.dx - radius * 0.8, center.dy - radius * 0.7), 6, starPaint);
        _drawStar(canvas, Offset(center.dx + radius * 0.8, center.dy - radius * 0.7), 7, starPaint);
        _drawStar(canvas, Offset(center.dx + radius * 0.95, center.dy + radius * 0.1), 5, starPaint);
        break;
    }
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
