import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../audio/audio_service.dart';

/// Rappresenta lo stato completo delle preferenze e sblocchi dell'app
class SettingsState {
  final int musicVolume;     // 0 = Mute, 1 = Low, 2 = Mid, 3 = High
  final int effectsVolume;   // 0 = Mute, 1 = Low, 2 = Mid, 3 = High
  final int voiceVolume;     // 0 = Mute, 1 = Low, 2 = Mid, 3 = High
  final bool isVoiceMuted;   // Se la voce guida è silenziata
  final int voiceSex;        // 0 = Maschile, 1 = Femminile
  final int language;        // 0 = Italiano, 1 = Inglese
  final bool isUnlocked;     // Se l'app premium è sbloccata
  final bool isVrMode;       // Se la visualizzazione VR stereoscopica è attiva
  final bool isDarkTheme;    // Se il tema scuro Japandi è attivo
  final bool vrCalibrated;   // Se la calibrazione VR è stata effettuata
  final double vrBiasX;      // Drift asse X giroscopio
  final double vrBiasZ;      // Drift asse Z giroscopio

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
    );
  }
}

/// Gestisce lo stato e la persistenza offline delle preferenze
class SettingsNotifier extends StateNotifier<SettingsState> {
  final SharedPreferences _prefs;
  final GuidoAudioService _audioService;

  SettingsNotifier(this._prefs, this._audioService)
      : super(const SettingsState(
          musicVolume: 3,
          effectsVolume: 3,
          voiceVolume: 3,
          isVoiceMuted: false,
          voiceSex: 0,
          language: 0,
          isUnlocked: false,
          isVrMode: false,
          isDarkTheme: true, // Default a tema Japandi Dark per la meditazione
          vrCalibrated: false,
          vrBiasX: 0.0,
          vrBiasZ: 0.0,
        )) {
    _loadFromPrefs();
  }

  /// Carica le impostazioni da SharedPreferences e inizializza il servizio audio
  void _loadFromPrefs() {
    final music = _prefs.getInt("Music") ?? 3;
    final effects = _prefs.getInt("Effects") ?? 3;
    final voice = _prefs.getInt("Voice") ?? 3;
    final muteVoice = _prefs.getBool("MuteVoice") ?? false;
    final sex = _prefs.getInt("VoiceSex") ?? 0;
    final lang = _prefs.getInt("Lang") ?? 0;
    final unlocked = _prefs.getBool("IsUnlocked") ?? false;
    final vrMode = false; // VR è una scelta per-sessione, non viene mai persistita tra le sessioni
    final darkTheme = _prefs.getBool("IsDarkTheme") ?? true;
    final vrCalibrated = _prefs.getBool("VrCalibrated") ?? false;
    final vrBiasX = _prefs.getDouble("VrBiasX") ?? 0.0;
    final vrBiasZ = _prefs.getDouble("VrBiasZ") ?? 0.0;

    state = SettingsState(
      musicVolume: music,
      effectsVolume: effects,
      voiceVolume: voice,
      isVoiceMuted: muteVoice,
      voiceSex: sex,
      language: lang,
      isUnlocked: unlocked,
      isVrMode: vrMode,
      isDarkTheme: darkTheme,
      vrCalibrated: vrCalibrated,
      vrBiasX: vrBiasX,
      vrBiasZ: vrBiasZ,
    );

    // Inizializza i volumi reali nel servizio audio in base a quanto caricato
    _audioService.setAmbientVolume(music);
    _audioService.setEffectsVolume(effects);
    _audioService.setVoiceVolume(voice);
    _audioService.setVoiceMute(muteVoice);
  }

  /// Modifica il volume della musica e lo salva offline
  Future<void> changeMusicVolume(int volume) async {
    state = state.copyWith(musicVolume: volume);
    await _prefs.setInt("Music", volume);
    _audioService.setAmbientVolume(volume);
  }

  /// Modifica il volume degli effetti e lo salva offline
  Future<void> changeEffectsVolume(int volume) async {
    state = state.copyWith(effectsVolume: volume);
    await _prefs.setInt("Effects", volume);
    _audioService.setEffectsVolume(volume);
  }

  /// Modifica il volume della voce e lo salva offline
  Future<void> changeVoiceVolume(int volume) async {
    state = state.copyWith(voiceVolume: volume);
    await _prefs.setInt("Voice", volume);
    _audioService.setVoiceVolume(volume);
  }

  /// Cambia lo stato di Mute della voce
  Future<void> toggleVoiceMute(bool isMuted) async {
    state = state.copyWith(isVoiceMuted: isMuted);
    await _prefs.setBool("MuteVoice", isMuted);
    _audioService.setVoiceMute(isMuted);
  }

  /// Cambia il genere della voce (0 = Maschile, 1 = Femminile)
  Future<void> changeVoiceSex(int sex) async {
    state = state.copyWith(voiceSex: sex);
    await _prefs.setInt("VoiceSex", sex);
  }

  /// Cambia la lingua dell'applicazione (0 = Italiano, 1 = Inglese)
  Future<void> changeLanguage(int lang) async {
    state = state.copyWith(language: lang);
    await _prefs.setInt("Lang", lang);
  }

  /// Sblocca la versione Premium completa dell'app
  Future<void> unlockPremium() async {
    state = state.copyWith(isUnlocked: true);
    await _prefs.setBool("IsUnlocked", true);
  }

  /// Attiva o disattiva la modalità VR per la sessione corrente (non persistita)
  void toggleVrMode(bool enabled) {
    state = state.copyWith(isVrMode: enabled);
    // Non viene salvata su SharedPreferences: la modalità VR è sempre falsa all'avvio dell'app
  }

  /// Attiva o disattiva il tema scuro Japandi
  Future<void> toggleDarkTheme(bool enabled) async {
    state = state.copyWith(isDarkTheme: enabled);
    await _prefs.setBool("IsDarkTheme", enabled);
  }

  /// Salva la calibrazione del giroscopio VR
  Future<void> saveVrCalibration(double biasX, double biasZ) async {
    state = state.copyWith(
      vrCalibrated: true,
      vrBiasX: biasX,
      vrBiasZ: biasZ,
    );
    await _prefs.setBool("VrCalibrated", true);
    await _prefs.setDouble("VrBiasX", biasX);
    await _prefs.setDouble("VrBiasZ", biasZ);
  }

  /// Resetta la calibrazione del giroscopio VR
  Future<void> resetVrCalibration() async {
    state = state.copyWith(
      vrCalibrated: false,
      vrBiasX: 0.0,
      vrBiasZ: 0.0,
    );
    await _prefs.setBool("VrCalibrated", false);
    await _prefs.setDouble("VrBiasX", 0.0);
    await _prefs.setDouble("VrBiasZ", 0.0);
  }
}

// --- PROVIDERS ---

/// Provider globale per SharedPreferences (inizializzato nel main)
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

/// Provider globale per GuidoAudioService (inizializzato a inizio app)
final audioServiceProvider = Provider<GuidoAudioService>((ref) {
  final service = GuidoAudioService();
  service.initSession(); // Inizializza asincrono in background
  ref.onDispose(() => service.dispose()); // Previene memory leaks
  return service;
});

/// Provider globale dello stato delle impostazioni dell'app
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  final audio = ref.watch(audioServiceProvider);
  return SettingsNotifier(prefs, audio);
});

/// Provider globale per controllare l'indice del tab attivo da qualsiasi schermata
final activeTabProvider = StateProvider<int>((ref) => 0);
