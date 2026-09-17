import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'core/theme/app_theme.dart';
import 'app/router/app_router.dart';

import 'package:guido/l10n/app_localizations.dart';
import 'core/database/settings_provider.dart';
import 'core/database/app_initializer_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Crash log channel for iOS native crash detection
const _crashLogChannel = MethodChannel('com.codepulse.guido/crash-log');

/// Checks for a previous crash log and returns it, then clears it.
Future<String?> _checkPreviousCrashLog() async {
  try {
    final String? log = await _crashLogChannel.invokeMethod('checkCrashLog');
    if (log != null && log.isNotEmpty) {
      await _crashLogChannel.invokeMethod('clearCrashLog');
      return log;
    }
  } catch (e) {
    debugPrint('[CrashLog] Check error: $e');
  }
  return null;
}

/// Shows a local notification about a previous crash.
Future<void> _showCrashNotification() async {
  try {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    const androidDetails = AndroidNotificationDetails(
      'crash_channel',
      'Crash Reports',
      channelDescription: 'Crash notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Crash Rilevato',
      'Lapp si e chiusa in modo anomalo. Tocca per i dettagli.',
      details,
    );
  } catch (e) {
    debugPrint('[CrashLog] Notification error: $e');
  }
}

/// Shows a dialog with crash details.
void _showCrashDialog(BuildContext context, String crashLog) {
  // Extract just the essential info (first 500 chars to keep dialog readable)
  final preview = crashLog.length > 500 ? '${crashLog.substring(0, 500)}...' : crashLog;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      title: const Row(
        children: [
          Icon(Icons.error_outline, color: Colors.redAccent, size: 28),
          SizedBox(width: 8),
          Text('Crash Report', style: TextStyle(color: Colors.white)),
        ],
      ),
      content: SingleChildScrollView(
        child: Text(
          preview,
          style: const TextStyle(
            fontFamily: 'LiberationSans',
            fontSize: 11,
            color: Colors.white70,
            height: 1.4,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('OK', style: TextStyle(color: Colors.cyanAccent)),
        ),
      ],
    ),
  );
}

/// Prevents showing crash dialog/notification multiple times on widget rebuilds
bool _crashLogDisplayed = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Check for previous crash log BEFORE anything else
  String? previousCrashLog;
  try {
    previousCrashLog = await _checkPreviousCrashLog();
  } catch (e) {
    debugPrint('[Main] Crash log check error: $e');
  }

  SharedPreferences? prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    debugPrint('[Main] Prefs init error: $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        if (prefs != null)
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
      ],
      child: MainApp(crashLog: previousCrashLog),
    ),
  );
}

class MainApp extends ConsumerWidget {
  final String? crashLog;

  const MainApp({super.key, this.crashLog});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Avvia l'inizializzazione asincrona senza bloccare l'UI
    ref.watch(appInitializerProvider);

    // Show crash notification and dialog on first frame (only once)
    if (crashLog != null && !_crashLogDisplayed) {
      _crashLogDisplayed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCrashNotification();
        if (context.mounted) {
          _showCrashDialog(context, crashLog!);
        }
      });
    }

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
