//
//  Thumbnail.swift
//  Meme
//
//  Created by 임현규 on 7/29/25.
//

import Foundation

struct Thumbnail: Hashable {
    let id = UUID()
    var year: Int
    var title: String
    var hashtag: [String]
    var imageURL: String
    let randomColor = RandomColor.allCases.randomElement() ?? .none
}
