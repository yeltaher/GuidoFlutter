import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/unity/unity_bridge_dto.dart';
import '../../features/splash/splash_feature.dart';
import '../../features/onboarding/onboarding_feature.dart';
import '../../features/menu/menu_feature.dart';
import '../../features/meditation/meditation_feature.dart';
import '../../features/breathing/breathing_feature.dart';
import '../../features/premium/premium_feature.dart';

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
        builder: (context, state) => const VrCalibrationScreen(),
      ),
      GoRoute(
        path: '/remove-vr-headset',
        builder: (context, state) => const RemoveVrHeadsetView(),
      ),
      GoRoute(
        path: '/breathing',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          final title = args['title'] as String? ?? 'Respirazione Acqua';
          final audioPath = args['audioPath'] as String? ??
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
          final args = state.extra as Map<String, dynamic>? ?? {};
          final title = args['title'] as String? ?? 'Meditazione Acqua';
          final voicePath = args['voicePath'] as String? ??
              'assets/audio/real/Meditazioni/Acqua/Meditazione del Mattino_Procedimento.m4a';
          final ambientPath = args['ambientPath'] as String? ??
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
          final args = state.extra as Map<String, dynamic>? ?? {};
          final title = args['title'] ?? 'Esperienza Zen';
          final sceneName = UnityScenes.resolveSceneName(
            explicitSceneName: args['sceneName'] as String?,
            title: title,
          );
          return UnityExperienceScreen(
            title: title,
            sceneName: sceneName,
            durationSeconds:
                (args['durationSeconds'] as num?)?.toDouble() ?? 300.0,
            isVrMode: args['isVrMode'] ?? false,
            voicePath: args['voicePath'] as String?,
            ambientPath: args['ambientPath'] as String?,
          );
        },
      ),
    ],
  );
});
