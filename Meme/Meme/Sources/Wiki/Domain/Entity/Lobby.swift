//
//  Lobby.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Foundation

struct Lobby {
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
