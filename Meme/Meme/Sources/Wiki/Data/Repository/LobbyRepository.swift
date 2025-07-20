//
//  LobbyRepository.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Combine
import Moya

extension Wiki.Repository {
    final class LobbyRepository: Wiki.Namespace, LobbyInterface {
        private let provider = MoyaProvider<Wiki.API.Lobby>()
    }
}

extension Wiki.Repository.LobbyRepository {
    func fetchSections() async throws -> Wiki.Repository.DTO.SectionResponse {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.sample(id: "sample")) { result in
                switch result {
                case .success(let response):
                    do {
                        let response = try response.map(DTO.SectionResponse.self)
                        continuation.resume(returning: response)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    do {
                        if let errorResponse = try error.response?.map(ErrorResponse.self) {
                            continuation.resume(throwing: ServiceError.server(errorResponse))
                        } else {
                            continuation.resume(throwing: ServiceError.unknown(error))
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}
