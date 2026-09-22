import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/splash/splash_feature.dart';
import '../../features/onboarding/onboarding_feature.dart';
import '../../features/menu/menu_feature.dart';
import '../../features/meditation/meditation_feature.dart';
import '../../features/breathing/breathing_feature.dart';
import '../../features/premium/premium_feature.dart';
import '../../features/menu/presentation/zen_sound_mixer_view.dart';

/// Helper difensivo per l'estrazione e merge di parametri di rotta da GoRouter.
/// Supporta `Map<String, dynamic>`, `Map<dynamic, dynamic>`, ed effettua il merge con queryParameters.
Map<String, dynamic> _extractRouteParams(GoRouterState state) {
  final params = <String, dynamic>{};
  params.addAll(state.uri.queryParameters);
  final extra = state.extra;
  if (extra is Map) {
    extra.forEach((key, value) {
      if (key != null) {
        params[key.toString()] = value;
      }
    });
  }
  return params;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const BootSplashView()),
      GoRoute(path: '/login', builder: (context, state) => const SplashView()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingWizardView(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeContainerView(),
      ),
      GoRoute(
        path: '/premium',
        builder: (context, state) => const PremiumPaywallView(),
      ),
      GoRoute(
        path: '/vr-calibration',
        builder: (context, state) {
          final args = _extractRouteParams(state);
          final rawFromSettings = args['isFromSettings'];
          final isFromSettings = rawFromSettings is bool
              ? rawFromSettings
              : (rawFromSettings is String
                  ? (rawFromSettings.toLowerCase() != 'false' &&
                      rawFromSettings != '0')
                  : true);
          if (isFromSettings) {
            return const VrCalibrationScreen(isFromSettings: true);
          }
          final rawDuration = args['durationSeconds'];
          final duration = rawDuration is num
              ? rawDuration.toDouble()
              : (rawDuration is String
                  ? (double.tryParse(rawDuration) ?? 300.0)
                  : 300.0);
          return VrCalibrationScreen(
            isFromSettings: false,
            title: args['title']?.toString(),
            voicePath: args['voicePath']?.toString(),
            ambientPath: args['ambientPath']?.toString(),
            breathingAudioPath: args['breathingAudioPath']?.toString(),
            sceneName: args['sceneName']?.toString(),
            durationSeconds: duration,
          );
        },
      ),
      GoRoute(
        path: '/vr-confirmation',
        builder: (context, state) {
          final args = _extractRouteParams(state);
          final rawDuration = args['durationSeconds'];
          final duration = rawDuration is num
              ? rawDuration.toDouble()
              : (rawDuration is String
                  ? (double.tryParse(rawDuration) ?? 300.0)
                  : 300.0);
          return VrConfirmationScreen(
            title: args['title']?.toString() ?? '',
            voicePath: args['voicePath']?.toString() ?? '',
            ambientPath: args['ambientPath']?.toString() ?? '',
            breathingAudioPath: args['breathingAudioPath']?.toString(),
            sceneName: args['sceneName']?.toString(),
            durationSeconds: duration,
          );
        },
      ),
      GoRoute(
        path: '/remove-vr-headset',
        builder: (context, state) => const RemoveVrHeadsetView(),
      ),
      GoRoute(
        path: '/explanation',
        builder: (context, state) {
          final args = _extractRouteParams(state);
          final rawDuration = args['durationSeconds'];
          final duration = rawDuration is num
              ? rawDuration.toDouble()
              : (rawDuration is String
                  ? (double.tryParse(rawDuration) ?? 300.0)
                  : 300.0);
          return ExplanationScreen(
            title: args['title']?.toString() ?? '',
            voicePath: args['voicePath']?.toString() ?? '',
            ambientPath: args['ambientPath']?.toString() ?? '',
            breathingAudioPath: args['breathingAudioPath']?.toString(),
            sceneName: args['sceneName']?.toString(),
            durationSeconds: duration,
          );
        },
      ),
      GoRoute(
        path: '/breathing',
        builder: (context, state) {
          final args = _extractRouteParams(state);
          final title = args['title']?.toString() ?? 'Respirazione Acqua';
          final audioPath = args['audioPath']?.toString() ??
              'assets/audio/real/Respirazioni/Acqua/Respirazione acqua.m4a';
          return BreathingView(
            title: title,
            audioPath: audioPath,
          );
        },
      ),
      GoRoute(
        path: '/meditation',
        builder: (context, state) {
          final args = _extractRouteParams(state);
          final title = args['title']?.toString() ?? 'Meditazione Acqua';
          final voicePath = args['voicePath']?.toString() ??
              'assets/audio/real/Meditazioni/Acqua/Meditazione del Mattino_Procedimento.m4a';
          final ambientPath = args['ambientPath']?.toString() ??
              'assets/audio/real/Meditazioni/Acqua/Musica Percorso Acqua - Meditazione MATTINO.m4a';
          return MeditationView(
            title: title,
            voicePath: voicePath,
            ambientPath: ambientPath,
          );
        },
      ),
      GoRoute(
        path: '/unity-experience',
        builder: (context, state) {
          final params = _extractRouteParams(state);
          final rawVr = params['isVrMode'];
          final bool isVrMode = rawVr is bool
              ? rawVr
              : (rawVr is String &&
                  (rawVr.toLowerCase() == 'true' || rawVr == '1'));
          final rawTitle = params['title'];
          final String title =
              (rawTitle is String && rawTitle.trim().isNotEmpty)
                  ? rawTitle.trim()
                  : 'Esperienza Immersiva';
          final rawScene = params['sceneName'];
          final String sceneName =
              (rawScene is String && rawScene.trim().isNotEmpty)
                  ? rawScene.trim()
                  : 'Scena Zen 3D';
          final rawDuration = params['durationSeconds'];
          final double durationSeconds = rawDuration is num
              ? rawDuration.toDouble()
              : (rawDuration is String
                  ? (double.tryParse(rawDuration) ?? 300.0)
                  : 300.0);
          final rawVoice = params['voicePath'];
          final String? voicePath =
              (rawVoice is String && rawVoice.isNotEmpty) ? rawVoice : null;
          final rawAmbient = params['ambientPath'];
          final String? ambientPath =
              (rawAmbient is String && rawAmbient.isNotEmpty)
                  ? rawAmbient
                  : null;

          return UnityExperienceScreen(
            title: title,
            sceneName: sceneName,
            durationSeconds: durationSeconds,
            isVrMode: isVrMode,
            voicePath: voicePath,
            ambientPath: ambientPath,
          );
        },
      ),
      GoRoute(
        path: '/zen-sound-mixer',
        builder: (context, state) => const ZenSoundMixerView(),
      ),
    ],
  );
});
