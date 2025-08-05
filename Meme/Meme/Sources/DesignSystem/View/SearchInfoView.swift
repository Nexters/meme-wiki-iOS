//
//  SearchInfoView.swift
//  Meme
//
//  Created by 임현규 on 7/31/25.
//

import UIKit
import MarqueeLabel

final class SearchInfoView: UIView {
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = CustomColor.gray(.gray5).color
        return imageView
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray(.gray1).color
        return label
    }()
    
    private let contentLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.speed = .rate(50)
        label.textColor = CustomColor.gray(.gray4).color
        return label
    }()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        backgroundColor = CustomColor.gray(.gray8).color
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func updateUI(_ title: String, _ content: String) {
        titleLabel.attributedText = .customFont(.pretendard(.title(.subhead2)), text: title)
        contentLabel.attributedText = .customFont(.pretendard(.body(.body1)), text: content)
    }
}

// MARK: - Private Methods

private extension SearchInfoView {
    func configureUI() {
        [ imageView, titleLabel, contentLabel ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.imageView.leading),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageView.width),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageView.height),
            
            
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.titleLabel.leading),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: Constants.titleLabel.width),
            
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Constants.contentLabel.leading),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.contentLabel.trailing),
            contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - Constants

private extension SearchInfoView {
    enum Constants {
        enum imageView {
            static let leading: CGFloat = 10
            static let width: CGFloat = 22
            static let height: CGFloat = 22
        }
        
        enum titleLabel {
            static let leading: CGFloat = 6
            static let width: CGFloat = 24
        }
        
        enum contentLabel {
            static let leading: CGFloat = 10
            static let trailing: CGFloat = -8
        }
    }
}
