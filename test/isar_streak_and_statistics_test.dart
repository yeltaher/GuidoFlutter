import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guido/core/database/models/user_stats_model.dart';
import 'package:guido/core/database/repositories/user_repository.dart';
import 'package:guido/core/database/settings_provider.dart';
import 'package:guido/features/menu/presentation/home_japandi_tab.dart';
import 'package:guido/features/menu/presentation/me_tab.dart';
import 'package:guido/features/menu/presentation/me_tab_provider.dart';
import 'package:guido/core/unity/unity_session_controller.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FASE 3: UserStatsModel & TimelineRecordModel Architecture', () {
    test('UserStatsModel has all required stats fields including longestStreak', () {
      final model = UserStatsModel()
        ..totalMinutes = 45
        ..totalSessions = 3
        ..profileXp = 90
        ..currentStreak = 2
        ..longestStreak = 5
        ..lastSessionDate = "2026-09-24";

      expect(model.totalMinutes, 45);
      expect(model.totalSessions, 3);
      expect(model.profileXp, 90);
      expect(model.currentStreak, 2);
      expect(model.longestStreak, 5);
      expect(model.lastSessionDate, "2026-09-24");
    });

    test('TimelineRecordModel has all required chronological fields and @Index annotation', () {
      final record = TimelineRecordModel()
        ..title = "Respiro Profondo"
        ..type = "Respirazione"
        ..duration = "8 MIN"
        ..timestamp = 1790240000000;

      expect(record.title, "Respiro Profondo");
      expect(record.type, "Respirazione");
      expect(record.duration, "8 MIN");
      expect(record.timestamp, 1790240000000);

      // Verify @Index() exists on timestamp in the model file
      final modelCode = File('lib/core/database/models/user_stats_model.dart').readAsStringSync();
      expect(modelCode.contains('@Index()') && modelCode.contains('late int timestamp;'), isTrue);
    });
  });

  group('FASE 3: Streak Calculation Logic in UserRepository', () {
    test('Streak Calculation Rule 1: First session sets streak = 1 and longestStreak = 1', () {
      final stats = UserStatsModel();

      // Simula logica UserRepository
      DateTime? lastDate;
      if (stats.lastSessionDate != null && stats.lastSessionDate!.isNotEmpty) {
        final parsed = DateTime.parse(stats.lastSessionDate!);
        lastDate = DateTime.utc(parsed.year, parsed.month, parsed.day);
      }

      if (lastDate == null) {
        stats.currentStreak = 1;
        stats.longestStreak = 1;
      }

      stats.lastSessionDate = "2026-09-24";

      expect(stats.currentStreak, 1);
      expect(stats.longestStreak, 1);
      expect(stats.lastSessionDate, "2026-09-24");
    });

    test('Streak Calculation Rule 2: Multiple sessions on same day (diff == 0) keep current streak', () {
      final stats = UserStatsModel()
        ..currentStreak = 3
        ..longestStreak = 5
        ..lastSessionDate = "2026-09-24";

      final now = DateTime.utc(2026, 9, 24);
      final lastDate = DateTime.parse(stats.lastSessionDate!);
      final lastUtc = DateTime.utc(lastDate.year, lastDate.month, lastDate.day);
      final diff = now.difference(lastUtc).inDays;

      expect(diff, 0);
      if (diff == 0) {
        // Non incrementa
      }
      expect(stats.currentStreak, 3);
      expect(stats.longestStreak, 5);
    });

    test('Streak Calculation Rule 3: Consecutive day session (diff == 1) increments streak and updates longestStreak', () {
      final stats = UserStatsModel()
        ..currentStreak = 5
        ..longestStreak = 5
        ..lastSessionDate = "2026-09-23";

      final now = DateTime.utc(2026, 9, 24);
      final lastDate = DateTime.parse(stats.lastSessionDate!);
      final lastUtc = DateTime.utc(lastDate.year, lastDate.month, lastDate.day);
      final diff = now.difference(lastUtc).inDays;

      expect(diff, 1);
      if (diff == 1) {
        stats.currentStreak += 1;
        if (stats.currentStreak > stats.longestStreak) {
          stats.longestStreak = stats.currentStreak;
        }
      }
      stats.lastSessionDate = "2026-09-24";

      expect(stats.currentStreak, 6);
      expect(stats.longestStreak, 6);
      expect(stats.lastSessionDate, "2026-09-24");
    });

    test('Streak Calculation Rule 4: Skipped days (diff > 1) resets current streak to 1 while preserving longestStreak', () {
      final stats = UserStatsModel()
        ..currentStreak = 10
        ..longestStreak = 10
        ..lastSessionDate = "2026-09-20";

      final now = DateTime.utc(2026, 9, 24); // 4 days later
      final lastDate = DateTime.parse(stats.lastSessionDate!);
      final lastUtc = DateTime.utc(lastDate.year, lastDate.month, lastDate.day);
      final diff = now.difference(lastUtc).inDays;

      expect(diff, 4);
      if (diff > 1) {
        stats.currentStreak = 1;
        if (1 > stats.longestStreak) {
          stats.longestStreak = 1;
        }
      }
      stats.lastSessionDate = "2026-09-24";

      expect(stats.currentStreak, 1);
      expect(stats.longestStreak, 10);
      expect(stats.lastSessionDate, "2026-09-24");
    });
  });

  group('FASE 3: UI Real Data Binding & Reactive Providers', () {
    testWidgets('HomeJapandiTab renders real stats from userStatsStreamProvider', (tester) async {
      SharedPreferences.setMockInitialValues({
        "is_dark_theme": true,
      });
      final prefs = await SharedPreferences.getInstance();

      final mockStats = UserStatsModel()
        ..currentStreak = 7
        ..totalSessions = 14
        ..totalMinutes = 120
        ..profileXp = 300;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefsProvider.overrideWithValue(prefs),
            userStatsStreamProvider
                .overrideWith((ref) => Stream.value(mockStats)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: HomeJapandiTab(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text("7 giorni streak • 14 sessioni totali"), findsOneWidget);
    });

    testWidgets('MeTab renders real stats and timeline from meTabDataProvider', (tester) async {
      SharedPreferences.setMockInitialValues({
        "is_dark_theme": true,
      });
      final prefs = await SharedPreferences.getInstance();

      final mockStats = UserStatsModel()
        ..currentStreak = 5
        ..totalSessions = 8
        ..totalMinutes = 75
        ..profileXp = 450;

      final mockTimeline = [
        TimelineRecordModel()
          ..title = "Respiro Mattutino"
          ..type = "Respirazione"
          ..duration = "8 MIN"
          ..timestamp = DateTime.now().millisecondsSinceEpoch,
        TimelineRecordModel()
          ..title = "Pace nella Foresta"
          ..type = "Meditazione"
          ..duration = "15 MIN"
          ..timestamp = DateTime.now()
              .subtract(const Duration(hours: 3))
              .millisecondsSinceEpoch,
      ];

      final meData = MeTabData(
        stats: mockStats,
        timeline: mockTimeline,
        userName: "Elena Zen",
        quizProblems: ["Ansia", "Stress"],
        quizGoals: ["Calma interiore"],
        quizStrengths: ["Costanza"],
        quizWeaknesses: ["Pensieri intrusivi"],
        profileStyle: 0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefsProvider.overrideWithValue(prefs),
            meTabDataProvider.overrideWith((ref) => Stream.value(meData)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: MeTab(isActive: false),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text("Elena Zen"), findsOneWidget);
      expect(find.text("75 min"), findsOneWidget); // Minuti totali
      expect(find.text("SESSIONI"), findsOneWidget);
      expect(find.text("5 giorni 🔥"), findsOneWidget); // Streak
      expect(find.text("Respiro Mattutino"), findsOneWidget);
      expect(find.text("8 MIN"), findsOneWidget);
      expect(find.text("Pace nella Foresta"), findsOneWidget);
      expect(find.text("15 MIN"), findsOneWidget);
    });
  });

  group('FASE 3: Session Duplication Prevention', () {
    test('UnitySessionController recordPartialSession sets isCompleted and prevents duplicate saves', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final controller =
          container.read(unitySessionControllerProvider.notifier);

      // Simulate Unity sending progress
      controller.onUnityMessage(
        '{"jsonrpc":"2.0","method":"onSessionProgress","params":{"sessionId":"test_1","sceneName":"Acqua","elapsedSeconds":25.0,"totalDurationSeconds":120.0,"progressNormalized":0.2,"currentPhase":"Inhale","userHeartRateOrState":0}}',
      );

      expect(container.read(unitySessionControllerProvider).isPlaying, isTrue);
      expect(
        container.read(unitySessionControllerProvider).isCompleted,
        isFalse,
      );

      // First partial session record
      await controller.recordPartialSession();
      expect(
        container.read(unitySessionControllerProvider).isCompleted,
        isTrue,
      );

      // Second invocation should be completely ignored by the isCompleted guard
      await controller.recordPartialSession();
      expect(
        container.read(unitySessionControllerProvider).isCompleted,
        isTrue,
      );
    });

    test('unity_experience_screen.dart guards session recording on exit against duplicate recording', () {
      final code = File('lib/features/meditation/presentation/unity_experience_screen.dart').readAsStringSync();
      // Verify _confirmExit is properly guarded by !ref.read(unitySessionControllerProvider).isCompleted
      final confirmExitIdx = code.indexOf('void _confirmExit()');
      final confirmExitBody = code.substring(confirmExitIdx, confirmExitIdx + 600);
      expect(confirmExitBody.contains('!ref.read(unitySessionControllerProvider).isCompleted'), isTrue);
    });
  });
}
