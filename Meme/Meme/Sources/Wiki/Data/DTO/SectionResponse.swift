//
//  SectionResponse.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Foundation

extension Wiki.DTO {
    struct SectionResponse: Decodable {
        let sections: [Section]
        
        func toEntity() -> [Wiki.Entity.Lobby.Section] {
            sections.map { $0.toEntity() }
        }
    }
    
    struct Section: Decodable {
        let type: String
        let title: String
        
        func toEntity() -> Wiki.Entity.Lobby.Section {
            Wiki.Entity.Lobby.Section(type: type, title: title)
        }
    }
}
