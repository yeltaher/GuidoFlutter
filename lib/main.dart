import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'core/theme/app_theme.dart';
import 'app/router/app_router.dart';

import 'package:guido/l10n/app_localizations.dart';
import 'core/database/settings_provider.dart';
import 'core/database/app_initializer_provider.dart';
import 'core/database/models/user_stats_model.dart';
import 'core/database/repositories/user_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Intercetta gli errori asincroni non gestiti
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('[Global PlatformDispatcher Error] $error\n$stack');
    return true;
  };

  // 2. Intercetta gli errori di rendering/framework Flutter
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('[Global FlutterError] ${details.exceptionAsString()}');
  };

  // 3. ErrorWidget personalizzato per evitare crash a schermo rosso
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: Colors.redAccent.withValues(alpha: 0.5),
              width: 1.0,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 40,
              ),
              const SizedBox(height: 12),
              const Text(
                'Si è verificato un problema',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                details.exceptionAsString(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  try {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                  } catch (_) {}
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Ripristina'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  };

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SharedPreferences? prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    debugPrint('[Main] Prefs init error: $e');
  }

  Isar? isar;
  try {
    final dir = await getApplicationDocumentsDirectory();
    isar = Isar.getInstance() ??
        await Isar.open(
          [
            UserStatsModelSchema,
            TimelineRecordModelSchema,
          ],
          directory: dir.path,
          inspector: kDebugMode,
        );
  } catch (e) {
    debugPrint('[Main] Isar init error: $e');
    isar = Isar.getInstance();
  }

  // Pre-warming e auto-seeding atomico (id = 1)
  if (isar != null && prefs != null) {
    try {
      final userRepo = UserRepository(isar, prefs);
      await userRepo.ensureSeeded();
    } catch (e) {
      debugPrint('[Main] Seeding error: $e');
    }
  }

  runApp(
    ProviderScope(
      overrides: [
        if (prefs != null) ...[
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
        if (isar != null) ...[
          isarInstanceProvider.overrideWith((ref) => isar),
          isarProvider.overrideWithValue(isar),
        ],
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Avvia l'inizializzazione asincrona senza bloccare l'UI
    ref.watch(appInitializerProvider);

    final settings = ref.watch(settingsProvider);
    return MaterialApp.router(
      title: 'Guido Meditation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData(settings.isDarkTheme),
      locale: Locale(settings.language == 0 ? 'it' : 'en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return const Locale('it');
      },
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
