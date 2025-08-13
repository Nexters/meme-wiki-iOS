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
    private var gradientLayer: CAGradientLayer?
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
        gradientLayer?.frame = gradientView.bounds
    }
    
    // MARK: - Public
    func configureCell(with item: Lobby.Item) {
        if let urlString = item.imageURL, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        }
        titleLabel.text = item.content
        let index = item.indexPath.item % gradientColors.count
        gradientLayer = makeDiagonalGradientLayer(gradientColors[index])
        gradientView.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    // MARK: - Private
    private func layoutCell() {
        gradientView = UIView()
        gradientView.layer.cornerRadius = 12
        gradientView.layer.masksToBounds = true
        
        imageView = UIImageView()
        imageView.image = UIImage(resource: .iconTemporaryCategory)
        
        titleLabel = UILabel()
        titleLabel.font = .customFont(.pretendard(.body(.body1)))
        titleLabel.textColor = .gray1
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        gradientView.addSubview(imageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(titleLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 44),
            imageView.widthAnchor.constraint(equalToConstant: 44),
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 74),
            titleLabel.topAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
