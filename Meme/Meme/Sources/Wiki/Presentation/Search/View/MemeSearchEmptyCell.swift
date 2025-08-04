//
//  MemeSearchEmptyCell.swift
//  Meme
//
//  Created by 임현규 on 8/4/25.
//

import UIKit

final class MemeSearchEmptyCell: UICollectionViewCell {
    
    static let identifier = "MemeSearchListCell"
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let content: UILabel = {
        let label = UILabel()
        label.attributedText = .customFont(.pretendard(.body(.body1)), text: "검색 결과가 없습니다.\n다시입력해주세요")
        label.textAlignment = .center
        label.textColor = CustomColor.gray(.gray5).color
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
}

// MARK: - Private Methods

private extension MemeSearchEmptyCell {
    func configureUI() {
        [ imageView, content ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 128),
            imageView.heightAnchor.constraint(equalToConstant: 128),
            
            content.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            content.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

