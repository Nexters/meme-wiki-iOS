//
//  MemeMainTopRatedDecorationView.swift
//  Meme
//
//  Created by 제나 on 8/6/25.
//

import UIKit

final class MemeMainTopRatedDecorationView: UICollectionReusableView {
    static let elementKind = "MemeMainTopRatedDecorationView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
    }
    required init?(coder: NSCoder) { fatalError() }
}
