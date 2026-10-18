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
  });
}
