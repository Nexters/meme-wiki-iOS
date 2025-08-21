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
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 26)
        textView.textColor = .black
        textView.text = "텍스트"
        textView.isScrollEnabled = false
        textView.textAlignment = .center
        textView.delegate = self
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
        selectedLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), cornerRadius: 10).cgPath

    }
    
    func select() {
        Log.debug("selected", .ui)
        selectedLayer.isHidden = false
        superview?.bringSubviewToFront(self)
    }
}

private extension UserTextView {
    func configureUI() {
        addSubview(textView)
        layer.addSublayer(selectedLayer)
    }
    
    func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTextTapGesture))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        
        [tapGesture, panGesture].forEach { addGestureRecognizer($0) }
    }
    
    @objc func handleTextTapGesture() {
        select()
        delegate?.didTapUserTextView(self)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard !selectedLayer.isHidden else { return } // 선택된 상태일 때만 이동
        let translation = gesture.translation(in: superview)
        if let view = gesture.view {
            view.center = CGPoint(
                x: view.center.x + translation.x,
                y: view.center.y + translation.y
            )
        }
        gesture.setTranslation(.zero, in: superview)
    }
}

extension UserTextView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        select()
        delegate?.didTapUserTextView(self)
        return true
    }
}
