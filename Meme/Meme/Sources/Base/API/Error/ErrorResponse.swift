//
//  ErrorResponse.swift
//  Meme
//
//  Created by 제나 on 7/19/25.
//

import Foundation

enum ServiceError: Error {
    case server(ErrorResponse)
    case unknown(Error)
}

struct ErrorResponse: Decodable {
    let message: String
}
