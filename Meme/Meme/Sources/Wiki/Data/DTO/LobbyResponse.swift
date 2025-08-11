//
//  LobbyResponse.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Foundation

struct CategoryResponseDTO: Decodable {
    let id: Int
    let name: String
    let imgUrl: String
    
    func toEntity() -> Lobby.CategoryItem {
        .init(id: id, title: name, imageURL: imgUrl)
    }
}

struct TopRatedRatedReponseDTO: Decodable {
    let id: Int
    let title: String
    let imgUrl: String
    
    func toEntity() -> Lobby.TopRatedItem {
        .init(id: id, title: title, imageURL: imgUrl)
    }
}

struct MostSharedResponseDTO: Decodable {
    let id: Int
    let title: String
    let imgUrl: String
    
    func toEntity() -> Lobby.MostSharedItem {
        .init(id: id, title: title, imageURL: imgUrl)
    }
}
