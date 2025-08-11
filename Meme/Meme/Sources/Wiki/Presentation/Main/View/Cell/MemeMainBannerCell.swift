//
//  MemeMainBannerCell.swift
//  Meme
//
//  Created by 제나 on 8/5/25.
//

import UIKit

final class MemeMainBannerCell: UICollectionViewCell {
    static let identifier = "MemeMainBannerCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for sub in contentView.subviews {
            sub.removeFromSuperview()
        }
    }
    
    func configureCell(with item: Lobby.Item) {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        let imageview = UIImageView()
        imageview.image = UIImage(named: "banner_custom_\(item.indexPath.item + 1)")
        imageview.contentMode = .scaleAspectFill
        contentView.addSubview(imageview)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageview.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
