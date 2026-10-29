import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guido/core/database/settings_provider.dart';
import 'package:guido/core/database/app_initializer_provider.dart';
import 'package:guido/features/onboarding/presentation/onboarding_wizard_view.dart';
import 'package:guido/features/premium/presentation/premium_paywall_view.dart';
import 'package:guido/core/session/zen_session_dto.dart';
import 'package:guido/core/theme/custom_button_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Build 30 Quality Gate 5.1 & 5.2: App Store Compliance & LaunchScreen', () {
    test('pubspec.yaml has version 0.1.0+30 and remove_alpha_ios: true', () {
      final pubspecFile = File('pubspec.yaml');
      expect(pubspecFile.existsSync(), isTrue);
      final content = pubspecFile.readAsStringSync();
      expect(content.contains('version: 0.1.0+30'), isTrue);
      expect(content.contains('remove_alpha_ios: true'), isTrue);
    });

    test('ios/Runner/Info.plist conforms to Apple App Store review requirements', () {
      final plistFile = File('ios/Runner/Info.plist');
      expect(plistFile.existsSync(), isTrue);
      final content = plistFile.readAsStringSync();

      // Ghost permissions removed
      expect(content.contains('NSMicrophoneUsageDescription'), isFalse);
      expect(content.contains('NSCameraUsageDescription'), isFalse);

      // Motion preserved for VR 3D tracking
      expect(content.contains('NSMotionUsageDescription'), isTrue);

      // App Transport Security for local streaming
      expect(content.contains('NSAppTransportSecurity'), isTrue);
      expect(content.contains('NSAllowsArbitraryLoads'), isTrue);
      expect(content.contains('NSAllowsLocalNetworking'), isTrue);

      // Encryption exemption
      expect(content.contains('ITSAppUsesNonExemptEncryption'), isTrue);

      // View controller based status bar appearance
      expect(content.contains('UIViewControllerBasedStatusBarAppearance'), isTrue);
      expect(content.contains('<key>UIViewControllerBasedStatusBarAppearance</key>\n\t\t<true/>'), isTrue);
    });

    test('ios/Runner/Base.lproj/LaunchScreen.storyboard has dark background #070A18', () {
      final storyboard = File('ios/Runner/Base.lproj/LaunchScreen.storyboard');
      expect(storyboard.existsSync(), isTrue);
      final content = storyboard.readAsStringSync();
      expect(content.contains('red="0.02745" green="0.03921" blue="0.09411" alpha="1"'), isTrue);
    });
  });

  group('Build 30 Quality Gate 5.3: Wakelock Protection in Screens', () {
    test('VR calibration and explanation screens include WakelockPlus', () {
      final vrCalibration = File('lib/features/meditation/presentation/vr_calibration_screen.dart').readAsStringSync();
      expect(vrCalibration.contains('WakelockPlus.enable()'), isTrue);
      expect(vrCalibration.contains('WakelockPlus.disable()'), isTrue);

      final explanation = File('lib/features/meditation/presentation/explanation_screen.dart').readAsStringSync();
      expect(explanation.contains('WakelockPlus.enable()'), isTrue);
      expect(explanation.contains('WakelockPlus.disable()'), isTrue);

      final breathing = File('lib/features/breathing/presentation/breathing_view.dart').readAsStringSync();
      expect(breathing.contains('WakelockPlus.enable()'), isTrue);
      expect(breathing.contains('WakelockPlus.disable()'), isTrue);

      final meditation = File('lib/features/meditation/presentation/meditation_view.dart').readAsStringSync();
      expect(meditation.contains('WakelockPlus.enable()'), isTrue);
      expect(meditation.contains('WakelockPlus.disable()'), isTrue);

      final vrScreen = File('lib/features/vr_experiences/presentation/vr_experience_screen.dart').readAsStringSync();
      expect(vrScreen.contains('WakelockPlus.enable()'), isTrue);
      expect(vrScreen.contains('WakelockPlus.disable()'), isTrue);
    });
  });

  group('Build 30 Quality Gate 5.4: Safe i18n & Zero Crash Fallbacks', () {
    testWidgets('PremiumPaywallView renders with safe Italian fallbacks even without AppLocalizations', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPrefsInstanceProvider.overrideWith((ref) => prefs),
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      // Pump WITHOUT localizationsDelegates to test defensive null guards
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: PremiumPaywallView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sblocca Guido Premium'), findsOneWidget);
      expect(find.text('1 Mese'), findsOneWidget);
      expect(find.text('1 Anno'), findsOneWidget);
      expect(find.text('A Vita'), findsOneWidget);
      expect(find.text('ATTIVA ORA (GRATIS)'), findsOneWidget);
    });
  });

  group('Build 30 Quality Gate 5.5: Persistence, Onboarding Regex & PopScope', () {
    testWidgets('OnboardingWizardView profile name field enforces maxLength 25 and regex validation', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
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
          child: const MaterialApp(
            home: OnboardingWizardView(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // PopScope is wrapping the wizard
      expect(find.byWidgetPredicate((w) => w is PopScope), findsOneWidget);

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      final widget = tester.widget<TextField>(textField);
      expect(widget.maxLength, 25);

      final avantiButton = find.text('AVANTI');

      // 1. Empty validation
      await tester.tap(avantiButton);
      await tester.pump();
      expect(find.text('Per favore, inserisci un nome per il profilo'), findsOneWidget);

      // 2. Invalid characters validation
      await tester.enterText(textField, 'User@#\$%');
      await tester.pump();
      await tester.tap(avantiButton);
      await tester.pump();
      expect(find.text('Il nome contiene caratteri non validi'), findsOneWidget);

      // 3. Valid name passes
      await tester.enterText(textField, 'Yehia El Taher');
      await tester.pump();
      await tester.tap(avantiButton);
      await tester.pumpAndSettle();

      // Successfully advanced to Step 2 (Commitment)
      expect(find.text('Il nome contiene caratteri non validi'), findsNothing);
      expect(find.text('Per favore, inserisci un nome per il profilo'), findsNothing);
    });

    test('BreathingView records session to UserRepository on completion', () {
      final breathingSource = File('lib/features/breathing/presentation/breathing_view.dart').readAsStringSync();
      expect(
        breathingSource.contains('ref.read(userRepositoryProvider)?.recordSession(widget.title, "Respirazione")'),
        isTrue,
      );
    });

    test('VrExperienceScreen records session on completion', () {
      final vrSource = File('lib/features/vr_experiences/presentation/vr_experience_screen.dart').readAsStringSync();
      expect(vrSource.contains('recordSession'), isTrue);
    });
  });

  group('Build 30 Quality Gate 5.6: Canonical Zen Scenes Alignment', () {
    test('ZenScenes canonical names match EditorBuildSettings.asset exactly', () {
      expect(ZenScenes.waterBreathing, 'Respirazione acqua');
      expect(ZenScenes.airBreathing, 'Respirazione aria');
      expect(ZenScenes.fireBreathing, 'Respirazione fuoco');
      expect(ZenScenes.earthBreathing, 'Respirazione terra');
      
      expect(ZenScenes.waterMeditationMorning, 'Meditazione acqua matt');
      expect(ZenScenes.waterMeditationAfternoon, 'Meditazione acqua pom');
      expect(ZenScenes.waterMeditationEvening, 'Meditazione acqua sera');
      expect(ZenScenes.generalMeditation, 'Meditazione generale');

      expect(ZenScenes.waterTutorial, 'Procedimento acqua');
      expect(ZenScenes.airTutorial, 'Procedimento aria');
      expect(ZenScenes.fireTutorial, 'Procedimento fuoco');
      expect(ZenScenes.earthTutorial, 'Procedimento terra');

      expect(ZenScenes.mainMenu, 'MainMenu Corretto');
      expect(ZenScenes.splashScreen, 'SplashScreen');

      expect(ZenScenes.allScenes.length, 14);
    });
  });

  group('Build 30 Quality Gate 5.7: GuidoButton Tap Up & Lock Protection', () {
    testWidgets('GuidoButton executes onTap on tap-up when not locked, and ignores taps when locked', (tester) async {
      int tapCount = 0;
      bool isLocked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: GuidoButton(
                  text: 'START',
                  isLocked: isLocked,
                  requireHold: false,
                  onTap: () {
                    tapCount++;
                  },
                ),
              );
            },
          ),
        ),
      );

      final buttonFinder = find.byType(GuidoButton);
      expect(buttonFinder, findsOneWidget);

      // 1. Gesture down should not invoke onTap yet
      final gesture = await tester.startGesture(tester.getCenter(buttonFinder));
      await tester.pump();
      expect(tapCount, 0);

      // AnimatedScale should scale down to 0.96
      final scaleFinder = find.descendant(
        of: buttonFinder,
        matching: find.byType(AnimatedScale),
      );
      final scaleWidget = tester.widget<AnimatedScale>(scaleFinder);
      expect(scaleWidget.scale, 0.96);

      // 2. Gesture up should invoke onTap
      await gesture.up();
      await tester.pumpAndSettle();
      expect(tapCount, 1);

      // Scale should return to 1.0
      final scaleWidgetAfter = tester.widget<AnimatedScale>(scaleFinder);
      expect(scaleWidgetAfter.scale, 1.0);

      // 3. Locked button should block taps completely
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GuidoButton(
              text: 'START',
              isLocked: true,
              requireHold: false,
              onTap: () {
                tapCount++;
              },
            ),
          ),
        ),
      );

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();
      expect(tapCount, 1); // Remains 1, never triggered when locked
    });
  });

  group('Build 30 Quality Gate 5.8: Teardown Verification', () {
    test('VrExperienceScreen teardown cleans up resources', () {
      final vrSource = File('lib/features/vr_experiences/presentation/vr_experience_screen.dart').readAsStringSync();
      expect(vrSource.contains('dispose()'), isTrue);
      expect(vrSource.contains('WakelockPlus.disable()'), isTrue);
    });
  });
}
