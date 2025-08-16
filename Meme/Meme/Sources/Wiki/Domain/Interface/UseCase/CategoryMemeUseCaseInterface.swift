//
//  CategoryMemeUseCaseInterface.swift
//  Meme
//
//  Created by 임현규 on 8/15/25.
//

import Combine

protocol CategoryMemeUseCaseInterface {
    var result: AnyPublisher<Result<SearchPage<MemeSearchItem>, ServiceError>?, Never> { get }
    func execute(id: Int, next: Int?, limit: Int?)
}
