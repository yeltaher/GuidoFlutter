import Flutter
import UIKit

// MARK: - AppDelegate

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    private var memoryChannel: FlutterMethodChannel?

    // MARK: - Application Lifecycle

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Previene il blocco automatico dello schermo su iOS durante le sessioni di meditazione e respirazione
        application.isIdleTimerDisabled = true

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - FlutterImplicitEngineDelegate (UIScene Lifecycle)

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

        let messenger = engineBridge.applicationRegistrar.messenger()

        // Orientation & Keep-Screen-On channel
        let orientationChannel = FlutterMethodChannel(
            name: "com.codepulse.guido/orientation",
            binaryMessenger: messenger
        )
        orientationChannel.setMethodCallHandler { call, channelResult in
            if call.method == "forceLandscape" {
                UIApplication.shared.isIdleTimerDisabled = true
                channelResult(nil)
            } else if call.method == "forcePortrait" {
                UIApplication.shared.isIdleTimerDisabled = true
                channelResult(nil)
            } else if call.method == "keepScreenOn" {
                UIApplication.shared.isIdleTimerDisabled = true
                channelResult(nil)
            } else {
                channelResult(FlutterMethodNotImplemented)
            }
        }

        // Memory Pressure Channel
        memoryChannel = FlutterMethodChannel(
            name: "com.codepulse.guido/memory",
            binaryMessenger: messenger
        )
    }

    override func applicationDidBecomeActive(_ application: UIApplication) {
        super.applicationDidBecomeActive(application)
        // Riafferma il blocco dello standby al ritorno in primo piano su iOS
        application.isIdleTimerDisabled = true
        UIApplication.shared.isIdleTimerDisabled = true
    }

    // MARK: - Memory Pressure Handling

    override func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        super.applicationDidReceiveMemoryWarning(application)

        // Under memory pressure, notify Flutter to trigger image cache purge (PaintingBinding.instance.imageCache.clear())
        // and reduce memory footprint to prevent iOS Jetsam SIGKILL
        DispatchQueue.main.async { [weak self] in
            self?.memoryChannel?.invokeMethod("onMemoryWarning", arguments: nil)
        }
    }
}
