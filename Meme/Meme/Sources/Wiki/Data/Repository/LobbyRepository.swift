//
//  LobbyRepository.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Combine
import Moya

final class LobbyRepository: LobbyInterface {
    private let provider = Provider<LobbyAPI>()
}

extension LobbyRepository {
    func fetchSections() async throws -> BannerResponseDTO {
        return BannerResponseDTO(id: 0, title: "", imgUrl: "")
    }
}
