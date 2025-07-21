//
//  WikiAPI.swift
//  Meme
//
//  Created by 제나 on 7/19/25.
//

import Foundation
import Moya

enum LobbyAPI {
    case sample(id: String) // TODO: - remove this line
}

extension LobbyAPI: TargetType {
    var baseURL: URL { ApiConfiguration.shared.hostUrl }
    
    var path: String {
        switch self {
        case .sample(let id): // TODO: - remove this line
            return "/sample/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sample: // TODO: - remove this line
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
}
