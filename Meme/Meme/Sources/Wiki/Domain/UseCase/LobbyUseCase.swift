//
//  LobbyUseCase.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Combine

extension Wiki.UseCase {
    protocol Lobby {
        var result: CurrentValueSubject<Result<[Entity.Lobby.Section], ServiceError>?, Never> { get }
        func execute()
    }
}

extension Wiki.UseCase {
    final class LobbyUseCase: Lobby {
        
        var result = CurrentValueSubject<Result<[Entity.Lobby.Section], ServiceError>?, Never>(nil)
        
        private var task: Task<Void, Never>?
        private let repository: Repository.LobbyInterface
        
        init(repository: Repository.LobbyInterface) {
            self.repository = repository
        }
        
        deinit {
            task?.cancel()
        }
        
        func execute() {
            task?.cancel()
            task = Task {
                do {
                    let response = try await repository.fetchSections()
                    result.send(.success(response.toEntity()))
                } catch let error as ServiceError {
                    result.send(.failure(error))
                } catch {
                    result.send(.failure(ServiceError.unknown(error)))
                }
            }
        }
    }
}
