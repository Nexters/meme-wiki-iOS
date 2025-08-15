//
//  WKWebView++Extension.swift
//  Meme
//
//  Created by ZENA on 8/16/25.
//

import WebKit

extension WKWebView {
    func notifyClientReady() {
        guard
            let javascript = CallbackJavaScript(data: ["APP_ENTERED"])?.toScript()
        else {
            Log.error("Failed to create callback javascript", .networking)
            return
        }
        self.evaluateJavaScript(javascript) { result, error in
            if let error = error {
                Log.error("notifyClientReady() error: \(error)", .networking)
            } else {
                Log.error("notifyClientReady() success: \(String(describing: result))", .networking)
            }
        }
    }
}
