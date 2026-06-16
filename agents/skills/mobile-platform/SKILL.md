---
name: "Mobile Platform Specialist"
description: "Ingegnere specializzato nelle specificità di iOS e Android, configurazione di Platform Channels, codice nativo (Swift/Kotlin), permessi di sistema, notifiche push, dati biometrici e hardware (camera/GPS)."
---

# 📱 SKILL: Mobile Platform Specialist (iOS + Android)

Sei un **Senior Mobile Platform Engineer** specializzato in integrazione nativa Flutter con iOS (Swift/Objective-C) e Android (Kotlin/Java). Gestisci platform channels, plugin nativi, permessi, notifiche push, biometrici, camera, GPS, e tutte le API specifiche di piattaforma.

---

## ⚙️ STACK OBBLIGATORIO

| Categoria | iOS | Android |
|-----------|-----|---------|
| **Linguaggio nativo** | Swift 5.9+ | Kotlin 1.9+ |
| **Build** | Xcode 15+ | Android Gradle Plugin 8+ |
| **Min OS** | iOS 14+ (default) | API 23+ (Android 6) |
| **Target OS** | iOS 17+ | API 34+ |
| **Platform Channel** | FlutterMethodChannel | MethodChannel |
| **Permissions** | Info.plist + runtime | AndroidManifest + runtime |
| **Push** | APNs | FCM |
| **Biometrics** | LocalAuthentication | BiometricPrompt |
| **Secure Storage** | Keychain | EncryptedSharedPreferences |

---

## 🏗️ PLATFORM CHANNELS

### Method Channel Pattern
```dart
// Dart side
import 'package:flutter/services.dart';

class NativeBridge {
  static const _channel = MethodChannel('com.example.app/native');
  
  static Future<bool> isBiometricAvailable() async {
    try {
      return await _channel.invokeMethod<bool>('isBiometricAvailable') ?? false;
    } on PlatformException catch (e) {
      debugPrint('Biometric check failed: ${e.message}');
      return false;
    }
  }
  
  static Future<bool> authenticateWithBiometrics({
    required String reason,
  }) async {
    try {
      return await _channel.invokeMethod<bool>(
        'authenticateWithBiometrics',
        {'reason': reason},
      ) ?? false;
    } on PlatformException catch (e) {
      if (e.code == 'USER_CANCELLED') return false;
      if (e.code == 'NOT_AVAILABLE') return false;
      rethrow;
    }
  }
  
  static Stream<String> get eventStream {
    const eventChannel = EventChannel('com.example.app/events');
    return eventChannel.receiveBroadcastStream().map((e) => e.toString());
  }
}
```

```swift
// iOS side - AppDelegate.swift
import Flutter
import LocalAuthentication
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "com.example.app/native",
      binaryMessenger: controller.binaryMessenger
    )
    
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "isBiometricAvailable":
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(
          .deviceOwnerAuthenticationWithBiometrics,
          error: &error
        )
        result(canEvaluate)
        
      case "authenticateWithBiometrics":
        guard let args = call.arguments as? [String: Any],
              let reason = args["reason"] as? String else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing reason", details: nil))
          return
        }
        
        let context = LAContext()
        context.evaluatePolicy(
          .deviceOwnerAuthenticationWithBiometrics,
          localizedReason: reason
        ) { success, error in
          DispatchQueue.main.async {
            if success {
              result(true)
            } else if let laError = error as? LAError {
              switch laError.code {
              case .userCancel:
                result(FlutterError(code: "USER_CANCELLED", message: "User cancelled", details: nil))
              case .biometryNotAvailable:
                result(FlutterError(code: "NOT_AVAILABLE", message: "Biometry not available", details: nil))
              default:
                result(false)
              }
            } else {
              result(false)
            }
          }
        }
        
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

```kotlin
// Android side - MainActivity.kt
package com.example.app

import android.os.Bundle
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.example.app/native"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isBiometricAvailable" -> {
                        val biometricManager = BiometricManager.from(this)
                        val canAuthenticate = biometricManager.canAuthenticate(
                            BiometricManager.Authenticators.BIOMETRIC_STRONG
                        )
                        result.success(canAuthenticate == BiometricManager.BIOMETRIC_SUCCESS)
                    }
                    
                    "authenticateWithBiometrics" -> {
                        val reason = call.argument<String>("reason") ?: "Authenticate"
                        
                        val executor = ContextCompat.getMainExecutor(this)
                        val biometricPrompt = BiometricPrompt(this, executor,
                            object : BiometricPrompt.AuthenticationCallback() {
                                override fun onAuthenticationSucceeded(res: BiometricPrompt.AuthenticationResult) {
                                    result.success(true)
                                }
                                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                                    when (errorCode) {
                                        BiometricPrompt.ERROR_USER_CANCELED,
                                        BiometricPrompt.ERROR_NEGATIVE_BUTTON -> {
                                            result.error("USER_CANCELLED", "User cancelled", null)
                                        }
                                        BiometricPrompt.ERROR_NO_BIOMETRICS -> {
                                            result.error("NOT_AVAILABLE", "No biometrics", null)
                                        }
                                        else -> result.success(false)
                                    }
                                }
                                override fun onAuthenticationFailed() {
                                    result.success(false)
                                }
                            })
                        
                        val promptInfo = BiometricPrompt.PromptInfo.Builder()
                            .setTitle("Authentication")
                            .setSubtitle(reason)
                            .setNegativeButtonText("Cancel")
                            .build()
                        
                        biometricPrompt.authenticate(promptInfo)
                    }
                    
                    else -> result.notImplemented()
                }
            }
    }
}
```

---

## 🔐 PERMISSIONS STRATEGY

### iOS (Info.plist + Runtime)
```xml
<!-- ios/Runner/Info.plist -->
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos for your profile.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select images.</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby stores.</string>

<key>NSFaceIDUsageDescription</key>
<string>We use Face ID to secure your account.</string>

<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access for voice messages.</string>
```

### Android (AndroidManifest.xml + Runtime)
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest>
    <!-- Normal permissions (auto-granted) -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <!-- Dangerous permissions (runtime) -->
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    
    <!-- For Android <13 -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" 
                     android:maxSdkVersion="32" />
    
    <!-- Feature declarations -->
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    <uses-feature android:name="android.hardware.location" android:required="false" />
    
    <application ... />
</manifest>
```

### Runtime Permission Handler (Flutter)
```dart
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<PermissionStatus> requestCamera() async {
    final status = await Permission.camera.status;
    
    if (status.isGranted) return status;
    if (status.isPermanentlyDenied) {
      // Show dialog explaining and open settings
      await _showOpenSettingsDialog('Camera');
      return PermissionStatus.permanentlyDenied;
    }
    
    return await Permission.camera.request();
  }
  
  static Future<bool> ensureCameraPermission() async {
    final status = await requestCamera();
    return status.isGranted;
  }
  
  static Future<void> _showOpenSettingsDialog(String permission) async {
    // Show dialog explaining why permission is needed
    // Then open app settings
    await openAppSettings();
  }
}

// Usage in widget
ElevatedButton(
  onPressed: () async {
    if (await PermissionService.ensureCameraPermission()) {
      await _openCamera();
    } else {
      _showPermissionDeniedMessage();
    }
  },
  child: const Text('Take Photo'),
)
```

---

## 🔔 PUSH NOTIFICATIONS

### FCM + APNs Setup
```dart
// lib/core/notifications/push_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushService {
  PushService({required this.tokenStorage});
  
  final TokenStorage tokenStorage;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  
  Future<void> init() async {
    // Request permission (iOS + Android 13+)
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      // Handle denied permission
      return;
    }
    
    // Get FCM token
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await tokenStorage.saveFcmToken(token);
      await _registerTokenOnBackend(token);
    }
    
    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await tokenStorage.saveFcmToken(newToken);
      await _registerTokenOnBackend(newToken);
    });
    
    // Setup foreground notifications
    await _setupLocalNotifications();
    
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    
    // Handle notification that opened app from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }
  
  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );
  }
  
  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification when in foreground
    _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'Default',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data['route'],
    );
  }
  
  void _handleNotificationTap(RemoteMessage message) {
    final route = message.data['route'] as String?;
    if (route != null) {
      // Navigate to route
      navigatorKey.currentState?.pushNamed(route);
    }
  }
}
```

---

## 🎨 NATIVE SPLASH SCREEN

### iOS (LaunchScreen.storyboard)
```xml
<!-- ios/Runner/Base.lproj/LaunchScreen.storyboard -->
<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0">
    <scenes>
        <scene sceneID="...">
            <objects>
                <viewController id="...">
                    <view key="view" contentMode="scaleToFill" id="...">
                        <rect key="frame" x="0.0" y="0.0" width="414" height="896"/>
                        <color key="backgroundColor" systemColor="systemBackgroundColor"/>
                        <subviews>
                            <imageView clipsSubviews="YES" userInteractionEnabled="NO" 
                                       contentMode="scaleAspectFit" 
                                       image="LaunchImage" 
                                       translatesAutoresizingMaskIntoConstraints="NO" id="..."/>
                        </subviews>
                        <constraints>
                            <!-- Center logo -->
                        </constraints>
                    </view>
                </viewController>
            </objects>
        </scene>
    </scenes>
</document>
```

### Android (values/styles.xml)
```xml
<!-- android/app/src/main/res/values/styles.xml -->
<resources>
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">@drawable/launch_background</item>
        <item name="android:windowSplashScreenBackground">@color/launch_bg</item>
    </style>
</resources>

<!-- android/app/src/main/res/values/colors.xml -->
<resources>
    <color name="launch_bg">#2563EB</color>
</resources>

<!-- android/app/src/main/res/drawable/launch_background.xml -->
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@color/launch_bg" />
    <item>
        <bitmap
            android:gravity="center"
            android:src="@mipmap/launch_image" />
    </item>
</layer-list>
```

### Flutter Native Splash Package (recommended)
```yaml
# pubspec.yaml
dev_dependencies:
  flutter_native_splash: ^2.4.0

# flutter_native_splash.yaml
flutter_native_splash:
  color: "#2563EB"
  image: assets/splash/logo.png
  android_12:
    image: assets/splash/logo_android12.png
    color: "#2563EB"
  ios: true
  android: true
  web: false
```

```bash
flutter pub run flutter_native_splash:create
```

---

## 📍 LOCATION SERVICES

```dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    // Check permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show dialog to enable location services
      return null;
    }
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, guide user to settings
      return null;
    }
    
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }
  
  Stream<Position> watchLocation() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,  // meters
      ),
    );
  }
}
```

---

## 🔒 SECURE STORAGE

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );
  
  final FlutterSecureStorage _storage;
  
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _fcmTokenKey = 'fcm_token';
  
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }
  
  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);
  
  Future<void> clear() => _storage.deleteAll();
}
```

---

## 🧪 PLATFORM TESTING

### iOS Testing (Xcode)
```bash
# Run on iOS simulator
flutter run -d "iPhone 15 Pro"

# Run on physical device
flutter run -d <device-id>

# Build for TestFlight
flutter build ipa --export-method ad-hoc
```

### Android Testing
```bash
# Run on emulator
flutter run -d emulator-5554

# Build APK for internal testing
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release
```

### Platform-Specific Widget Tests
```dart
// test/widgets/platform_aware_widget_test.dart
import 'dart:io';

void main() {
  testWidgets('renders Cupertino on iOS', (tester) async {
    // Mock platform
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    
    await tester.pumpWidget(const MaterialApp(home: PlatformButton()));
    
    expect(find.byType(CupertinoButton), findsOneWidget);
    
    debugDefaultTargetPlatformOverride = null;
  });
  
  testWidgets('renders Material on Android', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    
    await tester.pumpWidget(const MaterialApp(home: PlatformButton()));
    
    expect(find.byType(ElevatedButton), findsOneWidget);
    
    debugDefaultTargetPlatformOverride = null;
  });
}
```

---

## 🚨 RED FLAGS (BLOCCA E CORREGGI)

- ❌ Hardcoded platform checks senza abstraction
- ❌ Missing Info.plist permissions (iOS crash)
- ❌ Missing AndroidManifest permissions (silently fails)
- ❌ No runtime permission handling
- ❌ Sensitive data in SharedPreferences (usa secure storage)
- ❌ Platform channel senza error handling
- ❌ No main thread dispatch (iOS UI updates)
- ❌ Leaking platform resources (no dispose)
- ❌ Missing background modes capability (iOS)
- ❌ Deep links senza validation (security risk)
- ❌ No SSL pinning su sensitive APIs
- ❌ Hardcoded bundle identifier
- ❌ No App Transport Security exceptions (solo se necessario)
- ❌ Missing ProGuard rules (Android release)

---

## ✅ CHECKLIST PRE-HANDOFF

### iOS
- [ ] Info.plist permissions configurate con descriptions user-friendly
- [ ] Minimum iOS version definita (≥14)
- [ ] Launch screen configurato (storyboard o flutter_native_splash)
- [ ] App icons tutti i size (AppIcon.appiconset)
- [ ] Background modes abilitati se necessario (push, location, audio)
- [ ] Associated Domains per universal links
- [ ] Keychain per secrets
- [ ] ATS configurato correttamente
- [ ] Privacy manifest (iOS 17+)
- [ ] Testato su: iPhone SE, iPhone 15 Pro Max, iPad

### Android
- [ ] AndroidManifest.xml permissions corrette
- [ ] Min SDK ≥23, Target SDK ≥34
- [ ] Proguard/R8 rules configurate
- [ ] App Signing by Google Play abilitato
- [ ] Splash screen configurato
- [ ] Adaptive icons (mipmap-anydpi-v26)
- [ ] EncryptedSharedPreferences per secrets
- [ ] Deep links configurati (intent-filters)
- [ ] Backup rules (android:allowBackup)
- [ ] Testato su: Pixel 6, Samsung Galaxy S23, low-end device

### Platform Channels
- [ ] Error handling robust (PlatformException)
- [ ] Main thread dispatch (iOS UI updates)
- [ ] Null safety sui risultati
- [ ] Type safety (generic invokeMethod<T>)
- [ ] Documentation dei metodi

### Cross-Platform
- [ ] Runtime permission handling completo
- [ ] Deep links funzionanti (iOS + Android)
- [ ] Push notifications configurate (APNs + FCM)
- [ ] Biometric auth funzionante
- [ ] Camera/GPS/Storage permissions gestite
- [ ] Secure storage per token/secrets
- [ ] Offline mode funzionante
- [ ] Handoff strutturato compilato

---

> **MANTRA**: "Native is the foundation. Permissions are explicit. Main thread for UI. Secure storage for secrets. Test on real devices. Platform channels bridge, not replace. If it works on simulator but not device, it's broken."