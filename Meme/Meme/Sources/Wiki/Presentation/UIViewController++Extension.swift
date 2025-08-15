//
//  UIViewController++Extension.swift
//  Meme
//
//  Created by 제나 on 8/15/25.
//

import UIKit

extension UIViewController {
    func gotoMemeDetail(id: Int) {
        guard let url = URL(string: "https://meme-wiki.net/meme/\(id)") else { return }
        let webVC = WikiWebViewController(url: url)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func presentShareSheet(items: [Any]) {
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if let popover = activity.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(
                x: view.bounds.midX,
                y: view.bounds.midY,
                width: 0,
                height: 0)
            popover.permittedArrowDirections = []
        }
        present(activity, animated: true)
    }
}
