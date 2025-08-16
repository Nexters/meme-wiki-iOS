//
//  SearchCategoryCell.swift
//  Meme
//
//  Created by 임현규 on 8/11/25.
//

import UIKit
import Kingfisher

final class SearchCategoryCell: UICollectionViewCell {
    
    static let identifier = "SearchCategoryCell"
    private var gradientLayer = CAGradientLayer()

    private let gradientColors: [[UIColor]] = [
        [.lightBlue95, .lightBlue80],
        [.violet95, .violet80],
        [.red95, .red80],
        [.yellow95, .yellow80]
    ]
    // MARK: - UI Components
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = .gray9
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray5
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = CustomColor.gray(.gray2).color
        label.font = .customFont(.pretendard(.body(.body1)))
        return label
    }()
    
    private let selectLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            selectLine.isHidden = !isSelected
            gradientLayer.isHidden = !isSelected
            imageView.tintColor = isSelected ? .black : .gray5
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageContainerView.bounds
    }
    
    func updateUI(_ item: CategoryItem) {
        titleLabel.text = item.title
        configureImageView(url: item.imageURL)
        gradientLayer.makeDiagonalGradient(gradientColors[item.id - 1])
    }
}

// MARK: - Private Methods

private extension SearchCategoryCell {
    func configureUI() {
        imageContainerView.layer.insertSublayer(gradientLayer, at: 0)
        
        [ imageContainerView, titleLabel, selectLine ].forEach {
            contentView.addSubview($0)
        }
        
        imageContainerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageContainerView.heightAnchor.constraint(equalToConstant: 64),
            imageContainerView.widthAnchor.constraint(equalToConstant: 64),
            
            titleLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            selectLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            selectLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 64),
            imageView.heightAnchor.constraint(equalToConstant: 64),
            
        ])
    }
    
    func configureImageView(url: String) {
        guard let url = URL(string: url) else { return }

        let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))

        imageView.kf.setImage(
            with: url,
            placeholder: nil, // 템플릿 처리 혼동 방지
            options: [
//                .transition(.fade(0.25)),
                .forceTransition,
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .imageModifier(AnyImageModifier { image in
                    image.withRenderingMode(.alwaysTemplate)
                })
            ]
        )
    }
}
