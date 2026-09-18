import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/database/settings_provider.dart';
import '../../../core/database/app_initializer_provider.dart';

class BootSplashView extends ConsumerWidget {
  const BootSplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInitState = ref.watch(appInitializerProvider);

    return appInitState.when(
      data: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            final prefs = ref.read(sharedPrefsProvider);
            final isOnboarded = prefs?.getBool("IsOnboarded") ?? false;
            if (isOnboarded) {
              context.go('/home');
            } else {
              context.go('/login');
            }
          }
        });
        return const _BootBackground();
      },
      error: (error, stackTrace) {
        return _ErrorScreen(error: error);
      },
      loading: () {
        return const _BootBackground();
      },
    );
  }
}

class _BootBackground extends StatelessWidget {
  const _BootBackground();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070A18),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color(0xFF070A18),
            ),
          ),
          SafeArea(
            child: Center(
              child: Image.asset(
                'assets/images/sfondo_new.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorScreen extends ConsumerWidget {
  final Object error;

  const _ErrorScreen({required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkTheme;
    final textColor = AppColors.getTextColor(isDark);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.dangerAccent,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Oops! Qualcosa è andato storto.',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: textColor.withValues(alpha: 0.7),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
