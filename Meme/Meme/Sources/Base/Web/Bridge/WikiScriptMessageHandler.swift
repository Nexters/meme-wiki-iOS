//
//  WikiScriptMessageHandler.swift
//  Meme
//
//  Created by 제나 on 7/26/25.
//

import WebKit

class WikiScriptMessageHandler: NSObject, WKScriptMessageHandler {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard let parameters = message.body as? [String: Any],
              let command = parameters["command"] as? String, // TODO: - command?
              let handlerName = WikiScriptMessageHandlerName(rawValue: command)
        else { return }
        
        switch handlerName {
        case .close:
            return
        case .share:
            let method = parameters["method"] as? String
            let link = (parameters["link"] as? String)?.asEncodedURL()
            // TODO: - share
        }
    }
}

enum WikiScriptMessageHandlerName: String, CaseIterable {
    case close
    case share
}
