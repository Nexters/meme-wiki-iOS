//
//  TopRatedUseCase.swift
//  Meme
//
//  Created by 제나 on 8/11/25.
//

import Combine

protocol TopRatedUseCase {
    var result: CurrentValueSubject<Result<[Lobby.TopRatedItem], ServiceError>?, Never> { get }
    func execute()
}

final class DefaultTopRatedUseCase: TopRatedUseCase {
    
    var result = CurrentValueSubject<Result<[Lobby.TopRatedItem], ServiceError>?, Never>(nil)
    
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
                let response = try await repository.fetchTopRatedMemes()
                let topRatedMemes = response.success.map { $0.toEntity() }
                result.send(.success(topRatedMemes))
            } catch let error as ServiceError {
                result.send(.failure(error))
            } catch {
                result.send(.failure(ServiceError.unknown(error)))
            }
        }
    }
}
