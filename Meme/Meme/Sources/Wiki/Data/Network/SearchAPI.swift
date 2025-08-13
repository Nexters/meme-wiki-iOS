//
//  SearchAPI.swift
//  Meme
//
//  Created by 임현규 on 8/6/25.
//

import Moya

enum SearchAPI {
    case searchMeme(title: String?, next: Int?, limit: Int)
}

extension SearchAPI: BaseTargetType {
    var path: String {
        switch self {
        case .searchMeme:
            return "api/memes"
        }
    }

    var method: Moya.Method {
        switch self {
        case .searchMeme:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .searchMeme(let title, let next, let limit):
            return .requestParameters(
                parameters: [
                    "next": next ?? "",
                    "query": title ?? "",
                    "limit": limit
                ],
                encoding: URLEncoding.default
            )
        }
    }
}
