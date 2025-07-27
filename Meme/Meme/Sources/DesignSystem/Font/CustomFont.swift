//
//  CustomFont.swift
//  Meme
//
//  Created by 임현규 on 7/26/25.
//

import UIKit

enum CustomFont {
    case pretendard(Pretendard)

    fileprivate var base: CustomFontConvertible {
        switch self {
        case .pretendard(let font): return font
        }
    }
    
    var name: String { base.name }
    var size: CGFloat { base.size }
    var letterSpacing: CGFloat { base.letterSpacing }
    var lineHeight: CGFloat { base.lineHeight }
}
