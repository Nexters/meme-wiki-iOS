//
//  MemeSearchGridCell.swift
//  Meme
//
//  Created by 임현규 on 8/4/25.
//

import UIKit

final class MemeSearchGridCell: UICollectionViewCell {
    
    static let identifier = "MemeSearchGridCell"
    
    // MARK: - UI Components
    
    private let thumbnailView: SearchThumbnailView = {
        let view = SearchThumbnailView(.half)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(_ item: Thumbnail) {
        thumbnailView.updateUI(item)
    }
}

// MARK: - Private Methods

private extension MemeSearchGridCell {
    func configureUI() {
        addSubview(thumbnailView)
        
        NSLayoutConstraint.activate([
            thumbnailView.topAnchor.constraint(equalTo: topAnchor),
            thumbnailView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnailView.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbnailView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

