import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/repositories/user_repository.dart';
import '../../../core/database/models/user_stats_model.dart';

class MeTabData {
  final UserStatsModel? stats;
  final List<TimelineRecordModel> timeline;
  final String userName;
  final List<String> quizProblems;
  final List<String> quizGoals;
  final List<String> quizStrengths;
  final List<String> quizWeaknesses;
  final int profileStyle;

  MeTabData({
    this.stats,
    this.timeline = const [],
    this.userName = "Ospite Zen",
    this.quizProblems = const [],
    this.quizGoals = const [],
    this.quizStrengths = const [],
    this.quizWeaknesses = const [],
    this.profileStyle = 0,
  });
}

final meTabDataProvider = FutureProvider<MeTabData>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  final stats = await repo.getStats();
  final timeline = await repo.getTimeline();

  final prefs = repo.prefs;

  return MeTabData(
    stats: stats,
    timeline: timeline,
    userName: repo.profileName.isEmpty ? "Ospite Zen" : repo.profileName,
    quizProblems: prefs.getStringList("QuizProblems") ?? [],
    quizGoals: prefs.getStringList("QuizGoals") ?? [],
    quizStrengths: prefs.getStringList("QuizStrengths") ?? [],
    quizWeaknesses: prefs.getStringList("QuizWeaknesses") ?? [],
    profileStyle: prefs.getInt("ProfileStyle") ?? 0,
  );
});
