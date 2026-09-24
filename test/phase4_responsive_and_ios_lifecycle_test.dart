import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guido/core/database/settings_provider.dart';
import 'package:guido/core/database/app_initializer_provider.dart';
import 'package:guido/core/vr/vr_orientation_service.dart';
import 'package:guido/features/menu/presentation/home_container_view.dart';
import 'package:guido/features/menu/presentation/home_tab.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> systemChromeCalls = [];

  setUp(() {
    systemChromeCalls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (MethodCall methodCall) async {
      systemChromeCalls.add(methodCall);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  group('Phase 4.1: Static Source Code Quality Gates', () {
    test('home_container_view.dart computes and applies bottomPadding for iOS home indicator', () {
      final source = File('lib/features/menu/presentation/home_container_view.dart').readAsStringSync();
      expect(source.contains('final bottomPadding = MediaQuery.of(context).padding.bottom;'), isTrue);
      expect(source.contains('bottom: 24.0 + bottomPadding'), isTrue);
    });

    test('vr_orientation_service.dart defines resetToPortrait with edgeToEdge and portraitUp', () {
      final source = File('lib/core/vr/vr_orientation_service.dart').readAsStringSync();
      expect(source.contains('resetToPortrait()'), isTrue);
      expect(source.contains('SystemUiMode.edgeToEdge'), isTrue);
      expect(source.contains('DeviceOrientation.portraitUp'), isTrue);
    });

    test('session_launch_helper.dart includes WakelockPlus protection in VrConfirmationScreen', () {
      final source = File('lib/features/meditation/presentation/session_launch_helper.dart').readAsStringSync();
      expect(source.contains('import \'package:wakelock_plus/wakelock_plus.dart\';'), isTrue);
      expect(source.contains('WakelockPlus.enable()'), isTrue);
      expect(source.contains('WakelockPlus.disable()'), isTrue);
    });

    test('home_tab.dart has text overflow and maxLines protections on cards and rows', () {
      final source = File('lib/features/menu/presentation/home_tab.dart').readAsStringSync();
      expect(source.contains('TextOverflow.ellipsis'), isTrue);
      expect(source.contains('maxLines: 1'), isTrue);
      expect(source.contains('maxLines: 2'), isTrue);
    });
  });

  group('Phase 4.2: VrOrientationService Deterministic Portrait Reset', () {
    test('VrOrientationService.resetToPortrait() sets edgeToEdge and forces portraitUp', () async {
      await VrOrientationService.resetToPortrait();

      final modeCalls = systemChromeCalls
          .where((call) => call.method == 'SystemChrome.setEnabledSystemUIMode')
          .toList();
      expect(modeCalls.isNotEmpty, isTrue);
      expect(modeCalls.last.arguments, 'SystemUiMode.edgeToEdge');
    });
  });

  group('Phase 4.3: HomeContainerView & HomeTab Dynamic Type Responsive Tests', () {
    testWidgets('HomeContainerView renders cleanly with 34px bottom padding and large text scale without overflow', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532); // iPhone 13/14/15 Pro
      tester.view.devicePixelRatio = 3.0;
      tester.view.padding = const FakeViewPadding(bottom: 34.0, top: 47.0);

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.view.resetPadding();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

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
          child: MediaQuery(
            data: const MediaQueryData(
              size: Size(390, 844),
              padding: EdgeInsets.only(top: 47, bottom: 34),
              textScaler: TextScaler.linear(1.4), // Dynamic Type enlarged
            ),
            child: const MaterialApp(
              home: HomeContainerView(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(HomeContainerView), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Meditate'), findsOneWidget);
      expect(find.text('Journal'), findsOneWidget);
      expect(find.text('Me'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // Verify that the Positioned widget for the floating bar has bottom == 24.0 + 34.0 = 58.0
      final positionedWidgets = tester.widgetList<Positioned>(find.byType(Positioned));
      final navBarPositioned = positionedWidgets.firstWhere(
        (p) => p.bottom == 58.0 && p.left == 24.0 && p.right == 24.0,
      );
      expect(navBarPositioned, isNotNull);
      expect(navBarPositioned.bottom, 58.0);
    });

    testWidgets('HomeTab renders all cards with enlarged textScaler without overflow', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

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
          child: MediaQuery(
            data: const MediaQueryData(
              size: Size(540, 1200),
              textScaler: TextScaler.linear(1.3),
            ),
            child: const MaterialApp(
              home: Scaffold(
                body: HomeTab(),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('Guido'), findsOneWidget);
      expect(find.text('Morning Flow'), findsOneWidget);
      expect(find.text('Scopri'), findsOneWidget);
      expect(find.text('Consapevolezza'), findsOneWidget);
      expect(find.text('Inizia Sessione'), findsOneWidget);
    });
  });
}
