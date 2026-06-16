import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'app/router/app_router.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:guido/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/database/settings_provider.dart';
import 'core/database/repositories/user_repository.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'core/database/models/user_stats_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [UserStatsModelSchema, TimelineRecordModelSchema],
    directory: dir.path,
  );
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        isarProvider.overrideWithValue(isar),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
