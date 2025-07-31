//
//  UIView++Extension.swift
//  Meme
//
//  Created by 임현규 on 7/31/25.
//

import UIKit

extension UIView {
    func makeGradientLayer(_ color: UIColor) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            color.withAlphaComponent(0.0).cgColor,
            color.withAlphaComponent(0.0).cgColor,
            color.withAlphaComponent(0.2).cgColor,
            color.withAlphaComponent(0.5).cgColor
        ]
        
        gradientLayer.locations = [0.0, 0.4, 0.7, 1.0].map(NSNumber.init)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return gradientLayer
    }
}

