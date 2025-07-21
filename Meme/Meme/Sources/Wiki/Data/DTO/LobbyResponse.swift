//
//  LobbbyResponse.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Foundation

struct LobbyResponse: Decodable {
    let sections: [SectionResponse]
    
    func toEntity() -> Lobby {
        Lobby(sections: sections.map { $0.toEntity() })
    }
    
    struct SectionResponse: Decodable {
        let type: String
        let title: String
        
        func toEntity() -> Lobby.Section {
            Lobby.Section(type: type, title: title)
        }
    }
}
