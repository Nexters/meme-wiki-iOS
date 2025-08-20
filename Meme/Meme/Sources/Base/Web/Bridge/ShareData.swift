//
//  ShareData.swift
//  Meme
//
//  Created by 제나 on 8/21/25.
//

import Foundation

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
