import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class GlbViewerWidget extends StatelessWidget {
  final String src;
  final bool autoRotate;
  final bool cameraControls;

  const GlbViewerWidget({
    Key? key,
    required this.src,
    this.autoRotate = true,
    this.cameraControls = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModelViewer(
      backgroundColor: Colors.transparent,
      src: src,
      alt: "Modello 3D",
      autoRotate: autoRotate,
      cameraControls: cameraControls,
      disableZoom: true,
      interactionPrompt: InteractionPrompt.none,
      loading: Loading.eager,
    );
  }
}
