//
//  BaseTargetType.swift
//  Meme
//
//  Created by 임현규 on 8/3/25.
//

import Foundation
import Moya

public protocol BaseTargetType: TargetType {}

public extension BaseTargetType {
  var baseURL: URL { ApiConfiguration.shared.hostUrl }
  
  var headers: [String : String]? {
    return ["Content-type": "application/json"]
  }
  
  var validationType: ValidationType {
    return .successCodes
  }
}
