//
//  FLTUnityViewFactory.swift
//  flutter_unity_widget
//
//  Created by Rex Raphael on 30/01/2021.
//

import Foundation

class FLTUnityWidgetFactory: NSObject, FlutterPlatformViewFactory {
    private var registrar: (NSObjectProtocol & FlutterPluginRegistrar)?

    init(registrar: NSObjectProtocol & FlutterPluginRegistrar) {
        super.init()
        self.registrar = registrar
    }

    func createArgsCodec() -> (NSObjectProtocol & FlutterMessageCodec) {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        guard let reg = registrar else {
            fatalError("FLTUnityWidgetFactory: registrar was unexpectedly nil")
        }
        let controller = FLTUnityWidgetController(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            registrar: reg)
        return controller
    }
}
