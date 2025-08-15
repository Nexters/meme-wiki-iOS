//
//  MemeMainMostsharedHeaderView.swift
//  Meme
//
//  Created by 제나 on 8/6/25.
//

import UIKit

final class MemeMainMostsharedHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    static let identifier = "MemeMainMostsharedHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .customFont(
            .pretendard(.title(.display2)),
            text: "단톡방행 밈 셔틀,\n지금 탑승하세요 🚂",
            color: .white(.white)
        )
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .customFont(
            .pretendard(.title(.subhead1)),
            text: "지금 가장 많이 공유된 밈만 골라 실었어요",
            color: .gray(.gray4))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .customFont(
            .galmuri(.headline),
            text: "24 : 00 : 00",
            color: .white(.white))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            timerLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
            timerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
