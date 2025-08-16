//
//  MostSharedUseCase.swift
//  Meme
//
//  Created by 제나 on 8/11/25.
//

import Combine

protocol MostSharedUseCase {
    var result: CurrentValueSubject<Result<Lobby.MostSharedItem, ServiceError>?, Never> { get }
    func execute()
}

final class DefaultMostSharedUseCase: MostSharedUseCase {
    
    var result = CurrentValueSubject<Result<Lobby.MostSharedItem, ServiceError>?, Never>(nil)
    
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
                let response = try await repository.fetchMostSharedMemes().success
                let mostSharedItem = response.toEntity()
                result.send(.success(mostSharedItem))
            } catch let error as ServiceError {
                result.send(.failure(error))
            } catch {
                result.send(.failure(ServiceError.unknown(error)))
            }
        }
    }
}
