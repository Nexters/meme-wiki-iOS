//
//  SearchTextField.swift
//  Meme
//
//  Created by 임현규 on 8/1/25.
//

import UIKit

final class SearchTextField: UITextField {
    
    // MARK: - UI Components
    
    private let leftImageView: UIImageView = {
        // TODO: - change image
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = CustomColor.gray(.gray4).color
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let leftContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let clearButton: UIButton = {
        // TODO: - change image
        let button = UIButton()
        let image = UIImage(systemName: "xmark.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = CustomColor.gray(.gray4).color
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private let rightContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLeftView()
        configureRightView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setPlaceHolder(_ text: String) {
        attributedPlaceholder = .customFont(.pretendard(.title(.subheadLong2)), text: text, color: .gray(.gray4))
    }
    
    // MARK: - Actions
    
    @objc private func clearText() {
        text = ""
        updateClearButtonVisibility()
    }
    
    @objc private func textDidChange() {
        updateClearButtonVisibility()
    }
}

// MARK: - UI Configure Methods

private extension SearchTextField {
    func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.customFont(.pretendard(.title(.subheadLong2)))
        textColor = CustomColor.gray(.gray1).color
        backgroundColor = CustomColor.gray(.gray8).color
        clearButtonMode = .never
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func configureLeftView() {
        leftContainerView.addSubview(leftImageView)
        
        NSLayoutConstraint.activate([
            leftImageView.centerYAnchor.constraint(equalTo: leftContainerView.centerYAnchor),
            leftImageView.centerXAnchor.constraint(equalTo: leftContainerView.centerXAnchor),
            leftImageView.widthAnchor.constraint(equalToConstant: Constants.LeftImageView.width),
            leftImageView.heightAnchor.constraint(equalToConstant: Constants.LeftImageView.height),
            leftContainerView.widthAnchor.constraint(equalToConstant: Constants.LightContainerView.width),
            leftContainerView.heightAnchor.constraint(equalToConstant: Constants.LightContainerView.height)
        ])
        
        leftView = leftContainerView
        leftViewMode = .always
    }
    
    func configureRightView() {
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        rightContainerView.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            clearButton.centerYAnchor.constraint(equalTo: rightContainerView.centerYAnchor),
            clearButton.centerXAnchor.constraint(equalTo: rightContainerView.centerXAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: Constants.ClearButton.width),
            clearButton.heightAnchor.constraint(equalToConstant: Constants.ClearButton.height),
            rightContainerView.widthAnchor.constraint(equalToConstant: Constants.RightContainerView.width),
            rightContainerView.heightAnchor.constraint(equalToConstant: Constants.RightContainerView.height)
        ])
        
        rightView = rightContainerView
        rightViewMode = .whileEditing
    }
}

// MARK: - Private Methods

private extension SearchTextField {
    func updateClearButtonVisibility() {
        clearButton.isHidden = (text ?? "").isEmpty
    }
}

// MARK: - Constants

private extension SearchTextField {
    enum Constants {
        enum LeftImageView {
            static let width: CGFloat = 20
            static let height: CGFloat = 20
        }
        
        enum ClearButton {
            static let width: CGFloat = 20
            static let height: CGFloat = 20
        }
        
        enum LightContainerView {
            static let width: CGFloat = 40
            static let height: CGFloat = 20
        }
        
        enum RightContainerView {
            static let width: CGFloat = 40
            static let height: CGFloat = 20
        }
    }
}
