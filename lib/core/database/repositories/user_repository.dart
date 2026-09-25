import 'dart:math' as math;
import 'package:isar/isar.dart';
import '../models/user_stats_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../settings_provider.dart';
import '../app_initializer_provider.dart';

/// Provider for Isar instance.
/// Ritorna null se Isar non è ancora stato inizializzato.
/// I consumer devono gestire il caso null (es. mostrare loading).
final isarProvider = Provider<Isar?>((ref) {
  return ref.watch(isarInstanceProvider);
});

class UserRepository {
  final Isar isar;
  final SharedPreferences prefs;

  UserRepository(this.isar, this.prefs);

  /// Assicura l'esistenza atomica di un record UserStatsModel predefinito (id = 1).
  Future<UserStatsModel> ensureSeeded() async {
    var stats = await isar.userStatsModels.where().findFirst();
    if (stats == null) {
      final initialStats = UserStatsModel()..id = 1;
      await isar.writeTxn(() async {
        await isar.userStatsModels.put(initialStats);
      });
      return initialStats;
    }
    return stats;
  }

  /// Calcola lo streak effettivo corrente:
  /// Se la differenza tra oggi e lastSessionDate è 0 o 1 giorno, la streak è valida;
  /// se è maggiore o uguale a 2 giorni, restituisce 0.
  int calculateEffectiveStreak(UserStatsModel? stats, [DateTime? now]) {
    if (stats == null) return 0;
    return stats.effectiveStreak(now);
  }

  Future<void> recordSession(
    String sessionTitle,
    String sessionType, {
    int? durationMinutes,
    int? xp,
    DateTime? now,
  }) async {
    final int minutes =
        durationMinutes ?? (sessionType == "Respirazione" ? 8 : 15);
    final int xpEarned = xp ?? (minutes * 2);
    final currentTime = now ?? DateTime.now();

    await isar.writeTxn(() async {
      var stats = await isar.userStatsModels.where().findFirst();
      stats ??= UserStatsModel()..id = 1;

      stats.totalMinutes += minutes;
      stats.totalSessions += 1;
      stats.profileXp += xpEarned;

      // Normalizzazione della data odierna (midnight UTC per evitare anomalie DST)
      final today =
          DateTime.utc(currentTime.year, currentTime.month, currentTime.day);
      final todayStr =
          "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      DateTime? lastDate;
      if (stats.lastSessionDate != null && stats.lastSessionDate!.isNotEmpty) {
        try {
          final parsed = DateTime.parse(stats.lastSessionDate!);
          lastDate = DateTime.utc(parsed.year, parsed.month, parsed.day);
        } catch (_) {
          lastDate = null;
        }
      }

      if (lastDate == null) {
        // Nessuna sessione precedente: streak = 1
        stats.currentStreak = 1;
        stats.longestStreak = math.max(stats.longestStreak, 1);
      } else {
        final diff = today.difference(lastDate).inDays;
        if (diff == 0) {
          // Stesso giorno (diff == 0): non incrementare ulteriormente la streak
          stats.longestStreak =
              math.max(stats.longestStreak, stats.currentStreak);
        } else if (diff == 1) {
          // Giorno successivo (diff == 1): incrementa streak
          stats.currentStreak += 1;
          stats.longestStreak =
              math.max(stats.longestStreak, stats.currentStreak);
        } else if (diff > 1) {
          // Giorni saltati (diff > 1): reset streak a 1
          stats.currentStreak = 1;
          stats.longestStreak = math.max(stats.longestStreak, 1);
        } else {
          // Data passata / anomalie clock: preserva streak
          stats.longestStreak =
              math.max(stats.longestStreak, stats.currentStreak);
        }
      }

      stats.lastSessionDate = todayStr;

      await isar.userStatsModels.put(stats);

      final record = TimelineRecordModel()
        ..title = sessionTitle
        ..type = sessionType
        ..duration = "$minutes MIN"
        ..timestamp = currentTime.millisecondsSinceEpoch;

      await isar.timelineRecordModels.put(record);

      // keep only last 10 records
      final allRecords = await isar.timelineRecordModels
          .where()
          .sortByTimestampDesc()
          .findAll();
      if (allRecords.length > 10) {
        final toDelete = allRecords.sublist(10).map((e) => e.id).toList();
        await isar.timelineRecordModels.deleteAll(toDelete);
      }
    });
  }

  Future<UserStatsModel?> getStats() async {
    return isar.userStatsModels.where().findFirst();
  }

  Stream<UserStatsModel?> watchStats() {
    return isar.userStatsModels.where().watch(fireImmediately: true).map(
      (list) => list.isNotEmpty ? list.first : null,
    );
  }

  Future<List<TimelineRecordModel>> getTimeline() async {
    return isar.timelineRecordModels.where().sortByTimestampDesc().findAll();
  }

  Stream<List<TimelineRecordModel>> watchTimeline() {
    return isar.timelineRecordModels
        .where()
        .sortByTimestampDesc()
        .watch(fireImmediately: true);
  }

  String get profileName => prefs.getString("ProfileName") ?? "";
  Future<void> setProfileName(String name) =>
      prefs.setString("ProfileName", name);

  bool get isOnboarded => prefs.getBool("IsOnboarded") ?? false;
  Future<void> setOnboarded(bool value) => prefs.setBool("IsOnboarded", value);
}

final userRepositoryProvider = Provider<UserRepository?>((ref) {
  final isar = ref.watch(isarProvider);
  final prefs = ref.watch(sharedPrefsProvider);
  if (isar == null || prefs == null) return null;
  return UserRepository(isar, prefs);
});

final userStatsStreamProvider = StreamProvider<UserStatsModel?>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  if (repo == null) return Stream.value(null);
  return repo.watchStats();
});

final userTimelineStreamProvider =
    StreamProvider<List<TimelineRecordModel>>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  if (repo == null) return Stream.value([]);
  return repo.watchTimeline();
});
