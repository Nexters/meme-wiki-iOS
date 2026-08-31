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

        let attributedText = NSMutableAttributedString(string: text, attributes: [
            .font: customFont,
            .kern: font.letterSpacing,
            .paragraphStyle: paragraph,
            .baselineOffset: (font.lineHeight - customFont.lineHeight) / 2,
            .foregroundColor: color?.color ?? UIColor.label
        ])
        applyEmojiFont(to: attributedText, size: font.size)

        return attributedText
    }

    /// Pretendard와 Galmuri에는 이모지 글리프가 없다. 문자열 전체에 그 폰트를 지정하면
    /// 이모지 자리가 빈 네모로 그려지므로, 이모지 구간만 시스템 이모지 폰트로 덮어쓴다.
    private static func applyEmojiFont(to attributedText: NSMutableAttributedString, size: CGFloat) {
        guard let emojiFont = UIFont(name: "AppleColorEmoji", size: size) else { return }

        var location = 0
        for character in attributedText.string {
            let length = String(character).utf16.count
            if character.isEmoji {
                attributedText.addAttribute(
                    .font,
                    value: emojiFont,
                    range: NSRange(location: location, length: length)
                )
            }
            location += length
        }
    }
}

private extension Character {
    /// 이모지로 그려야 하는 문자인지 판단한다.
    ///
    /// 숫자 0~9처럼 이모지가 아닌 문자도 `isEmoji`가 true이므로,
    /// 기본 표시가 이모지이거나 변이 선택자가 붙은 경우만 인정한다.
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmojiPresentation
            || (scalar.properties.isEmoji && unicodeScalars.count > 1)
    }
}
