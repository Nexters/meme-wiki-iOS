//
//  Providable.swift
//  Meme
//
//  Created by 임현규 on 8/3/25.
//

import Foundation
import Moya

protocol Providable<APIType> {
    associatedtype APIType: BaseTargetType
    
    func reqeust<E: Decodable>(api: APIType, dto: E.Type) async throws -> APIResponse<E>
}
