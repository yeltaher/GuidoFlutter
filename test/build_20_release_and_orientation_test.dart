import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guido/core/database/settings_provider.dart';
import 'package:guido/core/database/app_initializer_provider.dart';
import 'package:guido/core/unity/unity_bridge_dto.dart';
import 'package:guido/core/unity/unity_session_controller.dart';
import 'package:guido/core/theme/custom_button_widget.dart';
import 'package:guido/features/meditation/presentation/session_launch_helper.dart';
import 'package:guido/features/meditation/presentation/unity_experience_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> systemChromeCalls = [];

  setUp(() {
    systemChromeCalls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (MethodCall methodCall) async {
      systemChromeCalls.add(methodCall);
      if (methodCall.method == 'SystemChrome.setPreferredOrientations') {
        return null;
      }
      if (methodCall.method == 'SystemChrome.setEnabledSystemUIMode') {
        return null;
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  group('Build 20: 1. Pubspec Version & Configuration Quality Gates', () {
    test('pubspec.yaml has version 0.1.0+27', () {
      final pubspecFile = File('pubspec.yaml');
      expect(pubspecFile.existsSync(), isTrue);
      final content = pubspecFile.readAsStringSync();
      expect(content.contains('version: 0.1.0+27'), isTrue);
    });

    test('iOS Info.plist contains required camera, motion, audio and orientation keys', () {
      final infoPlistFile = File('ios/Runner/Info.plist');
      expect(infoPlistFile.existsSync(), isTrue);
      final content = infoPlistFile.readAsStringSync();
      expect(content.contains('NSCameraUsageDescription'), isTrue);
      expect(content.contains('NSMotionUsageDescription'), isTrue);
      expect(content.contains('UIBackgroundModes'), isTrue);
      expect(content.contains('<string>audio</string>'), isTrue);
      expect(content.contains('UIInterfaceOrientationPortrait'), isTrue);
      expect(content.contains('UIInterfaceOrientationLandscapeLeft'), isTrue);
      expect(content.contains('UIInterfaceOrientationLandscapeRight'), isTrue);
    });

    test('iOS PrivacyInfo.xcprivacy contains NSPrivacyAccessedAPITypes', () {
      final privacyFile = File('ios/Runner/PrivacyInfo.xcprivacy');
      expect(privacyFile.existsSync(), isTrue);
      final content = privacyFile.readAsStringSync();
      expect(content.contains('NSPrivacyAccessedAPICategoryUserDefaults'), isTrue);
      expect(content.contains('NSPrivacyAccessedAPICategoryFileTimestamp'), isTrue);
    });

    test('ios/Podfile includes system(git lfs pull) in pre_install', () {
      final podfile = File('ios/Podfile');
      expect(podfile.existsSync(), isTrue);
      final content = podfile.readAsStringSync();
      expect(content.contains('git lfs pull'), isTrue);
      expect(content.contains('pre_install'), isTrue);
    });

    test('ios/Runner.xcworkspace contains UnityLibrary preceding Runner', () {
      final workspaceFile = File('ios/Runner.xcworkspace/contents.xcworkspacedata');
      expect(workspaceFile.existsSync(), isTrue);
      final content = workspaceFile.readAsStringSync();
      final unityIndex = content.indexOf('UnityLibrary/Unity-iPhone.xcodeproj');
      final runnerIndex = content.indexOf('Runner.xcodeproj');
      expect(unityIndex, isNonNegative);
      expect(runnerIndex, isNonNegative);
      expect(unityIndex < runnerIndex, isTrue);
    });

    test('ios/Runner.xcscheme has parallelizeBuildables = NO and UnityFramework before Runner', () {
      final schemeFile = File('ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme');
      expect(schemeFile.existsSync(), isTrue);
      final content = schemeFile.readAsStringSync();
      expect(content.contains('parallelizeBuildables = "NO"'), isTrue);
      final unityIndex = content.indexOf('BlueprintName = "UnityFramework"');
      final runnerIndex = content.indexOf('BlueprintName = "Runner"');
      expect(unityIndex, isNonNegative);
      expect(runnerIndex, isNonNegative);
      expect(unityIndex < runnerIndex, isTrue);
    });

    test('ios/Runner.xcodeproj FRAMEWORK_SEARCH_PATHS includes BUILT_PRODUCTS_DIR', () {
      final pbxFile = File('ios/Runner.xcodeproj/project.pbxproj');
      expect(pbxFile.existsSync(), isTrue);
      final content = pbxFile.readAsStringSync();
      expect(content.contains(r'$(BUILT_PRODUCTS_DIR)'), isTrue);
      expect(content.contains(r'"$(PROJECT_DIR)/UnityLibrary"'), isFalse);
    });
  });

  Future<void> holdCustomButton(WidgetTester tester, Finder finder) async {
    final gesture = await tester.startGesture(tester.getCenter(finder));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1400));
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 300));
  }

  group('Build 20: 2. Unity Orientation Lifecycle Tests', () {
    testWidgets('UnityExperienceScreen sets landscape orientations in initState and restores portrait on exit', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      String? currentRoute;
      final router = GoRouter(
        initialLocation: '/unity-experience',
        routes: [
          GoRoute(
            path: '/unity-experience',
            builder: (context, state) => const UnityExperienceScreen(
              title: 'Meditazione Acqua',
              sceneName: UnityScenes.waterMeditation,
              durationSeconds: 300.0,
              isVrMode: false,
            ),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) {
              currentRoute = '/home';
              return const Scaffold(body: Text('Home View'));
            },
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Simulate Unity notifying that scene is loaded
      container.read(unitySessionControllerProvider.notifier).onUnityMessage(
        'SCENE_LOADED',
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Check that SystemChrome.setPreferredOrientations was called with landscape
      final orientationCalls = systemChromeCalls
          .where((call) => call.method == 'SystemChrome.setPreferredOrientations')
          .toList();

      expect(orientationCalls.isNotEmpty, isTrue);
      final firstCallArgs = orientationCalls.first.arguments as List;
      expect(
        firstCallArgs.contains('DeviceOrientation.landscapeLeft') ||
        firstCallArgs.contains('DeviceOrientation.landscapeRight'),
        isTrue,
      );

      // Trigger exit confirmation
      final closeButton = find.byIcon(Icons.close_rounded);
      expect(closeButton, findsOneWidget);
      await tester.tap(closeButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Tap confirm exit (ESCI is a CustomUnityButton which requires holding)
      final exitConfirmButton = find.widgetWithText(CustomUnityButton, 'ESCI');
      expect(exitConfirmButton, findsOneWidget);
      await holdCustomButton(tester, exitConfirmButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(currentRoute, '/home');

      // Check that portrait orientation was restored
      final lastOrientationCall = systemChromeCalls
          .where((call) => call.method == 'SystemChrome.setPreferredOrientations')
          .last;
      final lastCallArgs = lastOrientationCall.arguments as List;
      expect(lastCallArgs.contains('DeviceOrientation.portraitUp'), isTrue);

      container.read(unitySessionControllerProvider.notifier).stopSession();
      await tester.pump(const Duration(milliseconds: 100));
    });
  });

  group('Build 20: 3. Pure Unity Session Routing Tests', () {
    testWidgets('SessionLaunchDialog Standard Mode launches UnityExperienceScreen with isVrMode = false', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic>? unityExtra;
      final router = GoRouter(
        initialLocation: '/dialog-host',
        routes: [
          GoRoute(
            path: '/dialog-host',
            builder: (context, state) => Scaffold(
              body: Center(
                child: Builder(
                  builder: (ctx) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: ctx,
                        builder: (_) => const SessionLaunchDialog(
                          title: 'Meditazione Acqua',
                          voicePath: '',
                          ambientPath: '',
                          sceneName: UnityScenes.waterMeditation,
                          durationSeconds: 300.0,
                        ),
                      );
                    },
                    child: const Text('OPEN DIALOG'),
                  ),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/unity-experience',
            builder: (context, state) {
              unityExtra = state.extra as Map<String, dynamic>?;
              return const Scaffold(body: Text('Unity Experience Target'));
            },
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pump();
      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      expect(find.text('Modalità Standard'), findsOneWidget);
      expect(find.text('Modalità Visore VR 3D'), findsOneWidget);

      // Tap Modalità Standard
      await tester.tap(find.text('Modalità Standard'));
      await tester.pumpAndSettle();

      expect(unityExtra, isNotNull);
      expect(unityExtra!['isVrMode'], isFalse);
      expect(unityExtra!['title'], 'Meditazione Acqua');
    });
  });
}
