//
//  CategoryRepositoryInterface.swift
//  Meme
//
//  Created by 임현규 on 8/15/25.
//

import Foundation

protocol CategoryRepositoryInterface {
    func fetchCategories() async throws -> [CategoryItem]
    func fetchCategoryMeme(id: Int, next: Int?, limit: Int?) async throws -> SearchPage<MemeSearchItem>
}
