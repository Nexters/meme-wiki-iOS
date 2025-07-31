//
//  ThumbnailView.swift
//  Meme
//
//  Created by 임현규 on 7/28/25.
//

import UIKit

final class ThumbnailView: UIView {
    
    // MARK: - Properties
    
    private var type: ThumbnailType? = nil
    private let randomColor = RandomColor.allCases.randomElement() ?? .none
    
    // MARK: - UI Components
    
    private var yearLabelColor: UIColor? {
        return randomColor?.labelColor
    }
    
    private var ThumnailGradientColor: UIColor? {
        return randomColor?.gradientColor
    }
    
    private let yearLabel: UILabel = {
        // TODO: - yearlabel random color
        let label = PaddingLabel(left: 8, right: 8)
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
        hastagLabel.attributedText = .customFont(type.hastagFont, text: thumbnail.hashtag.map { "#\($0)" }.joined(separator: " "))
        yearLabel.attributedText = .customFont(type.yearFont, text: String(thumbnail.year))
    }
}

// MARK: - Private Methods

private extension ThumbnailView {
    
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
            titleLabel.bottomAnchor.constraint(equalTo: hastagLabel.topAnchor, constant: -2),
            
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
        guard let baseColor = ThumnailGradientColor else { return }
        gradientLayer = makeGradientLayer(baseColor)
        layer.insertSublayer(gradientLayer, above: imageView.layer)
    }
}

