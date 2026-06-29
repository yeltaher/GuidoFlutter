import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'app/router/app_router.dart';

import 'package:guido/l10n/app_localizations.dart';
import 'core/database/settings_provider.dart';
import 'core/database/app_initializer_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MainApp(),
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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
