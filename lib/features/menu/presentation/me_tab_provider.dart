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

final meTabDataProvider = StreamProvider<MeTabData>((ref) async* {
  final repo = ref.watch(userRepositoryProvider);
  if (repo == null) {
    yield MeTabData();
    return;
  }

  final prefs = repo.prefs;
  final userName = repo.profileName.isEmpty ? "Ospite Zen" : repo.profileName;
  final quizProblems = prefs.getStringList("QuizProblems") ?? [];
  final quizGoals = prefs.getStringList("QuizGoals") ?? [];
  final quizStrengths = prefs.getStringList("QuizStrengths") ?? [];
  final quizWeaknesses = prefs.getStringList("QuizWeaknesses") ?? [];
  final profileStyle = prefs.getInt("ProfileStyle") ?? 0;

  await for (final stats in repo.watchStats()) {
    final timeline = await repo.getTimeline();
    yield MeTabData(
      stats: stats,
      timeline: timeline,
      userName: userName,
      quizProblems: quizProblems,
      quizGoals: quizGoals,
      quizStrengths: quizStrengths,
      quizWeaknesses: quizWeaknesses,
      profileStyle: profileStyle,
    );
  }
});
