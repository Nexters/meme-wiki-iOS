//
//  NSAttributedString++Extension.swift
//  Meme
//
//  Created by 임현규 on 7/27/25.
//

import UIKit

extension NSAttributedString {
    static func customFont(_ font: CustomFont, text: String) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = font.lineHeight
        paragraph.maximumLineHeight = font.lineHeight

        return NSAttributedString(string: text, attributes: [
            .font: UIFont(name: font.name, size: font.size)!,
            .kern: font.letterSpacing,
            .paragraphStyle: paragraph
        ])
    }
}
