//
//  TextEditView.swift
//  Meme
//
//  Created by 임현규 on 8/22/25.
//

import UIKit

protocol TextEditViewDelegate: AnyObject {
    func textAddButtonDidTapped()
    func deleteButtonDidTapped()
    func moreButtonDidTapped()
}

final class TextEditView: UIView {
    // MARK: - UI Components
    
    weak var delegate: TextEditViewDelegate?
    
    private lazy var textAddButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.customFont(.pretendard(.title(.subhead2)), text: "텍스트 추가", color: .gray(.gray9)), for: .normal)
        button.addTarget(self, action: #selector(textAddButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray5
        return view
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconDelete), for: .normal)
        button.tintColor = .red40
        button.addTarget(self, action: #selector(deleteButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconMoreCircle), for: .normal)
        button.tintColor = .gray9
        button.addTarget(self, action: #selector(moreButtonDidTapped), for: .touchUpInside)
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
        [ textAddButton, separatorLine, deleteButton, moreButton ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            textAddButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            textAddButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            textAddButton.trailingAnchor.constraint(equalTo: separatorLine.leadingAnchor, constant: -24),
            
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

private extension TextEditView {
    @objc func textAddButtonDidTapped() {
        Log.debug("textAddButtonDidTapped", .ui)
        delegate?.textAddButtonDidTapped()
    }

    @objc func deleteButtonDidTapped() {
        Log.debug("deleteButtonDidTapped", .ui)
        delegate?.deleteButtonDidTapped()
    }
    
    @objc func moreButtonDidTapped() {
        Log.debug("moreButtonDidTapped", .ui)
        delegate?.moreButtonDidTapped()
    }
}
