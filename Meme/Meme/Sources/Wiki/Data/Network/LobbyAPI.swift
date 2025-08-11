//
//  LobbyAPI.swift
//  Meme
//
//  Created by 제나 on 7/19/25.
//

import Foundation
import Moya

enum LobbyAPI {
    case banner
    case categories
    case category(id: String, next: Int?, limit: Int = 20)
    case topRated
    case mostShared
}

extension LobbyAPI: BaseTargetType {
    
    var path: String {
        switch self {
        case .banner:
            return "/api/memes/rankings/custom"
        case .categories:
            return "/api/memes/categories"
        case .category(let id, _, _):
            return "/api/memes/categories/\(id)"
        case .topRated:
            return "/api/memes/rankings/top-rated"
        case .mostShared:
            return "/api/memes/rankings/shared"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case let .category(id, next, limit):
            var parameters: [String: Any] = [
                "id": id,
                "limit": limit
            ]
            if let next {
                parameters["next"] = next
            }
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
}
