import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/splash/splash_feature.dart';
import '../../features/onboarding/onboarding_feature.dart';
import '../../features/menu/menu_feature.dart';
import '../../features/breathing/breathing_feature.dart';
import '../../features/meditation/meditation_feature.dart';
import '../../features/premium/premium_feature.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
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
          return BreathingView(
            title: args['title'] ?? 'Respirazione',
            audioPath: args['audioPath'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/meditation',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return MeditationView(
            title: args['title'] ?? 'Meditazione',
            voicePath: args['voicePath'] ?? '',
            ambientPath: args['ambientPath'] ?? '',
          );
        },
      ),
    ],
  );
});
