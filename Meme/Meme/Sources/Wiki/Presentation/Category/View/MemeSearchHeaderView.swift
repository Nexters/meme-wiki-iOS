//
//  MemeSearchHeaderView.swift
//  Meme
//
//  Created by 임현규 on 8/11/25.
//

import UIKit

final class MemeSearchHeaderView: UICollectionReusableView {
    
    static let identifier = "MemeSearchHeaderView"
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func updateUI(_ title: String) {
        // TODO: - change to white
        titleLabel.attributedText = .customFont(.pretendard(.title(.headline1)), text: title, color: .gray(.gray1))
    }
}

// MARK: - Private Methods

private extension MemeSearchHeaderView {
    func configureUI() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
    


