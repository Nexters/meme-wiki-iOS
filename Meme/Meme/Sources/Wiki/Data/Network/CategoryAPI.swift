//
//  CategoryAPI.swift
//  Meme
//
//  Created by 임현규 on 8/15/25.
//

import Moya

enum CategoryAPI {
    case categories
    case category(id: Int, next: Int?, limit: Int?)

}

extension CategoryAPI: BaseTargetType {
    var path: String {
        switch self {
        case .categories:
            return "/api/memes/categories"
        case .category(let id, _, _):
            return "/api/memes/categories/\(id)"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case let .category(id, next, limit):
            return .requestParameters(
                parameters: [
                    "next": next ?? "",
                    "id": id,
                    "limit": limit ?? 20
                ],
                encoding: URLEncoding.default
            )
        case .categories:
            return .requestPlain
        }
    }
}
