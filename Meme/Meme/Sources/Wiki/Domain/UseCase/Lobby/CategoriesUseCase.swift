//
//  CategoriesUseCase.swift
//  Meme
//
//  Created by 제나 on 8/11/25.
//

import Combine

protocol CategoriesUseCase {
    var result: CurrentValueSubject<Result<[CategoryItem], ServiceError>?, Never> { get }
    func execute()
}

final class DefaultCategoriesUseCase: CategoriesUseCase {
    
    var result = CurrentValueSubject<Result<[CategoryItem], ServiceError>?, Never>(nil)
    
    private var task: Task<Void, Never>?
    private let repository: CategoryRepositoryInterface
    
    init(repository: CategoryRepositoryInterface) {
        self.repository = repository
    }
    
    deinit {
        task?.cancel()
    }
    
    func execute() {
        task?.cancel()
        task = Task {
            do {
                let categories = try await repository.fetchCategories()
                result.send(.success(categories))
            } catch let error as ServiceError {
                result.send(.failure(error))
            } catch {
                result.send(.failure(ServiceError.unknown(error)))
            }
        }
    }
}
