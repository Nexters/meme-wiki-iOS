//
//  Namespace.swift
//  Meme
//
//  Created by 제나 on 7/20/25.
//

import Foundation

enum Wiki {
    protocol Namespace {
        typealias API = Wiki.API
        typealias Repository = Wiki.Repository
        typealias DTO = Wiki.DTO
        typealias Entity = Wiki.Entity
        typealias UseUserCase = Wiki.UseCase
        
        typealias ViewModel = Wiki.ViewModel
    }
    
    enum API: Namespace { }
    enum Repository: Namespace { }
    enum DTO: Namespace { }
    enum Entity: Namespace { }
    enum UseCase: Namespace { }
    
    enum ViewModel: Namespace { }
}
