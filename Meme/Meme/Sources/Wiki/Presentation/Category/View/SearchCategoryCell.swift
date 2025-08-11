//
//  SearchCategoryCell.swift
//  Meme
//
//  Created by 임현규 on 8/11/25.
//

import UIKit

final class SearchCategoryCell: UICollectionViewCell {
    
    static let identifier = "CategoryPillCell"
    
    // MARK: - UI Components
    
    private let imageContainerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = CustomColor.gray(.gray8).color
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = CustomColor.gray(.gray2).color
        lb.font = .customFont(.pretendard(.body(.body1)))
        return lb
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
            imageContainerView.backgroundColor = isSelected ? .green70 : .gray9
            titleLabel.textColor = isSelected ? .white : .gray5
            selectLine.isHidden = !isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(_ item: CategoryItem) {
        titleLabel.text = item.title
    }
}

// MARK: - Private Methods

private extension SearchCategoryCell {
    func configureUI() {
        [ imageContainerView, titleLabel, selectLine ].forEach {
            contentView.addSubview($0)
        }
        
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
    }
}
