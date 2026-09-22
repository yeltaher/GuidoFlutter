//
//  FLTUnityViewController.swift
//  flutter_unity_widget
//
//  Created by Rex Raphael on 30/01/2021.
//

import Foundation
import UnityFramework

// Defines unity controllable from Flutter.
public class FLTUnityWidgetController: NSObject, FLTUnityOptionsSink, FlutterPlatformView {
    private var _rootView: FLTUnityView
    private var viewId: Int64 = 0
    private var channel: FlutterMethodChannel?
    private weak var registrar: (NSObjectProtocol & FlutterPluginRegistrar)?
    
    private var _disposed = false

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        registrar: NSObjectProtocol & FlutterPluginRegistrar
    ) {
        self._rootView = FLTUnityView(frame: frame)
        super.init()

        globalControllers.append(self)

        self.viewId = viewId

        let channelName = String(format: "plugin.xraph.com/unity_view_%lld", viewId)
        self.channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())

        self.channel?.setMethodCallHandler(self.methodHandler)
        self.attachView()
    }

    func methodHandler(_ call: FlutterMethodCall, result: FlutterResult) {
        if call.method == "unity#dispose" {
            self.dispose()
            result(nil)
        } else {
            self.reattachView()
            if call.method == "unity#isReady" {
                result(GetUnityPlayerUtils().unityIsInitiallized())
            } else if call.method == "unity#isLoaded" {
                let _isUnloaded = GetUnityPlayerUtils().isUnityLoaded()
                result(_isUnloaded)
            } else if call.method == "unity#createUnityPlayer" {
                startUnityIfNeeded()
                result(nil)
            } else if call.method == "unity#isPaused" {
                let _isPaused = GetUnityPlayerUtils().isUnityPaused()
                result(_isPaused)
            } else if call.method == "unity#pausePlayer" {
                GetUnityPlayerUtils().pause()
                result(nil)
            } else if call.method == "unity#postMessage" {
                self.postMessage(call: call, result: result)
                result(nil)
            } else if call.method == "unity#resumePlayer" {
                GetUnityPlayerUtils().resume()
                result(nil)
            } else if call.method == "unity#unloadPlayer" {
                GetUnityPlayerUtils().unload()
                result(nil)
            } else if call.method == "unity#quitPlayer" {
                GetUnityPlayerUtils().quit()
                result(nil)
            } else if call.method == "unity#waitForUnity" {
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    func setDisabledUnload(enabled: Bool) {

    }

    public func view() -> UIView {
        return _rootView;
    }

    private func startUnityIfNeeded() {
        GetUnityPlayerUtils().createPlayer(completed: { [weak self] (view: UIView?) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let unityView = view ?? GetUnityPlayerUtils().ufw?.appController()?.rootView
                if let unityView = unityView {
                    if let superview = unityView.superview, superview != self._rootView {
                        unityView.removeFromSuperview()
                        superview.layoutIfNeeded()
                    }
                    if !self._rootView.subviews.contains(unityView) {
                        unityView.frame = self._rootView.bounds
                        unityView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        self._rootView.addSubview(unityView)
                        self._rootView.layoutIfNeeded()
                    }
                }
            }
        })
    }

    func attachView() {
        startUnityIfNeeded()

        let unityView = GetUnityPlayerUtils().ufw?.appController()?.rootView
        if let superview = unityView?.superview, superview != _rootView {
            unityView?.removeFromSuperview()
            superview.layoutIfNeeded()
        }

        if let unityView = unityView {
            if !_rootView.subviews.contains(unityView) {
                unityView.frame = _rootView.bounds
                unityView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                _rootView.addSubview(unityView)
                _rootView.layoutIfNeeded()
                DispatchQueue.main.async { [weak self] in
                    self?.channel?.invokeMethod("events#onViewReattached", arguments: "")
                }
            }
        }
        GetUnityPlayerUtils().resume()
    }

    func reattachView() {
        let unityView = GetUnityPlayerUtils().ufw?.appController()?.rootView
        let superview = unityView?.superview
        if superview != _rootView {
            attachView()
        }

        GetUnityPlayerUtils().resume()
    }

    func removeViewIfNeeded() {
        if GetUnityPlayerUtils().ufw == nil {
            return
        }

        let unityView = GetUnityPlayerUtils().ufw?.appController()?.rootView
        if _rootView == unityView?.superview {
            if globalControllers.isEmpty {
                unityView?.removeFromSuperview()
                unityView?.superview?.layoutIfNeeded()
            } else {
                globalControllers.last?.reattachView()
            }
        }
        if globalControllers.isEmpty {
            GetUnityPlayerUtils().pause()
        } else {
            GetUnityPlayerUtils().resume()
        }
    }

    func dispose() {
        if _disposed {
            return
        }

        globalControllers.removeAll{ value in
            return value == self
        }

        channel?.setMethodCallHandler(nil)
        removeViewIfNeeded()
        
        _disposed = true
    }
    
    /// Handles messages from unity in the current view
    func handleMessage(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.channel?.invokeMethod("events#onUnityMessage", arguments: message)
        }
    }
    
    
    /// Handles scene changed event from unity in the current view
    func handleSceneChangeEvent(info: Dictionary<String, Any>) {
        DispatchQueue.main.async { [weak self] in
            self?.channel?.invokeMethod("events#onUnitySceneLoaded", arguments: info)
        }
    }
    
    /// Post messages to unity from flutter
    func postMessage(call: FlutterMethodCall, result: FlutterResult) {
        guard let args = call.arguments else {
            result("iOS could not recognize flutter arguments in method: (postMessage)")
            return
        }

        if let myArgs = args as? [String: Any],
           let gObj = myArgs["gameObject"] as? String,
           let method = myArgs["methodName"] as? String,
           let message = myArgs["message"] as? String {
            GetUnityPlayerUtils().postMessageToUnity(gameObject: gObj, unityMethodName: method, unityMessage: message)
            result(nil)
        } else {
            result(FlutterError(code: "-1", message: "iOS could not extract " +
                   "flutter arguments in method: (postMessage)", details: nil))
        }
    }
}
