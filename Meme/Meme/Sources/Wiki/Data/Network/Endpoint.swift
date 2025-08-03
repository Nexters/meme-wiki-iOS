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

extension LobbyAPI: BaseTargetType {
    
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
}
