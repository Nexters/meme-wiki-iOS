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
}
