//
//  CustomFontConvertible.swift
//  Meme
//
//  Created by 임현규 on 7/27/25.
//

import Foundation

protocol CustomFontConvertible {
    var name: String { get }
    var size: CGFloat { get }
    var letterSpacing: CGFloat { get }
    var lineHeight: CGFloat { get }
}
