//
//  CategoryMemeUseCase.swift
//  Meme
//
//  Created by 임현규 on 8/15/25.
//

import Combine

final class CategoryMemeUseCase: CategoryMemeUseCaseInterface {
    private let subject = CurrentValueSubject<Result<SearchPage<MemeSearchItem>, ServiceError>?, Never>(nil)
    
    var result: AnyPublisher<Result<SearchPage<MemeSearchItem>, ServiceError>?, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private let respository: CategoryRepositoryInterface
    
    init(respository: CategoryRepositoryInterface) {
        self.respository = respository
    }
    
    func execute(id: Int, next: Int?, limit: Int?) {
        Task {
            do {
                let entity = try await respository.fetchCategoryMeme(id: id, next: next, limit: limit)
                subject.send(.success(entity))
            } catch let error as ServiceError {
                subject.send(.failure(error))
            } catch {
                subject.send(.failure(ServiceError.unknown(error)))
            }
        }
    }
}
