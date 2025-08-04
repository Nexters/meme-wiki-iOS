//
//  MemeSearchListCell.swift
//  Meme
//
//  Created by 임현규 on 8/4/25.
//

import UIKit

final class MemeSearchListCell: UICollectionViewCell {
    
    static let identifier = "MemeSearchListCell"
    
    // MARK: - UI Components
    
    private let searchResultView: SearchResultView = {
        let view = SearchResultView()
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
    
    func updateUI(_ item: MemeSearchItem) {
        searchResultView.updateUI(item)
    }
}

// MARK: - Private Methods

private extension MemeSearchListCell {
    func configureUI() {
        addSubview(searchResultView)
        
        NSLayoutConstraint.activate([
            searchResultView.topAnchor.constraint(equalTo: topAnchor),
            searchResultView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchResultView.trailingAnchor.constraint(equalTo: leadingAnchor),
            searchResultView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

