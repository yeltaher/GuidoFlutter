import 'dart:io' show Platform;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../audio/audio_service.dart';
import '../unity/unity_bridge_dto.dart';
import 'app_initializer_provider.dart';


/// Rappresenta lo stato completo delle preferenze e sblocchi dell'app
class SettingsState extends Equatable {
  final int musicVolume; // 0 = Mute, 1 = Low, 2 = Mid, 3 = High
  final int effectsVolume; // 0 = Mute, 1 = Low, 2 = Mid, 3 = High
  final int voiceVolume; // 0 = Mute, 1 = Low, 2 = Mid, 3 = High
  final bool isVoiceMuted; // Se la voce guida è silenziata
  final int voiceSex; // 0 = Maschile, 1 = Femminile
  final int language; // 0 = Italiano, 1 = Inglese
  final bool isUnlocked; // Se l'app premium è sbloccata
  final bool isVrMode; // Se la visualizzazione VR stereoscopica è attiva
  final bool isDarkTheme; // Se il tema scuro Japandi è attivo
  final bool vrCalibrated; // Se la calibrazione VR è stata effettuata
  final double vrBiasX; // Drift asse X giroscopio
  final double vrBiasZ; // Drift asse Z giroscopio
  final QualityPreset qualityPreset; // Profilo di resa grafica UaaL (0 = Alta Fedeltà, 1 = Eco)

  const SettingsState({
    required this.musicVolume,
    required this.effectsVolume,
    required this.voiceVolume,
    required this.isVoiceMuted,
    required this.voiceSex,
    required this.language,
    required this.isUnlocked,
    required this.isVrMode,
    required this.isDarkTheme,
    required this.vrCalibrated,
    required this.vrBiasX,
    required this.vrBiasZ,
    this.qualityPreset = QualityPreset.highFidelity,
  });

  SettingsState copyWith({
    int? musicVolume,
    int? effectsVolume,
    int? voiceVolume,
    bool? isVoiceMuted,
    int? voiceSex,
    int? language,
    bool? isUnlocked,
    bool? isVrMode,
    bool? isDarkTheme,
    bool? vrCalibrated,
    double? vrBiasX,
    double? vrBiasZ,
    QualityPreset? qualityPreset,
  }) {
    return SettingsState(
      musicVolume: musicVolume ?? this.musicVolume,
      effectsVolume: effectsVolume ?? this.effectsVolume,
      voiceVolume: voiceVolume ?? this.voiceVolume,
      isVoiceMuted: isVoiceMuted ?? this.isVoiceMuted,
      voiceSex: voiceSex ?? this.voiceSex,
      language: language ?? this.language,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isVrMode: isVrMode ?? this.isVrMode,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      vrCalibrated: vrCalibrated ?? this.vrCalibrated,
      vrBiasX: vrBiasX ?? this.vrBiasX,
      vrBiasZ: vrBiasZ ?? this.vrBiasZ,
      qualityPreset: qualityPreset ?? this.qualityPreset,
    );
  }

  @override
  List<Object?> get props => [
        musicVolume,
        effectsVolume,
        voiceVolume,
        isVoiceMuted,
        voiceSex,
        language,
        isUnlocked,
        isVrMode,
        isDarkTheme,
        vrCalibrated,
        vrBiasX,
        vrBiasZ,
        qualityPreset,
      ];
}

/// Gestisce lo stato e la persistenza offline delle preferenze
class SettingsNotifier extends Notifier<SettingsState> {
  SharedPreferences? _prefs;

  @override
  SettingsState build() {
    _prefs = ref.watch(sharedPrefsInstanceProvider);

    final bool isTest =
        !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');
    final defaultLang =
        (PlatformDispatcher.instance.locale.languageCode == 'it' || isTest)
            ? 0
            : 1;

    // Default state
    final defaultState = SettingsState(
      musicVolume: 3,
      effectsVolume: 3,
      voiceVolume: 3,
      isVoiceMuted: false,
      voiceSex: 0,
      language: defaultLang,
      isUnlocked: false,
      isVrMode: false,
      isDarkTheme: true,
      vrCalibrated: false,
      vrBiasX: 0.0,
      vrBiasZ: 0.0,
      qualityPreset: QualityPreset.highFidelity,
    );

    if (_prefs == null) {
      return defaultState;
    }

    // Initialize from prefs
    final music = _prefs!.getInt("Music") ?? 3;
    final effects = _prefs!.getInt("Effects") ?? 3;
    final voice = _prefs!.getInt("Voice") ?? 3;
    final muteVoice = _prefs!.getBool("MuteVoice") ?? false;
    final sex = _prefs!.getInt("VoiceSex") ?? 0;
    final lang = _prefs!.getInt("Lang") ?? defaultLang;
    final unlocked = _prefs!.getBool("IsUnlocked") ?? false;
    final darkTheme = _prefs!.getBool("IsDarkTheme") ?? true;
    final vrCalibrated = _prefs!.getBool("VrCalibrated") ?? false;
    final vrBiasX = _prefs!.getDouble("VrBiasX") ?? 0.0;
    final vrBiasZ = _prefs!.getDouble("VrBiasZ") ?? 0.0;
    final qualityInt = _prefs!.getInt("QualityPreset") ?? 0;
    final qualityPreset = QualityPreset.fromValue(qualityInt);

    return SettingsState(
      musicVolume: music,
      effectsVolume: effects,
      voiceVolume: voice,
      isVoiceMuted: muteVoice,
      voiceSex: sex,
      language: lang,
      isUnlocked: unlocked,
      isVrMode: false,
      isDarkTheme: darkTheme,
      vrCalibrated: vrCalibrated,
      vrBiasX: vrBiasX,
      vrBiasZ: vrBiasZ,
      qualityPreset: qualityPreset,
    );
  }

  /// Modifica il profilo grafico UaaL (Alta Fedeltà / Eco) e lo salva offline
  Future<void> changeQualityPreset(QualityPreset preset) async {
    state = state.copyWith(qualityPreset: preset);
    await _prefs?.setInt("QualityPreset", preset.value);
  }

  /// Modifica il volume della musica e lo salva offline
  Future<void> changeMusicVolume(int volume) async {
    state = state.copyWith(musicVolume: volume);
    await _prefs?.setInt("Music", volume);
    ref
        .read(audioServiceProvider)
        .whenData((service) => service.setAmbientVolume(volume));
  }

  /// Modifica il volume degli effetti e lo salva offline
  Future<void> changeEffectsVolume(int volume) async {
    state = state.copyWith(effectsVolume: volume);
    await _prefs?.setInt("Effects", volume);
    ref
        .read(audioServiceProvider)
        .whenData((service) => service.setEffectsVolume(volume));
  }

  /// Modifica il volume della voce e lo salva offline
  Future<void> changeVoiceVolume(int volume) async {
    state = state.copyWith(voiceVolume: volume);
    await _prefs?.setInt("Voice", volume);
    ref
        .read(audioServiceProvider)
        .whenData((service) => service.setVoiceVolume(volume));
  }

  /// Cambia lo stato di Mute della voce
  Future<void> toggleVoiceMute(bool isMuted) async {
    state = state.copyWith(isVoiceMuted: isMuted);
    await _prefs?.setBool("MuteVoice", isMuted);
    ref
        .read(audioServiceProvider)
        .whenData((service) => service.setVoiceMute(isMuted));
  }

  /// Cambia il genere della voce (0 = Maschile, 1 = Femminile)
  Future<void> changeVoiceSex(int sex) async {
    state = state.copyWith(voiceSex: sex);
    await _prefs?.setInt("VoiceSex", sex);
  }

  /// Cambia la lingua dell'applicazione (0 = Italiano, 1 = Inglese)
  Future<void> changeLanguage(int lang) async {
    state = state.copyWith(language: lang);
    await _prefs?.setInt("Lang", lang);
  }

  /// Sblocca la versione Premium completa dell'app
  Future<void> unlockPremium() async {
    state = state.copyWith(isUnlocked: true);
    await _prefs?.setBool("IsUnlocked", true);
  }

  /// Blocca la versione Premium dell'app (re-imposta stato Free)
  Future<void> lockPremium() async {
    state = state.copyWith(isUnlocked: false);
    await _prefs?.setBool("IsUnlocked", false);
  }

  /// Commuta lo stato di sblocco dell'app per test e sviluppo con persistenza
  Future<void> togglePremiumSimulation([bool? forceState]) async {
    final next = forceState ?? !state.isUnlocked;
    state = state.copyWith(isUnlocked: next);
    await _prefs?.setBool("IsUnlocked", next);
  }

  /// Attiva o disattiva la modalità VR per la sessione corrente (non persistita)
  void toggleVrMode(bool enabled) {
    state = state.copyWith(isVrMode: enabled);
    // Non viene salvata su SharedPreferences: la modalità VR è sempre falsa all'avvio dell'app
  }

  /// Attiva o disattiva il tema scuro Japandi
  Future<void> toggleDarkTheme(bool enabled) async {
    state = state.copyWith(isDarkTheme: enabled);
    await _prefs?.setBool("IsDarkTheme", enabled);
  }

  /// Salva la calibrazione del giroscopio VR
  Future<void> saveVrCalibration(double biasX, double biasZ) async {
    state = state.copyWith(vrCalibrated: true, vrBiasX: biasX, vrBiasZ: biasZ);
    await _prefs?.setBool("VrCalibrated", true);
    await _prefs?.setDouble("VrBiasX", biasX);
    await _prefs?.setDouble("VrBiasZ", biasZ);
  }

  /// Resetta la calibrazione del giroscopio VR
  Future<void> resetVrCalibration() async {
    state = state.copyWith(vrCalibrated: false, vrBiasX: 0.0, vrBiasZ: 0.0);
    await _prefs?.setBool("VrCalibrated", false);
    await _prefs?.setDouble("VrBiasX", 0.0);
    await _prefs?.setDouble("VrBiasZ", 0.0);
  }
}

// --- PROVIDERS ---

/// Provider globale per SharedPreferences (inizializzato nel main).
/// Ritorna null se SharedPreferences non è ancora stato inizializzato.
/// I consumer devono gestire il caso null (es. mostrare loading).
final sharedPrefsProvider = Provider<SharedPreferences?>((ref) {
  return ref.watch(sharedPrefsInstanceProvider);
});

/// Provider globale per GuidoAudioService (inizializzato a inizio app).
/// Se l'inizializzazione della sessione audio fallisce (es. conflitto audio
/// su iOS, permessi negati), il servizio viene comunque restituito per
/// consentire la riproduzione locale senza sessione di sistema configurata.
final audioServiceProvider = FutureProvider<GuidoAudioService>((ref) async {
  final service = GuidoAudioService();
  try {
    await service.initSession();
  } catch (e, st) {
    debugPrint(
      '[audioServiceProvider] Fallback: audio session init failed, '
      'continuing without system audio session: $e\n$st',
    );
  }
  ref.onDispose(() => service.dispose()); // Previene memory leaks
  return service;
});

/// Provider globale dello stato delle impostazioni dell'app
final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

/// Provider globale per controllare l'indice del tab attivo da qualsiasi schermata
final activeTabProvider = StateProvider<int>((ref) => 0);
