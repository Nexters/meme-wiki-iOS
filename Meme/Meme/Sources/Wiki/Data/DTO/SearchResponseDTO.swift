//
//  SearchResponseDTO.swift
//  Meme
//
//  Created by 임현규 on 8/6/25.
//

import Foundation

struct SearchResponseDTO: Decodable {
    let id: Int
    let title: String
    let usageContext: String
    let origin: String
    let trendPeriod: String
    let imgUrl: String
    let hashtags: [String]
    
    func toEntity() -> MemeSearchItem {
        return .init(
            thumbnail: .init(
                year: Int(trendPeriod) ?? 0,
                title: title,
                hashtag: hashtags,
                imageURL: imgUrl
            ),
            usage: usageContext,
            source: origin
        )
    }
}
