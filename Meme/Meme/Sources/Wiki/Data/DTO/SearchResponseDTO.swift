//
//  SearchResponseDTO.swift
//  Meme
//
//  Created by 임현규 on 8/6/25.
//

import Foundation

struct SearchResponseDTO: Decodable {
    let paging: PagingDTO
    let results: [SearchItemDTO]
    
    func toEntity() -> SearchPage<MemeSearchItem> {
        .init(items: results.map { $0.toEntity() }, pageState: .init(next: paging.next, hasMore: paging.hasMore, pageSize: paging.pageSize))
    }
}

struct PagingDTO: Codable {
    let next: Int?
    let hasMore: Bool
    let pageSize: Int
}

struct SearchItemDTO: Codable {
    let id: Int
    let title: String
    let usageContext: String
    let origin: String
    let trendPeriod: String
    let imgUrl: String
    let hashtags: [String]
    
    func toEntity() -> MemeSearchItem {
        return .init(
            id: id,
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
