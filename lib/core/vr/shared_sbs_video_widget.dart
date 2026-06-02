import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/vr_gaze_button.dart';

class SharedSbsVideoWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isLeftEye;
  final VrGazeController gazeController;

  const SharedSbsVideoWidget({
    Key? key,
    required this.controller,
    required this.isLeftEye,
    required this.gazeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    final videoWidth = controller.value.size.width;
    final videoHeight = controller.value.size.height;

    return AnimatedBuilder(
      animation: gazeController,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final double height = constraints.maxHeight;
            
            // Aumentiamo lo zoom al 160% (1.6) per avere un grande margine di esplorazione
            const double scale = 1.6;

            // Calcolo matematico del limite massimo di traslazione prima di vedere i bordi neri
            final double maxPanX = (width * (scale - 1)) / (2 * scale);
            final double maxPanY = (height * (scale - 1)) / (2 * scale);

            // Il reticleOffset aumenta quando si guarda in una direzione.
            // Se guardiamo a DESTRA (dx positivo), l'ambiente deve scorrere a SINISTRA (dx negativo).
            // Moltiplicatore abbassato a 0.5 per un movimento morbido che non sbatte subito sui bordi
            double panX = -gazeController.reticleOffset.dx * 0.5;
            double panY = -gazeController.reticleOffset.dy * 0.5;

            // Limitiamo la traslazione ai limiti matematici di sicurezza
            panX = panX.clamp(-maxPanX, maxPanX);
            panY = panY.clamp(-maxPanY, maxPanY);

            return Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
              child: ClipRect(
                child: Transform.scale(
                  scale: scale, 
                  child: Transform.translate(
                    offset: Offset(panX, panY),
                    child: FractionallySizedBox(
                      widthFactor: 2.0, // SBS: il video totale è largo il doppio della singola lente
                      alignment: isLeftEye ? Alignment.centerLeft : Alignment.centerRight,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: videoWidth,
                          height: videoHeight,
                          child: VideoPlayer(controller),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }
}
