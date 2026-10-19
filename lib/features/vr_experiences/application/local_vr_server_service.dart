import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/vr_experience_type.dart';

/// Provider globale Riverpod per il servizio del server locale offline WebXR.
final localVrServerServiceProvider = Provider<LocalVrServerService>((ref) {
  final service = LocalVrServerService();
  ref.onDispose(() {
    service.stopServer();
  });
  return service;
});

/// Servizio responsabile della gestione del lifecycle di `InAppLocalhostServer`.
/// Consente di servire gli asset WebXR/Three.js tramite HTTP locale (porta 8085)
/// per aggirare le restrizioni CORS su iOS WKWebView e supportare lo streaming
/// audio parziale (Byte-Range 206) a 432 Hz senza alcuna dipendenza da internet.
class LocalVrServerService {
  static const int defaultPort = 8085;
  static const String defaultDocumentRoot = 'assets';

  final int port;
  final String documentRoot;
  InAppLocalhostServer? _localhostServer;

  bool _isStarting = false;
  Completer<void>? _startCompleter;

  LocalVrServerService({
    this.port = defaultPort,
    this.documentRoot = defaultDocumentRoot,
  });

  InAppLocalhostServer? _getOrCreateServer() {
    if (kIsWeb) return null;
    try {
      _localhostServer ??= InAppLocalhostServer(
        port: port,
        documentRoot: documentRoot,
      );
      return _localhostServer;
    } catch (e) {
      debugPrint('[LocalVrServerService] Inizializzazione piattaforma InAppLocalhostServer non disponibile: $e');
      return null;
    }
  }

  /// Indica se il server locale è attualmente attivo ed in ascolto.
  bool get isRunning => !kIsWeb && (_localhostServer?.isRunning() ?? false);

  /// Avvia il server HTTP locale su localhost:8085 in modo idempotente.
  /// Se già in esecuzione o in fase di avvio, attende il completamento senza lanciare eccezioni.
  Future<void> startServer() async {
    if (kIsWeb) {
      debugPrint('[LocalVrServerService] Ambiente Web: InAppLocalhostServer non richiesto.');
      return;
    }

    final server = _getOrCreateServer();
    if (server == null) {
      return;
    }

    if (server.isRunning()) {
      return;
    }

    if (_isStarting && _startCompleter != null) {
      return _startCompleter!.future;
    }

    _isStarting = true;
    _startCompleter = Completer<void>();

    try {
      debugPrint('[LocalVrServerService] Avvio InAppLocalhostServer su porta $port (root: $documentRoot)...');
      await server.start();
      debugPrint('[LocalVrServerService] InAppLocalhostServer avviato con successo su http://localhost:$port/');
      _startCompleter?.complete();
    } catch (e, st) {
      debugPrint('[LocalVrServerService] Errore durante l\'avvio di InAppLocalhostServer: $e\n$st');
      if (!(_startCompleter?.isCompleted ?? true)) {
        _startCompleter?.complete();
      }
    } finally {
      _isStarting = false;
    }
  }

  /// Arresta il server HTTP locale e rilascia la porta occupata.
  Future<void> stopServer() async {
    if (kIsWeb) return;
    try {
      if (_localhostServer != null && _localhostServer!.isRunning()) {
        debugPrint('[LocalVrServerService] Chiusura InAppLocalhostServer...');
        await _localhostServer!.close();
        debugPrint('[LocalVrServerService] InAppLocalhostServer chiuso.');
      }
    } catch (e) {
      debugPrint('[LocalVrServerService] Errore durante l\'arresto: $e');
    }
  }

  /// Costruisce l'URL completo locale per l'esperienza richiesta.
  String getExperienceUrl(
    VrExperienceType type, {
    bool isVrMode = false,
    bool autoStart = true,
    bool cacheBust = false,
  }) {
    final queryParams = <String>[];
    if (isVrMode) queryParams.add('vr=true');
    if (autoStart) queryParams.add('autostart=true');
    if (cacheBust) queryParams.add('v=${DateTime.now().millisecondsSinceEpoch}');

    final queryString =
        queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
    return 'http://localhost:$port/vr_experiences/${type.folderName}/index.html$queryString';
  }
}
