//
//  MemeMainTopRatedCell.swift
//  Meme
//
//  Created by 제나 on 8/5/25.
//

import UIKit

final class MemeMainTopRatedCell: UICollectionViewCell {
    static let identifier = "MemeMainTopRatedCell"
    private let fixedColor = [UIColor.pink80, .red80, .yellow90, .lightBlue80, .purple80, .green90]
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for sub in contentView.subviews {
            sub.removeFromSuperview()
        }
    }
    
    func configureCell(with item: Lobby.Item) {
        let index = item.indexPath.item % fixedColor.count
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .systemPink.withAlphaComponent(0.3)
        
        let imageview = UIImageView()
        imageview.image = UIImage(resource: .imageTemporary)
        imageview.contentMode = .scaleAspectFill
        
        let rateLabel = UILabel()
        rateLabel.backgroundColor = fixedColor[index]
        rateLabel.layer.cornerRadius = 6
        rateLabel.layer.masksToBounds = true
        rateLabel.font = .customFont(.pretendard(.title(.subhead2)))
        rateLabel.textColor = .black
        rateLabel.textAlignment = .center
        rateLabel.text = "\(index + 1)위"
        
        let gradientView = UIView()
        
        let textView = UIView()
        textView.backgroundColor = fixedColor[index]
        
        let titleLabel = UILabel()
        titleLabel.font = .customFont(.pretendard(.title(.subhead2)))
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = item.content
        
        imageview.addSubview(gradientView)
        contentView.addSubview(imageview)
        contentView.addSubview(rateLabel)
        textView.addSubview(titleLabel)
        contentView.addSubview(textView)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageview.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -36),
            rateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            rateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            rateLabel.widthAnchor.constraint(equalToConstant: 38),
            rateLabel.heightAnchor.constraint(equalToConstant: 24),
            gradientView.leadingAnchor.constraint(equalTo: imageview.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: imageview.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: imageview.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: imageview.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.heightAnchor.constraint(equalToConstant: 36),
            titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 136),
            titleLabel.centerXAnchor.constraint(equalTo: textView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor)
        ])
    }
}
