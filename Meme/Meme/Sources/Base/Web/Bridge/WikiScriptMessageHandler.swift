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
              let command = parameters["type"] as? String,
              let handlerName = WikiScriptMessageHandlerName(rawValue: command)
        else { return }
        
        switch handlerName {
        case .SHARE_MEME:
            guard let data = parameters["data"] as? [String: Any] else { return }
            let shareData = ShareData(data: data)
            DispatchQueue.main.async { [weak self] in
                guard let self, let viewController, let shareData else { return }
                viewController.presentShareSheet(items: [shareData.image])
            }
        case .DIY_MEME:
            // TODO: -
            viewController?.present(MemeMainViewController(), animated: true)
        }
    }
}

extension WikiScriptMessageHandler {
    struct ShareData {
        let title: String
        let image: String
        
        init?(data: [String: Any]) {
            guard
                let title = data["title"] as? String,
                let image = data["image"] as? String
            else { return nil }
            self.title = title
            self.image = image
        }
    }
}

enum WikiScriptMessageHandlerName: String, CaseIterable {
    case SHARE_MEME
    case DIY_MEME
}
