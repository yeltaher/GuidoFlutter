import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:audio_session/audio_session.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter_rotation_sensor/flutter_rotation_sensor.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';
import '../../../core/database/repositories/user_repository.dart';
import '../domain/vr_experience_type.dart';
import '../application/local_vr_server_service.dart';

/// Schermata immersiva a tutto schermo orizzontale (Landscape Fullscreen) per la
/// fruizione offline ad altissime prestazioni delle esperienze 3D Three.js e WebXR.
///
/// Integra controlli hardware per audio a 432 Hz su iOS (bypassa lo switch muto),
/// WakelockPlus per prevenire lo standby, bridge JavaScript bidirezionale e
/// teardown atomico WebGL per garantire Zero Memory Leaks.
class VrExperienceScreen extends ConsumerStatefulWidget {
  final String experienceId;
  final bool isVrMode;
  final bool autoStart;

  const VrExperienceScreen({
    super.key,
    required this.experienceId,
    this.isVrMode = false,
    this.autoStart = true,
  });

  @override
  ConsumerState<VrExperienceScreen> createState() => VrExperienceScreenState();
}

class VrExperienceScreenState extends ConsumerState<VrExperienceScreen> {
  InAppWebViewController? _webViewController;
  late final VrExperienceType _experienceType;

  bool _isServerReady = false;
  bool _isWebReady = false;
  bool _isVrMode = false;
  bool _isExiting = false;
  bool _brightnessOverridden = false;
  bool _isSessionCompleted = false;
  bool _hasRecordedCurrentCompletion = false;
  Timer? _serverPollTimer;
  StreamSubscription<OrientationEvent>? _rotationSubscription;
  int _lastSensorTimestampMs = 0;

  @visibleForTesting
  bool get isSessionCompletedForTesting => _isSessionCompleted;

  @visibleForTesting
  void simulateSessionCompleteForTesting([dynamic data]) {
    _handleSessionComplete(data);
  }

  @override
  void initState() {
    super.initState();
    _experienceType = VrExperienceType.fromId(widget.experienceId);
    _isVrMode = widget.isVrMode;

    if (_isVrMode) {
      _startNativeSensorStream();
      _applyVrBrightness();
    }

    _setupEnvironment();
  }

  /// Avvia lo stream di campionamento dal sensore nativo di rotazione a ~60 Hz
  /// e inoltra gli angoli di Eulero alla scena Three.js WebXR.
  void _startNativeSensorStream() {
    _rotationSubscription?.cancel();
    if (!RotationSensor.isPlatformSupported) return;

    try {
      RotationSensor.coordinateSystem = CoordinateSystem.device();
      RotationSensor.samplingPeriod = const Duration(milliseconds: 16);
      _rotationSubscription = RotationSensor.orientationStream.listen((data) {
        if (!_isVrMode || _webViewController == null || _isExiting) return;

        // Limita il throughput verso il bridge JavaScript a max ~60 FPS
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - _lastSensorTimestampMs < 15) return;
        _lastSensorTimestampMs = now;

        final alpha = (data.eulerAngles.azimuth * 180 / math.pi) % 360;
        final beta = data.eulerAngles.pitch * 180 / math.pi;
        final gamma = data.eulerAngles.roll * 180 / math.pi;

        if (alpha.isNaN || beta.isNaN || gamma.isNaN) return;

        _webViewController?.evaluateJavascript(
          source: 'if (window.GuidoVR && window.GuidoVR.setDeviceOrientation) '
                  'window.GuidoVR.setDeviceOrientation($alpha, $beta, $gamma);',
        );
      });
    } catch (e) {
      debugPrint('[VrExperienceScreen] Errore avvio sensore rotazione: $e');
    }
  }

  /// Ferma e rilascia la sottoscrizione allo stream del sensore di rotazione
  void _stopNativeSensorStream() {
    _rotationSubscription?.cancel();
    _rotationSubscription = null;
  }

  /// Imposta una luminosità hardware confortevole anti-abbagliamento per il visore (~0.38)
  Future<void> _applyVrBrightness() async {
    try {
      await ScreenBrightness.instance.setApplicationScreenBrightness(0.38);
      _brightnessOverridden = true;
    } catch (e) {
      debugPrint('[VrExperienceScreen] Errore ScreenBrightness: $e');
    }
  }

  /// Ripristina la luminosità originaria del sistema
  Future<void> _restoreBrightness() async {
    if (!_brightnessOverridden) return;
    try {
      await ScreenBrightness.instance.resetApplicationScreenBrightness();
      _brightnessOverridden = false;
    } catch (e) {
      debugPrint('[VrExperienceScreen] Errore reset ScreenBrightness: $e');
    }
  }

  /// Configura l'ambiente nativo del dispositivo (orientamento landscape,
  /// fullscreen immersivo, wakelock e profilo audio).
  Future<void> _setupEnvironment() async {
    try {
      // 1. Forza orientamento orizzontale e fullscreen immersivo senza barre di sistema
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      debugPrint('[VrExperienceScreen] Errore configurazione SystemChrome: $e');
    }

    try {
      // 2. Mantieni lo schermo acceso durante l'esperienza
      await WakelockPlus.enable();
    } catch (e) {
      debugPrint('[VrExperienceScreen] Errore Wakelock: $e');
    }

    try {
      // 3. Ferma qualsiasi audio nativo di sottofondo preesistente in Guido
      final audioService = ref.read(audioServiceProvider).valueOrNull;
      await audioService?.stopAll();

      // 4. Configura AudioSession a livello OS su Playback (bypassa il tasto Muto di iPhone)
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      await session.setActive(true);
    } catch (e) {
      debugPrint('[VrExperienceScreen] Errore configurazione AudioSession: $e');
    }

    // 5. Avvia InAppLocalhostServer se non ancora in esecuzione
    final serverService = ref.read(localVrServerServiceProvider);
    await serverService.startServer();

    if (mounted) {
      setState(() {
        _isServerReady = true;
      });
    }
  }

  /// Teardown rigoroso per evitare leak di contesti WebGL su GPU e arrestare i grafi Web Audio
  Future<void> _safeTeardownAndExit() async {
    if (_isExiting) return;
    _isExiting = true;

    await _cleanupNativeAndWebGlResources();

    if (mounted) {
      context.pop();
    }
  }

  /// Esegue la pulizia e disallocazione di tutte le risorse native, audio e WebGL.
  Future<void> _cleanupNativeAndWebGlResources() async {
    _stopNativeSensorStream();
    try {
      // 1. Invoca la routine di pulizia JavaScript interna alla pagina Three.js
      await _webViewController?.evaluateJavascript(
        source: '''
        (function() {
          try {
            if (window.GuidoVR && typeof window.GuidoVR.dispose === 'function') {
              window.GuidoVR.dispose();
            } else {
              if (window.animFrameId) cancelAnimationFrame(window.animFrameId);
              if (window.audioCtx && typeof window.audioCtx.close === 'function') {
                window.audioCtx.close();
              }
              var audios = document.querySelectorAll('audio');
              audios.forEach(function(a) { 
                try { a.pause(); a.src = ''; } catch(e){} 
              });
            }
          } catch(err) {
            console.error('Error during JS dispose:', err);
          }
        })();
        ''',
      );
    } catch (e) {
      debugPrint('[VrExperienceScreen] Eccezione evaluateJavascript dispose: $e');
    }

    try {
      // 2. Carica about:blank per forzare la WebView a distruggere il DOM e il contesto WebGL
      await _webViewController?.loadUrl(
        urlRequest: URLRequest(url: WebUri('about:blank')),
      );
    } catch (e) {
      debugPrint('[VrExperienceScreen] Eccezione loadUrl about:blank: $e');
    }

    _webViewController = null;
    _serverPollTimer?.cancel();

    try {
      // 3. Ripristina l'orientamento verticale standard e la visualizzazione edge-to-edge
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    } catch (e) {
      debugPrint('[VrExperienceScreen] Errore ripristino SystemChrome: $e');
    }

    try {
      // 4. Rilascia il Wakelock
      await WakelockPlus.disable();
    } catch (e) {
      debugPrint('[VrExperienceScreen] Errore rilascio Wakelock: $e');
    }

    try {
      // 5. Deattiva la sessione audio
      final session = await AudioSession.instance;
      await session.setActive(false);
    } catch (e) {
      debugPrint('[VrExperienceScreen] Errore rilascio AudioSession: $e');
    }

    // 6. Ripristina luminosità hardware originaria
    await _restoreBrightness();
  }

  /// Invia il comando di ricalibrazione del centro / orizzonte al motore WebXR Three.js
  void _recenterVrView() {
    _webViewController?.evaluateJavascript(
      source: 'if (window.GuidoVR && window.GuidoVR.recenter) window.GuidoVR.recenter();',
    );
    HapticFeedback.mediumImpact();
  }

  /// Mostra la finestra modale Japandi di conferma uscita
  Future<void> _handleExitAttempt() async {
    final settings = ref.read(settingsProvider);
    final isIt = settings.language == 0;
    final isDark = settings.isDarkTheme;

    final shouldExit = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (dialogCtx) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 420),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF16191E) : const Color(0xFFF5F2EC),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.goldAccent.withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.self_improvement_rounded,
                    size: 38,
                    color: AppColors.goldAccent,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isIt ? 'Concludere l\'esperienza?' : 'End the experience?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isIt
                      ? 'Desideri uscire dalla sessione e tornare alla schermata principale?'
                      : 'Do you want to leave the session and return to the main screen?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(dialogCtx).pop(false),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDark ? Colors.white24 : Colors.black26,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            isIt ? 'CONTINUA' : 'RESUME',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(dialogCtx).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.dangerAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            isIt ? 'ESCI' : 'EXIT',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (shouldExit == true) {
      await _safeTeardownAndExit();
    }
  }

  /// Gestisce il completamento della sessione salvando lo storico su Isar
  /// e attivando lo stato di completamento per l'overlay nativo Flutter.
  void _handleSessionComplete([dynamic data]) {
    debugPrint('[VrExperienceBridge] Sessione completata (data: $data)');
    if (!_hasRecordedCurrentCompletion) {
      _hasRecordedCurrentCompletion = true;
      try {
        final userRepo = ref.read(userRepositoryProvider);
        userRepo?.recordSession(
          _experienceType.title,
          _experienceType.isBreathing ? 'Respirazione' : 'Meditazione',
        );
      } catch (e) {
        debugPrint('[VrExperienceBridge] Errore salvataggio sessione: $e');
      }
    }

    if (mounted && !_isSessionCompleted) {
      setState(() {
        _isSessionCompleted = true;
      });
      HapticFeedback.mediumImpact();
    }
  }

  /// Reinizializza la sessione richiamando l'API JavaScript e reimpostando lo stato
  Future<void> _handleRepeatSession() async {
    HapticFeedback.lightImpact();
    if (mounted) {
      setState(() {
        _isSessionCompleted = false;
        _hasRecordedCurrentCompletion = false;
      });
    }
    try {
      await _webViewController?.evaluateJavascript(
        source: 'if (window.GuidoVR && window.GuidoVR.reset) { '
                '  window.GuidoVR.reset(); '
                '  if (window.GuidoVR.start) window.GuidoVR.start(); '
                '}',
      );
    } catch (e) {
      debugPrint('[VrExperienceScreen] Errore riavvio sessione JS: $e');
    }
  }

  /// Conclude la sessione e ritorna all'app Guido
  Future<void> _handleExitSession() async {
    HapticFeedback.lightImpact();
    await _safeTeardownAndExit();
  }

  /// Restituisce la descrizione di consapevolezza personalizzata per ciascun modulo
  String _getCompletionDescription(bool isIt) {
    if (_experienceType == VrExperienceType.meditazioneMattinoAcqua) {
      return isIt
          ? 'La tua meditazione dell\'alba è completata. Porta con te questa serenità cristallina, limpidezza e quiete interiore.'
          : 'Your morning meditation is complete. Carry this crystalline serenity, clarity, and inner stillness into your day.';
    } else if (_experienceType.isBreathing) {
      return isIt
          ? 'La tua sessione di respirazione è completata. Porta questa calma, ritmo armonico e profonda presenza nella tua giornata.'
          : 'Your breathing session is complete. Carry this calm, harmonic rhythm, and mindful presence into your day.';
    } else {
      return isIt
          ? 'Sessione completata con successo. Porta questo equilibrio e benessere nella tua giornata.'
          : 'Session completed successfully. Carry this balance and well-being into your day.';
    }
  }

  /// Registra i canali di comunicazione nativi con la pagina HTML/JS
  void _setupJavaScriptHandlers(InAppWebViewController controller) {
    // 1. Notifica che Three.js e il motore 3D sono pronti ed inizializzati
    controller.addJavaScriptHandler(
      handlerName: 'onVRReady',
      callback: (args) {
        debugPrint('[VrExperienceBridge] Evento onVRReady ricevuto: $args');
        if (mounted) {
          setState(() {
            _isWebReady = true;
          });
        }

        // Se era stata richiesta la modalità VR sin dall'inizio, imposta VR SBS
        if (_isVrMode) {
          controller.evaluateJavascript(
            source: 'if (window.GuidoVR && window.GuidoVR.setVRMode) { window.GuidoVR.setVRMode(true); }',
          );
          _startNativeSensorStream();
        }

        // Se autoStart abilitato, avvia la sessione
        if (widget.autoStart) {
          controller.evaluateJavascript(
            source: 'if (window.GuidoVR && window.GuidoVR.start) { window.GuidoVR.start(); }',
          );
        }
      },
    );

    // 2. Cambio fase di respirazione (Inspira / Trattieni / Espira / Pausa)
    controller.addJavaScriptHandler(
      handlerName: 'onPhaseChange',
      callback: (args) {
        if (args.isNotEmpty) {
          final phaseData = args[0];
          String phaseName = '';
          if (phaseData is Map) {
            phaseName = phaseData['phaseName']?.toString() ??
                phaseData['phase']?.toString() ??
                '';
          } else if (phaseData != null) {
            phaseName = phaseData.toString();
          }

          if (mounted && phaseName.isNotEmpty) {
            // Leggero feedback tattile su cambio fase
            HapticFeedback.lightImpact();
          }
        }
      },
    );

    // 3. Notifica cambio modalità VR dalla pagina HTML
    controller.addJavaScriptHandler(
      handlerName: 'onVRModeChanged',
      callback: (args) {
        if (args.isNotEmpty && mounted) {
          final dynamic first = args[0];
          final bool isVr = first is bool
              ? first
              : (first is Map && first['isVr'] == true);
          setState(() {
            _isVrMode = isVr;
          });
          if (isVr) {
            _startNativeSensorStream();
            _applyVrBrightness();
          } else {
            _stopNativeSensorStream();
            _restoreBrightness();
          }
        }
      },
    );

    // 4. Sessione completata: salvataggio storico su Isar e visualizzazione overlay nativo
    controller.addJavaScriptHandler(
      handlerName: 'onSessionComplete',
      callback: (args) {
        _handleSessionComplete(args.isNotEmpty ? args[0] : null);
      },
    );

    // 5. Shim handler per meditazione_mattino_acqua (window.GuidoFlutterBridge.postMessage)
    controller.addJavaScriptHandler(
      handlerName: 'GuidoFlutterBridge',
      callback: (args) {
        debugPrint('[VrExperienceBridge] GuidoFlutterBridge message: $args');
        if (args.isNotEmpty) {
          final dynamic raw = args[0];
          if (raw is Map) {
            final event = raw['event']?.toString();
            if (event == 'onVRReady') {
              if (mounted) setState(() => _isWebReady = true);
            } else if (event == 'onSessionComplete') {
              _handleSessionComplete(raw['data']);
            } else if (event == 'onExitRequested') {
              if (_isVrMode) {
                _safeTeardownAndExit();
              } else {
                _handleExitAttempt();
              }
            }
          }
        }
      },
    );

    // 6. Richiesta di uscita diretta dal codice JS
    controller.addJavaScriptHandler(
      handlerName: 'onExitRequested',
      callback: (args) async {
        if (_isVrMode) {
          await _safeTeardownAndExit();
        } else {
          await _handleExitAttempt();
        }
      },
    );
  }

  @override
  void dispose() {
    _stopNativeSensorStream();
    _serverPollTimer?.cancel();
    if (!_isExiting) {
      _isExiting = true;
      _cleanupNativeAndWebGlResources();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverService = ref.watch(localVrServerServiceProvider);
    final targetUrl = serverService.getExperienceUrl(
      _experienceType,
      isVrMode: _isVrMode,
      autoStart: widget.autoStart,
      cacheBust: true,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_isSessionCompleted) {
            _handleExitSession();
          } else {
            _handleExitAttempt();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // 1. InAppWebView per rendering WebGL 60/120 FPS
            if (_isServerReady)
              Positioned.fill(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(targetUrl)),
                  initialSettings: InAppWebViewSettings(
                    allowsInlineMediaPlayback: true,
                    mediaPlaybackRequiresUserGesture: false,
                    disallowOverScroll: true,
                    disableContextMenu: true,
                    supportZoom: false,
                    allowsAirPlayForMediaPlayback: true,
                    allowsPictureInPictureMediaPlayback: false,
                    isFraudulentWebsiteWarningEnabled: false,
                    upgradeKnownHostsToHTTPS: false,
                    allowFileAccessFromFileURLs: true,
                    allowUniversalAccessFromFileURLs: true,
                    hardwareAcceleration: true,
                    useHybridComposition: true,
                    transparentBackground: true,
                    allowFileAccess: true,
                    allowContentAccess: true,
                    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                    cacheEnabled: false,
                    cacheMode: CacheMode.LOAD_NO_CACHE,
                    clearCache: true,
                    clearSessionCache: true,
                  ),
                  initialUserScripts: UnmodifiableListView<UserScript>([
                    // Iniezione preventiva dello shim di compatibilità per Meditazione Mattino e permessi sensori iOS
                    UserScript(
                      source: '''
                      window.GuidoFlutterBridge = {
                        postMessage: function(msg) {
                          if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
                            try {
                              var parsed = typeof msg === 'string' ? JSON.parse(msg) : msg;
                              window.flutter_inappwebview.callHandler(parsed.event || 'GuidoFlutterBridge', parsed.data || parsed);
                            } catch(e) {
                              window.flutter_inappwebview.callHandler('GuidoFlutterBridge', msg);
                            }
                          }
                        }
                      };

                      // Polyfill automatico dei permessi sensori orientamento / movimento per Safari/WKWebView su iOS
                      if (typeof DeviceOrientationEvent !== 'undefined' && typeof DeviceOrientationEvent.requestPermission === 'function') {
                        DeviceOrientationEvent.requestPermission = function() {
                          return Promise.resolve('granted');
                        };
                      }
                      if (typeof DeviceMotionEvent !== 'undefined' && typeof DeviceMotionEvent.requestPermission === 'function') {
                        DeviceMotionEvent.requestPermission = function() {
                          return Promise.resolve('granted');
                        };
                      }
                      ''',
                      injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
                    ),
                  ]),
                  onPermissionRequest: (controller, request) async {
                    return PermissionResponse(
                      resources: request.resources,
                      action: PermissionResponseAction.GRANT,
                    );
                  },
                  onWebViewCreated: (controller) async {
                    _webViewController = controller;
                    _setupJavaScriptHandlers(controller);
                    try {
                      await InAppWebViewController.clearAllCache();
                    } catch (_) {}
                  },
                  onLoadStop: (controller, url) {
                    controller.evaluateJavascript(source: '''
                      window.focus();
                      if (document.body) document.body.focus();
                      if (screen.orientation && typeof screen.orientation.angle === 'undefined') {
                        Object.defineProperty(screen.orientation, 'angle', { get: () => 90 });
                      }
                      if (!window.screen.orientation) {
                        window.screen.orientation = { angle: (window.innerWidth > window.innerHeight ? 90 : 0) };
                      }
                      if (window.audioCtx && window.audioCtx.state === 'suspended') {
                        window.audioCtx.resume();
                      }
                      window.focus();
                      if (document.body) document.body.focus();
                      if (window.GuidoVR) {
                        if ($_isVrMode && window.GuidoVR.setVRMode) {
                          window.GuidoVR.setVRMode(true);
                        }
                        if (window.GuidoVR.start) {
                          window.GuidoVR.start();
                        }
                      }
                    ''');
                    // Fallback di sicurezza: se la pagina non invia onVRReady dopo 1.5s dal carico
                    Future.delayed(const Duration(milliseconds: 1500), () {
                      if (mounted && !_isWebReady) {
                        setState(() {
                          _isWebReady = true;
                        });
                      }
                    });
                  },
                ),
              ),

            // 2. HUD Minimalista Japandi: Back Button Discreto nell'angolo in alto a sinistra
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 14, left: 14),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: _buildHudIconButton(
                    icon: Icons.close_rounded,
                    tooltip: 'Esci',
                    onPressed: _isSessionCompleted ? _handleExitSession : _handleExitAttempt,
                  ),
                ),
              ),
            ),

            // In modalità VR: Pulsante discreto nell'angolo in alto a destra per window.GuidoVR.recenter()
            if (_isVrMode)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 14, right: 14),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: _buildHudIconButton(
                      icon: Icons.explore_rounded,
                      tooltip: 'Ricalibra Centro',
                      activeColor: AppColors.goldAccent,
                      isActive: true,
                      onPressed: _recenterVrView,
                    ),
                  ),
                ),
              ),

            // 3. Loading Overlay Elegante con dissolvenza Japandi
            IgnorePointer(
              ignoring: _isWebReady,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeInOut,
                opacity: _isWebReady ? 0.0 : 1.0,
                child: Container(
                  color: const Color(0xFF0C0E11),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.goldAccent.withValues(alpha: 0.1),
                            border: Border.all(
                              color: AppColors.goldAccent.withValues(alpha: 0.25),
                              width: 1.5,
                            ),
                          ),
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.goldAccent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          _experienceType.title,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Caricamento ambiente 3D & Frequenze 432 Hz...',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 4. Dual-Layer Fallback: Overlay Nativo Japandi per Sessione Completata (Modalità Schermo Normale)
            if (_isSessionCompleted && !_isVrMode)
              _buildSessionCompletionOverlay(),

            // 5. VR Mode: Barra Touch di Fallback per Sessione Completata (se rimosso visore)
            if (_isSessionCompleted && _isVrMode)
              _buildVrCompletionFallbackBar(),
          ],
        ),
      ),
    );
  }

  /// Helper per costruire un pulsante HUD discreto e semi-trasparente
  Widget _buildHudIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool isActive = false,
    Color? activeColor,
  }) {
    final effectiveColor = isActive
        ? (activeColor ?? AppColors.goldAccent)
        : Colors.white.withValues(alpha: 0.85);

    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.5),
              border: Border.all(
                color: isActive
                    ? (activeColor ?? AppColors.goldAccent).withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 20,
              color: effectiveColor,
            ),
          ),
        ),
      ),
    );
  }

  /// Costruisce l'overlay nativo Flutter Japandi di completamento per la modalità schermo normale.
  /// Garantisce la massima leggibilità, estetica zen e pulsanti evidenti 'RIPETI' ed 'ESCI'.
  Widget _buildSessionCompletionOverlay() {
    final settings = ref.watch(settingsProvider);
    final isIt = settings.language == 0;
    final isDark = settings.isDarkTheme;

    return Positioned.fill(
      key: const Key('vr_session_completion_overlay'),
      child: Container(
        color: Colors.black.withValues(alpha: 0.78),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF14171E) : const Color(0xFFFBF8F3),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.goldAccent.withValues(alpha: 0.45),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.goldAccent.withValues(alpha: 0.15),
                    blurRadius: 32,
                    spreadRadius: 1,
                  ),
                  const BoxShadow(
                    color: Colors.black54,
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icona circolare Japandi con bagliore dorato
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.goldAccent.withValues(alpha: 0.12),
                      border: Border.all(
                        color: AppColors.goldAccent.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.spa_rounded,
                      size: 26,
                      color: AppColors.goldAccent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Titolo principale
                  Text(
                    isIt ? 'Esperienza Completata' : 'Experience Completed',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Titolo esperienza
                  Text(
                    _experienceType.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.goldAccent,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Messaggio di pace e consapevolezza
                  Text(
                    _getCompletionDescription(isIt),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.darkTextSub : AppColors.lightTextSub,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Azioni: ESCI e RIPETI
                  Row(
                    children: [
                      // Pulsante ESCI
                      Expanded(
                        child: OutlinedButton.icon(
                          key: const Key('btn_completion_exit'),
                          onPressed: _handleExitSession,
                          icon: const Icon(Icons.close_rounded, size: 18),
                          label: Text(
                            isIt ? 'ESCI' : 'EXIT',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFF87171),
                            side: BorderSide(
                              color: const Color(0xFFEF4444).withValues(alpha: 0.65),
                              width: 1.3,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Pulsante RIPETI
                      Expanded(
                        child: ElevatedButton.icon(
                          key: const Key('btn_completion_repeat'),
                          onPressed: _handleRepeatSession,
                          icon: const Icon(Icons.replay_rounded, size: 18),
                          label: Text(
                            isIt ? 'RIPETI' : 'REPEAT',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.goldAccent,
                            foregroundColor: const Color(0xFF0F172A),
                            elevation: 3,
                            shadowColor: AppColors.goldAccent.withValues(alpha: 0.4),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Costruisce una barra HUD touch di fallback discreta per la modalità VR Cardboard,
  /// consentendo all'utente di ripetere o uscire con un semplice tocco senza indossare il visore.
  Widget _buildVrCompletionFallbackBar() {
    final settings = ref.watch(settingsProvider);
    final isIt = settings.language == 0;

    return SafeArea(
      key: const Key('vr_fallback_completion_bar'),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.goldAccent.withValues(alpha: 0.5),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 16,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton.icon(
                  key: const Key('btn_vr_fallback_exit'),
                  onPressed: _handleExitSession,
                  icon: const Icon(Icons.close_rounded, size: 16, color: Color(0xFFFCA5A5)),
                  label: Text(
                    isIt ? 'ESCI' : 'EXIT',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFCA5A5),
                    ),
                  ),
                ),
                Container(
                  height: 16,
                  width: 1,
                  color: Colors.white24,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                TextButton.icon(
                  key: const Key('btn_vr_fallback_repeat'),
                  onPressed: _handleRepeatSession,
                  icon: Icon(Icons.replay_rounded, size: 16, color: AppColors.goldAccent),
                  label: Text(
                    isIt ? 'RIPETI' : 'REPEAT',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.goldAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
