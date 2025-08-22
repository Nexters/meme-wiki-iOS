//
//  TouchHandleView.swift
//  Meme
//
//  Created by 임현규 on 8/22/25.
//

import UIKit

final class TouchHandleView: UIView {
    var hitTestOutset: CGFloat = 50

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)

        let touchArea = bounds.insetBy(dx: -hitTestOutset, dy: -hitTestOutset)
        return touchArea.contains(point)
    }
}
