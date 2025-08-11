//
//  MemeMainCategoryCell.swift
//  Meme
//
//  Created by 제나 on 8/5/25.
//

import UIKit

final class MemeMainCategoryCell: UICollectionViewCell {
    static let identifier = "MemeMainCategoryCell"
    private let fixedColor = [UIColor.blue80, .purple80, .yellow80, .red80]
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for sub in contentView.subviews {
            sub.removeFromSuperview()
        }
    }
    
    func configureCell(with item: Lobby.Item) {
        let gradientView = UIView()
        gradientView.backgroundColor = fixedColor[item.indexPath.item % fixedColor.count]
        gradientView.layer.cornerRadius = 12
        gradientView.layer.masksToBounds = true
        
        let imageview = UIImageView()
        imageview.image = UIImage(resource: .iconTemporaryCategory)
        if let urlString = item.imageURL, let url = URL(string: urlString) {
            imageview.kf.setImage(with: url)
        }
        
        let label = UILabel()
        label.font = .customFont(.pretendard(.body(.body1)))
        label.textColor = .gray1
        label.textAlignment = .center
        label.text = item.content
        label.numberOfLines = 2
        
        gradientView.addSubview(imageview)
        contentView.addSubview(gradientView)
        contentView.addSubview(label)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageview.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
            imageview.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor),
            imageview.heightAnchor.constraint(equalToConstant: 44),
            imageview.widthAnchor.constraint(equalToConstant: 44),
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 74),
            label.topAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
