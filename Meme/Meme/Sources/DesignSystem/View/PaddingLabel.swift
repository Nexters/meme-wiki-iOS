//
//  PaddingLabel.swift
//  Meme
//
//  Created by 임현규 on 7/28/25.
//

import UIKit

final class PaddingLabel: UILabel {
    
    // MARK: - Properties
    
    private var insets: UIEdgeInsets
    
    // MARK: - init
    
    public init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        let width = originalSize.width + insets.left + insets.right
        let height = originalSize.height + insets.top + insets.bottom
        return CGSize(width: width, height: height)
    }
}
