import 'package:isar/isar.dart';
import '../models/user_stats_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../settings_provider.dart';

/// Provider for Isar instance
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('isarProvider not initialized');
});

class UserRepository {
  final Isar isar;
  final SharedPreferences prefs;

  UserRepository(this.isar, this.prefs);

  Future<void> recordSession(String sessionTitle, String sessionType) async {
    final int minutes = sessionType == "Respirazione" ? 8 : 15;
    final int xpEarned = minutes * 2;

    await isar.writeTxn(() async {
      var stats = await isar.userStatsModels.where().findFirst();
      if (stats == null) {
        stats = UserStatsModel();
      }

      stats.totalMinutes += minutes;
      stats.totalSessions += 1;
      stats.profileXp += xpEarned;

      final todayStr = DateTime.now().toIso8601String().substring(0, 10);
      if (stats.lastSessionDate != todayStr) {
        stats.currentStreak += 1;
        stats.lastSessionDate = todayStr;
      }
      
      await isar.userStatsModels.put(stats);

      final record = TimelineRecordModel()
        ..title = sessionTitle
        ..type = sessionType
        ..duration = "$minutes MIN"
        ..timestamp = DateTime.now().millisecondsSinceEpoch;

      await isar.timelineRecordModels.put(record);
      
      // keep only last 10 records
      final allRecords = await isar.timelineRecordModels.where().sortByTimestampDesc().findAll();
      if (allRecords.length > 10) {
        final toDelete = allRecords.sublist(10).map((e) => e.id).toList();
        await isar.timelineRecordModels.deleteAll(toDelete);
      }
    });
  }

  Future<UserStatsModel?> getStats() async {
    return isar.userStatsModels.where().findFirst();
  }

  Future<List<TimelineRecordModel>> getTimeline() async {
    return isar.timelineRecordModels.where().sortByTimestampDesc().findAll();
  }

  String get profileName => prefs.getString("ProfileName") ?? "";
  Future<void> setProfileName(String name) => prefs.setString("ProfileName", name);

  bool get isOnboarded => prefs.getBool("IsOnboarded") ?? false;
  Future<void> setOnboarded(bool value) => prefs.setBool("IsOnboarded", value);
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(isarProvider), ref.watch(sharedPrefsProvider));
});
