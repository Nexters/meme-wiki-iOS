//
//  Provider.swift
//  Meme
//
//  Created by 임현규 on 8/3/25.
//

import Foundation
import Moya

final class Provider<APIType: BaseTargetType>: Providable {
    private var moyaProvider: MoyaProvider<APIType>
    
    public init(moyaProvider: MoyaProvider<APIType>) {
        self.moyaProvider = moyaProvider
    }
    
    public init() {
        self.moyaProvider = MoyaProvider<APIType>.init(
            plugins: [MoyaLoggerPlugin()]
        )
    }
    
    func reqeust<E: Decodable>(api: APIType, dto: E.Type) async throws -> APIResponse<E> {
        return try await withCheckedThrowingContinuation { continuation in
            moyaProvider.request(api) { result in
                switch result {
                case let .success(response) where 200..<300 ~= response.statusCode:
                    do {
                        let response = try response.map(APIResponse<E>.self)
                        continuation.resume(returning: response)

                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .success(response) where 300... ~= response.statusCode:
                    continuation.resume(throwing: MoyaError.statusCode(response))
                case let .failure(error):
                    continuation.resume(throwing: error)
                default:
                    let error = NSError(domain: "Unkowned Error", code: 0)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
