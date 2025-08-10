//
//  Lobby.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Foundation

struct Lobby {
    let banners: [BannerItem]
}

extension Lobby {
    enum Section: Int, CaseIterable {
        case custom = 0
        case category
        case topRated
        case mostShared
    }
    
    struct Item: Hashable {
        let id = UUID()
        let type: Section
        let content: String
        
        let indexPath: IndexPath
    }
}

extension Lobby {
    struct BannerItem {
        let id: Int
        let title: String
        let subTitle: String
        let imageURL: String
    }
    
    struct CategoryItem {
        let id: Int
        let title: String
        let imageURL: String
    }
    
    struct TopRatedItem {
        let id: Int
        let title: String
        let imageURL: String
    }
    
    struct MostSharedItem {
        let id: Int
        let title: String
        let imageURL: String
    }
}
