//
//  EditToolView.swift
//  Meme
//
//  Created by 임현규 on 8/21/25.
//

import UIKit

protocol EditToolDelegate: NSObject {
    func didTapPenButton()
    func didTapTextButton()
}

final class EditToolView: UIView {
    weak var delegate: EditToolDelegate?
    
    // MARK: - UI Components
    private lazy var penButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconEdit), for: .normal)
        button.addTarget(self, action: #selector(didTapPenButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var textButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconText), for: .normal)
        button.addTarget(self, action: #selector(didTapTextButton), for: .touchUpInside)
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
    
    @objc func didTapPenButton() {
        delegate?.didTapPenButton()
    }
    
    @objc func didTapTextButton() {
        delegate?.didTapTextButton()
    }
}

private extension EditToolView {
    func configureUI() {
        [ penButton, textButton ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            penButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            penButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            penButton.widthAnchor.constraint(equalToConstant: 30),
            penButton.heightAnchor.constraint(equalToConstant: 30),
            
            textButton.leadingAnchor.constraint(equalTo: penButton.trailingAnchor, constant: 12),
            textButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            textButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            textButton.widthAnchor.constraint(equalToConstant: 30),
            textButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}

