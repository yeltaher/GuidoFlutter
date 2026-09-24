import 'dart:convert';

/// Supported URP rendering quality presets for Unity as a Library.
enum QualityPreset {
  /// High Fidelity PBR profile: Single Pass Instanced, MSAA 2x, 40m Shadows, Full Lightmaps (60 FPS target).
  highFidelity(0),

  /// Balanced Eco profile: Single Pass Instanced, MSAA off/light, 20m Shadows, Scaled LOD Bias (Battery Saving).
  balancedEco(1);

  final int value;
  const QualityPreset(this.value);

  static QualityPreset fromValue(int val) {
    return QualityPreset.values.firstWhere(
      (e) => e.value == val,
      orElse: () => QualityPreset.highFidelity,
    );
  }

  String getDisplayName(bool isItalian) {
    switch (this) {
      case QualityPreset.highFidelity:
        return isItalian ? 'Alta Fedeltà (PBR)' : 'High Fidelity (PBR)';
      case QualityPreset.balancedEco:
        return isItalian ? 'Risparmio Energetico (Eco)' : 'Battery Saver (Eco)';
    }
  }

  String getSubtitle(bool isItalian) {
    switch (this) {
      case QualityPreset.highFidelity:
        return isItalian
            ? '60 FPS • Ombre e Materiali Fotorealistici'
            : '60 FPS • Photorealistic Materials & Shadows';
      case QualityPreset.balancedEco:
        return isItalian
            ? 'Consumo batteria ridotto • Minore riscaldamento'
            : 'Reduced battery drain • Lower thermal footprint';
    }
  }
}

/// Supported languages for Unity guidance.
enum AppLanguage {
  italian(0),
  english(1);

  final int value;
  const AppLanguage(this.value);

  static AppLanguage fromValue(int val) {
    return AppLanguage.values.firstWhere(
      (e) => e.value == val,
      orElse: () => AppLanguage.italian,
    );
  }
}

/// The 4 physiological breathing phases of guided VR meditation sessions.
enum BreathingPhase {
  inhale(0),
  holdIn(1),
  exhale(2),
  holdOut(3);

  final int value;
  const BreathingPhase(this.value);

  static BreathingPhase fromValue(int val) {
    return BreathingPhase.values.firstWhere(
      (e) => e.value == val,
      orElse: () => BreathingPhase.inhale,
    );
  }

  static BreathingPhase fromString(String name) {
    final lower = name.trim().toLowerCase();
    if (lower.contains('inhale') || lower.contains('inspira')) {
      return BreathingPhase.inhale;
    } else if (lower.contains('holdin') ||
        lower.contains('trattieni') ||
        lower.contains('hold in')) {
      return BreathingPhase.holdIn;
    } else if (lower.contains('exhale') || lower.contains('espira')) {
      return BreathingPhase.exhale;
    } else if (lower.contains('holdout') ||
        lower.contains('pausa') ||
        lower.contains('hold out')) {
      return BreathingPhase.holdOut;
    }
    return BreathingPhase.inhale;
  }

  String getLocalizedLabel(bool isItalian) {
    switch (this) {
      case BreathingPhase.inhale:
        return isItalian ? 'INSPIRA...' : 'BREATHE IN...';
      case BreathingPhase.holdIn:
        return isItalian ? 'TRATTIENI...' : 'HOLD...';
      case BreathingPhase.exhale:
        return isItalian ? 'ESPIRA...' : 'BREATHE OUT...';
      case BreathingPhase.holdOut:
        return isItalian ? 'PAUSA...' : 'REST...';
    }
  }
}

/// Natural element biomes associated with distinct meditation respiration VFX.
enum BreathingElement {
  water(0),
  air(1),
  fire(2),
  earth(3);

  final int value;
  const BreathingElement(this.value);

  static BreathingElement fromValue(int val) {
    return BreathingElement.values.firstWhere(
      (e) => e.value == val,
      orElse: () => BreathingElement.water,
    );
  }
}

/// Configuration payload sent from Flutter companion app to initialize a VR/3D session.
/// Matches C# `SessionConfigDto` exactly.
class SessionConfigDto {
  final String sceneName;
  final int language; // 0 = Italian, 1 = English
  final double durationSeconds;
  final bool isVrMode;
  final int qualityPreset; // 0 = HighFidelity, 1 = BalancedEco

  const SessionConfigDto({
    required this.sceneName,
    this.language = 0,
    this.durationSeconds = 300.0,
    this.isVrMode = false,
    this.qualityPreset = 0,
  });

  QualityPreset get quality => QualityPreset.fromValue(qualityPreset);
  AppLanguage get appLanguage => AppLanguage.fromValue(language);

  Map<String, dynamic> toJson() => {
    'sceneName': sceneName,
    'language': language,
    'durationSeconds': durationSeconds,
    'isVrMode': isVrMode,
    'qualityPreset': qualityPreset,
  };

  factory SessionConfigDto.fromJson(Map<String, dynamic> json) {
    return SessionConfigDto(
      sceneName: json['sceneName'] as String? ?? '',
      language: json['language'] as int? ?? 0,
      durationSeconds: (json['durationSeconds'] as num?)?.toDouble() ?? 300.0,
      isVrMode: json['isVrMode'] as bool? ?? false,
      qualityPreset: json['qualityPreset'] as int? ?? 0,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  SessionConfigDto copyWith({
    String? sceneName,
    int? language,
    double? durationSeconds,
    bool? isVrMode,
    int? qualityPreset,
  }) {
    return SessionConfigDto(
      sceneName: sceneName ?? this.sceneName,
      language: language ?? this.language,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isVrMode: isVrMode ?? this.isVrMode,
      qualityPreset: qualityPreset ?? this.qualityPreset,
    );
  }
}

/// Real-time progress metric sent from Unity to Flutter companion app.
/// Matches C# `SessionProgressDto` exactly.
class SessionProgressDto {
  final String sessionId;
  final String sceneName;
  final double elapsedSeconds;
  final double totalDurationSeconds;
  final double progressNormalized;
  final String currentPhase;
  final int userHeartRateOrState;

  const SessionProgressDto({
    required this.sessionId,
    required this.sceneName,
    required this.elapsedSeconds,
    required this.totalDurationSeconds,
    required this.progressNormalized,
    required this.currentPhase,
    this.userHeartRateOrState = 0,
  });

  BreathingPhase get breathingPhase => BreathingPhase.fromString(currentPhase);

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'sceneName': sceneName,
    'elapsedSeconds': elapsedSeconds,
    'totalDurationSeconds': totalDurationSeconds,
    'progressNormalized': progressNormalized,
    'currentPhase': currentPhase,
    'userHeartRateOrState': userHeartRateOrState,
  };

  factory SessionProgressDto.fromJson(Map<String, dynamic> json) {
    return SessionProgressDto(
      sessionId: json['sessionId'] as String? ?? '',
      sceneName: json['sceneName'] as String? ?? '',
      elapsedSeconds: (json['elapsedSeconds'] as num?)?.toDouble() ?? 0.0,
      totalDurationSeconds:
          (json['totalDurationSeconds'] as num?)?.toDouble() ?? 0.0,
      progressNormalized:
          (json['progressNormalized'] as num?)?.toDouble() ?? 0.0,
      currentPhase: json['currentPhase'] as String? ?? '',
      userHeartRateOrState: json['userHeartRateOrState'] as int? ?? 0,
    );
  }

  String toJsonString() => jsonEncode(toJson());
}

/// Completed session summary sent from Unity to Flutter for persistence in Isar Database.
/// Matches C# `SessionSummaryDto` exactly.
class SessionSummaryDto {
  final String sessionId;
  final String sceneName;
  final double totalDurationSeconds;
  final bool completedSuccessfully;
  final int xpEarned;
  final int timestamp;

  const SessionSummaryDto({
    required this.sessionId,
    required this.sceneName,
    required this.totalDurationSeconds,
    required this.completedSuccessfully,
    required this.xpEarned,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'sceneName': sceneName,
    'totalDurationSeconds': totalDurationSeconds,
    'completedSuccessfully': completedSuccessfully,
    'xpEarned': xpEarned,
    'timestamp': timestamp,
  };

  factory SessionSummaryDto.fromJson(Map<String, dynamic> json) {
    return SessionSummaryDto(
      sessionId: json['sessionId'] as String? ?? '',
      sceneName: json['sceneName'] as String? ?? '',
      totalDurationSeconds:
          (json['totalDurationSeconds'] as num?)?.toDouble() ?? 0.0,
      completedSuccessfully: json['completedSuccessfully'] as bool? ?? false,
      xpEarned: json['xpEarned'] as int? ?? 0,
      timestamp: json['timestamp'] as int? ?? 0,
    );
  }

  String toJsonString() => jsonEncode(toJson());
}

/// Breathing phase event emitted on breath cycle change for haptic feedback synchronization.
class BreathPhaseEventDto {
  final BreathingPhase phase;
  final BreathingElement element;
  final double phaseDurationSeconds;
  final int cycleIndex;

  const BreathPhaseEventDto({
    required this.phase,
    required this.element,
    this.phaseDurationSeconds = 4.0,
    this.cycleIndex = 0,
  });

  Map<String, dynamic> toJson() => {
    'phase': phase.value,
    'element': element.value,
    'phaseDurationSeconds': phaseDurationSeconds,
    'cycleIndex': cycleIndex,
  };

  factory BreathPhaseEventDto.fromJson(Map<String, dynamic> json) {
    return BreathPhaseEventDto(
      phase: BreathingPhase.fromValue(json['phase'] as int? ?? 0),
      element: BreathingElement.fromValue(json['element'] as int? ?? 0),
      phaseDurationSeconds:
          (json['phaseDurationSeconds'] as num?)?.toDouble() ?? 4.0,
      cycleIndex: json['cycleIndex'] as int? ?? 0,
    );
  }
}

/// Lightweight JSON-RPC 2.0 request envelope for Flutter UaaL messaging.
/// Matches C# `JsonRpcRequestDto` exactly.
class JsonRpcRequestDto {
  final String jsonrpc;
  final String method;
  final String params;
  final int id;

  const JsonRpcRequestDto({
    this.jsonrpc = '2.0',
    required this.method,
    this.params = '',
    this.id = 0,
  });

  Map<String, dynamic> toJson() => {
    'jsonrpc': jsonrpc,
    'method': method,
    'params': params,
    'id': id,
  };

  factory JsonRpcRequestDto.fromJson(Map<String, dynamic> json) {
    return JsonRpcRequestDto(
      jsonrpc: json['jsonrpc'] as String? ?? '2.0',
      method: json['method'] as String? ?? '',
      params: json['params'] as String? ?? '',
      id: json['id'] as int? ?? 0,
    );
  }

  String toJsonString() => jsonEncode(toJson());
}

/// Lightweight JSON-RPC 2.0 response envelope for Flutter UaaL messaging.
/// Matches C# `JsonRpcResponseDto` exactly.
class JsonRpcResponseDto {
  final String jsonrpc;
  final String result;
  final String error;
  final int id;

  const JsonRpcResponseDto({
    this.jsonrpc = '2.0',
    this.result = '',
    this.error = '',
    this.id = 0,
  });

  bool get isSuccess => error.isEmpty;

  Map<String, dynamic> toJson() => {
    'jsonrpc': jsonrpc,
    'result': result,
    'error': error,
    'id': id,
  };

  factory JsonRpcResponseDto.fromJson(Map<String, dynamic> json) {
    return JsonRpcResponseDto(
      jsonrpc: json['jsonrpc'] as String? ?? '2.0',
      result: json['result'] as String? ?? '',
      error: json['error'] as String? ?? '',
      id: json['id'] as int? ?? 0,
    );
  }

  String toJsonString() => jsonEncode(toJson());
}

/// Canonical scene names for the 9 Unity UaaL meditation and breathing environments.
class UnityScenes {
  static const String waterBreathing = 'Respirazione acqua';
  static const String waterMeditation = 'Respirazione acqua';
  static const String airBreathing = 'Respirazione aria';
  static const String airMeditation = 'Respirazione aria';
  static const String fireBreathing = 'Respirazione fuoco';
  static const String fireMeditation = 'Respirazione fuoco';
  static const String earthBreathing = 'Procedimento terra';
  static const String earthMeditation = 'Procedimento terra';
  static const String generalMeditation = 'Respirazione acqua';

  static const List<String> allScenes = [
    waterBreathing,
    waterMeditation,
    airBreathing,
    airMeditation,
    fireBreathing,
    fireMeditation,
    earthBreathing,
    earthMeditation,
    generalMeditation,
  ];

  /// Resolves the canonical Unity scene name based on explicit parameter, title, and session type.
  static String resolveSceneName({
    String? explicitSceneName,
    required String title,
    bool isBreathing = false,
  }) {
    if (explicitSceneName != null && explicitSceneName.trim().isNotEmpty) {
      return explicitSceneName.trim();
    }

    final t = title.toLowerCase();
    final bool breathing = isBreathing ||
        t.contains('respir') ||
        t.contains('breath') ||
        t.contains('resp');

    if (t.contains('generale') || t.contains('general')) {
      return generalMeditation;
    }
    if (t.contains('fuoco') || t.contains('fire')) {
      return breathing ? fireBreathing : fireMeditation;
    }
    if (t.contains('aria') || t.contains('air')) {
      return breathing ? airBreathing : airMeditation;
    }
    if (t.contains('terra') || t.contains('earth')) {
      return breathing ? earthBreathing : earthMeditation;
    }
    if (t.contains('acqua') ||
        t.contains('water') ||
        t.contains('alba') ||
        t.contains('flow') ||
        t.contains('mattin') ||
        t.contains('pomeriggio') ||
        t.contains('afternoon') ||
        t.contains('sera') ||
        t.contains('evening') ||
        t.contains('starlight') ||
        t.contains('riposo') ||
        t.contains('concentrazione') ||
        t.contains('present') ||
        t.contains('focus') ||
        t.contains('calm')) {
      return breathing ? waterBreathing : waterMeditation;
    }

    return breathing ? waterBreathing : generalMeditation;
  }
}

/// Pan/drag delta coordinates sent from Flutter to Unity for 2D look around.
class CameraRotationDto {
  final double dx;
  final double dy;

  const CameraRotationDto({required this.dx, required this.dy});

  Map<String, dynamic> toJson() => {'dx': dx, 'dy': dy};

  factory CameraRotationDto.fromJson(Map<String, dynamic> json) {
    return CameraRotationDto(
      dx: (json['dx'] as num?)?.toDouble() ?? 0.0,
      dy: (json['dy'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJsonString() => jsonEncode(toJson());
}

