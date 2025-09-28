//
//  NotificationRepository.swift
//  Meme
//
//  Created by ZENA on 9/28/25.
//

import Foundation

final class NotificationRepository: NotificationRepositoryInterface {
    
    private var provider = Provider<NotificationAPI>()
    
    init(provider: Provider<NotificationAPI>) {
        self.provider = provider
    }
    
    init() {}
}

extension NotificationRepository {
    func register(token: String) async throws {
        _ = try await provider.request(
            api: .register(token: token),
            dto: NotificationResponseDTO.self)
    }
}

struct NotificationResponseDTO: Decodable { }
