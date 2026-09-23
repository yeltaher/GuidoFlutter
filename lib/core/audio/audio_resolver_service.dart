import 'package:flutter/foundation.dart';
import '../unity/unity_bridge_dto.dart';

/// Bundle contenente tutte le risorse audio e metadati per l'avvio della sessione
class AudioExperienceBundle {
  final String voicePath;
  final String ambientPath;
  final String sceneName;
  final double durationSeconds;
  final String voiceActorName;

  const AudioExperienceBundle({
    required this.voicePath,
    required this.ambientPath,
    required this.sceneName,
    this.durationSeconds = 300.0,
    required this.voiceActorName,
  });
}

/// Servizio enterprise per la risoluzione deterministica e resiliente delle tracce audio (Voce M/F e Ambient)
/// accoppiate con precisione alle scene Unity UaaL canoniche.
class AudioResolverService {
  // Tracce Michela (Femminile)
  static const String _michelaAcquaEsercizio =
      'assets/Esperienze_Guido/Audio/Respirazioni/Acqua/Respirazione acqua.mp3';
  static const String _michelaAcquaProcedimento =
      'assets/Esperienze_Guido/Audio/Respirazioni/Acqua/Respirazione-Narici-Alternate_Procedimento.mp3';

  static const String _michelaAriaEsercizio =
      'assets/Esperienze_Guido/Audio/Respirazioni/Aria/Respirazione aria.mp3';
  static const String _michelaAriaProcedimento =
      'assets/Esperienze_Guido/Audio/Respirazioni/Aria/Percorso-Aria_respiraz_diaframmaticaProcedimento.mp3';

  static const String _michelaFuocoEsercizio =
      'assets/Esperienze_Guido/Audio/Respirazioni/Fuoco/percorso fuoco quadrato Esercizio fix tempo.mp3';
  static const String _michelaFuocoProcedimento =
      'assets/Esperienze_Guido/Audio/Respirazioni/Fuoco/Percorso-Fuoco-Quadrato_Procedimento.mp3';

  static const String _michelaTerraEsercizio =
      'assets/Esperienze_Guido/Audio/Respirazioni/Terra/Respirazione terra.mp3';
  static const String _michelaTerraProcedimento =
      'assets/Esperienze_Guido/Audio/Respirazioni/Terra/Respirazione-Percorso-Terra_Procedimento.mp3';

  static const String _michelaMedMattino =
      'assets/Esperienze_Guido/Audio/Meditazioni/Acqua/Meditazione del Mattino_Procedimento.mp3';
  static const String _michelaMedPomeriggio =
      'assets/Esperienze_Guido/Audio/Meditazioni/Acqua/Meditazione-del-Pomeriggio.mp3';
  static const String _michelaMedSera =
      'assets/Esperienze_Guido/Audio/Meditazioni/Acqua/Meditazione-della-Sera.mp3';
  static const String _michelaMedGenerale =
      'assets/Esperienze_Guido/Audio/Meditazioni/Generale/Meditazione_Percorso-Acqua_Procedimento.mp3';

  // Tracce Luigi (Maschile)
  static const String _luigiAriaEsercizio =
      'assets/Esperienze_Guido/Audio/Voce_Luigi/percorso aria respirazione diaframmatica esercizio Luigi con correzione.mp3';
  static const String _luigiAriaProcedimento =
      'assets/Esperienze_Guido/Audio/Voce_Luigi/Percorso aria respirazione diaframmatica procedimento Luigi con correzione.mp3';

  static const String _luigiFuocoEsercizio =
      'assets/Esperienze_Guido/Audio/Voce_Luigi/Percorso Fuoco quadrato Luigi Esercizio.mp3';
  static const String _luigiFuocoProcedimento =
      'assets/Esperienze_Guido/Audio/Voce_Luigi/Percorso Fuoco quadrato procedimento Luigi.mp3';

  static const String _luigiTerraEsercizio =
      'assets/Esperienze_Guido/Audio/Voce_Luigi/Respirazione percorso terra Esercizio Luigi.mp3';
  static const String _luigiTerraProcedimento =
      'assets/Esperienze_Guido/Audio/Voce_Luigi/Respirazione Luigi percorso terra procedimento.mp3';

  // Musiche Ambientali
  static const String _ambientAcqua =
      'assets/Esperienze_Guido/Audio/Respirazioni/Acqua/RespAcqua.mp3';
  static const String _ambientAria =
      'assets/Esperienze_Guido/Audio/Respirazioni/Aria/RespAria.mp3';
  static const String _ambientFuoco =
      'assets/Esperienze_Guido/Audio/Respirazioni/Fuoco/RespFuoco.mp3';
  static const String _ambientTerra =
      'assets/Esperienze_Guido/Audio/Respirazioni/Terra/RespTerra.mp3';

  static const String _ambientMedMattino =
      'assets/Esperienze_Guido/Audio/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione MATTINO.mp3';
  static const String _ambientMedPomeriggio =
      'assets/Esperienze_Guido/Audio/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione POMERIGGIO.mp3';
  static const String _ambientMedSera =
      'assets/Esperienze_Guido/Audio/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione SERA.mp3';
  static const String _ambientEtereo =
      'assets/Esperienze_Guido/Audio/Meditazioni/Effetti/Musica eterea.mp3';

  /// Risolve il bundle audio completo in base a titolo, scena, sesso voce e lingua.
  static AudioExperienceBundle resolveBundle({
    required String title,
    String? sceneName,
    int voiceSex = 0, // 0 = Luigi (Maschile), 1 = Michela (Femminile)
    int language = 0, // 0 = Italiano, 1 = Inglese
    String? customVoicePath,
    String? customAmbientPath,
    double? durationSeconds,
  }) {
    final resolvedScene = UnityScenes.resolveSceneName(
      explicitSceneName: sceneName,
      title: title,
    );

    final t = title.toLowerCase();
    final isProcedimento = t.contains('procedimento') ||
        t.contains('spiegazione') ||
        t.contains('guida') ||
        t.contains('intro') ||
        resolvedScene.startsWith('Procedimento');

    String voicePath = '';
    String ambientPath = '';
    String actorName = voiceSex == 0 ? 'Luigi' : 'Michela';

    // Se forniti percorsi personalizzati espliciti non vuoti, usali come priorità
    if (customVoicePath != null && customVoicePath.trim().isNotEmpty) {
      voicePath = customVoicePath.trim();
    }
    if (customAmbientPath != null && customAmbientPath.trim().isNotEmpty) {
      ambientPath = customAmbientPath.trim();
    }

    // Risoluzione voce se non esplicitata
    if (voicePath.isEmpty) {
      if (t.contains('generale') || t.contains('general')) {
        voicePath = _michelaMedGenerale;
        actorName = 'Michela';
        ambientPath = ambientPath.isEmpty ? _ambientEtereo : ambientPath;
      } else if (t.contains('fuoco') || resolvedScene == UnityScenes.fireBreathing || resolvedScene == UnityScenes.fireMeditation) {
        if (voiceSex == 0) {
          voicePath = isProcedimento ? _luigiFuocoProcedimento : _luigiFuocoEsercizio;
          actorName = 'Luigi';
        } else {
          voicePath = isProcedimento ? _michelaFuocoProcedimento : _michelaFuocoEsercizio;
          actorName = 'Michela';
        }
        ambientPath = ambientPath.isEmpty ? _ambientFuoco : ambientPath;
      } else if (t.contains('aria') || resolvedScene == UnityScenes.airBreathing || resolvedScene == UnityScenes.airMeditation) {
        if (voiceSex == 0) {
          voicePath = isProcedimento ? _luigiAriaProcedimento : _luigiAriaEsercizio;
          actorName = 'Luigi';
        } else {
          voicePath = isProcedimento ? _michelaAriaProcedimento : _michelaAriaEsercizio;
          actorName = 'Michela';
        }
        ambientPath = ambientPath.isEmpty ? _ambientAria : ambientPath;
      } else if (t.contains('terra') || resolvedScene == UnityScenes.earthBreathing || resolvedScene == UnityScenes.earthMeditation) {
        if (voiceSex == 0) {
          voicePath = isProcedimento ? _luigiTerraProcedimento : _luigiTerraEsercizio;
          actorName = 'Luigi';
        } else {
          voicePath = isProcedimento ? _michelaTerraProcedimento : _michelaTerraEsercizio;
          actorName = 'Michela';
        }
        ambientPath = ambientPath.isEmpty ? _ambientTerra : ambientPath;
      } else {
        // Percorso Acqua o Meditazioni per momento della giornata
        if (t.contains('mattin') || t.contains('morning')) {
          voicePath = _michelaMedMattino;
          ambientPath = ambientPath.isEmpty ? _ambientMedMattino : ambientPath;
          actorName = 'Michela';
        } else if (t.contains('pomeriggio') || t.contains('afternoon')) {
          voicePath = _michelaMedPomeriggio;
          ambientPath = ambientPath.isEmpty ? _ambientMedPomeriggio : ambientPath;
          actorName = 'Michela';
        } else if (t.contains('sera') || t.contains('evening')) {
          voicePath = _michelaMedSera;
          ambientPath = ambientPath.isEmpty ? _ambientMedSera : ambientPath;
          actorName = 'Michela';
        } else {
          // Respirazione Acqua di default
          // Nota architetturale: Per Acqua italiano non esiste traccia Luigi dedicata.
          // Eseguiamo fallback trasparente su Michela.
          if (voiceSex == 0) {
            debugPrint(
              '[AudioResolver] Voce Luigi per Acqua non presente nei materiali originali IT. Fallback elegante su Michela.',
            );
          }
          voicePath = isProcedimento ? _michelaAcquaProcedimento : _michelaAcquaEsercizio;
          actorName = 'Michela';
          ambientPath = ambientPath.isEmpty ? _ambientAcqua : ambientPath;
        }
      }
    }

    if (ambientPath.isEmpty) {
      ambientPath = _ambientAcqua;
    }

    final calculatedDuration = durationSeconds ??
        (t.contains('generale') || t.contains('mattin') || t.contains('pomeriggio') || t.contains('sera')
            ? 600.0
            : 300.0);

    return AudioExperienceBundle(
      voicePath: voicePath,
      ambientPath: ambientPath,
      sceneName: resolvedScene,
      durationSeconds: calculatedDuration,
      voiceActorName: actorName,
    );
  }
}
