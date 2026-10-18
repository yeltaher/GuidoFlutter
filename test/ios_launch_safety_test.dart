import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Regression guards for iOS launch safety:
/// Verifies that Runner.app is a pure Flutter + WebKit application,
/// completely decoupled from UnityFramework, dyld load crashes, and early static initializers.
void main() {
  group('iOS launch safety', () {
    test('AppDelegate does not start Unity or call InitUnityIntegrationWithOptions at boot', () {
      final src = File('ios/Runner/AppDelegate.swift').readAsStringSync();
      expect(src.contains('runEmbedded'), isFalse);
      expect(src.contains('UnityFramework.getInstance'), isFalse);
      expect(src.contains('InitUnityIntegrationWithOptions'), isFalse);
      expect(src.contains('import flutter_unity_widget_2'), isFalse);
    });

    test('Runner.xcodeproj does not embed or link UnityFramework or UnityRuntime', () {
      final pbx = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
      expect(pbx.contains('UnityFramework.framework in Embed Frameworks'), isFalse);
      expect(pbx.contains('UnityFramework.framework in Frameworks'), isFalse);
      expect(pbx.contains('UnityRuntime.framework in Embed Frameworks'), isFalse);
      expect(pbx.contains('UnityRuntime.framework in Frameworks'), isFalse);
      expect(pbx.contains('UnityFramework.framework'), isFalse);
    });

    test('Runner.xcworkspace does not include UnityLibrary/Unity-iPhone.xcodeproj', () {
      final workspace = File('ios/Runner.xcworkspace/contents.xcworkspacedata').readAsStringSync();
      expect(workspace.contains('UnityLibrary/Unity-iPhone.xcodeproj'), isFalse);
      expect(workspace.contains('Runner.xcodeproj'), isTrue);
    });

    test('Runner.xcscheme builds only Runner without UnityFramework dependencies', () {
      final scheme = File('ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme').readAsStringSync();
      expect(scheme.contains('BlueprintName = "UnityFramework"'), isFalse);
      expect(scheme.contains('BlueprintName = "Runner"'), isTrue);
    });

    test('Podfile does not contain Unity search paths or LFS assertion', () {
      final podfile = File('ios/Podfile').readAsStringSync();
      expect(podfile.contains('UnityLibrary'), isFalse);
      expect(podfile.contains('flutter_unity_widget_2'), isFalse);
    });

    test('Runner-Bridging-Header.h does not import UnityFramework', () {
      final bridgingHeader = File('ios/Runner/Runner-Bridging-Header.h').readAsStringSync();
      expect(bridgingHeader.contains('UnityFramework'), isFalse);
      expect(bridgingHeader.contains('GeneratedPluginRegistrant.h'), isTrue);
    });

    test('Podfile enforces Release AOT engine mapping and cache synchronization for CI builds', () {
      final podfile = File('ios/Podfile').readAsStringSync();
      expect(podfile.contains("'Debug' => is_ci_build ? :release : :debug"), isTrue);
      expect(podfile.contains('flutter precache --ios'), isTrue);
      expect(podfile.contains('ios-release'), isTrue);
      expect(podfile.contains('gsub(\'/artifacts/engine/ios/\', \'/artifacts/engine/ios-release/\')'), isTrue);
    });

    test('project.pbxproj exports FLUTTER_BUILD_MODE=release on CI in build and thin phases', () {
      final pbx = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
      expect(pbx.contains('export FLUTTER_BUILD_MODE=release'), isTrue);
    });

    test('project.pbxproj automatically packages Sideload IPA into AC_OUTPUT_DIR in Thin Binary phase', () {
      final pbx = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
      expect(pbx.contains('Guido_iOS_Sideload.ipa'), isTrue);
      expect(pbx.contains('Guido_Release_AOT.ipa'), isTrue);
      expect(pbx.contains('TARGET_BUILD_DIR'), isTrue);
      expect(pbx.contains('WRAPPER_NAME'), isTrue);
    });

    test('package_sideload_ipa.sh exists and supports multi-directory Runner.app discovery', () {
      final script = File('scripts/appcircle/package_sideload_ipa.sh');
      expect(script.existsSync(), isTrue);
      final content = script.readAsStringSync();
      expect(content.contains('build/ios/iphoneos/Runner.app'), isTrue);
      expect(content.contains('build/ios/Debug-iphoneos/Runner.app'), isTrue);
      expect(content.contains('Payload'), isTrue);
    });
  });
}

