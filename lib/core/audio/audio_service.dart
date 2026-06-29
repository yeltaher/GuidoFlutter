import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:audio_session/audio_session.dart';

/// Servizio audio multitraccia enterprise-grade per gestire riproduzioni simultanee
/// di voci guida e musiche ambientali offline, con controllo dei volumi indipendente.
class GuidoAudioService {
  late AudioPlayer _voicePlayer;
  late AudioPlayer _ambientPlayer;
  late AudioPlayer _effectsPlayer;

  // Riferimenti ai volumi lineari (da 0.0 a 1.0) ricavati dagli indici delle preferenze (0, 1, 2, 3)
  double _voiceVolume = 1.0;
  double _ambientVolume = 1.0;
  double _effectsVolume = 1.0;
  bool _isVoiceMuted = false;

  GuidoAudioService() {
    _voicePlayer = AudioPlayer();
    _ambientPlayer = AudioPlayer();
    _effectsPlayer = AudioPlayer();
  }

  /// Inizializza la sessione audio a livello di sistema operativo
  /// per consentire la riproduzione in background a schermo spento.
  Future<void> initSession() async {
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.none,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ),
    );
  }

  /// Mappa gli indici delle preferenze (0, 1, 2, 3) su valori di volume lineare (0.0 -> 1.0)
  double _mapIndexToVolume(int index) {
    switch (index) {
      case 0:
        return 0.0;
      case 1:
        return 0.33;
      case 2:
        return 0.66;
      case 3:
      default:
        return 1.0;
    }
  }

  /// Imposta il volume della Voce Guida
  void setVoiceVolume(int volumeIndex) {
    _voiceVolume = _mapIndexToVolume(volumeIndex);
    if (!_isVoiceMuted) {
      _voicePlayer.setVolume(_voiceVolume);
    }
  }

  /// Gestisce l'opzione Mute specifica per la voce guida (risolvendo il bug originario in Unity)
  void setVoiceMute(bool isMuted) {
    _isVoiceMuted = isMuted;
    _voicePlayer.setVolume(_isVoiceMuted ? 0.0 : _voiceVolume);
  }

  /// Imposta il volume della Musica Ambientale
  void setAmbientVolume(int volumeIndex) {
    _ambientVolume = _mapIndexToVolume(volumeIndex);
    _ambientPlayer.setVolume(_ambientVolume);
  }

  /// Imposta il volume degli Effetti (Respirazioni)
  void setEffectsVolume(int volumeIndex) {
    _effectsVolume = _mapIndexToVolume(volumeIndex);
    _effectsPlayer.setVolume(_effectsVolume);
  }

  /// Avvia la riproduzione della Voce Guida (Mono/Stereo)
  Future<void> playVoice(String assetPath) async {
    try {
      await _voicePlayer.setAsset(assetPath);
      _voicePlayer.setVolume(_isVoiceMuted ? 0.0 : _voiceVolume);
      await _voicePlayer.play();
    } catch (e) {
      debugPrint("[AudioService ERR] Errore riproduzione voce: $e");
    }
  }

  /// Avvia la riproduzione della Musica Ambientale in loop continuo
  Future<void> playAmbient(String assetPath) async {
    try {
      await _ambientPlayer.setAsset(assetPath);
      await _ambientPlayer.setLoopMode(LoopMode.one);
      _ambientPlayer.setVolume(_ambientVolume);
      await _ambientPlayer.play();
    } catch (e) {
      debugPrint("[AudioService ERR] Errore riproduzione ambient: $e");
    }
  }

  /// Avvia la riproduzione degli Effetti Sonori in loop continuo (se applicabile, es. bolle o battito)
  Future<void> playEffect(String assetPath, {bool loop = true}) async {
    try {
      await _effectsPlayer.setAsset(assetPath);
      if (loop) {
        await _effectsPlayer.setLoopMode(LoopMode.one);
      } else {
        await _effectsPlayer.setLoopMode(LoopMode.off);
      }
      _effectsPlayer.setVolume(_effectsVolume);
      await _effectsPlayer.play();
    } catch (e) {
      debugPrint("[AudioService ERR] Errore riproduzione effetto: $e");
    }
  }

  /// Mette in pausa tutte le riproduzioni contemporaneamente
  Future<void> pauseAll() async {
    await Future.wait([
      _voicePlayer.pause(),
      _ambientPlayer.pause(),
      _effectsPlayer.pause(),
    ]);
  }

  /// Riprende tutte le riproduzioni messe in pausa
  Future<void> resumeAll() async {
    await Future.wait([
      if (_voicePlayer.duration != null) _voicePlayer.play(),
      if (_ambientPlayer.duration != null) _ambientPlayer.play(),
      if (_effectsPlayer.duration != null) _effectsPlayer.play(),
    ]);
  }

  /// Ferma e resetta tutti i lettori audio
  Future<void> stopAll() async {
    await Future.wait([
      _voicePlayer.stop(),
      _ambientPlayer.stop(),
      _effectsPlayer.stop(),
    ]);
  }

  /// Libera le risorse dei lettori audio (Previene Memory Leaks)
  void dispose() {
    _voicePlayer.dispose();
    _ambientPlayer.dispose();
    _effectsPlayer.dispose();
  }

  /// Espone lo stream dello stato del player degli effetti per sapere quando finisce
  Stream<PlayerState> get effectsPlayerStateStream =>
      _effectsPlayer.playerStateStream;
}
