//
//  KeyChainError.swift
//  Meme
//
//  Created by 임현규 on 7/22/25.
//

import Foundation

enum KeyChainError: Error {
    case notFound(property: KeyChainProperties, status: OSStatus)
    case saveFaild(property: KeyChainProperties, status: OSStatus)
    case loadFaild(property: KeyChainProperties, status: OSStatus)
    case deleteFaild(property: KeyChainProperties, status: OSStatus)
    
    case keychainDataEncodingFaild(result: AnyObject?)
}
