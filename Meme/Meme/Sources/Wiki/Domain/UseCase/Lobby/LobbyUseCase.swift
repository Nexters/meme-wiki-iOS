//
//  LobbyUseCase.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Combine

protocol LobbyUseCase {
    var result: CurrentValueSubject<Result<Lobby, ServiceError>?, Never> { get }
    func execute()
}

final class DefaultLobbyUseCase: LobbyUseCase {
    
    var result = CurrentValueSubject<Result<Lobby, ServiceError>?, Never>(nil)
    private var subscriptions = Set<AnyCancellable>()
    
    private let categoriesUseCase: CategoriesUseCase
    private let topRatedUseCase: TopRatedUseCase
    private let mostSharedUseCase: MostSharedUseCase
    
    init(
        categoriesUseCase: CategoriesUseCase,
        topRatedUseCase: TopRatedUseCase,
        mostSharedUseCase: MostSharedUseCase
    ) {
        self.categoriesUseCase = categoriesUseCase
        self.topRatedUseCase = topRatedUseCase
        self.mostSharedUseCase = mostSharedUseCase
    }
    
    func execute() {
        categoriesUseCase.execute()
        topRatedUseCase.execute()
        mostSharedUseCase.execute()
        bind()
    }
    
    private func bind() {
        Publishers.Zip3(
            categoriesUseCase.result,
            topRatedUseCase.result,
            mostSharedUseCase.result
        ).sink { [weak self] output in
            let categories = try? output.0?.get()
            let topRated = try? output.1?.get()
            let mostShared = try? output.2?.get()
            if categories == nil,
               topRated == nil,
               mostShared?.memes == nil {
                self?.result.send(.failure(
                    ServiceError.server(ErrorResponse.init(message: "모든 데이터를 불러오지 못했습니다."))))
                return
            }
            let lobby = Lobby(
                categories: categories ?? [],
                topRatedMemes: topRated ?? [],
                mostSharedItem: mostShared ?? Lobby.MostSharedItem.getDummy())
            self?.result.send(.success(lobby))
        }.store(in: &subscriptions)
    }
}
