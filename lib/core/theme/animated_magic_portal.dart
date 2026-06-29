import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/settings_provider.dart';
import 'app_theme.dart';

/// Modello di particella per i petali di ciliegio cadenti (Cherry Blossom Petals)
class ZenPetal {
  double x; // Coordinata X relativa (0.0 - 1.0)
  double y; // Coordinata Y relativa (0.0 - 1.0)
  double size; // Dimensione media in pixel
  double speed; // Velocità di discesa dolcissima
  double baseOpacity; // Opacità di base
  double swaySpeed; // Velocità di oscillazione laterale
  double swayWidth; // Ampiezza di oscillazione
  double rotationSpeed; // Velocità di rotazione sul proprio asse
  double seed; // Seme casuale per l'asincronia

  ZenPetal({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.baseOpacity,
    required this.swaySpeed,
    required this.swayWidth,
    required this.rotationSpeed,
    required this.seed,
  });
}

/// Portale Magico Animato nativo in stile Japandi ('Zen Japandi Garden')
/// Disegna un laghetto Zen in 2.5D con crespature concentriche, pila di pietre in 3D e petali cadenti.
class AnimatedMagicPortalWidget extends ConsumerStatefulWidget {
  final double width;
  final double height;
  final bool isMeditating;
  final double vrEyeOffset;
  final int? randomSeed;

  const AnimatedMagicPortalWidget({
    super.key,
    this.width = 240,
    this.height = 240,
    this.isMeditating = false,
    this.vrEyeOffset = 0.0,
    this.randomSeed,
  });

  @override
  ConsumerState<AnimatedMagicPortalWidget> createState() =>
      _AnimatedMagicPortalWidgetState();
}

class _AnimatedMagicPortalWidgetState
    extends ConsumerState<AnimatedMagicPortalWidget>
    with TickerProviderStateMixin {
  late List<ZenPetal> _petals;
  late AnimationController _waveController;
  late AnimationController _breatheController;

  @override
  void initState() {
    super.initState();

    // Inizializza 20 petali di ciliegio soffici e asincroni
    final random = widget.randomSeed != null
        ? math.Random(widget.randomSeed)
        : math.Random();
    _petals = List.generate(20, (index) {
      return ZenPetal(
        x: random.nextDouble(),
        y: random.nextDouble() * 1.5 - 0.5, // Alcuni partono sopra lo schermo
        size: 6.0 + random.nextDouble() * 7.0, // da 6 a 13 pixel
        speed: 0.01 + random.nextDouble() * 0.015, // caduta dolcissima
        baseOpacity: 0.25 + random.nextDouble() * 0.5, // opacità
        swaySpeed: 0.4 + random.nextDouble() * 0.8,
        swayWidth: 0.02 + random.nextDouble() * 0.03,
        rotationSpeed: 0.5 + random.nextDouble() * 1.5,
        seed: random.nextDouble() * 100.0,
      );
    });

    // Loop animazione per il movimento dei petali e crespature
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Loop respirazione per le crespature concentriche (8 secondi)
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final themeGradients = AppColors.getGradientByTime(isDark);

    return AnimatedBuilder(
      animation: Listenable.merge([_waveController, _breatheController]),
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                spreadRadius: -4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CustomPaint(
              painter: ZenJapandiGardenPainter(
                waveProgress: _waveController.value,
                breatheProgress: _breatheController.value,
                petals: _petals,
                vrEyeOffset: widget.vrEyeOffset,
                isDarkTheme: isDark,
                themeGradients: themeGradients,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Disegna il laghetto Zen, le crespature dell'acqua geometriche concentriche, la pila di pietre e i petali di ciliegio
class ZenJapandiGardenPainter extends CustomPainter {
  final double waveProgress;
  final double breatheProgress;
  final List<ZenPetal> petals;
  final double vrEyeOffset;
  final bool isDarkTheme;
  final List<Color> themeGradients;

  ZenJapandiGardenPainter({
    required this.waveProgress,
    required this.breatheProgress,
    required this.petals,
    required this.vrEyeOffset,
    required this.isDarkTheme,
    required this.themeGradients,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final accentColor = AppColors.getActiveAccentColor(isDarkTheme);

    // 1. Sfondo nebbioso laghetto Zen sfumato
    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          themeGradients.first.withValues(alpha: isDarkTheme ? 0.35 : 0.65),
          themeGradients.last.withValues(alpha: isDarkTheme ? 0.1 : 0.3),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // 2. CRESPATURE CONCENTRICHE GEOMETRICHE (Zen ripples in sync col respiro)
    final center = Offset(
      size.width / 2 - (vrEyeOffset * 0.65),
      size.height / 2,
    );
    final double maxRippleRadius = size.width * 0.7;

    for (int i = 0; i < 4; i++) {
      // Distribuzione spaziale radiale asincrona
      final double ringProgress = (breatheProgress + i * 0.25) % 1.0;
      final double ringRadius =
          maxRippleRadius * 0.15 + (maxRippleRadius * 0.85 * ringProgress);
      final double ringOpacity =
          (1.0 - ringProgress) * (isDarkTheme ? 0.18 : 0.25);

      final ripplePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isDarkTheme ? 0.8 : 1.2
        ..color = accentColor.withValues(alpha: ringOpacity);

      canvas.drawCircle(center, ringRadius, ripplePaint);
    }

    // 3. PILA DI PIETRE ZEN IN 3D (Cairn prospettico)
    // Disegniamo 3 pietre levigate impilate verticalmente
    // Applicando offset di parallasse diversi a ciascuna pietra, si ottiene un fantastico effetto di tridimensionalità reale

    // Pietra 1 (Base - Più grande e vicina)
    _drawZenStone(
      canvas,
      center: Offset(
        center.dx - (vrEyeOffset * 0.1),
        center.dy + (size.height * 0.15),
      ),
      width: size.width * 0.34,
      height: size.height * 0.14,
      stoneColor: isDarkTheme
          ? const Color(0xFF282E37)
          : const Color(0xFFE2DDD5),
      shadowOpacity: isDarkTheme ? 0.5 : 0.15,
    );

    // Pietra 2 (Mezzo - Media profondità)
    _drawZenStone(
      canvas,
      center: Offset(
        center.dx - (vrEyeOffset * 0.2),
        center.dy + (size.height * 0.05),
      ),
      width: size.width * 0.26,
      height: size.height * 0.11,
      stoneColor: isDarkTheme
          ? const Color(0xFF383F4B)
          : const Color(0xFFEBE6DC),
      shadowOpacity: isDarkTheme ? 0.4 : 0.12,
    );

    // Pietra 3 (Cima - Più piccola e distante)
    _drawZenStone(
      canvas,
      center: Offset(
        center.dx - (vrEyeOffset * 0.3),
        center.dy - (size.height * 0.03),
      ),
      width: size.width * 0.18,
      height: size.height * 0.08,
      stoneColor: isDarkTheme
          ? const Color(0xFF485160)
          : const Color(0xFFF3EFE7),
      shadowOpacity: isDarkTheme ? 0.3 : 0.08,
    );

    // Piccolo nucleo di luce eterea sulla cima della pietra (Candela / Moss)
    final glowPaint = Paint()
      ..color = accentColor.withValues(
        alpha: 0.35 + 0.15 * math.sin(waveProgress * math.pi * 4),
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(
      Offset(center.dx - (vrEyeOffset * 0.3), center.dy - (size.height * 0.05)),
      size.width * 0.035,
      glowPaint,
    );

    // 4. CADUTA E OSCILLAZIONE DEI PETALI DI CILIEGIO (Cherry Blossom Rain)
    for (final p in petals) {
      // Discesa verso il basso
      double currentY = p.y + (waveProgress * p.speed);
      if (currentY > 1.0) {
        currentY -= 1.5; // Resetta sopra lo schermo
      }

      // Oscillazione a foglia cadente
      final double sway =
          math.sin(waveProgress * math.pi * 2 * p.swaySpeed + p.seed) *
          p.swayWidth;
      double currentX = p.x + sway;
      if (currentX < 0.0) currentX += 1.0;
      if (currentX > 1.0) currentX -= 1.0;

      // Parallasse spinto per i petali in primissimo piano
      final double petalVrOffset = vrEyeOffset * (0.9 + (p.size * 0.12));
      final double posX = currentX * size.width - petalVrOffset;
      final double posY = currentY * size.height;

      if (posX >= -20 &&
          posX <= size.width + 20 &&
          posY >= -20 &&
          posY <= size.height + 20) {
        final double opacity =
            p.baseOpacity *
            (0.6 + 0.4 * math.sin(waveProgress * math.pi * 2 + p.seed));

        canvas.save();
        canvas.translate(posX, posY);
        // Rotazione asincrona
        canvas.rotate(waveProgress * math.pi * 2 * p.rotationSpeed + p.seed);

        final Path petalPath = Path();
        // Disegna un grazioso petalo di ciliegio ellittico asimmetrico
        petalPath.moveTo(0, -p.size);
        petalPath.quadraticBezierTo(
          p.size * 0.7,
          -p.size * 0.7,
          p.size * 0.5,
          0,
        );
        petalPath.quadraticBezierTo(p.size * 0.3, p.size * 0.8, 0, p.size);
        petalPath.quadraticBezierTo(
          -p.size * 0.3,
          p.size * 0.8,
          -p.size * 0.5,
          0,
        );
        petalPath.quadraticBezierTo(-p.size * 0.7, -p.size * 0.7, 0, -p.size);
        petalPath.close();

        // Riempimento rosa cipria per Light Theme e oro/crema per Dark Theme
        final petalPaint = Paint()
          ..shader = RadialGradient(
            colors: isDarkTheme
                ? [
                    accentColor.withValues(alpha: opacity),
                    Colors.white.withValues(alpha: opacity * 0.1),
                  ]
                : [
                    const Color(0xFFFBC4CB).withValues(alpha: opacity),
                    const Color(0xFFFFF0F2).withValues(alpha: opacity * 0.3),
                  ],
          ).createShader(Rect.fromCircle(center: Offset.zero, radius: p.size));

        canvas.drawPath(petalPath, petalPaint);
        canvas.restore();
      }
    }
  }

  /// Disegna una pietra levigata Zen ombreggiata in prospettiva
  void _drawZenStone(
    Canvas canvas, {
    required Offset center,
    required double width,
    required double height,
    required Color stoneColor,
    required double shadowOpacity,
  }) {
    final rect = Rect.fromCenter(center: center, width: width, height: height);
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.elliptical(width * 0.45, height * 0.45),
    );

    // 1. Ombra soffusa della pietra sottostante
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + (height * 0.22)),
          width: width * 0.95,
          height: height * 0.9,
        ),
        Radius.elliptical(width * 0.45, height * 0.45),
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: shadowOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // 2. Pietra principale con sfumatura radiale per rilievo tridimensionale
    final stonePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          stoneColor,
          stoneColor.withValues(alpha: 0.85),
          isDarkTheme
              ? Colors.black.withValues(alpha: 0.5)
              : const Color(0xFFB5AEA5).withValues(alpha: 0.5),
        ],
        center: const Alignment(-0.25, -0.35),
        radius: 0.95,
      ).createShader(rect);

    canvas.drawRRect(rrect, stonePaint);

    // 3. Lucentezza minimal sul bordo superiore
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: isDarkTheme ? 0.08 : 0.25);
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant ZenJapandiGardenPainter oldDelegate) {
    return oldDelegate.waveProgress != waveProgress ||
        oldDelegate.breatheProgress != breatheProgress ||
        oldDelegate.vrEyeOffset != vrEyeOffset ||
        oldDelegate.isDarkTheme != isDarkTheme ||
        oldDelegate.themeGradients != themeGradients;
  }
}

/// Sfera di Respirazione Zen in stile Japandi concentrico
class ZenBreathingBubbleWidget extends StatelessWidget {
  final double progress;
  final double size;

  const ZenBreathingBubbleWidget({
    super.key,
    required this.progress,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    // Legge il tema corrente dal settings provider per riflettere all'istante giorno/notte
    return Consumer(
      builder: (context, ref, child) {
        final settings = ref.watch(settingsProvider);
        final isDark = settings.isDarkTheme;
        final themeGradients = AppColors.getGradientByTime(isDark);

        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: ZenBreathingBubblePainter(
              progress: progress,
              isDarkTheme: isDark,
              themeGradients: themeGradients,
            ),
          ),
        );
      },
    );
  }
}

/// Disegna la sfera di respirazione geometrica concentrica a onde d'urto Japandi
class ZenBreathingBubblePainter extends CustomPainter {
  final double progress;
  final bool isDarkTheme;
  final List<Color> themeGradients;

  ZenBreathingBubblePainter({
    required this.progress,
    required this.isDarkTheme,
    required this.themeGradients,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double maxRadius = size.width / 2;
    final accentColor = AppColors.getActiveAccentColor(isDarkTheme);

    // 1. Cerchi concentrici a feedback d'onda di respirazione (Ripples)
    for (int i = 0; i < 3; i++) {
      final double ringProgress = (progress + i * 0.33) % 1.0;
      final double ringRadius =
          maxRadius * 0.28 + (maxRadius * 0.72 * ringProgress);
      final double ringOpacity =
          (1.0 - ringProgress) * (isDarkTheme ? 0.2 : 0.26);

      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isDarkTheme ? 0.8 : 1.2
        ..color = accentColor.withValues(alpha: ringOpacity);

      canvas.drawCircle(center, ringRadius, ringPaint);
    }

    // 2. Core centrale pulsante (stile ciottolo levigato traslucido o loto)
    final double baseRadius = maxRadius * 0.42;
    final double currentRadius =
        baseRadius * (0.82 + progress * 0.38); // da 0.82x a 1.2x

    // Aura di luce esterna soffice in base alla respirazione
    canvas.drawCircle(
      center,
      currentRadius * 1.38,
      Paint()
        ..style = PaintingStyle.fill
        ..color = accentColor.withValues(
          alpha: isDarkTheme ? 0.08 * progress : 0.15 * progress,
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    // Sfera principale Japandi in vetro/ciottolo levigato
    final corePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: isDarkTheme
            ? [
                Colors.white.withValues(alpha: 0.85),
                accentColor.withValues(alpha: 0.4),
                Colors.transparent,
              ]
            : [
                Colors.white.withValues(alpha: 0.95),
                accentColor.withValues(alpha: 0.35),
                Colors.transparent,
              ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: currentRadius));
    canvas.drawCircle(center, currentRadius, corePaint);

    // 3. Geometria Japandi interna (8 petali stilizzati geometrici rotanti)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(
      progress * math.pi * 0.22,
    ); // Rotazione in sincrono col respiro

    final petalPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader =
          RadialGradient(
            colors: [
              Colors.white.withValues(alpha: isDarkTheme ? 0.42 : 0.52),
              accentColor.withValues(alpha: 0.0),
            ],
          ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: currentRadius),
          );

    for (int i = 0; i < 8; i++) {
      canvas.save();
      canvas.rotate(i * (math.pi / 4));
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(currentRadius * 0.45, 0),
          width: currentRadius * 0.7,
          height: currentRadius * 0.22,
        ),
        petalPaint,
      );
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ZenBreathingBubblePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isDarkTheme != isDarkTheme ||
        oldDelegate.themeGradients != themeGradients;
  }
}
