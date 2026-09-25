import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guido/core/database/models/user_stats_model.dart';
import 'package:guido/core/database/repositories/user_repository.dart';
import 'package:isar/isar.dart';

class FakeIsar implements Isar {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserRepository Unit Tests', () {
    late UserRepository repository;
    late SharedPreferences prefs;
    late FakeIsar fakeIsar;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      fakeIsar = FakeIsar();
      repository = UserRepository(fakeIsar, prefs);
    });

    test('profileName returns empty string by default', () {
      expect(repository.profileName, "");
    });

    test('setProfileName updates the profileName', () async {
      await repository.setProfileName("TestUser");
      expect(repository.profileName, "TestUser");
    });

    test('isOnboarded returns false by default', () {
      expect(repository.isOnboarded, false);
    });

    test('setOnboarded updates the onboarded status', () async {
      await repository.setOnboarded(true);
      expect(repository.isOnboarded, true);
    });

    test('streak calculation logic increments on consecutive day and resets on gap', () {
      // Test sequence of date calculations
      final day1 = DateTime.utc(2026, 9, 20);
      final day2 = DateTime.utc(2026, 9, 21);
      final day2Evening = DateTime.utc(2026, 9, 21);
      final day4 = DateTime.utc(2026, 9, 23);

      int currentStreak = 0;
      int longestStreak = 0;
      String? lastSessionDate;

      void record(DateTime dt) {
        final today = DateTime.utc(dt.year, dt.month, dt.day);
        final todayStr = "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

        DateTime? lastDate;
        if (lastSessionDate != null && lastSessionDate!.isNotEmpty) {
          final parsed = DateTime.parse(lastSessionDate!);
          lastDate = DateTime.utc(parsed.year, parsed.month, parsed.day);
        }

        if (lastDate == null) {
          currentStreak = 1;
          if (1 > longestStreak) longestStreak = 1;
        } else {
          final diff = today.difference(lastDate).inDays;
          if (diff == 0) {
            if (currentStreak > longestStreak) longestStreak = currentStreak;
          } else if (diff == 1) {
            currentStreak += 1;
            if (currentStreak > longestStreak) longestStreak = currentStreak;
          } else if (diff > 1) {
            currentStreak = 1;
            if (1 > longestStreak) longestStreak = 1;
          }
        }
        lastSessionDate = todayStr;
      }

      // Day 1: first session
      record(day1);
      expect(currentStreak, 1);
      expect(longestStreak, 1);

      // Day 2: consecutive day
      record(day2);
      expect(currentStreak, 2);
      expect(longestStreak, 2);

      // Day 2 evening: same day
      record(day2Evening);
      expect(currentStreak, 2);
      expect(longestStreak, 2);

      // Day 4: skipped day 3 (diff = 2)
      record(day4);
      expect(currentStreak, 1);
      expect(longestStreak, 2); // longest streak preserved
    });

    test('effectiveCurrentStreak dynamic calculation rules (diff <= 1 valid, diff >= 2 returns 0)', () {
      final stats = UserStatsModel()
        ..currentStreak = 4
        ..longestStreak = 5
        ..lastSessionDate = "2026-09-24";

      // Today is same day (diff = 0) -> streak valid
      expect(stats.effectiveStreak(DateTime.utc(2026, 9, 24)), 4);
      expect(repository.calculateEffectiveStreak(stats, DateTime.utc(2026, 9, 24)), 4);

      // Today is next day (diff = 1) -> streak valid
      expect(stats.effectiveStreak(DateTime.utc(2026, 9, 25)), 4);
      expect(repository.calculateEffectiveStreak(stats, DateTime.utc(2026, 9, 25)), 4);

      // Today is 2 days later (diff = 2) -> streak broken, returns 0
      expect(stats.effectiveStreak(DateTime.utc(2026, 9, 26)), 0);
      expect(repository.calculateEffectiveStreak(stats, DateTime.utc(2026, 9, 26)), 0);

      // Today is 5 days later (diff = 5) -> returns 0
      expect(stats.effectiveStreak(DateTime.utc(2026, 9, 29)), 0);
      expect(repository.calculateEffectiveStreak(stats, DateTime.utc(2026, 9, 29)), 0);
    });
  });
}
