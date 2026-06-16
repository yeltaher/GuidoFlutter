import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let success = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    if let controller = window?.rootViewController as? FlutterViewController {
      let orientationChannel = FlutterMethodChannel(name: "com.codepulse.guido/orientation",
                                                    binaryMessenger: controller.binaryMessenger)
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
    
    return success
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
