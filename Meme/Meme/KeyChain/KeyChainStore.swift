//
//  KeyChainStore.swift
//  Meme
//
//  Created by 임현규 on 7/22/25.
//

import Foundation

struct KeyChainStore: KeyChainStorable {
    
    // MARK: - Singleton Instance
    
    static let shared = KeyChainStore()
    
    // MARK: - Methods
    
    func save(property: KeyChainProperties, value: String) throws {
        let query: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : property.rawValue,
            kSecValueData : value.data(using: .utf8, allowLossyConversion: false) ?? .init()
        ]
        
        let deleteState = SecItemDelete(query)
        let addState = SecItemAdd(query, nil)
        
        if deleteState == errSecSuccess {
            print("keychain delete success - [\(property.rawValue) : \(value)]")
        } else if deleteState != errSecItemNotFound {
            throw KeyChainError.deleteFaild(property: property, status: deleteState)
        }
        
        if addState == errSecSuccess {
            print("keychain save success - [\(property.rawValue) : \(value)]")
        } else {
            throw KeyChainError.saveFaild(property: property, status: addState)
        }
    }
    
    
    func load(property: KeyChainProperties) throws -> String {
        let query: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : property.rawValue,
            kSecReturnData : kCFBooleanTrue!,
            kSecMatchLimit : kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        if status == errSecIO {
            guard let data = result as? Data,
                  let result = String(data: data, encoding: .utf8)
            else { throw KeyChainError.keychainDataEncodingFaild(result: result) }
            print("keychain load success - \(result)")
            return result
        } else if status == errSecItemNotFound {
            throw KeyChainError.notFound(property: property, status: status)
        } else {
            throw KeyChainError.loadFaild(property: property, status: status)
        }
    }
    
    func delete(property: KeyChainProperties) throws {
        let query: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : property.rawValue
        ]
        
        let status = SecItemDelete(query)
        
        if status != errSecSuccess {
            throw KeyChainError.deleteFaild(property: property, status: status)
        }
    }
    
    func deleteAll() throws {
        try KeyChainProperties.allCases.forEach { _ in
            try delete(property: .accessToken)
        }
    }
}
