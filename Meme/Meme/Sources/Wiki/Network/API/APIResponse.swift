//
//  APIResponse.swift
//  Meme
//
//  Created by 임현규 on 8/3/25.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let resultType: String
    let success: T
    let error: APIError?
}
