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
    let mostSharedItem: MostSharedItem
}

extension Lobby {
    enum Section: Equatable, Hashable {
        case banner
        case category
        case topRated
        case mostShared(countdown: String)
        
        var index: Int {
            switch self {
            case .banner:
                return 0
            case .category:
                return 1
            case .topRated:
                return 2
            case .mostShared:
                return 3
            }
        }
        
        init?(rawIndex: Int) {
            switch rawIndex {
            case 0: self = .banner
            case 1: self = .category
            case 2: self = .topRated
            case 3: self = .mostShared(countdown: "")
            default: return nil
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .mostShared(let countdown):
                hasher.combine(index)
                hasher.combine(countdown)
            default:
                hasher.combine(index)
            }
        }

        static func == (lhs: Section, rhs: Section) -> Bool {
            switch (lhs, rhs) {
            case (.mostShared(let lhsCountdown), .mostShared(let rhsCountdown)):
                return lhsCountdown == rhsCountdown
            default:
                return lhs.index == rhs.index
            }
        }
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
    
    struct TopRatedItem {
        let id: Int
        let title: String
        let imageURL: String
    }
    
    struct MostSharedItem {
        let nextFetchTime: String
        let memes: [MemeItem]
        
        struct MemeItem {
            let id: Int
            let title: String
            let imageURL: String
        }
        
        static func getDummy() -> Self {
            .init(nextFetchTime: "", memes: [])
        }
    }
}
