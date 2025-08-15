//
//  MemeMainCategoryHeaderView.swift
//  Meme
//
//  Created by 제나 on 8/6/25.
//

import UIKit

class MemeMainCategoryHeaderView: UICollectionReusableView {
    static let identifier = "MemeMainCategoryHeaderView"
    
    private let spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .customFont(
            .pretendard(.title(.display1)),
            text: "뭘 좋아하는지 몰라서\n그냥 다 준비했어 👀",
            color: .white(.white))
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(spacer)
        
        NSLayoutConstraint.activate([
            spacer.topAnchor.constraint(equalTo: topAnchor),
            spacer.leadingAnchor.constraint(equalTo: leadingAnchor),
            spacer.trailingAnchor.constraint(equalTo: trailingAnchor),
            spacer.heightAnchor.constraint(equalToConstant: 60),
            titleLabel.topAnchor.constraint(equalTo: spacer.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
