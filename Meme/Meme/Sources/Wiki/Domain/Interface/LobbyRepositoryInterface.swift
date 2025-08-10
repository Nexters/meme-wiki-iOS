//
//  LobbyRepositoryInterface.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Foundation

protocol LobbyRepositoryInterface {
    func fetchBanners() async throws -> APIResponse<[BannerResponseDTO]>
    func fetchCategories() async throws -> APIResponse<[CategoryResponseDTO]>
    func fetchTopRatedMemes() async throws -> APIResponse<[TopRatedRatedReponseDTO]>
    func fetchMostSharedMemes() async throws -> APIResponse<[MostSharedResponseDTO]>
}
