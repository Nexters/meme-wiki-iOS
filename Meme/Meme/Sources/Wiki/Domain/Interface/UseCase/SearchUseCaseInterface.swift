//
//  SearchUseCaseInterface.swift
//  Meme
//
//  Created by 임현규 on 8/6/25.
//

import Combine

protocol SearchUseCaseInterface {
    var result: AnyPublisher<Result<SearchPage<MemeSearchItem>, ServiceError>?, Never> { get }
    func execute(title: String?, next: Int?, limit: Int)
}
