//
//  MemeMainTopRatedCell.swift
//  Meme
//
//  Created by 제나 on 8/5/25.
//

import UIKit

final class MemeMainTopRatedCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "MemeMainTopRatedCell"
    private let fixedColor = [UIColor.pink90, .red90, .yellow90, .lightBlue80, .purple80, .green90]
    
    private var gradientView = UIView()
    private var dimmedLayer = CAGradientLayer()
    private var gradientLayer = CAGradientLayer()
    private var imageView: UIImageView!
    private var rateLabel: UILabel!
    private var textView = UIView()
    private var titleLabel: UILabel!
    
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
        imageView.frame = contentView.bounds.inset(
            by: UIEdgeInsets(top: 0, left: 0, bottom: 36, right: 0))
        gradientView.frame = imageView.bounds
        dimmedLayer.frame = gradientView.bounds
        gradientLayer.frame = gradientView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
    }
    
    // MARK: - Public
    func configureCell(with item: Lobby.Item) {
        let index = item.indexPath.item % fixedColor.count
        let itemColor = fixedColor[index]
        if let urlString = item.imageURL, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        }
        gradientLayer.makeVerticalGradient(itemColor)
        textView.backgroundColor = itemColor
        rateLabel.backgroundColor = itemColor
        rateLabel.attributedText = .customFont(
            .pretendard(.title(.subhead2)),
            text: "\(index + 1)위",
            color: .black(.black))
        rateLabel.textAlignment = .center
        titleLabel.attributedText = .customFont(
            .pretendard(.title(.subheadLong2)),
            text: item.content,
            color: .black(.black))
        titleLabel.textAlignment = .center
    }
    
    // MARK: - Private
    private func layoutCell() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .systemPink.withAlphaComponent(0.3)
        
        dimmedLayer.makeDimmed()
        gradientView.layer.insertSublayer(dimmedLayer, at: 0)
        gradientView.layer.insertSublayer(gradientLayer, at: 1)
        
        imageView = UIImageView()
        imageView.image = UIImage(resource: .imageTemporary)
        imageView.contentMode = .scaleAspectFill
        
        rateLabel = UILabel()
        rateLabel.layer.cornerRadius = 6
        rateLabel.layer.masksToBounds = true
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.lineBreakMode = .byTruncatingTail
        
        imageView.addSubview(gradientView)
        contentView.addSubview(imageView)
        contentView.addSubview(rateLabel)
        textView.addSubview(titleLabel)
        contentView.addSubview(textView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -36),
            rateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            rateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            rateLabel.widthAnchor.constraint(equalToConstant: 38),
            rateLabel.heightAnchor.constraint(equalToConstant: 24),
            gradientView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: imageView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.heightAnchor.constraint(equalToConstant: 36),
            titleLabel.centerXAnchor.constraint(equalTo: textView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: textView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: textView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor)
        ])
    }
}
