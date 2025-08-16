//
//  SearchResultView.swift
//  Meme
//
//  Created by 임현규 on 7/31/25.
//

import UIKit

final class SearchResultView: UIView {
    
    // MARK: - UI Components
    
    private let thumbnailView: SearchThumbnailView = {
        let view = SearchThumbnailView(.full)
        view.layer.cornerRadius = Constants.ThumbnailView.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private let usageInfoView: SearchInfoView = {
        let view = SearchInfoView()
        view.layer.cornerRadius = Constants.infoView.cornerRadius
        return view
    }()

    private let sourceInfoView: SearchInfoView = {
        let view = SearchInfoView()
        view.layer.cornerRadius = Constants.infoView.cornerRadius
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
        usageInfoView.updateUI("이럴때 쓰세요", item.usage, UIImage(resource: .symbolPinkNobg))
        sourceInfoView.updateUI("이렇게 시작됐어요", item.source, UIImage(resource: .symbolBlueNobg))
    }
}

// MARK: - Private extension

private extension SearchResultView {
    func configureUI() {
        [ usageInfoView, sourceInfoView, thumbnailView ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            thumbnailView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.ThumbnailView.top),
            thumbnailView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnailView.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbnailView.heightAnchor.constraint(equalToConstant: Constants.ThumbnailView.height),
            
            usageInfoView.topAnchor.constraint(equalTo: thumbnailView.bottomAnchor, constant: Constants.infoView.bottom),
            usageInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            usageInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            usageInfoView.heightAnchor.constraint(equalToConstant: Constants.infoView.height),
            
            sourceInfoView.topAnchor.constraint(equalTo: usageInfoView.bottomAnchor, constant: Constants.infoView.bottom),
            sourceInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sourceInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sourceInfoView.heightAnchor.constraint(equalToConstant: Constants.infoView.height),
        ])
    }
}

// MARK: - Constants
private extension SearchResultView {
    enum Constants {
        enum infoView {
            static let cornerRadius: CGFloat = 8
            static let bottom: CGFloat = 11
            static let height: CGFloat = 40
        }
        
        enum ThumbnailView {
            static let cornerRadius: CGFloat = 12
            static let top: CGFloat = 10
            static let height: CGFloat = 240
        }
    }
}
