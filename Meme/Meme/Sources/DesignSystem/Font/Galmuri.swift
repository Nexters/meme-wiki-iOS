//
//  Galmuri.swift
//  Meme
//
//  Created by 임현규 on 8/1/25.
//

import Foundation

enum Galmuri: CustomFontConvertible {
    case headline
    case body(Body)
    
    enum Body {
        case body1
    }
    
    var name: String {
        switch self {
        case .headline, .body: return "Galmuri7"
        }
    }
    
    var size: CGFloat {
        switch self {
        case .headline: return 34
        case .body(let level):
            switch level {
            case .body1: return 14
            }
        }
    }
    
    var letterSpacing: CGFloat { return -0.6 }
    
    var lineHeight: CGFloat {
        switch self {
        case .headline:
            return 52
        case .body(let level):
            switch level {
            case .body1: return 18
            }
        }
    }
}
