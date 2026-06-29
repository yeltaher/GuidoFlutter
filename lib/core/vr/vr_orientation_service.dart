import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Unico responsabile della gestione orientamento per la modalità VR.
///
/// Usa un **reference counter** (_activeVrScreens) per gestire correttamente
/// le transizioni con pushReplacement tra schermate VR:
///
/// Problema senza counter:
///   VrCalibration → pushReplacement → VrConfirmation
///   1. VrConfirmation.initState → enterVr() → forceLandscape ✅
///   2. VrCalibration.dispose   → exitVr()  → forcePortrait  ← CANCELLA! ❌
///
/// Con counter:
///   1. VrConfirmation.initState → enterVr() → count=2, skip forcePortrait
///   2. VrCalibration.dispose   → exitVr()  → count=1, still VR, skip forcePortrait ✅
///   3. Quando l'utente esce da MeditationView → count=0 → forcePortrait ✅
///
/// NON chiama mai SystemChrome.setPreferredOrientations su Android perché
/// su API 31+ sovrascrive asincronamente il lock nativo.
class VrOrientationService {
  static const _channel = MethodChannel('com.codepulse.guido/orientation');

  /// Numero di schermate VR attive nel navigator stack
  static int _activeVrScreens = 0;

  static Future<void> enterVr() async {
    _activeVrScreens++;

    if (_activeVrScreens == 1) {
      // Prima schermata VR: forza landscape + fullscreen
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      try {
        await _channel.invokeMethod('forceLandscape');
      } catch (e) {
        debugPrint('[VR] forceLandscape error: $e');
      }
    }
    // Se count > 1: già in landscape, nessuna azione necessaria
  }

  static Future<void> exitVr() async {
    _activeVrScreens = (_activeVrScreens - 1).clamp(0, 999);

    if (_activeVrScreens == 0) {
      // Ultima schermata VR chiusa: ripristina portrait + barre di sistema
      // Usa SystemUiMode.manual (non edgeToEdge) per evitare che il contenuto
      // Flutter si estenda sotto la system nav bar e tagli la floating bar
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values, // ripristina top + bottom bar
      );
      try {
        await _channel.invokeMethod('forcePortrait');
      } catch (e) {
        debugPrint('[VR] forcePortrait error: $e');
      }
    }
    // Se count > 0: ci sono ancora schermate VR attive, non uscire
  }

  /// Forza il reset del counter (usato in caso di errori/crash imprevisti)
  static void resetCounter() {
    _activeVrScreens = 0;
  }
}
