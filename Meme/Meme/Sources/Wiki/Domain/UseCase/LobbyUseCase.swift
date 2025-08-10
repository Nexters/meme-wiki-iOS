//
//  LobbyUseCase.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Combine

protocol LobbyUseCase {
    var result: CurrentValueSubject<Result<Lobby, ServiceError>?, Never> { get }
    func execute()
}

final class DefaultLobbyUseCase: LobbyUseCase {
    
    var result = CurrentValueSubject<Result<Lobby, ServiceError>?, Never>(nil)
    
    private var task: Task<Void, Never>?
    private let repository: LobbyRepositoryInterface
    
    init(repository: LobbyRepositoryInterface) {
        self.repository = repository
    }
    
    deinit {
        task?.cancel()
    }
    
    func execute() {
        task?.cancel()
        task = Task {
            do {
                // TODO: - Call the all sections
                let response = try await repository.fetchBanners()
                let banners = response.success.map { $0.toEntity() }
                let lobby = Lobby(banners: banners)
                result.send(.success(lobby))
            } catch let error as ServiceError {
                result.send(.failure(error))
            } catch {
                result.send(.failure(ServiceError.unknown(error)))
            }
        }
    }
}
