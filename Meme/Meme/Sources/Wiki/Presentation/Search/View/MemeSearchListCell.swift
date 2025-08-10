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
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray9
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
        [ searchResultView, separatorLine ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            searchResultView.topAnchor.constraint(equalTo: topAnchor),
            searchResultView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchResultView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchResultView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            separatorLine.topAnchor.constraint(equalTo: searchResultView.bottomAnchor, constant: 24),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

