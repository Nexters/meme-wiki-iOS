//
//  ThumbnailView.swift
//  Meme
//
//  Created by 임현규 on 7/28/25.
//

import UIKit

final class ThumbnailView: UIView {

    // MARK: - UI Components

    private let yearLabel: UILabel = {
        // TODO: - yearlabel random color
        let label = PaddingLabel(left: 8, right: 8)
        label.backgroundColor = CustomColor.purple(.purple90).color
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    private let hastagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = CustomColor.gray(.gray9).color
        return imageView
    }()

    private let gradientLayer = CAGradientLayer()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureGradient()
    }

    required init?(coder: NSCoder) {
        fatalError("Don't use Storyboard")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    // MARK: - Public Methods

    public func updateUI(_ thumbnail: Thumbnail) {
        // TODO: - imageView Setting
        titleLabel.attributedText = .customFont(.pretendard(.title(.headline2)), text: thumbnail.title)
        hastagLabel.attributedText = .customFont(.pretendard(.body(.caption)), text: thumbnail.hashtag.map { "#\($0)" }.joined(separator: " "))
        yearLabel.attributedText = .customFont(.pretendard(.body(.body1)), text: String(thumbnail.year))
    }
}

// MARK: - Private Methods

private extension ThumbnailView {
    
    func configureUI() {
        [imageView, yearLabel, titleLabel, hastagLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            yearLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: hastagLabel.topAnchor, constant: -2),

            hastagLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            hastagLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            hastagLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func configureGradient() {
        // TODO: - add Yellow Color
        let colorSets: [CustomColor] = [
            .purple(.purple30), .pink(.pink40), .violet(.violet30), .lightBlue(.lightBlue30), .green(.green60), .red(.red50)
        ]
        
        guard let baseColor = colorSets.randomElement()?.color else { return }
        
        gradientLayer.colors = [
            baseColor.withAlphaComponent(0.0).cgColor,
            baseColor.withAlphaComponent(0.0).cgColor,
            baseColor.withAlphaComponent(0.2).cgColor,
            baseColor.withAlphaComponent(0.5).cgColor
        ]

        gradientLayer.locations = [0.0, 0.4, 0.7, 1.0].map(NSNumber.init)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        layer.insertSublayer(gradientLayer, above: imageView.layer)
    }
}

