//
//  SearchReposioryInterface.swift
//  Meme
//
//  Created by 임현규 on 8/6/25.
//

import Foundation

protocol SearchRepositoryInterface {
    func search(title: String?, next: Int?, limit: Int) async throws -> APIResponse<SearchResponseDTO>
}
