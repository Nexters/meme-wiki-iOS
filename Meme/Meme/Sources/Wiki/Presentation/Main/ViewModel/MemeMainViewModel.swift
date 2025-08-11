//
//  MemeMainViewModel.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Combine

final class MemeMainViewModel {
    private let lobbyUseCase: LobbyUseCase
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var lobby: Lobby?
    
    init(lobbyUseCase: LobbyUseCase) {
        self.lobbyUseCase = lobbyUseCase
        bind()
    }
    
    private func bind() {
        lobbyUseCase.result
            .sink { [weak self] result in
                switch result {
                case .success(let value):
                    self?.lobby = value
                case .failure(let error):
                    let erorr = error
                case nil:
                    break
                }
            }
            .store(in: &subscriptions)
    }
}
extension MemeMainViewModel {
    func fetch() {
        lobbyUseCase.execute()
    }
}
