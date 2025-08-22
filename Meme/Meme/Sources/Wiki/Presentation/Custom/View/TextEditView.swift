//
//  TextEditView.swift
//  Meme
//
//  Created by 임현규 on 8/22/25.
//

import UIKit

final class TextEditView: UIView {
    // MARK: - UI Components
    
    private let textAddLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .customFont(.pretendard(.title(.subhead2)), text: "텍스트 추가")
        label.textColor = .gray9
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray5
        return view
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconDelete), for: .normal)
        button.tintColor = .red40
        return button
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconMoreCircle), for: .normal)
        button.tintColor = .gray9
        return button
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

private extension TextEditView {
    func configureUI() {
        [ textAddLabel, separatorLine, deleteButton, moreButton ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            textAddLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            textAddLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textAddLabel.trailingAnchor.constraint(equalTo: separatorLine.leadingAnchor, constant: 24),
            
            separatorLine.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            separatorLine.widthAnchor.constraint(equalToConstant: 1),
            separatorLine.heightAnchor.constraint(equalToConstant: 18),
            
            deleteButton.leadingAnchor.constraint(equalTo: separatorLine.trailingAnchor, constant: 20),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            
            moreButton.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: 6),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            moreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 30),
            moreButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
