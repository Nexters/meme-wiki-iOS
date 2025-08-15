//
//  MemeMainTopRatedHeaderView.swift
//  Meme
//
//  Created by 제나 on 8/6/25.
//

import UIKit

final class MemeMainTopRatedHeaderView: UICollectionReusableView {
    static let identifier = "MemeMainTopRatedHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .customFont(
            .pretendard(.title(.display1)),
            text: "🔥인급밈🔥",
            color: .black(.black))
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .customFont(
            .pretendard(.title(.subhead2)),
            text: "지금 가장 따끈따근한 밈만 골랐어요",
            color: .gray(.gray7)
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
