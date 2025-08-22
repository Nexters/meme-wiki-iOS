//
//  UserTextView.swift
//  Meme
//
//  Created by 임현규 on 8/21/25.
//

import UIKit

protocol UserTextViewDelegate: AnyObject {
    func didTapUserTextView(_ userTextView: UserTextView)
    func textAddButtonDidTapped()
    func deleteButtonDidTapped(_ userTextView: UserTextView)
}

final class UserTextView: UIView {
    // MARK: - UI Components
    weak var delegate: UserTextViewDelegate?

    private lazy var stylePanel: TextStylePanelView = {
        let panel = TextStylePanelView()
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.delegate = self
        panel.isHidden = true
        return panel
    }()

    private lazy var textEditView: TextEditView = {
        let view = TextEditView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.isHidden = true
        return view
    }()

    private let rightResizeView: TouchHandleView = {
        let view = TouchHandleView()
        view.hitTestOutset = 50
        view.layer.cornerRadius = 6
        view.backgroundColor = .systemBlue
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()

    private let leftResizeView: TouchHandleView = {
        let view = TouchHandleView()
        view.hitTestOutset = 50
        view.layer.cornerRadius = 6
        view.backgroundColor = .systemBlue
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()

    private let selectedLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.systemBlue.cgColor
        layer.fillColor = UIColor.clear.cgColor
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
        selectedLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), cornerRadius: 0).cgPath
    }

    // MARK: - Public Methods
    func select() {
        Log.debug("selected", .ui)
        stylePanel.isHidden = true
        selectedLayer.isHidden = false
        rightResizeView.isHidden = false
        leftResizeView.isHidden = false
        textEditView.isHidden = false
        superview?.bringSubviewToFront(self)
    }

    func deSelect() {
        Log.debug("deselected", .ui)
        stylePanel.isHidden = true
        selectedLayer.isHidden = true
        rightResizeView.isHidden = true
        leftResizeView.isHidden = true
        textEditView.isHidden = true
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if super.point(inside: point, with: event) { return true }
        let pInEdit = convert(point, to: textEditView)
        if textEditView.bounds.contains(pInEdit) { return true }
        return false
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard isUserInteractionEnabled, !isHidden, alpha > 0.01 else { return nil }
        let pInEdit = convert(point, to: textEditView)
        if super.point(inside: point, with: event), let view = super.hitTest(point, with: event) { return view }
        if textEditView.bounds.contains(pInEdit) { return textEditView.hitTest(pInEdit, with: event) }
        return nil
    }
}

private extension UserTextView {
    func showStylePanel() {
        stylePanel.configure(
            initialSize: textView.font?.pointSize ?? 26,
            initialColor: textView.textColor ?? .black
        )
        
        guard let superview = superview else { return }

        if stylePanel.superview == nil {
            superview.addSubview(stylePanel)
            NSLayoutConstraint.activate([
                stylePanel.topAnchor.constraint(equalTo: textEditView.topAnchor, constant: -70),
                stylePanel.centerXAnchor.constraint(equalTo: textEditView.centerXAnchor),
                stylePanel.widthAnchor.constraint(greaterThanOrEqualToConstant: 220),
                stylePanel.leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: 8),
                stylePanel.trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor, constant: -8),
            ])
        }

        stylePanel.isHidden = false
        superview.bringSubviewToFront(stylePanel)
    }

    func configureUI() {
        [ textView, rightResizeView, leftResizeView, textEditView ].forEach { addSubview($0) }
        layer.addSublayer(selectedLayer)
        
        NSLayoutConstraint.activate([
            rightResizeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 6),
            rightResizeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightResizeView.widthAnchor.constraint(equalToConstant: 12),
            rightResizeView.heightAnchor.constraint(equalToConstant: 12),
            
            leftResizeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -6),
            leftResizeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftResizeView.widthAnchor.constraint(equalToConstant: 12),
            leftResizeView.heightAnchor.constraint(equalToConstant: 12),
            
            textEditView.topAnchor.constraint(equalTo: textView.topAnchor, constant: -70),
            textEditView.centerXAnchor.constraint(equalTo: textView.centerXAnchor),
            textEditView.widthAnchor.constraint(greaterThanOrEqualToConstant: 215),
            textEditView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTextTapGesture))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let rightResizePanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleResize(_:)))
        let leftResizePanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleResize(_:)))
        
        [tapGesture, panGesture, pinchGesture].forEach { addGestureRecognizer($0) }
        
        leftResizeView.addGestureRecognizer(leftResizePanGesture)
        rightResizeView.addGestureRecognizer(rightResizePanGesture)
    }
    
    @objc func handleTextTapGesture() {
        select()
        delegate?.didTapUserTextView(self)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard !selectedLayer.isHidden else { return }
        let translation = gesture.translation(in: superview)
        center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
        gesture.setTranslation(.zero, in: superview)
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard !selectedLayer.isHidden else { return }
        transform = transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
    }
    
    @objc private func handleResize(_ gesture: UIPanGestureRecognizer) {
        guard !selectedLayer.isHidden,
              let handle = gesture.view else { return }
        let translation = gesture.translation(in: superview)
        gesture.setTranslation(.zero, in: superview)
        let minWidth: CGFloat = 60, minHeight: CGFloat = 40

        if handle === leftResizeView {
            frame.origin.x += translation.x
            frame.size.width -= translation.x
            frame.size.height += translation.y
            if frame.size.width < minWidth {
                let diff = minWidth - frame.size.width
                frame.origin.x -= diff
                frame.size.width = minWidth
            }
            if frame.size.height < minHeight { frame.size.height = minHeight }
        } else if handle === rightResizeView {
            frame.size.width += translation.x
            frame.size.height += translation.y
            if frame.size.width < minWidth { frame.size.width = minWidth }
            if frame.size.height < minHeight { frame.size.height = minHeight }
        }

        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - UITextViewDelegate

extension UserTextView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        select()
        delegate?.didTapUserTextView(self)
        return true
    }
}

// MARK: - TextEditViewDelegate
extension UserTextView: TextEditViewDelegate {
    func textAddButtonDidTapped() {
        Log.debug("textAddButtonDidTapped", .ui)
        delegate?.textAddButtonDidTapped()
    }
    
    func deleteButtonDidTapped() {
        Log.debug("deleteButtonDidTapped", .ui)
        delegate?.deleteButtonDidTapped(self)
    }
    
    func moreButtonDidTapped() {
        showStylePanel()
        Log.debug("moreButtonDidTapped", .ui)
    }
}

// MARK: - TextStylePanelViewDelegate
extension UserTextView: TextStylePanelViewDelegate {
    func didChangeSize(_ view: TextStylePanelView, size: CGFloat) {
        let family = textView.font?.fontName ?? UIFont.systemFont(ofSize: size).fontName
        textView.font = UIFont(name: family, size: size) ?? .systemFont(ofSize: size)
        setNeedsLayout()
        layoutIfNeeded()
    }

    func didSelectColor(_ view: TextStylePanelView, color: UIColor) {
        textView.textColor = color
    }
}

