import Flutter
import flutter_unity_widget_2
import UIKit

// MARK: - Crash Handler (async-signal-safe, C-level only)

/// Previous exception handler to chain
private var previousExceptionHandler: NSUncaughtExceptionHandler?

/// Writes crash info using ONLY async-signal-safe C operations.
/// This function must NEVER use: Swift strings, FileManager, DateFormatter,
/// Thread.callStackSymbols, malloc, or any Foundation/UIKit API.
private func writeCrashLogC(_ message: UnsafePointer<CChar>) {
    let path = "/Documents/crash_log.txt"  // Relative to home
    let home = getenv("HOME")
    guard let home = home else { return }

    // Build full path using C string operations
    var fullPath = [CChar](repeating: 0, count: 1024)
    snprintf(&fullPath, fullPath.count, "%s%s", home, path)

    let fd = fullPath.withUnsafeBufferPointer { buf in
        return open(buf.baseAddress!, O_WRONLY | O_CREAT | O_TRUNC, 0o644)
    }
    if fd >= 0 {
        _ = write(fd, message, strlen(message))
        close(fd)
    }
}

/// Uncaught exception handler (ObjC exceptions) — runs outside signal context
private func uncaughtExceptionHandler(exception: NSException) {
    let name = exception.name.rawValue
    let reason = exception.reason ?? "No reason"

    // Build a C-safe message using snprintf
    var buffer = [CChar](repeating: 0, count: 4096)
    name.withCString { nameC in
        reason.withCString { reasonC in
            snprintf(&buffer, buffer.count,
                "=== CRASH LOG ===\nType: UncaughtException\nException: %s\nReason: %s\n==================\n",
                nameC, reasonC)
        }
    }
    writeCrashLogC(buffer)

    previousExceptionHandler?(exception)
}

/// Signal handler (C-callable, async-signal-safe).
/// Uses ONLY: signal-safe writes, strlen, snprintf — no Swift objects.
@_cdecl("guidoSignalHandler")
private func guidoSignalHandler(_ signal: Int32) {
    // Get signal name using C-level switch
    let signalName: UnsafePointer<CChar>
    switch signal {
    case SIGABRT: signalName = "SIGABRT"
    case SIGSEGV: signalName = "SIGSEGV"
    case SIGBUS:  signalName = "SIGBUS"
    case SIGFPE:  signalName = "SIGFPE"
    case SIGILL:  signalName = "SIGILL"
    case SIGPIPE: signalName = "SIGPIPE"
    default:      signalName = "UNKNOWN"
    }

    // Build crash message using ONLY C-level operations
    var buffer = [CChar](repeating: 0, count: 512)
    snprintf(&buffer, buffer.count,
        "=== CRASH LOG ===\nType: Signal(%s)\nSignal: %d (%s)\n==================\n",
        signalName, signal, signalName)

    // Write using async-signal-safe operations only
    writeCrashLogC(buffer)

    // Restore default handler and re-raise
    signal(signal, SIG_DFL)
    raise(signal)
}

// MARK: - Crash Log Manager

/// Thread-safe crash log manager for Flutter method channel
private class CrashLogManager {
    static let shared = CrashLogManager()

    private let crashLogURL: URL?

    private init() {
        let fileManager = FileManager.default
        crashLogURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("crash_log.txt")
    }

    func checkCrashLog() -> String? {
        guard let url = crashLogURL,
              FileManager.default.fileExists(atPath: url.path),
              let content = try? String(contentsOf: url, encoding: .utf8),
              !content.isEmpty else {
            return nil
        }
        return content
    }

    func clearCrashLog() {
        guard let url = crashLogURL,
              FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        try? FileManager.default.removeItem(at: url)
    }
}

// MARK: - AppDelegate

@main
@objc class AppDelegate: FlutterAppDelegate {

    // MARK: - Crash Handler Registration

    private func registerCrashHandlers() {
        // 1. Register uncaught exception handler (ObjC exceptions)
        previousExceptionHandler = NSGetUncaughtExceptionHandler()
        NSSetUncaughtExceptionHandler { exception in
            uncaughtExceptionHandler(exception: exception)
        }

        // 2. Register signal handlers for native crashes
        let signals = [SIGABRT, SIGSEGV, SIGBUS, SIGFPE, SIGILL, SIGPIPE]
        for sig in signals {
            signal(sig, guidoSignalHandler)
        }
    }

    // MARK: - Application Lifecycle

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Register crash handlers FIRST (before any plugin registration)
        registerCrashHandlers()

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

            // Crash log channel
            let crashLogChannel = FlutterMethodChannel(
                name: "com.codepulse.guido/crash-log",
                binaryMessenger: controller.binaryMessenger
            )
            crashLogChannel.setMethodCallHandler { call, result in
                switch call.method {
                case "checkCrashLog":
                    result(CrashLogManager.shared.checkCrashLog())
                case "clearCrashLog":
                    CrashLogManager.shared.clearCrashLog()
                    result(nil)
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
