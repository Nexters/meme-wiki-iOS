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
        guard let body = message.body as? String,
              let data = body.data(using: .utf8),
              let parameters = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let command = parameters["type"] as? String,
              let handlerName = WikiScriptMessageHandlerName(rawValue: command)
        else {
            // TODO: - alert
            return
        }
        
        switch handlerName {
        case .SHARE_KAKAO:
            guard let data = parameters["data"] as? [String: Any] else { return }
            let shareData = ShareData(data: data)
            DispatchQueue.main.async {
                guard
                    let shareData,
                    let url = message.webView?.url
                else { return }
                KakaoShareManager.shared.shareToKakao(shareData: shareData, link: url)
            }
        case .SHARE_MEME:
            guard let data = parameters["data"] as? [String: Any] else { return }
            let shareData = ShareData(data: data)
            DispatchQueue.main.async { [weak self] in
                guard
                    let self, let viewController,
                    let url = message.webView?.url?.absoluteString
                else { return }
                viewController.presentShareSheet(items: ["미미키에서 더 많은 밈을 확인해보세요!", url])
            }
        case .CUSTOM_MEME:
            guard
                let data = parameters["data"] as? [String: Any],
                let shareData = ShareData(data: data)
            else { return }
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.navigationController?.pushViewController(
                    MemeCustomViewController(imageURL: shareData.image),
                    animated: true)
            }
        case .WEB_ENTERED:
            message.webView?.notifyClientReady()
        case .SHOW_MORE_MEMES:
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

enum WikiScriptMessageHandlerName: String, CaseIterable {
    case SHARE_KAKAO
    case SHARE_MEME
    case CUSTOM_MEME
    case WEB_ENTERED
    case SHOW_MORE_MEMES
}
