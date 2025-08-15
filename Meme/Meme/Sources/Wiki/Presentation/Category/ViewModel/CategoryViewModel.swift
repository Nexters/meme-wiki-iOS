//
//  CategoryViewModel.swift
//  Meme
//
//  Created by 임현규 on 8/15/25.
//

import Foundation
import Combine

final class CategoryViewModel {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var searchState: SearchState = .init(id: 1, page: .init(next: nil, hasMore: nil, pageSize: 20))
    private var isLoading: Bool = true
    private var isAppend: Bool = false
    
    // MARK: - Subject
    private let categoriesSubject = PassthroughSubject<[CategoryItem], Never>()
    private let searchCategoryMemeSubject = CurrentValueSubject<[MemeSearchItem]?, Never>(nil)
    private let selectedCategorySubject = PassthroughSubject<CategoryItem, Never>()
    
    // MARK: - Publisher
    
    var searchCategoryMemePublisher: AnyPublisher<[MemeSearchItem]?, Never> {
        searchCategoryMemeSubject.eraseToAnyPublisher()
    }
    var categoriesPublisher: AnyPublisher<[CategoryItem], Never> {
        categoriesSubject.eraseToAnyPublisher()
    }
    
    var selectedCategoryPublisher: AnyPublisher<CategoryItem, Never> {
        selectedCategorySubject.eraseToAnyPublisher()
    }
    
    // MARK: - UseCase
    private let categoriesUseCase: CategoriesUseCase
    private let categoryUseCase: CategoryMemeUseCaseInterface
    
    // MARK: - init
    
    init(categoriesUseCase: CategoriesUseCase, categoryUseCase: CategoryMemeUseCaseInterface) {
        self.categoriesUseCase = categoriesUseCase
        self.categoryUseCase = categoryUseCase
        bind()
    }
    
    // MARK: - input
    
    func fetchCategories() {
        categoriesUseCase.execute()
        isLoading = true
    }
    
    func fetchCategoryMeme(_ category: CategoryItem) {
        searchState.setId(category.id)
        selectedCategorySubject.send(category)
        requestMemeItems(searchState: searchState, isAppend: false)
    }
    
    func fetchNextPage() {
        guard let hasMore = searchState.page.hasMore, hasMore, !isLoading else { return }
        isLoading = true
        requestMemeItems(searchState: searchState, isAppend: true)
    }
}

// MARK: - bind

private extension CategoryViewModel {
    func bind() {
        categoryUseCase.result
            .compactMap { $0 }
            .sink { [weak self] result in
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let page):
                    self.searchState.update(page.pageState)
                    if self.isAppend {
                        guard let beforeData = self.searchCategoryMemeSubject.value else {
                            self.searchCategoryMemeSubject.send(page.items)
                            return
                        }
                        let merged = beforeData + page.items
                        self.searchCategoryMemeSubject.send(merged)
                        
                    } else {
                        self.searchCategoryMemeSubject.send(page.items)
                    }
                case .failure(let failure):
                    Log.error(failure.localizedDescription, .networking)
                }
            }.store(in: &cancellables)
        
        categoriesUseCase.result
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isLoading = false

                switch result {
                case .success(let categories):
                    self.categoriesSubject.send(categories)
                case .failure(let failure):
                    Log.error(failure.localizedDescription, .networking)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Methods

private extension CategoryViewModel {
    func requestMemeItems(searchState: SearchState, isAppend: Bool) {
        self.isAppend = isAppend
        categoryUseCase.execute(id: searchState.id, next: searchState.page.next, limit: searchState.page.pageSize)
    }
}

// MARK: - SearchState

extension CategoryViewModel {
    struct SearchState {
        var id: Int
        var page: PageState
        
        mutating func update(_ page: PageState) {
            self.page = page
        }
        
        mutating func setId(_ id: Int) {
            self.id = id
            self.page = .init(next: nil, hasMore: nil, pageSize: 20)
        }
    }
}

