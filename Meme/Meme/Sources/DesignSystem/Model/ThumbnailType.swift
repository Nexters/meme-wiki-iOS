//
//  ThumbnailType.swift
//  Meme
//
//  Created by 임현규 on 7/31/25.
//

import Foundation

extension ThumbnailView {
    public enum ThumbnailType {
        case half
        case full
        
        var padding: CGFloat {
            switch self {
            case .half: return 8
            case .full: return 20
            }
        }
        
        var yearFont: CustomFont {
            return .pretendard(.body(.caption))
        }
        
        var titleFont: CustomFont {
            switch self {
            case .half: return .pretendard(.title(.headline2))
            case .full: return .pretendard(.title(.display1))
            }
        }
        
        var hastagFont: CustomFont {
            switch self {
            case .half: return .pretendard(.body(.caption))
            case .full: return .pretendard(.title(.subhead2))
            }
        }
    }
}
