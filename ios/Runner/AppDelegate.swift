import Flutter
import flutter_unity_widget_2
import UIKit

// MARK: - AppDelegate

@main
@objc class AppDelegate: FlutterAppDelegate {

    // MARK: - Application Lifecycle

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Unity UaaL engine before plugin registration
        InitUnityIntegrationWithOptions(argc: CommandLine.argc, argv: CommandLine.unsafeArgv, launchOptions)

        GeneratedPluginRegistrant.register(with: self)

        if let controller = window?.rootViewController as? FlutterViewController {
            // Orientation channel
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

