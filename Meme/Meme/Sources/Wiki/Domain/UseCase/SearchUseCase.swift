//
//  SearchUseCase.swift
//  Meme
//
//  Created by 임현규 on 8/6/25.
//

import Combine

final class SearchUseCase: SearchUseCaseInterface {
    private let subject = CurrentValueSubject<Result<SearchPage<MemeSearchItem>, ServiceError>?, Never>(nil)
    
    var result: AnyPublisher<Result<SearchPage<MemeSearchItem>, ServiceError>?, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private let repository: SearchRepositoryInterface
    
    init(repository: SearchRepositoryInterface) {
        self.repository = repository
    }
    
    func execute(title: String?, next: Int?, limit: Int) {
        Task {
            do {
                let response = try await repository.search(title: title, next: next, limit: limit)
                let page = response.success.toEntity()
                subject.send(.success(page))
            } catch let error as ServiceError {
                subject.send(.failure(error))
            } catch {
                subject.send(.failure(ServiceError.unknown(error)))
            }
        }
    }
}
