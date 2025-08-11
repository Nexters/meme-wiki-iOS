//
//  CategoriesUseCase.swift
//  Meme
//
//  Created by 제나 on 8/11/25.
//

import Combine

protocol CategoriesUseCase {
    var result: CurrentValueSubject<Result<[Lobby.CategoryItem], ServiceError>?, Never> { get }
    func execute()
}

final class DefaultCategoriesUseCase: CategoriesUseCase {
    
    var result = CurrentValueSubject<Result<[Lobby.CategoryItem], ServiceError>?, Never>(nil)
    
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
                let response = try await repository.fetchCategories()
                let categories = response.success.map { $0.toEntity() }
                result.send(.success(categories))
            } catch let error as ServiceError {
                result.send(.failure(error))
            } catch {
                result.send(.failure(ServiceError.unknown(error)))
            }
        }
    }
}
