//
//  NotificationUseCase.swift
//  Meme
//
//  Created by ZENA on 9/28/25.
//

import Combine

protocol NotificationUseCase {
    func execute(token: String)
}


final class DefaultNotificationUseCase: NotificationUseCase {
    
    var result = CurrentValueSubject<Result<Void, ServiceError>?, Never>(nil)
    
    private var task: Task<Void, Never>?
    private let repository: NotificationRepositoryInterface
    
    init(repository: NotificationRepositoryInterface) {
        self.repository = repository
    }
    
    deinit {
        task?.cancel()
    }
    
    func execute(token: String) {
        task?.cancel()
        task = Task {
            do {
                _ = try await repository.register(token: token)
                result.send(.success(()))
            } catch let error as ServiceError {
                result.send(.failure(error))
            } catch {
                result.send(.failure(.unknown(error)))
            }
        }
    }
}
