//
//  Repository.Lobby.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Foundation

protocol LobbyInterface {
    func fetchSections() async throws -> LobbyResponse
}
