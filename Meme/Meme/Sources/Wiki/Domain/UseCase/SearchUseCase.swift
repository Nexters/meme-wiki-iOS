//
//  SearchUseCase.swift
//  Meme
//
//  Created by 임현규 on 8/6/25.
//

import Combine

final class SearchUseCase: SearchUseCaseInterface {
    private let subject = CurrentValueSubject<Result<[MemeSearchItem], ServiceError>?, Never>(nil)
    
    var result: AnyPublisher<Result<[MemeSearchItem], ServiceError>?, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    private let repository: SearchRepositoryInterface
    
    init(repository: SearchRepositoryInterface) {
        self.repository = repository
    }
    
    func excute(title: String?, next: Int?, limit: Int) {
        Task {
            do {
                let response = try await repository.search(title: title, next: next, limit: limit)
                let item = response.success.toEntity()
                subject.send(.success(item))
            } catch let error as ServiceError {
                subject.send(.failure(error))
            } catch {
                subject.send(.failure(ServiceError.unknown(error)))
            }
        }
    }
}
