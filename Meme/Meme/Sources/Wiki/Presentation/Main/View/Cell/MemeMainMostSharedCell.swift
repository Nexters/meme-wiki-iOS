//
//  MemeMainMostSharedCell.swift
//  Meme
//
//  Created by 제나 on 8/5/25.
//

import UIKit

final class MemeMainMostSharedCell: UICollectionViewCell {
    static let identifier = "MemeMainMostSharedCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for sub in contentView.subviews {
            sub.removeFromSuperview()
        }
    }
    
    func configureCell(with item: Lobby.Item) {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white.withAlphaComponent(0.3)
        
        let imageview = UIImageView()
        imageview.image = UIImage(resource: .imageTemporary)
        imageview.contentMode = .scaleAspectFill
        imageview.layer.cornerRadius = 12
        imageview.layer.masksToBounds = true
        if let urlString = item.imageURL, let url = URL(string: urlString) {
            imageview.kf.setImage(with: url)
        }
        
        let label = UILabel()
        label.font = .customFont(.pretendard(.title(.subhead2)))
        label.textColor = .black
        label.textAlignment = .center
        label.text = item.content
        
        contentView.addSubview(imageview)
        contentView.addSubview(label)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageview.heightAnchor.constraint(equalToConstant: 130),
            imageview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            imageview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            imageview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            label.topAnchor.constraint(equalTo: imageview.bottomAnchor, constant: 8),
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 176),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
        ])
    }
}
