import 'package:flutter/material.dart';
import '../theme/vr_gaze_button.dart';
import 'vr_orientation_service.dart';

/// Wrapper riutilizzabile per TUTTE le schermate VR.
///
/// Responsabilità:
/// • Chiama [VrOrientationService.enterVr()] in initState
///   (landscape + fullscreen immersive)
/// • Chiama [VrOrientationService.exitVr()] in dispose
/// • Costruisce il layout split-screen corretto: Row con 2 occhi separati
///   da un divisore nero da 2px
/// • Avvolge tutto in [VrGazeScope] con il controller passato
///
/// I bottoni nell'occhio sinistro devono avere [VrGazableButton.isActiveEye=true],
/// quelli nell'occhio destro [isActiveEye=false] per evitare interferenze
/// con il dwell timer.
class VrHostScreen extends StatefulWidget {
  /// Builder per il contenuto di ogni occhio.
  /// [isLeft] = true → occhio sinistro (isActiveEye=true per i bottoni)
  /// [isLeft] = false → occhio destro (isActiveEye=false per i bottoni)
  final Widget Function(BuildContext context, bool isLeft) eyeBuilder;
  final VrGazeController gazeController;
  final Color backgroundColor;

  const VrHostScreen({
    Key? key,
    required this.eyeBuilder,
    required this.gazeController,
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  @override
  State<VrHostScreen> createState() => _VrHostScreenState();
}

class _VrHostScreenState extends State<VrHostScreen> {
  @override
  void initState() {
    super.initState();
    // Forza landscape + fullscreen immediatamente all'ingresso nella schermata VR
    VrOrientationService.enterVr();
  }

  @override
  void dispose() {
    // Ripristina portrait + UI normale all'uscita
    VrOrientationService.exitVr();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: VrGazeScope(
        controller: widget.gazeController,
        child: Row(
          children: [
            // Occhio SINISTRO — isActive=true → aggiorna reticleGlobalPosition
            Expanded(
              child: ClipRect(
                child: VrGazeOverlay(
                  controller: widget.gazeController,
                  isActive: true,
                  child: widget.eyeBuilder(context, true),
                ),
              ),
            ),

            // Divisore centrale (lente del visore)
            Container(width: 2.0, color: widget.backgroundColor == Colors.transparent ? Colors.transparent : Colors.black),

            // Occhio DESTRO — isActive=false → solo visivo, no hit-test
            Expanded(
              child: ClipRect(
                child: VrGazeOverlay(
                  controller: widget.gazeController,
                  isActive: false,
                  child: widget.eyeBuilder(context, false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
