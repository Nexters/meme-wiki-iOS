//
//  SearchInfoView.swift
//  Meme
//
//  Created by 임현규 on 7/31/25.
//

import UIKit

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
    
    private let contentLabel: UILabel = {
        let label = UILabel()
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
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 22),
            imageView.heightAnchor.constraint(equalToConstant: 22),
            
            
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 6),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 24),
            
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
