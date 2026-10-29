import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guido/core/database/settings_provider.dart';
import 'package:guido/core/database/app_initializer_provider.dart';
import 'package:guido/core/session/zen_session_dto.dart';
import 'package:guido/features/meditation/presentation/session_launch_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> systemChromeCalls = [];
  const orientationChannel = MethodChannel('com.codepulse.guido/orientation');

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

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(orientationChannel, (MethodCall methodCall) async {
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(orientationChannel, null);
  });

  group('Build 20: 1. Pubspec Version & Configuration Quality Gates', () {
    test('pubspec.yaml has version 0.1.0+30', () {
      final pubspecFile = File('pubspec.yaml');
      expect(pubspecFile.existsSync(), isTrue);
      final content = pubspecFile.readAsStringSync();
      expect(content.contains('version: 0.1.0+30'), isTrue);
    });

    test('iOS Info.plist conforms to App Store guidelines with motion, audio, ATS and encryption exempt', () {
      final infoPlistFile = File('ios/Runner/Info.plist');
      expect(infoPlistFile.existsSync(), isTrue);
      final content = infoPlistFile.readAsStringSync();
      expect(content.contains('NSCameraUsageDescription'), isFalse);
      expect(content.contains('NSMicrophoneUsageDescription'), isFalse);
      expect(content.contains('NSMotionUsageDescription'), isTrue);
      expect(content.contains('NSAppTransportSecurity'), isTrue);
      expect(content.contains('NSAllowsArbitraryLoads'), isTrue);
      expect(content.contains('NSAllowsLocalNetworking'), isTrue);
      expect(content.contains('ITSAppUsesNonExemptEncryption'), isTrue);
      expect(content.contains('UIBackgroundModes'), isTrue);
    });

    test('iOS Podfile enforces static linkage and excludes Unity', () {
      final podfile = File('ios/Podfile');
      expect(podfile.existsSync(), isTrue);
      final content = podfile.readAsStringSync();
      expect(content.contains('use_frameworks! :linkage => :static'), isTrue);
      expect(content.contains('ENABLE_DEBUG_DYLIB'), isTrue);
      expect(content.contains('UnityLibrary'), isFalse);
      expect(content.contains('flutter_unity_widget'), isFalse);
    });

    test('ios/Runner.xcworkspace does not include UnityLibrary', () {
      final workspaceFile = File('ios/Runner.xcworkspace/contents.xcworkspacedata');
      expect(workspaceFile.existsSync(), isTrue);
      final content = workspaceFile.readAsStringSync();
      expect(content.contains('UnityLibrary/Unity-iPhone.xcodeproj'), isFalse);
      expect(content.contains('Runner.xcodeproj'), isTrue);
    });

    test('ios/Runner.xcscheme has parallelizeBuildables = YES and no UnityFramework entry', () {
      final schemeFile = File('ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme');
      expect(schemeFile.existsSync(), isTrue);
      final content = schemeFile.readAsStringSync();
      expect(content.contains('parallelizeBuildables = "YES"'), isTrue);
      expect(content.contains('BlueprintName = "UnityFramework"'), isFalse);
      expect(content.contains('BlueprintName = "Runner"'), isTrue);
    });

    test('ios/Runner.xcodeproj FRAMEWORK_SEARCH_PATHS includes BUILT_PRODUCTS_DIR', () {
      final pbxFile = File('ios/Runner.xcodeproj/project.pbxproj');
      expect(pbxFile.existsSync(), isTrue);
      final content = pbxFile.readAsStringSync();
      expect(content.contains(r'$(BUILT_PRODUCTS_DIR)'), isTrue);
      expect(content.contains(r'"$(PROJECT_DIR)/UnityLibrary"'), isFalse);
    });

    test('ios/Runner.xcodeproj does not embed or link UnityFramework or UnityRuntime', () {
      final pbxFile = File('ios/Runner.xcodeproj/project.pbxproj');
      expect(pbxFile.existsSync(), isTrue);
      final content = pbxFile.readAsStringSync();
      expect(content.contains('UnityRuntime.framework in Embed Frameworks'), isFalse);
      expect(content.contains('UnityRuntime.framework in Frameworks'), isFalse);
      expect(content.contains('UnityFramework.framework in Embed Frameworks'), isFalse);
      expect(content.contains('UnityFramework.framework in Frameworks'), isFalse);
      expect(content.contains('UnityFramework.framework'), isFalse);
    });

    test('ios/Runner/Runner-Bridging-Header.h does not reference UnityFramework', () {
      final headerFile = File('ios/Runner/Runner-Bridging-Header.h');
      expect(headerFile.existsSync(), isTrue);
      final content = headerFile.readAsStringSync();
      expect(content.contains('UnityFramework'), isFalse);
    });
  });

  group('Build 20: 2. Pure WebXR Session Routing Tests', () {
    testWidgets('SessionLaunchDialog Standard Mode launches WebXR with isVrMode = false', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic>? vrExtra;
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
                          title: 'Procedimento Acqua',
                          voicePath: '',
                          ambientPath: '',
                          sceneName: ZenScenes.waterTutorial,
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
            path: '/vr-experience',
            builder: (context, state) {
              vrExtra = state.extra as Map<String, dynamic>?;
              return const Scaffold(body: Text('VR Experience Target'));
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

      expect(vrExtra, isNotNull);
      expect(vrExtra!['isVrMode'], isFalse);
    });
  });
}
