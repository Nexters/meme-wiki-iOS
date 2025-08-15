//
//  MemeMainMostSharedCell.swift
//  Meme
//
//  Created by 제나 on 8/5/25.
//

import UIKit

final class MemeMainMostSharedCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "MemeMainMostSharedCell"
    private let gradientColorsForFirstRow: [[UIColor]] = [
        [.lightBlue95, .lightBlue80],
        [.yellow95, .yellow80],
        [.pink95, .pink80],
        [.lime95, .lime80],
        [.violet95, .violet80]
    ]
    private let gradientColorsForSecondRow: [[UIColor]] = [
        [.blue95, .blue80],
        [.red95, .red80],
        [.violet95, .violet80],
        [.lime95, .lime80],
        [.pink95, .pink80]
    ]
    
    private var gradientView: UIView!
    private var gradientLayer = CAGradientLayer()
    private var imageView: UIImageView!
    private var label: UILabel!
    
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
    func configureCell(with item: Lobby.Item, isFirstRow: Bool) {
        if let urlString = item.imageURL, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        }
        label.attributedText = .customFont(
            .pretendard(.title(.subhead2)),
            text: item.content, color: .black(.black))
        
        let index = item.indexPath.item % gradientColorsForFirstRow.count
        let colors = isFirstRow ? gradientColorsForFirstRow[index] : gradientColorsForSecondRow[index]
        gradientLayer.makeDiagonalGradient(colors)
    }
    
    // MARK: - Private
    private func layoutCell() {
        gradientView = UIView()
        gradientView.layer.cornerRadius = 12
        gradientView.layer.masksToBounds = true
        gradientView.backgroundColor = .white
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        imageView = UIImageView()
        imageView.image = UIImage(resource: .imageTemporary)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        
        label = UILabel()
        label.textAlignment = .center
        
        gradientView.addSubview(imageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(label)
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 130),
            imageView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 6),
            imageView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 6),
            imageView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -6),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
        ])
    }
}
