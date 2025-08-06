//
//  MemeSearchViewModel.swift
//  Meme
//
//  Created by 임현규 on 8/6/25.
//

import Foundation
import Combine

final class MemeSearchViewModel {
    
    // MARK: - Properties
    
    private var subscriptions = Set<AnyCancellable>()
    private var searchState: SearchState = SearchState(title: nil, next: nil, limit: 20)
    
    // MARK: - Subject
    private let searchItemSubject = CurrentValueSubject<[MemeSearchItem], Never>([])
    private let searchResultSubject = CurrentValueSubject<[MemeSearchItem], Never>([])
    private let emptySubject = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Publisher
    var searchItemPublisher: AnyPublisher<[MemeSearchItem], Never> {
        return searchItemSubject.eraseToAnyPublisher()
    }
    
    var searchResultPublisher: AnyPublisher<[MemeSearchItem], Never> {
        return searchResultSubject.eraseToAnyPublisher()
    }
    
    var emptyPublisher: AnyPublisher<Bool, Never> {
        return emptySubject.eraseToAnyPublisher()
    }
    
    // MARK: - UseCase
    
    private let searchUseCase: SearchUseCaseInterface
    
    init(searchUseCase: SearchUseCaseInterface) {
        self.searchUseCase = searchUseCase
    }
    
    func viewDidLoad() {
        searchUseCase.excute(title: searchState.title, next: searchState.next, limit: searchState.limit)
        
        searchUseCase.result
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let items):
                    if items.isEmpty {
                        self.emptySubject.send(true)
                    } else if searchState.title == nil {
                        self.searchItemSubject.send(items)
                    } else {
                        self.searchResultSubject.send(items)
                    }
                case .failure(let failure):
                    Log.error(failure.localizedDescription, .networking)
                case nil:
                    break
                }
            }.store(in: &subscriptions)
    }
    
    func textFieldDidChanged(_ input: String) {
        searchState.setTitle(input.isEmpty ? nil : input)
        searchUseCase.excute(title: searchState.title, next: searchState.next, limit: searchState.limit)
    }
}

extension MemeSearchViewModel {
    struct SearchState {
        var title: String? = ""
        var next: Int? = nil
        var limit: Int
        
        mutating func nextPage() {
            self.next = (self.next ?? 0) + 1
        }
        
        mutating func setTitle(_ title: String?) {
            self.title = title
        }
    }
}
