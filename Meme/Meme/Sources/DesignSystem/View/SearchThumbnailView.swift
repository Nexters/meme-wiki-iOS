//
//  ThumbnailView.swift
//  Meme
//
//  Created by 임현규 on 7/28/25.
//

import UIKit
import Kingfisher

final class SearchThumbnailView: UIView {
    
    // MARK: - Properties
    
    private var type: ThumbnailType? = nil
    private let randomColor = RandomColor.allCases.randomElement() ?? .none
    
    // MARK: - UI Components
    
    private var yearLabelColor: UIColor? {
        return randomColor?.labelColor
    }
    
    private var ThumbnailGradientColor: UIColor? {
        return randomColor?.gradientColor
    }
    
    private let yearLabel: UILabel = {
        // TODO: - yearlabel random color
        let label = PaddingLabel(left: Constants.yearLabel.padding, right: Constants.yearLabel.padding)
        label.layer.cornerRadius = Constants.yearLabel.cornerRadius
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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var gradientLayer = CAGradientLayer()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ type: ThumbnailType) {
        self.init(frame: .zero)
        self.type = type
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
        guard let type = type else { return }
        titleLabel.attributedText = .customFont(type.titleFont, text: thumbnail.title)
        hastagLabel.attributedText = .customFont(type.hastagFont, text: thumbnail.hashtag.map { $0 }.joined(separator: " "))
        yearLabel.attributedText = .customFont(type.yearFont, text: String(thumbnail.year))
        titleLabel.textColor = .white
        hastagLabel.textColor = .white
        configureImageView(url: thumbnail.imageURL)
    }
}

// MARK: - Private Methods

private extension SearchThumbnailView {
    
    func configureUI() {
        guard let padding = type?.padding else { return }
        yearLabel.backgroundColor = yearLabelColor
        
        [imageView, yearLabel, titleLabel, hastagLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            yearLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            titleLabel.bottomAnchor.constraint(equalTo: hastagLabel.topAnchor, constant: Constants.titleLabel.bottom),
            
            hastagLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            hastagLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            hastagLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // TODO: - Gradient UIView Extension으로 역할 변경
    
    func configureGradient() {
        guard let baseColor = ThumbnailGradientColor else { return }
        gradientLayer = makeGradientLayer(baseColor)
        layer.insertSublayer(gradientLayer, above: imageView.layer)
    }
    
    func configureImageView(url: String) {
        guard let url = URL(string: url) else { return }
        let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(),
            options: [
                .transition(.fade(1)),
                .forceTransition,
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }
}

// MARK: - Constants

private extension SearchThumbnailView {
    enum Constants {
        enum yearLabel {
            static let padding: CGFloat = 8
            static let cornerRadius: CGFloat = 9
        }
        
        enum titleLabel {
            static let bottom: CGFloat = -2
        }
    }
}
