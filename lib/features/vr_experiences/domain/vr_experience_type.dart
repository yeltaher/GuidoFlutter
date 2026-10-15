import '../../../core/unity/unity_bridge_dto.dart';

/// Rappresenta gli 8 moduli WebXR / Three.js 3D fruibili al 100% offline
/// tramite localhost server e InAppWebView.
enum VrExperienceType {
  respirazioneAria(
    id: 'respirazione_aria',
    folderName: 'respirazione_aria',
    title: 'Respirazione Aria',
    titleEn: 'Air Breathing',
    subtitle: 'Coerenza Cardiaca • 432 Hz',
    element: 'Aria',
    isBreathing: true,
  ),
  respirazioneAcqua(
    id: 'respirazione_acqua',
    folderName: 'respirazione_acqua',
    title: 'Respirazione Acqua',
    titleEn: 'Water Breathing',
    subtitle: 'Nadi Shodhana • 432 Hz',
    element: 'Acqua',
    isBreathing: true,
  ),
  respirazioneFuoco(
    id: 'respirazione_fuoco',
    folderName: 'respirazione_fuoco',
    title: 'Respirazione Fuoco',
    titleEn: 'Fire Breathing',
    subtitle: 'Box Breathing • 432 Hz',
    element: 'Fuoco',
    isBreathing: true,
  ),
  respirazioneTerra(
    id: 'respirazione_terra',
    folderName: 'respirazione_terra',
    title: 'Respirazione Terra',
    titleEn: 'Earth Breathing',
    subtitle: 'Radicamento • 432 Hz',
    element: 'Terra',
    isBreathing: true,
  ),
  meditazioneMattinoAcqua(
    id: 'meditazione_mattino_acqua',
    folderName: 'meditazione_mattino_acqua',
    title: 'Meditazione Mattino • Acqua',
    titleEn: 'Morning Meditation • Water',
    subtitle: 'Percorso Guidato • 432 Hz',
    element: 'Acqua',
    isBreathing: false,
  ),
  meditazionePomeriggioAcqua(
    id: 'meditazione_pomeriggio_acqua',
    folderName: 'meditazione_pomeriggio_acqua',
    title: 'Meditazione del Pomeriggio • Acqua',
    titleEn: 'Afternoon Meditation • Water',
    subtitle: 'Percorso Guidato • 432 Hz',
    element: 'Acqua',
    isBreathing: false,
  ),
  meditazioneSeraAcqua(
    id: 'meditazione_sera_acqua',
    folderName: 'meditazione_sera_acqua',
    title: 'Meditazione della Sera • Acqua',
    titleEn: 'Evening Meditation • Water',
    subtitle: 'Percorso Guidato • 432 Hz',
    element: 'Acqua',
    isBreathing: false,
  ),
  meditazioneGeneraleAcqua(
    id: 'meditazione_generale_acqua',
    folderName: 'meditazione_generale_acqua',
    title: 'Meditazione Generale • Acqua',
    titleEn: 'General Meditation • Water',
    subtitle: 'Consapevolezza Zen • 432 Hz',
    element: 'Acqua',
    isBreathing: false,
  );

  final String id;
  final String folderName;
  final String title;
  final String titleEn;
  final String subtitle;
  final String element;
  final bool isBreathing;

  const VrExperienceType({
    required this.id,
    required this.folderName,
    required this.title,
    required this.titleEn,
    required this.subtitle,
    required this.element,
    required this.isBreathing,
  });

  /// Restituisce il titolo localizzato
  String localizedTitle(bool isItalian) => isItalian ? title : titleEn;

  /// Restituisce l'URL locale relativo al server InAppLocalhost
  String getLocalUrl({int port = 8085}) =>
      'http://localhost:$port/vr_experiences/$folderName/index.html';

  /// Risolve il tipo dal suo identificatore stringa univoco
  static VrExperienceType fromId(String? id) {
    if (id == null || id.isEmpty) return VrExperienceType.respirazioneAria;
    final match = tryFromId(id) ?? fromSessionId(id);
    if (match != null) return match;
    return VrExperienceType.values.firstWhere(
      (e) => e.id.toLowerCase() == id.toLowerCase(),
      orElse: () => VrExperienceType.respirazioneAria,
    );
  }

  /// Risolve un tipo se presente, altrimenti null
  static VrExperienceType? tryFromId(String? id) {
    if (id == null || id.isEmpty) return null;
    final lower = id.toLowerCase().trim();
    for (final e in VrExperienceType.values) {
      if (e.id.toLowerCase() == lower || e.folderName.toLowerCase() == lower) {
        return e;
      }
    }
    return null;
  }

  /// Risolve il tipo da un identificativo di sessione o codice sessione.
  /// Riconosce formati come 'waterMeditationEvening', 'water_evening', 'meditazione_sera_acqua', ecc.
  static VrExperienceType? fromSessionId(String? sessionId) {
    if (sessionId == null || sessionId.trim().isEmpty) return null;
    final s = sessionId.trim().toLowerCase();

    // Match diretto su id o folderName
    final direct = tryFromId(s);
    if (direct != null) return direct;

    // Meditazione Generale (Acqua)
    if (s == 'generalmeditation' ||
        s == 'meditazione_generale_acqua' ||
        s == 'meditazione_generale' ||
        s == 'meditazionegenerale' ||
        s == 'water_general' ||
        s == 'watergeneral' ||
        s == 'general' ||
        s == 'generale' ||
        s == 'focus_zen' ||
        s == 'focuszen' ||
        s == 'zen_focus' ||
        (s.contains('general') && (s.contains('meditation') || s.contains('water') || s.contains('zen'))) ||
        (s.contains('generale') && (s.contains('meditaz') || s.contains('acqua') || s.contains('zen')))) {
      return VrExperienceType.meditazioneGeneraleAcqua;
    }

    // Meditazione della Sera (Acqua)
    if (s == 'watermeditationevening' ||
        s == 'water_evening' ||
        s == 'water_meditation_evening' ||
        s == 'watermeditationsera' ||
        s == 'water_sera' ||
        s == 'meditazione_sera_acqua' ||
        s == 'meditazione_acqua_sera' ||
        s == 'meditazionesera' ||
        s == 'starlight_sleep' ||
        s == 'starlight' ||
        (s.contains('water') && s.contains('evening')) ||
        (s.contains('acqua') && s.contains('sera'))) {
      return VrExperienceType.meditazioneSeraAcqua;
    }

    // Meditazione del Pomeriggio (Acqua)
    if (s == 'watermeditationafternoon' ||
        s == 'water_afternoon' ||
        s == 'water_meditation_afternoon' ||
        s == 'watermeditationpomeriggio' ||
        s == 'water_pomeriggio' ||
        s == 'water_pom' ||
        s == 'watermeditationpom' ||
        s == 'meditazione_pomeriggio_acqua' ||
        s == 'meditazione_acqua_pomeriggio' ||
        s == 'meditazionepomeriggio' ||
        s == 'meditazione_pom' ||
        (s.contains('water') && (s.contains('afternoon') || s.contains('pomeriggio') || s.contains('pom'))) ||
        (s.contains('acqua') && (s.contains('afternoon') || s.contains('pomeriggio') || s.contains('pom')))) {
      return VrExperienceType.meditazionePomeriggioAcqua;
    }

    // Meditazione del Mattino (Acqua)
    if (s == 'watermeditationmorning' ||
        s == 'water_morning' ||
        s == 'water_meditation_morning' ||
        s == 'watermeditation' ||
        s == 'water_mattino' ||
        s == 'meditazione_mattino_acqua' ||
        s == 'meditazione_acqua_mattino' ||
        s == 'meditazionemattino' ||
        (s.contains('water') && (s.contains('morning') || s.contains('mattin')))) {
      return VrExperienceType.meditazioneMattinoAcqua;
    }

    // Respirazioni
    if (s == 'waterbreathing' ||
        s == 'water_breathing' ||
        s == 'respirazione_acqua') {
      return VrExperienceType.respirazioneAcqua;
    }
    if (s == 'airbreathing' ||
        s == 'air_breathing' ||
        s == 'respirazione_aria') {
      return VrExperienceType.respirazioneAria;
    }
    if (s == 'firebreathing' ||
        s == 'fire_breathing' ||
        s == 'respirazione_fuoco') {
      return VrExperienceType.respirazioneFuoco;
    }
    if (s == 'earthbreathing' ||
        s == 'earth_breathing' ||
        s == 'respirazione_terra') {
      return VrExperienceType.respirazioneTerra;
    }

    return null;
  }

  /// Verifica e risolve se una determinata scena Unity o titolo corrisponde
  /// a uno degli 8 moduli WebXR Three.js implementati offline.
  static VrExperienceType? fromSceneOrTitle({
    String? sceneName,
    String? title,
  }) {
    final s = sceneName?.trim();
    if (s != null && s.isNotEmpty) {
      if (s == UnityScenes.airBreathing || s == UnityScenes.airMeditation) {
        return VrExperienceType.respirazioneAria;
      }
      if (s == UnityScenes.waterBreathing) {
        return VrExperienceType.respirazioneAcqua;
      }
      if (s == UnityScenes.fireBreathing || s == UnityScenes.fireMeditation) {
        return VrExperienceType.respirazioneFuoco;
      }
      if (s == UnityScenes.earthBreathing || s == UnityScenes.earthMeditation) {
        return VrExperienceType.respirazioneTerra;
      }
      if (s == UnityScenes.waterMeditationEvening) {
        return VrExperienceType.meditazioneSeraAcqua;
      }
      if (s == UnityScenes.waterMeditationAfternoon) {
        return VrExperienceType.meditazionePomeriggioAcqua;
      }
      if (s == UnityScenes.generalMeditation) {
        return VrExperienceType.meditazioneGeneraleAcqua;
      }
      if (s == UnityScenes.waterMeditationMorning || s == UnityScenes.waterMeditation) {
        // Se la scena legacy o waterMeditationMorning viene abbinata a un titolo serale o pomeridiano o generale, risolvi correttamente
        final t = (title ?? '').toLowerCase();
        if (t.contains('sera') || t.contains('evening') || t.contains('starlight') || t.contains('sonno')) {
          return VrExperienceType.meditazioneSeraAcqua;
        }
        if (t.contains('pomeriggio') || t.contains('afternoon') || t.contains('pom')) {
          return VrExperienceType.meditazionePomeriggioAcqua;
        }
        if (t.contains('generale') || t.contains('general')) {
          return VrExperienceType.meditazioneGeneraleAcqua;
        }
        return VrExperienceType.meditazioneMattinoAcqua;
      }

      // Check session parser on sceneName string
      final fromSession = fromSessionId(s);
      if (fromSession != null) {
        return fromSession;
      }
    }

    final t = (title ?? '').toLowerCase();
    if (t.contains('sera') || t.contains('evening') || t.contains('starlight') || t.contains('sonno')) {
      if (t.contains('acqua') || t.contains('water') || t.contains('meditaz') || t.contains('sleep') || t.contains('percorso')) {
        return VrExperienceType.meditazioneSeraAcqua;
      }
      return VrExperienceType.meditazioneSeraAcqua;
    }
    if (t.contains('pomeriggio') || t.contains('afternoon') || t.contains('pom')) {
      if (t.contains('acqua') || t.contains('water') || t.contains('meditaz') || t.contains('percorso')) {
        return VrExperienceType.meditazionePomeriggioAcqua;
      }
      return VrExperienceType.meditazionePomeriggioAcqua;
    }
    if (t.contains('generale') ||
        t.contains('general') ||
        ((t.contains('zen') || t.contains('focus') || t.contains('consapevolezza')) &&
            (t.contains('acqua') || t.contains('water') || t.contains('meditaz')))) {
      return VrExperienceType.meditazioneGeneraleAcqua;
    }
    if (t.contains('mattin') || (t.contains('acqua') && t.contains('meditaz'))) {
      return VrExperienceType.meditazioneMattinoAcqua;
    }
    if (t.contains('acqua') && t.contains('respiraz')) {
      return VrExperienceType.respirazioneAcqua;
    }
    if (t.contains('aria')) {
      return VrExperienceType.respirazioneAria;
    }
    if (t.contains('fuoco')) {
      return VrExperienceType.respirazioneFuoco;
    }
    if (t.contains('terra')) {
      return VrExperienceType.respirazioneTerra;
    }

    return null;
  }

  /// Restituisce true se la scena o il titolo corrispondono a un'esperienza VR offline disponibile.
  static bool isOfflineVrSupported({String? sceneName, String? title}) {
    return fromSceneOrTitle(sceneName: sceneName, title: title) != null;
  }
}
