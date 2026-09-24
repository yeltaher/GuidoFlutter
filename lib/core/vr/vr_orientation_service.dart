import 'dart:io';
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
      
      if (Platform.isIOS) {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      }
    }
    // Se count > 1: già in landscape, nessuna azione necessaria
  }

  static Future<void> exitVr() async {
    _activeVrScreens = (_activeVrScreens - 1).clamp(0, 999);

    if (_activeVrScreens == 0) {
      // Ultima schermata VR chiusa: ripristina portrait deterministico + barre di sistema
      await resetToPortrait();
    }
    // Se count > 0: ci sono ancora schermate VR attive, non uscire
  }

  /// Forza il reset del counter (usato in caso di errori/crash imprevisti)
  static void resetCounter() {
    _activeVrScreens = 0;
  }

  /// Ripristina in modo deterministico l'orientamento Portrait su iOS e Android,
  /// forzando DeviceOrientation.portraitUp su iOS e riabilitando la status bar
  /// con SystemUiMode.edgeToEdge.
  static Future<void> resetToPortrait() async {
    _activeVrScreens = 0;
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } catch (e) {
      debugPrint('[VR] setEnabledSystemUIMode edgeToEdge error: $e');
    }

    try {
      await _channel.invokeMethod('forcePortrait');
    } catch (e) {
      debugPrint('[VR] forcePortrait error: $e');
    }

    if (Platform.isIOS) {
      try {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      } catch (e) {
        debugPrint('[VR] setPreferredOrientations portraitUp error: $e');
      }
    }
  }
}
