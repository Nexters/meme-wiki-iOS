//
//  MemeMainCustomFooterView.swift
//  Meme
//
//  Created by 제나 on 8/6/25.
//

import UIKit

class MemeMainCustomFooterView: UICollectionReusableView {
    static let identifier = "MemeMainCustomFooterView"

    let pageControl = UIPageControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray8
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
