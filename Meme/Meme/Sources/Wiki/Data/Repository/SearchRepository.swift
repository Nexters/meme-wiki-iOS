//
//  SearchRepository.swift
//  Meme
//
//  Created by 임현규 on 8/6/25.
//

import Foundation

final class SearchRepository: SearchReposioryInterface {
    private var provider = Provider<SearchAPI>()
    
    init(provider: Provider<SearchAPI>) {
        self.provider = provider
    }
    
    init() {}
}

extension SearchRepository {
    func search(title: String?, next: Int?, limit: Int) async throws -> APIResponse<SearchResponseDTO> {
        let response = try await provider.request(api: .searchMeme(title: title, next: next, limit: limit), dto: SearchResponseDTO.self)
        return response
    }
}
