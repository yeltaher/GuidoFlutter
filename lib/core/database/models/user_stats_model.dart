import 'package:isar/isar.dart';

part 'user_stats_model.g.dart';

@collection
class UserStatsModel {
  Id id = Isar.autoIncrement;

  int totalMinutes = 0;
  int totalSessions = 0;
  int profileXp = 0;

  int currentStreak = 0;
  int longestStreak = 0;
  String? lastSessionDate;

  /// Dynamic streak calculation:
  /// - If difference between today and lastSessionDate is 0 or 1 day, streak is valid.
  /// - If difference is >= 2 days, returns 0.
  int effectiveStreak([DateTime? now]) {
    if (lastSessionDate == null || lastSessionDate!.isEmpty) {
      return currentStreak;
    }
    try {
      final parsed = DateTime.parse(lastSessionDate!);
      final current = now ?? DateTime.now();
      final today = DateTime.utc(current.year, current.month, current.day);
      final lastDate = DateTime.utc(parsed.year, parsed.month, parsed.day);
      final diff = today.difference(lastDate).inDays;
      if (diff >= 2) {
        return 0;
      }
      return currentStreak;
    } catch (_) {
      return currentStreak;
    }
  }

  int get effectiveCurrentStreak => effectiveStreak();
}

@collection
class TimelineRecordModel {
  Id id = Isar.autoIncrement;

  late String title;
  late String type;
  late String duration;
  @Index()
  late int timestamp;
}
