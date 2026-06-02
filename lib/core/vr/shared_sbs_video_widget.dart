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
            
            // Aumentiamo notevolmente lo zoom (2.2) per avvicinare il soggetto ("molto lontano")
            // e avere tantissimo margine di esplorazione VR
            const double scale = 2.2;

            // Calcolo matematico del limite massimo di traslazione per non mostrare mai bordi neri
            final double maxPanX = (width * (scale - 1)) / (2 * scale);
            final double maxPanY = (height * (scale - 1)) / (2 * scale);

            double panX = -gazeController.reticleOffset.dx * 0.7;
            double panY = -gazeController.reticleOffset.dy * 0.7;

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
                    // FittedBox ESTERNO: scala la metà perfetta del video per coprire lo schermo
                    child: FittedBox(
                      fit: BoxFit.cover,
                      // SizedBox pari all'esatta metà della risoluzione nativa del video
                      child: SizedBox(
                        width: videoWidth / 2.0,
                        height: videoHeight,
                        child: ClipRect(
                          child: OverflowBox(
                            maxWidth: videoWidth,
                            maxHeight: videoHeight,
                            // Allineiamo il video intero a sinistra o a destra per inquadrare la giusta metà
                            alignment: isLeftEye ? Alignment.centerLeft : Alignment.centerRight,
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
                ),
              ),
            );
          }
        );
      },
    );
  }
}
