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
    private let repository: LobbyInterface
    
    init(repository: LobbyInterface) {
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
                // TODO: - return success with result
            } catch let error as ServiceError {
                result.send(.failure(error))
            } catch {
                result.send(.failure(ServiceError.unknown(error)))
            }
        }
    }
}
