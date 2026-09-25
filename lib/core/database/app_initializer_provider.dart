import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/user_stats_model.dart';

/// Provider di stato per l'istanza di SharedPreferences
final sharedPrefsInstanceProvider = StateProvider<SharedPreferences?>((ref) => null);

/// Provider di stato per l'istanza di Isar
final isarInstanceProvider = StateProvider<Isar?>((ref) => null);

/// Inizializza le dipendenze asincrone bloccanti (SharedPreferences e Isar)
final appInitializerProvider = FutureProvider<void>((ref) async {
  if (ref.read(sharedPrefsInstanceProvider) == null) {
    try {
      final prefs = await SharedPreferences.getInstance();
      ref.read(sharedPrefsInstanceProvider.notifier).state = prefs;
    } catch (e, st) {
      debugPrint('[AppInitializer] Errore inizializzazione SharedPreferences: $e\n$st');
    }
  }

  if (ref.read(isarInstanceProvider) == null) {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final isar = Isar.getInstance() ??
          await Isar.open(
            [
              UserStatsModelSchema,
              TimelineRecordModelSchema,
            ],
            directory: dir.path,
            inspector: kDebugMode,
          );
      ref.read(isarInstanceProvider.notifier).state = isar;
    } catch (e, st) {
      debugPrint('[AppInitializer] Errore apertura database Isar: $e\n$st');
      final existingIsar = Isar.getInstance();
      if (existingIsar != null) {
        ref.read(isarInstanceProvider.notifier).state = existingIsar;
      }
    }
  }

  // Auto-seeding atomico (id = 1) se nessun record è presente
  try {
    final isar = ref.read(isarInstanceProvider);
    if (isar != null) {
      final stats = await isar.userStatsModels.where().findFirst();
      if (stats == null) {
        await isar.writeTxn(() async {
          await isar.userStatsModels.put(UserStatsModel()..id = 1);
        });
        debugPrint('[AppInitializer] Auto-seeding UserStatsModel (id = 1) completato con successo.');
      }
    }
  } catch (e) {
    debugPrint('[AppInitializer] Errore auto-seeding: $e');
  }
});

