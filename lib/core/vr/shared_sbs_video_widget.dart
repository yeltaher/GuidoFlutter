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
        // Il reticleOffset aumenta quando si guarda in una direzione.
        // Se guardiamo a DESTRA (dx positivo), l'ambiente deve scorrere a SINISTRA (dx negativo).
        final panX = -gazeController.reticleOffset.dx * 1.5;
        final panY = -gazeController.reticleOffset.dy * 1.5;

        return Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: ClipRect(
            child: Transform.scale(
              scale: 1.25, // Zoom in per nascondere i bordi neri durante il panning
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
      },
    );
  }
}
