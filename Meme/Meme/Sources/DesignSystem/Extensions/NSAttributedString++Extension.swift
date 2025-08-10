//
//  NSAttributedString++Extension.swift
//  Meme
//
//  Created by 임현규 on 7/27/25.
//

import UIKit

extension NSAttributedString {
    static func customFont(_ font: CustomFont, text: String, color: CustomColor? = nil) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = font.lineHeight
        paragraph.maximumLineHeight = font.lineHeight
        paragraph.lineBreakMode = .byTruncatingTail
        let customFont = UIFont(name: font.name, size: font.size)!
        
        return NSAttributedString(string: text, attributes: [
            .font: customFont,
            .kern: font.letterSpacing,
            .paragraphStyle: paragraph,
            .baselineOffset: (font.lineHeight - customFont.lineHeight) / 2,
            .foregroundColor: color?.color ?? UIColor.label
        ])
    }
}
