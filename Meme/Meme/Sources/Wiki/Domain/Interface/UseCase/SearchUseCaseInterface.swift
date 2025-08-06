//
//  SearchUseCaseInterface.swift
//  Meme
//
//  Created by 임현규 on 8/6/25.
//

import Combine

protocol SearchUseCaseInterface {
    var result: AnyPublisher<Result<[MemeSearchItem], ServiceError>?, Never> { get }
    func excute(title: String?, next: Int?, limit: Int)
}
