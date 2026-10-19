import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Regression guards for iOS launch safety:
/// Verifies that Runner.app is a pure Flutter + WebKit application,
/// completely decoupled from UnityFramework, dyld load crashes,
/// enforces Release AOT compilation, preserves cryptographic integrity of Flutter.framework,
/// centralizes IPA packaging, and unifies plugins via CocoaPods.
void main() {
  group('iOS launch safety', () {
    test('AppDelegate registers plugins and does not call UnityIntegration at boot', () {
      final src = File('ios/Runner/AppDelegate.swift').readAsStringSync();
      expect(src.contains('GeneratedPluginRegistrant.register(with: self)'), isTrue);
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

    test('Runner.xcscheme configures Release LaunchAction and PreAction for Release AOT', () {
      final scheme = File('ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme').readAsStringSync();
      expect(scheme.contains('BlueprintName = "UnityFramework"'), isFalse);
      expect(scheme.contains('BlueprintName = "Runner"'), isTrue);
      expect(scheme.contains('Enforce Flutter Release AOT'), isTrue);
      expect(scheme.contains('export FLUTTER_BUILD_MODE=release'), isTrue);
      expect(scheme.contains('buildConfiguration = "Release"'), isTrue);
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

    test('Podfile precaches iOS engine on CI without overriding engine cache directory', () {
      final podfile = File('ios/Podfile').readAsStringSync();
      expect(podfile.contains('flutter precache --ios'), isTrue);
      expect(podfile.contains("rm -rf '#{ios_debug_framework}'"), isFalse);
    });

    test('project.pbxproj Thin Binary executes only xcode_backend.sh embed_and_thin (no IPA in build phase)', () {
      final pbx = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
      expect(pbx.contains('embed_and_thin'), isTrue);
      expect(pbx.contains('xcode_backend.sh'), isTrue);
      // G4: Assenza di creazioni .ipa dentro le Build Phase interne di Xcode
      expect(pbx.contains('Guido_iOS_Sideload.ipa'), isFalse);
      expect(pbx.contains('Guido_Release_AOT.ipa'), isFalse);
      expect(pbx.contains('Pods-Runner-frameworks.sh'), isFalse);
    });

    test('project.pbxproj does not compile SceneDelegate.swift', () {
      final pbx = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
      expect(pbx.contains('SceneDelegate.swift'), isFalse);
    });

    test('package_sideload_ipa.sh exists and supports multi-directory Runner.app discovery', () {
      final script = File('scripts/appcircle/package_sideload_ipa.sh');
      expect(script.existsSync(), isTrue);
      final content = script.readAsStringSync();
      expect(content.contains('build/ios/iphoneos/Runner.app'), isTrue);
      expect(content.contains('build/ios/Debug-iphoneos/Runner.app'), isTrue);
      expect(content.contains('Payload'), isTrue);
    });

    test('pubspec.yaml disables Swift Package Manager for plugins and removes unused vr_player', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      expect(pubspec.contains('enable-swift-package-manager: false'), isTrue);
      expect(pubspec.contains('vr_player'), isFalse);
      expect(File('lib/core/vr/vr_360_video_widget.dart').existsSync(), isFalse);
    });

    test('package_sideload_ipa.sh validates recursive Mach-O dynamic dependencies and strips simulator slices with lipo', () {
      final script = File('scripts/appcircle/package_sideload_ipa.sh').readAsStringSync();
      expect(script.contains('otool -L'), isTrue);
      expect(script.contains('Frameworks'), isTrue);
      expect(script.contains('lipo -thin arm64'), isTrue);
      expect(script.contains('Guido_Release_AOT.ipa'), isTrue);
      expect(script.contains('Guido_iOS_Sideload.ipa'), isTrue);
    });

    test('package_sideload_ipa.sh applies inside-out ad-hoc codesign and preserves Flutter Headers and Modules', () {
      final script = File('scripts/appcircle/package_sideload_ipa.sh').readAsStringSync();
      expect(script.contains('codesign --force --sign "-"'), isTrue);
      expect(script.contains('Runner.debug.dylib'), isTrue);
      // G3: Assenza totale di cancellazioni rm -rf dentro _CodeSignature o cartelle interne di Flutter.framework
      expect(script.contains('rm -rf "\$PAYLOAD_DIR/Runner.app/Frameworks/Flutter.framework/Headers"'), isFalse);
      expect(script.contains('rm -rf "\$PAYLOAD_DIR/Runner.app/Frameworks/Flutter.framework/Modules"'), isFalse);
      expect(script.contains('Flutter.framework/Headers'), isFalse);
      expect(script.contains('Flutter.framework/Modules'), isFalse);
    });

    test('project.pbxproj and Podfile disable ENABLE_DEBUG_DYLIB', () {
      final pbx = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
      expect(pbx.contains('ENABLE_DEBUG_DYLIB = NO'), isTrue);

      final podfile = File('ios/Podfile').readAsStringSync();
      expect(podfile.contains("config.build_settings['ENABLE_DEBUG_DYLIB'] = 'NO'"), isTrue);
    });
  });
}
