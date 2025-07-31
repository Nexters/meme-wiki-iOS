//
//  SearchContainerView.swift
//  Meme
//
//  Created by 임현규 on 7/31/25.
//

import UIKit

final class SearchContainerView: UIView {
    
    // MARK: - UI Components
    
    private let thumbnailView: ThumbnailView = {
        let view = ThumbnailView(.full)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let usageInfoView: SearchInfoView = {
        let view = SearchInfoView()
        view.layer.cornerRadius = 6
        return view
    }()

    private let sourceInfoView: SearchInfoView = {
        let view = SearchInfoView()
        view.layer.cornerRadius = 6
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
        thumbnailView.updateUI(item.thumbnail)
        usageInfoView.updateUI("용도", item.usage)
        sourceInfoView.updateUI("유래", item.source)
    }
}

// MARK: - Private extension

private extension SearchContainerView {
    func configureUI() {
        [ usageInfoView, sourceInfoView, thumbnailView ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            thumbnailView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            thumbnailView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnailView.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbnailView.heightAnchor.constraint(equalToConstant: 240),
            
            usageInfoView.topAnchor.constraint(equalTo: thumbnailView.bottomAnchor, constant: 11),
            usageInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            usageInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            usageInfoView.heightAnchor.constraint(equalToConstant: 40),
            
            
            sourceInfoView.topAnchor.constraint(equalTo: usageInfoView.bottomAnchor, constant: 11),
            sourceInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sourceInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sourceInfoView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
