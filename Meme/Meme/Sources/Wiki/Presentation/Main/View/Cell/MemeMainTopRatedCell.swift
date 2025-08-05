//
//  MemeMainTopRatedCell.swift
//  Meme
//
//  Created by 제나 on 8/5/25.
//

import UIKit

final class MemeMainTopRatedCell: UICollectionViewCell {
    static let identifier = "MemeMainTopRatedCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for sub in contentView.subviews {
            sub.removeFromSuperview()
        }
    }
    
    func configureCell(with item: MemeMain.Model.Item) {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .systemPink.withAlphaComponent(0.3)
        
        let imageview = UIImageView()
        imageview.image = UIImage(resource: .imageTemporaryTopRated)
        imageview.contentMode = .scaleAspectFill
        
        let gradientView = UIView()
        
        let textView = UIView()
        textView.backgroundColor = .systemPink
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.text = item.content
        
        imageview.addSubview(gradientView)
        contentView.addSubview(imageview)
        textView.addSubview(label)
        contentView.addSubview(textView)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageview.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -36),
            gradientView.leadingAnchor.constraint(equalTo: imageview.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: imageview.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: imageview.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: imageview.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.heightAnchor.constraint(equalToConstant: 36),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 136),
            label.centerXAnchor.constraint(equalTo: textView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: textView.centerYAnchor)
        ])
    }
}
