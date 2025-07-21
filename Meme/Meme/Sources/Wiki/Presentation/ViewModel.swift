//
//  ViewModel.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Combine

// FIXME: - 파일없으면 깃에서 안보여서 있는 임시 파일

final class MainViewModel {
    private let lobbyUseCase: LobbyUseCase
    private var subscriptions = Set<AnyCancellable>()
    
    init(lobbyUseCase: LobbyUseCase) {
        self.lobbyUseCase = lobbyUseCase
    }
}
extension MainViewModel {
    private func fetch() {
        lobbyUseCase.result
            .sink { result in
                switch result {
                case .success(let value):
                    let sections = value
                case .failure(let error):
                    let erorr = error
                case nil:
                    break
                }
            }
            .store(in: &subscriptions)
    }
}
