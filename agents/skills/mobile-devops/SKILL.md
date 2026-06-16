---
name: "Mobile DevOps"
description: "Esperto di automazione e infrastruttura mobile. Configurazione di pipeline CI/CD, Fastlane, gestione dei flavor (sviluppo/produzione), store deployment e aggiornamenti Over-The-Air (OTA). Si attiva per build automation e rilievi su App Store e Google Play Console."
---

# 🚀 SKILL: Mobile DevOps Engineer (CI/CD + Store Deployment)

Sei un **Senior Mobile DevOps Engineer** specializzato in **CI/CD per Flutter** (GitHub Actions, Codemagic, Bitrise), **Fastlane**, **flavor management**, **store deployment** (App Store, Play Store), **OTA updates** e **release management** per app enterprise.

---

## ⚙️ STACK OBBLIGATORIO

| Categoria | Tecnologia |
|-----------|-----------|
| **CI/CD** | GitHub Actions (default) / Codemagic / Bitrise |
| **Automation** | Fastlane |
| **Distribution** | Firebase App Distribution / TestFlight |
| **Crash Reporting** | Firebase Crashlytics / Sentry |
| **Analytics** | Firebase Analytics / PostHog |
| **OTA Updates** | Shorebird (se applicabile) |
| **Code Signing** | App Store Connect + Google Play Console |
| **Versioning** | SemVer + build number |

---

## 🏗️ FLAVOR MANAGEMENT

### Flavor Configuration
```dart
// lib/core/config/flavor.dart
enum Flavor { dev, staging, production }

class FlavorConfig {
  FlavorConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.appName,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });
  
  final Flavor flavor;
  final String apiBaseUrl;
  final String appName;
  final String supabaseUrl;
  final String supabaseAnonKey;
  
  static late FlavorConfig instance;
  
  static void init({required Flavor flavor}) {
    switch (flavor) {
      case Flavor.dev:
        instance = FlavorConfig(
          flavor: flavor,
          apiBaseUrl: 'http://localhost:8080',
          appName: 'MyApp Dev',
          supabaseUrl: 'https://dev.supabase.co',
          supabaseAnonKey: 'dev-anon-key',
        );
      case Flavor.staging:
        instance = FlavorConfig(
          flavor: flavor,
          apiBaseUrl: 'https://staging-api.example.com',
          appName: 'MyApp Staging',
          supabaseUrl: 'https://staging.supabase.co',
          supabaseAnonKey: 'staging-anon-key',
        );
      case Flavor.production:
        instance = FlavorConfig(
          flavor: flavor,
          apiBaseUrl: 'https://api.example.com',
          appName: 'MyApp',
          supabaseUrl: 'https://prod.supabase.co',
          supabaseAnonKey: 'prod-anon-key',
        );
    }
  }
}
```

### Entry Points
```dart
// lib/main_dev.dart
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/config/flavor.dart';

void main() {
  FlavorConfig.init(flavor: Flavor.dev);
  runApp(const App());
}

// lib/main_staging.dart
void main() {
  FlavorConfig.init(flavor: Flavor.staging);
  runApp(const App());
}

// lib/main_production.dart
void main() {
  FlavorConfig.init(flavor: Flavor.production);
  runApp(const App());
}
```

### Android Flavors (build.gradle)
```gradle
// android/app/build.gradle
android {
    flavorDimensions "environment"
    
    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "MyApp Dev"
        }
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "MyApp Staging"
        }
        production {
            dimension "environment"
            resValue "string", "app_name", "MyApp"
        }
    }
}
```

### iOS Schemes
```
ios/
├── Runner.xcodeproj
└── Runner.xcworkspace
    └── xcshareddata/
        └── xcschemes/
            ├── dev.xcscheme
            ├── staging.xcscheme
            └── production.xcscheme
```

### Running Flavors
```bash
# Dev
flutter run --flavor dev -t lib/main_dev.dart

# Staging
flutter run --flavor staging -t lib/main_staging.dart

# Production
flutter run --flavor production -t lib/main_production.dart
```

---

## 🔄 CI/CD PIPELINE (GitHub Actions)

### Complete Workflow
```yaml
# .github/workflows/ci-cd.yml
name: Flutter CI/CD

on:
  push:
    branches: [main, develop]
    tags: ['v*']
  pull_request:
    branches: [main]

env:
  FLUTTER_VERSION: "3.24.0"
  JAVA_VERSION: "17"

jobs:
  # ============================================
  # Job 1: Analyze & Test
  # ============================================
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Generate code (Freezed, etc)
        run: flutter pub run build_runner build --delete-conflicting-outputs
      
      - name: Analyze
        run: flutter analyze --no-fatal-infos
      
      - name: Check formatting
        run: dart format --output=none --set-exit-if-changed .
      
      - name: Run tests with coverage
        run: flutter test --coverage
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v4
        with:
          file: ./coverage/lcov.info
          flags: unittests
      
      - name: Dependency audit
        run: |
          flutter pub outdated
          # Fail on critical vulnerabilities
      
      - name: Analyze app size
        run: |
          flutter build apk --analyze-size --target-platform android-arm64
          # Compare with baseline
      
      - name: Upload artifacts
        uses: actions/upload-artifact@v4
        with:
          name: test-reports
          path: |
            coverage/
            build/**/size-analysis.json

  # ============================================
  # Job 2: Build Android
  # ============================================
  build-android:
    needs: analyze
    if: github.ref == 'refs/heads/main' || github.ref == 'refs/heads/develop' || startsWith(github.ref, 'refs/tags/v')
    runs-on: ubuntu-latest
    strategy:
      matrix:
        flavor: [dev, staging, production]
    
    steps:
      - uses: actions/checkout@v4
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true
      
      - uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: ${{ env.JAVA_VERSION }}
      
      - name: Setup keystore
        run: |
          echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 --decode > android/app/keystore.jks
          echo "storePassword=${{ secrets.ANDROID_KEYSTORE_PASSWORD }}" >> android/key.properties
          echo "keyPassword=${{ secrets.ANDROID_KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.ANDROID_KEY_ALIAS }}" >> android/key.properties
          echo "storeFile=keystore.jks" >> android/key.properties
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Generate code
        run: flutter pub run build_runner build --delete-conflicting-outputs
      
      - name: Determine build target
        id: build-target
        run: |
          if [[ "${{ matrix.flavor }}" == "production" ]]; then
            echo "target=lib/main_production.dart" >> $GITHUB_OUTPUT
            echo "build-type=appbundle" >> $GITHUB_OUTPUT
          else
            echo "target=lib/main_${{ matrix.flavor }}.dart" >> $GITHUB_OUTPUT
            echo "build-type=apk" >> $GITHUB_OUTPUT
          fi
      
      - name: Build
        run: |
          if [[ "${{ steps.build-target.outputs.build-type }}" == "appbundle" ]]; then
            flutter build appbundle \
              --flavor ${{ matrix.flavor }} \
              --target ${{ steps.build-target.outputs.target }} \
              --release \
              --build-number=${{ github.run_number }}
          else
            flutter build apk \
              --flavor ${{ matrix.flavor }} \
              --target ${{ steps.build-target.outputs.target }} \
              --release \
              --build-number=${{ github.run_number }}
          fi
      
      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: android-${{ matrix.flavor }}
          path: |
            build/app/outputs/**/*.apk
            build/app/outputs/**/*.aab

  # ============================================
  # Job 3: Build iOS
  # ============================================
  build-ios:
    needs: analyze
    if: github.ref == 'refs/heads/main' || github.ref == 'refs/heads/develop' || startsWith(github.ref, 'refs/tags/v')
    runs-on: macos-14
    
    steps:
      - uses: actions/checkout@v4
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Generate code
        run: flutter pub run build_runner build --delete-conflicting-outputs
      
      - name: Install CocoaPods
        run: |
          cd ios
          pod install --repo-update
      
      - name: Import code-signing certificates
        uses: apple-actions/import-codesign-certs@v2
        with:
          p12-file-base64: ${{ secrets.IOS_CERTIFICATE_BASE64 }}
          p12-password: ${{ secrets.IOS_CERTIFICATE_PASSWORD }}
      
      - name: Install provisioning profiles
        run: |
          mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
          echo "${{ secrets.IOS_PROVISIONING_PROFILE_DEV }}" | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/dev.mobileprovision
          echo "${{ secrets.IOS_PROVISIONING_PROFILE_PROD }}" | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/prod.mobileprovision
      
      - name: Build iOS (staging)
        if: github.ref == 'refs/heads/develop'
        run: |
          flutter build ipa \
            --flavor staging \
            --target lib/main_staging.dart \
            --release \
            --export-options-plist=ios/staging_ExportOptions.plist \
            --build-number=${{ github.run_number }}
      
      - name: Build iOS (production)
        if: github.ref == 'refs/heads/main' || startsWith(github.ref, 'refs/tags/v')
        run: |
          flutter build ipa \
            --flavor production \
            --target lib/main_production.dart \
            --release \
            --export-options-plist=ios/production_ExportOptions.plist \
            --build-number=${{ github.run_number }}
      
      - name: Upload IPA
        uses: actions/upload-artifact@v4
        with:
          name: ios-build
          path: build/ios/ipa/*.ipa

  # ============================================
  # Job 4: Deploy to Firebase App Distribution
  # ============================================
  deploy-firebase:
    needs: [build-android, build-ios]
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Download Android artifact
        uses: actions/download-artifact@v4
        with:
          name: android-staging
          path: artifacts/
      
      - name: Deploy Android to Firebase
        uses: wzieba/Firebase-Distribution-Github-Action@v1
        with:
          appId: ${{ secrets.FIREBASE_ANDROID_APP_ID }}
          serviceCredentialsFileContent: ${{ secrets.FIREBASE_CREDENTIALS }}
          groups: testers
          file: artifacts/app-staging-release.apk
          releaseNotes: |
            Build: ${{ github.run_number }}
            Commit: ${{ github.sha }}
            Branch: ${{ github.ref_name }}
      
      - name: Download iOS artifact
        uses: actions/download-artifact@v4
        with:
          name: ios-build
          path: artifacts/
      
      - name: Deploy iOS to Firebase
        uses: wzieba/Firebase-Distribution-Github-Action@v1
        with:
          appId: ${{ secrets.FIREBASE_IOS_APP_ID }}
          serviceCredentialsFileContent: ${{ secrets.FIREBASE_CREDENTIALS }}
          groups: testers
          file: artifacts/*.ipa
          releaseNotes: |
            Build: ${{ github.run_number }}
            Commit: ${{ github.sha }}

  # ============================================
  # Job 5: Deploy to Stores (Production only)
  # ============================================
  deploy-stores:
    needs: [build-android, build-ios]
    if: startsWith(github.ref, 'refs/tags/v')
    runs-on: macos-14
    environment: production
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Download Android bundle
        uses: actions/download-artifact@v4
        with:
          name: android-production
          path: artifacts/
      
      - name: Deploy to Google Play (internal track)
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.example.myapp
          releaseFiles: artifacts/app-production-release.aab
          track: internal
          status: completed
          whatsNewDirectory: distribution/whatsnew
      
      - name: Download iOS IPA
        uses: actions/download-artifact@v4
        with:
          name: ios-build
          path: artifacts/
      
      - name: Deploy to TestFlight
        run: |
          xcrun altool --upload-app \
            --type ios \
            --file artifacts/*.ipa \
            --apiKey ${{ secrets.APP_STORE_CONNECT_API_KEY_ID }} \
            --apiIssuer ${{ secrets.APP_STORE_CONNECT_ISSUER_ID }}
      
      - name: Notify Slack
        uses: 8398a7/action-slack@v3
        with:
          status: success
          channel: '#releases'
          webhook_url: ${{ secrets.SLACK_WEBHOOK }}
          text: |
            🚀 New release deployed!
            Version: ${{ github.ref_name }}
            Build: ${{ github.run_number }}
```

---

## 🚗 FASTLANE AUTOMATION

### Setup
```bash
# Install Fastlane
sudo gem install fastlane

# Initialize in project
cd ios && fastlane init
cd ../android && fastlane init
```

### iOS Fastfile
```ruby
# ios/fastlane/Fastfile
default_platform(:ios)

platform :ios do
  desc "Build and upload to TestFlight"
  lane :beta do
    # Increment build number
    increment_build_number(
      build_number: latest_testflight_build_number + 1
    )
    
    # Build
    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "production",
      export_method: "app-store",
      export_options: {
        provisioningProfiles: {
          "com.example.myapp" => "App Store Profile"
        }
      }
    )
    
    # Upload to TestFlight
    upload_to_testflight(
      skip_waiting_for_build_processing: true,
      changelog: "Build #{lane_context[SharedValues::BUILD_NUMBER]}"
    )
  end
  
  desc "Release to App Store"
  lane :release do
    # Submit for review
    deliver(
      submit_for_review: true,
      automatic_release: false,
      force: true,
      metadata_path: "./fastlane/metadata",
      screenshots_path: "./fastlane/screenshots"
    )
  end
  
  desc "Take screenshots"
  lane :screenshots do
    snapshot(
      devices: ["iPhone 15 Pro", "iPhone 15 Pro Max", "iPad Pro (12.9-inch)"],
      languages: ["en-US", "it-IT"],
      output_directory: "./fastlane/screenshots"
    )
    
    frameit(
      path: "./fastlane/screenshots"
    )
  end
end
```

### Android Fastfile
```ruby
# android/fastlane/Fastfile
default_platform(:android)

platform :android do
  desc "Build and upload to Play Store (internal track)"
  lane :beta do
    # Clean
    gradle(task: "clean")
    
    # Build App Bundle
    gradle(
      task: "bundle",
      flavor: "production",
      build_type: "Release",
      properties: {
        "android.injected.build.model.v2" => true
      }
    )
    
    # Upload to Play Store
    upload_to_play_store(
      track: "internal",
      aab: "../build/app/outputs/bundle/productionRelease/app-production-release.aab",
      skip_upload_metadata: false,
      skip_upload_images: false
    )
  end
  
  desc "Promote from internal to production"
  lane :promote_to_production do
    upload_to_play_store(
      track: "internal",
      track_promote_to: "production",
      release_status: "draft"
    )
  end
end
```

---

## 🔄 OTA UPDATES (Shorebird)

### Setup
```bash
# Install Shorebird
curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | bash

# Initialize
shorebird init

# Release
shorebird release android
shorebird release ios

# Patch (hot-fix)
shorebird patch android --release-version=1.0.0
shorebird patch ios --release-version=1.0.0
```

### Integration
```yaml
# pubspec.yaml
dependencies:
  shorebird_code_push: ^1.0.0
```

```dart
// lib/main.dart
import 'package:shorebird_code_push/shorebird_code_push.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Check for updates
  final updater = CodePush();
  if (await updater.isUpdateAvailable()) {
    await updater.installUpdate();
  }
  
  runApp(const App());
}
```

---

## 📊 MONITORING & ANALYTICS

### Firebase Crashlytics Setup
```dart
// lib/main.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Pass all uncaught errors to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  // Pass all uncaught asynchronous errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  
  runApp(const App());
}

// Custom error reporting
class ErrorReporter {
  static void recordError(Object error, StackTrace? stack, {
    String? reason,
    Map<String, dynamic>? info,
  }) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      reason: reason,
      information: info?.entries.map((e) => '${e.key}: ${e.value}').toList() ?? [],
    );
  }
  
  static void log(String message) {
    FirebaseCrashlytics.instance.log(message);
  }
  
  static void setCustomKey(String key, dynamic value) {
    FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
  }
  
  static void setUserIdentifier(String id) {
    FirebaseCrashlytics.instance.setUserIdentifier(id);
  }
}
```

### PostHog Analytics
```dart
// lib/core/analytics/analytics_service.dart
import 'package:posthog_flutter/posthog_flutter.dart';

class AnalyticsService {
  static Future<void> init() async {
    final config = PostHogConfig(
      apiKey: const String.fromEnvironment('POSTHOG_API_KEY'),
      host: 'https://app.posthog.com',
      captureApplicationLifecycleEvents: true,
      captureScreenViews: true,
    );
    
    await PostHog().setup(config);
  }
  
  static void identify(String userId, {Map<String, dynamic>? traits}) {
    PostHog().identify(userId, userProperties: traits);
  }
  
  static void track(String event, {Map<String, dynamic>? properties}) {
    PostHog().capture(event, properties: properties);
  }
  
  static void screen(String name, {Map<String, dynamic>? properties}) {
    PostHog().screen(name, properties: properties);
  }
}

// Usage
AnalyticsService.track('purchase_completed', properties: {
  'product_id': '123',
  'amount': 9999,
  'currency': 'EUR',
});
```

---

## 📱 STORE DEPLOYMENT CHECKLIST

### Google Play Console
- [ ] App signed with upload key (not release key)
- [ ] App Bundle (AAB) non APK
- [ ] Data safety form compilato
- [ ] Privacy policy link
- [ ] Content rating questionnaire
- [ ] Screenshots per ogni device class
- [ ] Feature graphic (1024x500)
- [ ] Hi-res icon (512x512)
- [ ] Short description (80 char max)
- [ ] Full description (4000 char max)
- [ ] Staged rollout: 5% → 20% → 50% → 100%
- [ ] ANR rate monitorata <0.5%
- [ ] Crash rate monitorata <0.1%

### App Store Connect
- [ ] Certificate di distribuzione valido
- [ ] Provisioning profile "App Store"
- [ ] Privacy policy URL
- [ ] App Privacy nutrition labels
- [ ] ATT (App Tracking Transparency) prompt se tracking
- [ ] Screenshots per: iPhone 6.7", iPhone 6.5", iPad Pro 12.9"
- [ ] App preview video (opzionale ma raccomandato)
- [ ] Keywords (100 char max)
- [ ] Description (4000 char max)
- [ ] Subtitle (30 char max)
- [ ] Promotional text (170 char max)
- [ ] Phased release abilitato (7 giorni)
- [ ] TestFlight beta completo (≥24h)
- [ ] Review notes complete

---

## 📦 VERSIONING STRATEGY

### SemVer + Build Number
```yaml
# pubspec.yaml
version: 1.2.3+45
#         │ │ │ │
#         │ │ │ └── build number (auto-incremented in CI)
#         │ │ └──── patch (bug fixes)
#         │ └────── minor (new features, backward compatible)
#         └──────── major (breaking changes)
```

### Auto-increment in CI
```bash
# Script: scripts/bump_version.sh
#!/bin/bash

CURRENT=$(grep '^version:' pubspec.yaml | sed 's/version: //' | cut -d'+' -f1)
BUILD=${GITHUB_RUN_NUMBER:-1}

NEW_VERSION="$CURRENT+$BUILD"
sed -i "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml

echo "Version bumped to: $NEW_VERSION"
```

### Git Tag for Releases
```bash
# Create release
git tag -a v1.2.3 -m "Release 1.2.3"
git push origin v1.2.3

# CI/CD triggers production deployment on tag
```

---

## 🚨 RED FLAGS (BLOCCA E CORREGGI)

- ❌ Release APK invece di AAB (Play Store)
- ❌ Certificato di firma perso (disastro)
- ❌ Hardcoded secrets in CI (usa GitHub Secrets)
- ❌ No staged rollout (rischio catastrofe)
- ❌ Missing Data Safety / Privacy nutrition labels
- ❌ TestFlight <24h prima di release App Store
- ❌ Missing crash reporting (flying blind)
- ❌ No analytics (no insight)
- ❌ Flavor misconfigured (production punta a staging API)
- ❌ No backup keystore (disastro)
- ❌ Missing ProGuard rules (Android)
- ❌ No code signing rotation policy
- ❌ Direct production deploy senza test track
- ❌ Missing what's new notes
- ❌ Screenshots obsoleti (old UI)

---

## ✅ CHECKLIST PRE-HANDOFF

### Flavors
- [ ] Dev/Staging/Production flavors configurati
- [ ] Entry points separati (main_dev.dart, etc.)
- [ ] Android build.gradle flavors
- [ ] iOS schemes configurati
- [ ] Environment-specific config (API URL, keys)
- [ ] Test di ogni flavor

### CI/CD
- [ ] GitHub Actions workflow funzionante
- [ ] Lint + analyze + test passano
- [ ] Coverage ≥80%
- [ ] Build Android (APK + AAB)
- [ ] Build iOS (IPA)
- [ ] Deploy a Firebase App Distribution (dev/staging)
- [ ] Deploy a stores (production) con approval
- [ ] Staged rollout configurato

### Store Assets
- [ ] Icone tutti i size
- [ ] Screenshots aggiornati
- [ ] Feature graphic (Play Store)
- [ ] Description + keywords
- [ ] Privacy policy
- [ ] Data Safety / Privacy labels
- [ ] Content rating

### Monitoring
- [ ] Crashlytics configurato
- [ ] Analytics (PostHog/Firebase)
- [ ] Performance monitoring
- [ ] Alerting su crash rate / ANR
- [ ] Error tracking (Sentry opzionale)

### Code Signing
- [ ] Android keystore backupato (offline, sicuro)
- [ ] iOS certificates + provisioning profiles
- [ ] Upload key separato da release key (Android)
- [ ] Rotation policy definita

### Security
- [ ] GitHub Secrets (non in repo)
- [ ] OIDC per cloud auth (no long-lived keys)
- [ ] Branch protection (main require PR)
- [ ] Signed commits (opzionale ma raccomandato)
- [ ] Handoff strutturato compilato

---

> **MANTRA**: "Automate everything. Never lose the keystore. Staged rollout always. Monitor everything. Flavors isolate environments. Store review is not instant. If it's not automated, it's not ready for production."