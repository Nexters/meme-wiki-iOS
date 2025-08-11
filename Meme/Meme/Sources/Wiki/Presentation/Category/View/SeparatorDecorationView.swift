//
//  SeparatorDecorationView.swift
//  Meme
//
//  Created by 임현규 on 8/11/25.
//

import UIKit

final class SeparatorDecorationView: UICollectionReusableView {
    
    static let identifier = "SeparatorDecorationViewKind"
    
    // MARK: - UI Components
    
    private let selectLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray8
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
}

// MARK: - Private Methods

private extension SeparatorDecorationView {
    func configureUI() {
        addSubview(selectLine)
        
        NSLayoutConstraint.activate([
            selectLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            selectLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectLine.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}
