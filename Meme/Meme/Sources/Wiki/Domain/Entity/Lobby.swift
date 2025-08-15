//
//  Lobby.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Foundation

struct Lobby {
    let categories: [CategoryItem]
    let topRatedMemes: [TopRatedItem]
    let mostSharedMemes: [MostSharedItem]
}

extension Lobby {
    enum Section: Int, CaseIterable {
        case banner = 0
        case category
        case topRated
        case mostShared
    }
    
    struct Item: Hashable {
        let id = UUID()
        let memeId: Int?
        let type: Section
        let content: String
        let imageURL: String?
        let childs: [Item]?
        
        let indexPath: IndexPath
        
        init(
            memeId: Int? = nil,
            type: Section,
            content: String,
            imageURL: String? = nil,
            childs: [Item]? = nil,
            indexPath: IndexPath
        ) {
            self.memeId = memeId
            self.type = type
            self.content = content
            self.imageURL = imageURL
            self.childs = childs
            self.indexPath = indexPath
        }
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
