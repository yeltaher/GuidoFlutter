import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let orientationChannel = FlutterMethodChannel(
        name: "com.codepulse.guido/orientation",
        binaryMessenger: controller.binaryMessenger
      )
      orientationChannel.setMethodCallHandler { call, result in
        if call.method == "forceLandscape" {
          result(nil)
        } else if call.method == "forcePortrait" {
          result(nil)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

