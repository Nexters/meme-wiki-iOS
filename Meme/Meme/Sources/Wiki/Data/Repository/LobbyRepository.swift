//
//  LobbyRepository.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Combine
import Moya

final class LobbyRepository: LobbyRepositoryInterface {
    private let provider = Provider<LobbyAPI>()
}

extension LobbyRepository {
    func fetchCategories() async throws -> APIResponse<[CategoryResponseDTO]> {
        let response = try await provider.request(api: .categories, dto: [CategoryResponseDTO].self)
        return response
    }
    
    func fetchTopRatedMemes() async throws -> APIResponse<[TopRatedRatedReponseDTO]> {
        let response = try await provider.request(api: .topRated, dto: [TopRatedRatedReponseDTO].self)
        return response
    }
    
    func fetchMostSharedMemes() async throws -> APIResponse<MostSharedResponseDTO> {
        let response = try await provider.request(api: .mostShared, dto: MostSharedResponseDTO.self)
        return response
    }
}
