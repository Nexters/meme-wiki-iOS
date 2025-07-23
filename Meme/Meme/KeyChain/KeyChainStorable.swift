//
//  KeyChainStorable.swift
//  Meme
//
//  Created by 임현규 on 7/22/25.
//

protocol KeyChainStorable {
    func save(property: KeyChainProperties, value: String) throws
    func load(property: KeyChainProperties) throws -> String
    func delete(property: KeyChainProperties) throws
    func deleteAll() throws
}
