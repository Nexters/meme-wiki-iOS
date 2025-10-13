//
//  NotificationAPI.swift
//  Meme
//
//  Created by ZENA on 9/28/25.
//

import Foundation
import Moya

enum NotificationAPI {
    case register(token: String)
}

extension NotificationAPI: BaseTargetType {
    
    var path: String {
        switch self {
        case .register:
            return "/api/notifications/register"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case let .register(token):
            let parameters: [String: Any] = [
                "token": token
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default)
        }
    }
}
