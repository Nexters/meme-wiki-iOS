//
//  CategoryRepository.swift
//  Meme
//
//  Created by 임현규 on 8/15/25.
//

import Foundation

final class CategoryRepository: CategoryRepositoryInterface {
    
    private var provider = Provider<CategoryAPI>()
    
    init(provider: Provider<CategoryAPI>) {
        self.provider = provider
    }
    
    init() {}
}

extension CategoryRepository {
    func fetchCategories() async throws -> [CategoryItem] {
        let response = try await provider.request(api: .categories, dto: [CategoryResponseDTO].self)
        return response.success.map { $0.toEntity() }
    }
    
    func fetchCategoryMeme(id: Int, next: Int?, limit: Int?) async throws -> SearchPage<MemeSearchItem> {
        let response = try await provider.request(api: .category(id: id, next: next, limit: limit), dto: SearchResponseDTO.self)
        return response.success.toEntity()
    }
}
