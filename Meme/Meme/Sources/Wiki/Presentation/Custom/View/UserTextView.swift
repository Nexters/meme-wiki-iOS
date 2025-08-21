//
//  UserTextView.swift
//  Meme
//
//  Created by 임현규 on 8/21/25.
//

import UIKit

protocol UserTextViewDelegate: AnyObject {
    func didTapUserTextView(_ userTextView: UserTextView)
}

final class UserTextView: UIView {
    // MARK: - UI Components
    weak var delegate: UserTextViewDelegate?
    
    private let selectedLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.systemBlue.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineDashPattern = [6,3]
        layer.isHidden = true
        return layer
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 26)
        textView.textColor = .black
        textView.text = "텍스트"
        textView.isScrollEnabled = false
        textView.textAlignment = .center
        return textView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.frame = bounds
    }
}

private extension UserTextView {
    func configureUI() {
        addSubview(textView)
        layer.addSublayer(selectedLayer)
    }
    
    func configureGesture() {
        let textTap = UITapGestureRecognizer(target: self, action: #selector(handleTextTapGesture))
        addGestureRecognizer(textTap)
    }
    
    @objc func handleTextTapGesture() {
        selected()
        delegate?.didTapUserTextView(self)
    }
    
    func selected() {
        selectedLayer.isHidden = false
        superview?.bringSubviewToFront(self)
    }
}
