//
//  MemeMainCategoryCell.swift
//  Meme
//
//  Created by 제나 on 8/5/25.
//

import UIKit

final class MemeMainCategoryCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "MemeMainCategoryCell"
    
    private var gradientView: UIView!
    private var gradientLayer = CAGradientLayer()
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    
    private let gradientColors: [[UIColor]] = [
        [.lightBlue95, .lightBlue80],
        [.violet95, .violet80],
        [.red95, .red80],
        [.yellow95, .yellow80]
    ]
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layoutCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.frame = contentView.bounds
        gradientLayer.frame = gradientView.bounds
    }
    
    // MARK: - Public
    func configureCell(with item: Lobby.Item) {
        if let urlString = item.imageURL, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        }
        titleLabel.attributedText = .customFont(
            .pretendard(.body(.body1)),
            text: item.content,
            color: .gray(.gray1)
        )
        let index = item.indexPath.item % gradientColors.count
        gradientLayer.makeDiagonalGradient(gradientColors[index])
    }
    
    // MARK: - Private
    private func layoutCell() {
        gradientView = UIView()
        gradientView.layer.cornerRadius = 12
        gradientView.layer.masksToBounds = true
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        imageView = UIImageView()
        imageView.image = UIImage(resource: .iconTemporaryCategory)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        gradientView.addSubview(imageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(titleLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 74),
            imageView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: gradientView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
