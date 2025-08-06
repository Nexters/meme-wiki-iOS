//
//  MemeSearchViewModel.swift
//  Meme
//
//  Created by 임현규 on 8/6/25.
//

import Foundation
import Combine

final class MemeSearchViewModel {
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Subject
    private let searchItemSubject = CurrentValueSubject<[MemeSearchItem], Never>([])
    
    // MARK: - Publisher
    var searchItemPublisher: AnyPublisher<[MemeSearchItem], Never> {
        return searchItemSubject.eraseToAnyPublisher()
    }
    // MARK: - UseCase
    
    private let searchUseCase: SearchUseCaseInterface
    
    init(searchUseCase: SearchUseCaseInterface) {
        self.searchUseCase = searchUseCase
    }
    
    func viewDidLoad() {
        let title: String? = nil
        let next: Int? = nil
        let limit: Int = 20
        
        searchUseCase.excute(title: title, next: next, limit: limit)
        
        searchUseCase.result
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let items):
                    self.searchItemSubject.send(items)
                case .failure(let failure):
                    Log.error(failure.localizedDescription, .networking)
                case nil:
                    break
                }
            }.store(in: &subscriptions)
    }
    
    func textFieldDidChanged(_ input: String) {
        let title = input
        
    }
}
