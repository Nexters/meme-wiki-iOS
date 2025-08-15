//
//  CallbackJavaScript.swift
//  Meme
//
//  Created by 제나 on 8/15/25.
//

import Foundation

struct CallbackJavaScript {
    
    let script: String
    
    init(script: String) {
        self.script = script
    }
    
    init?(data: [String]) {
        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .sortedKeys),
            let jsonString = String(data: jsonData, encoding: .utf8)
        else { return nil }
        self.init(script: jsonString)
    }
    
    func toScript() -> String {
        """
        window.onNativeEntered(\(script));
        """
    }
}
