import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:audio_session/audio_session.dart';

/// Logger difensivo per il modulo audio
class AppLogger {
  static void info(String message) => debugPrint('[AudioService] $message');
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (error != null) {
      debugPrint('[AudioService ERR] $message: $error');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    } else {
      debugPrint('[AudioService ERR] $message');
    }
  }
}

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

  bool _isStopped = false;
  int _voiceSessionId = 0;
  int _ambientSessionId = 0;
  int _effectsSessionId = 0;

  StreamSubscription<AudioInterruptionEvent>? _interruptionSubscription;
  StreamSubscription<void>? _becomingNoisySubscription;

  bool get isStopped => _isStopped;

  GuidoAudioService() {
    _voicePlayer = AudioPlayer();
    _ambientPlayer = AudioPlayer();
    _effectsPlayer = AudioPlayer();
  }

  /// Inizializza la sessione audio a livello di sistema operativo
  /// per consentire la riproduzione in background a schermo spento e in modalità silenziosa.
  Future<void> initSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(
        AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playback,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.mixWithOthers |
                  AVAudioSessionCategoryOptions.defaultToSpeaker,
          avAudioSessionMode: AVAudioSessionMode.defaultMode,
          avAudioSessionRouteSharingPolicy:
              AVAudioSessionRouteSharingPolicy.defaultPolicy,
          avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
          androidAudioAttributes: const AndroidAudioAttributes(
            contentType: AndroidAudioContentType.music,
            usage: AndroidAudioUsage.media,
          ),
          androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
          androidWillPauseWhenDucked: true,
        ),
      );

      _interruptionSubscription?.cancel();
      _interruptionSubscription =
          session.interruptionEventStream.listen((event) {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
              _voicePlayer.setVolume(_voiceVolume * 0.5);
              _ambientPlayer.setVolume(_ambientVolume * 0.5);
              _effectsPlayer.setVolume(_effectsVolume * 0.5);
              break;
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              pauseAll();
              break;
          }
        } else {
          switch (event.type) {
            case AudioInterruptionType.duck:
              _voicePlayer.setVolume(_isVoiceMuted ? 0.0 : _voiceVolume);
              _ambientPlayer.setVolume(_ambientVolume);
              _effectsPlayer.setVolume(_effectsVolume);
              break;
            case AudioInterruptionType.pause:
              resumeAll();
              break;
            case AudioInterruptionType.unknown:
              break;
          }
        }
      });

      _becomingNoisySubscription?.cancel();
      _becomingNoisySubscription =
          session.becomingNoisyEventStream.listen((_) {
        pauseAll();
      });
    } catch (e, st) {
      AppLogger.error('Errore configurazione AudioSession', e, st);
    }
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

  /// Normalizza il percorso dell'asset assicurandosi che sia conforme a Flutter/just_audio
  String _normalizeAssetPath(String path) {
    var clean = path.trim();
    if (clean.isEmpty) return clean;
    if (clean.startsWith('/')) {
      clean = clean.substring(1);
    }
    if (!clean.startsWith('assets/')) {
      clean = 'assets/$clean';
    }
    return clean;
  }

  /// Avvia la riproduzione della Voce Guida (Mono/Stereo)
  Future<void> playVoice(String assetPath) async {
    _isStopped = false;
    final currentSession = ++_voiceSessionId;
    if (assetPath.trim().isEmpty) return;
    try {
      final session = await AudioSession.instance;
      await session.setActive(true);
      final normalized = _normalizeAssetPath(assetPath);
      await _voicePlayer.setAsset(normalized);
      if (_isStopped || currentSession != _voiceSessionId) {
        await _voicePlayer.stop();
        return;
      }
      _voicePlayer.setVolume(_isVoiceMuted ? 0.0 : _voiceVolume);
      if (_isStopped || currentSession != _voiceSessionId) {
        await _voicePlayer.stop();
        return;
      }
      await _voicePlayer.play();
    } catch (e, st) {
      AppLogger.error("Errore riproduzione voce", e, st);
    }
  }

  /// Avvia la riproduzione della Musica Ambientale in loop continuo
  Future<void> playAmbient(String assetPath) async {
    _isStopped = false;
    final currentSession = ++_ambientSessionId;
    if (assetPath.trim().isEmpty) return;
    try {
      final session = await AudioSession.instance;
      await session.setActive(true);
      final normalized = _normalizeAssetPath(assetPath);
      await _ambientPlayer.setAsset(normalized);
      if (_isStopped || currentSession != _ambientSessionId) {
        await _ambientPlayer.stop();
        return;
      }
      await _ambientPlayer.setLoopMode(LoopMode.one);
      _ambientPlayer.setVolume(_ambientVolume);
      if (_isStopped || currentSession != _ambientSessionId) {
        await _ambientPlayer.stop();
        return;
      }
      await _ambientPlayer.play();
    } catch (e, st) {
      AppLogger.error("Errore riproduzione ambient", e, st);
    }
  }

  /// Avvia la riproduzione degli Effetti Sonori in loop continuo (se applicabile, es. bolle o battito)
  Future<void> playEffect(String assetPath, {bool loop = true}) async {
    _isStopped = false;
    final currentSession = ++_effectsSessionId;
    if (assetPath.trim().isEmpty) return;
    try {
      final session = await AudioSession.instance;
      await session.setActive(true);
      final normalized = _normalizeAssetPath(assetPath);
      await _effectsPlayer.setAsset(normalized);
      if (_isStopped || currentSession != _effectsSessionId) {
        await _effectsPlayer.stop();
        return;
      }
      if (loop) {
        await _effectsPlayer.setLoopMode(LoopMode.one);
      } else {
        await _effectsPlayer.setLoopMode(LoopMode.off);
      }
      _effectsPlayer.setVolume(_effectsVolume);
      if (_isStopped || currentSession != _effectsSessionId) {
        await _effectsPlayer.stop();
        return;
      }
      await _effectsPlayer.play();
    } catch (e, st) {
      AppLogger.error("Errore riproduzione effetto", e, st);
    }
  }

  /// Mette in pausa tutte le riproduzioni contemporaneamente
  Future<void> pauseAll() async {
    try {
      await Future.wait([
        _voicePlayer.pause(),
        _ambientPlayer.pause(),
        _effectsPlayer.pause(),
      ]);
    } catch (e, st) {
      AppLogger.error("Errore pauseAll", e, st);
    }
  }

  /// Riprende tutte le riproduzioni messe in pausa
  Future<void> resumeAll() async {
    if (_isStopped) return;
    try {
      await Future.wait([
        if (_voicePlayer.duration != null) _voicePlayer.play(),
        if (_ambientPlayer.duration != null) _ambientPlayer.play(),
        if (_effectsPlayer.duration != null) _effectsPlayer.play(),
      ]);
    } catch (e, st) {
      AppLogger.error("Errore resumeAll", e, st);
    }
  }

  /// Deattiva la sessione nativa AudioSession rilasciando il background audio
  Future<void> deactivateAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.setActive(
        false,
        avAudioSessionSetActiveOptions:
            AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation,
      );
    } catch (e, st) {
      AppLogger.error('Errore deattivazione AudioSession nativa', e, st);
    }
  }

  /// Ferma e resetta simultaneamente tutti i lettori audio,
  /// deattivando la sessione nativa AudioSession su iOS per rilasciare
  /// lo stato di background audio e i controlli del blocco schermo.
  Future<void> stopAll() async {
    _isStopped = true;
    _voiceSessionId++;
    _ambientSessionId++;
    _effectsSessionId++;

    try {
      await Future.wait([
        _voicePlayer.stop(),
        _ambientPlayer.stop(),
        _effectsPlayer.stop(),
      ]);
    } catch (e, st) {
      AppLogger.error('Errore arresto contemporaneo player', e, st);
    }

    try {
      await Future.wait([
        _ambientPlayer.setLoopMode(LoopMode.off),
        _effectsPlayer.setLoopMode(LoopMode.off),
      ]);
    } catch (e, st) {
      AppLogger.error('Errore reset loop mode', e, st);
    }

    await deactivateAudioSession();
  }

  /// Libera le risorse dei lettori audio (Previene Memory Leaks)
  void dispose() {
    _isStopped = true;
    _voiceSessionId++;
    _ambientSessionId++;
    _effectsSessionId++;
    _interruptionSubscription?.cancel();
    _becomingNoisySubscription?.cancel();
    try {
      _voicePlayer.dispose();
      _ambientPlayer.dispose();
      _effectsPlayer.dispose();
    } catch (e, st) {
      AppLogger.error('Errore dispose player', e, st);
    }
  }

  /// Ferma la voce guida lasciando intatta la musica ambientale
  Future<void> stopVoice() async {
    _voiceSessionId++;
    try {
      await _voicePlayer.stop();
    } catch (e, st) {
      AppLogger.error('Errore stopVoice', e, st);
    }
  }

  /// Espone lo stream dello stato del player degli effetti per sapere quando finisce
  Stream<PlayerState> get effectsPlayerStateStream =>
      _effectsPlayer.playerStateStream;

  /// Espone lo stream dello stato del player della voce per sapere quando la guida finisce
  Stream<PlayerState> get voicePlayerStateStream =>
      _voicePlayer.playerStateStream;
}
