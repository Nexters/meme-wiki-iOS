//
//  Pretendard.swift
//  Meme
//
//  Created by 임현규 on 7/26/25.
//

import Foundation

enum Pretendard: CustomFontConvertible {
    case title(Title)
    case body(Body)

    enum Title {
        case display5, display4, display3, display2, display1
        case headline1, headline2
        case subhead1, subhead2
        case subheadLong1, subheadLong2
    }

    enum Body {
        case body2, bodyLong2, body1, bodyLong1, caption
    }

    var name: String {
        switch self {
        case .title(let level):
            switch level {
            case .display5, .display4, .display3, .display2, .display1,
                 .headline1, .headline2, .subheadLong1:
                return "Pretendard-Bold"
            case .subhead1, .subhead2, .subheadLong2:
                return "Pretendard-SemiBold"
            }
        case .body:
            return "Pretendard-Regular"
        }
    }

    var size: CGFloat {
        switch self {
        case .title(let level):
            switch level {
            case .display5: return 40
            case .display4: return 36
            case .display3: return 32
            case .display2: return 28
            case .display1: return 24
            case .headline1: return 20
            case .headline2: return 18
            case .subhead1: return 16
            case .subheadLong1: return 16
            case .subhead2: return 14
            case .subheadLong2: return 14
            }
        case .body(let level):
            switch level {
            case .body2, .bodyLong2: return 16
            case .body1, .bodyLong1: return 14
            case .caption: return 12
            }
        }
    }

    var letterSpacing: CGFloat { return -0.6 }

    var lineHeight: CGFloat {
        switch self {
        case .title(let level):
            switch level {
            case .display5: return 52
            case .display4: return 46
            case .display3: return 42
            case .display2: return 38
            case .display1: return 34
            case .headline1: return 28
            case .headline2: return 24
            case .subhead1: return 22
            case .subheadLong1: return 28
            case .subhead2: return 20
            case .subheadLong2: return 24
            }
        case .body(let level):
            switch level {
            case .body2: return 24
            case .bodyLong2: return 28
            case .body1: return 20
            case .bodyLong1: return 24
            case .caption: return 18
            }
        }
    }
}
