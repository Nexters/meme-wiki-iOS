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
    private var searchState: SearchState = SearchState(title: nil, page: .init(next: nil, hasMore: nil, pageSize: nil))
    private var isLoading: Bool = true
    
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
    
    func fetchMeme() {
        isLoading = true

        searchUseCase.execute(title: searchState.title, next: searchState.page.next, limit: searchState.page.pageSize ?? 16)
        
        searchUseCase.result
            .sink { [weak self] result in
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let page):
                    self.searchState.update(page.pageState)

                    if page.items.isEmpty {
                        self.emptySubject.send(true)
                    } else if searchState.title == nil {
                        self.searchItemSubject.send(page.items)
                    } else {
                        self.searchResultSubject.send(page.items)
                    }
                case .failure(let failure):
                    Log.error(failure.localizedDescription, .networking)
                case nil:
                    break
                }
            }.store(in: &subscriptions)
    }
    
    func searchMeme(_ input: String) {
        isLoading = true
        searchState.setTitle(input.isEmpty ? nil : input)
        searchUseCase.execute(title: searchState.title, next: searchState.page.next, limit: searchState.page.pageSize ?? 16)
    }
    
    func fetchNextPage() {
        guard let hasMore = searchState.page.hasMore, hasMore, !isLoading else { return }
        isLoading = true
        searchUseCase.execute(title: searchState.title, next: searchState.page.next, limit: searchState.page.pageSize ?? 16)
    }
}

extension MemeSearchViewModel {
    struct SearchState {
        var title: String? = ""
        var page: PageState
        
        mutating func update(_ page: PageState) {
            self.page = page
        }
        
        mutating func setTitle(_ title: String?) {
            self.title = title
            self.page = .init(next: nil, hasMore: nil, pageSize: nil)
        }
    }
}
