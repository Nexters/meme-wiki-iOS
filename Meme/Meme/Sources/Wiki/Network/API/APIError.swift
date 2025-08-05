//
//  APIError.swift
//  Meme
//
//  Created by 임현규 on 8/3/25.
//

import Foundation

struct APIError: Decodable {
    let code: String
    let message: String
    let data: String
}
