//
//  Lobby.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Foundation

extension Wiki.Entity {
    enum Lobby: Wiki.Namespace { }
}

extension Wiki.Entity.Lobby {
    struct Section {
        let type: String
        let title: String
    }
}
