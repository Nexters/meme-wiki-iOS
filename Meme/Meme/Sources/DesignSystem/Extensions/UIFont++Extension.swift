//
//  UIFont++Extension.swift
//  Meme
//
//  Created by 임현규 on 7/27/25.
//

import UIKit

extension UIFont {
    static func customFont(_ font: CustomFont) -> UIFont {
        return UIFont(name: font.name, size: font.size) ?? .systemFont(ofSize: font.size)
    }
}

