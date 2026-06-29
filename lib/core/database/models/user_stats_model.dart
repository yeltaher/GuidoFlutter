import 'package:isar/isar.dart';

part 'user_stats_model.g.dart';

@collection
class UserStatsModel {
  Id id = Isar.autoIncrement;

  int totalMinutes = 0;
  int totalSessions = 0;
  int profileXp = 0;

  int currentStreak = 0;
  String? lastSessionDate;
}

@collection
class TimelineRecordModel {
  Id id = Isar.autoIncrement;

  late String title;
  late String type;
  late String duration;
  late int timestamp;
}
