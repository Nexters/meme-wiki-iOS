//
//  TextStylePanelView.swift
//  Meme
//
//  Created by 임현규 on 8/22/25.
//

import UIKit

// MARK: - Delegate
protocol TextStylePanelViewDelegate: AnyObject {
    func didChangeSize(_ view: TextStylePanelView, size: CGFloat)
    func didSelectColor(_ view: TextStylePanelView, color: UIColor)
}

// MARK: - View
final class TextStylePanelView: UIView {

    // MARK: - UI
    weak var delegate: TextStylePanelViewDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .customFont(.pretendard(.title(.subhead2)), text: "텍스트 스타일", color: .gray(.gray9))
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let sizeValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomColor.gray(.gray6).color
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private lazy var sizeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 8
        slider.maximumValue = 128
        slider.addTarget(self, action: #selector(sizeChanged(_:)), for: .valueChanged)
        return slider
    }()

    private let colorScroll: UIScrollView = {
        let s = UIScrollView()
        s.showsHorizontalScrollIndicator = false
        return s
    }()

    private let colorStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()

    private let colors: [UIColor] = [
        .black, .white, .red40, .yellow, .green60, .blue50, .purple40
    ]

    // MARK: - State
    private weak var selectedColorButton: UIButton?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setColorStack()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public
extension TextStylePanelView {
    func configure(initialSize: CGFloat, initialColor: UIColor) {
        let clamped = max(8, min(128, initialSize))
        sizeSlider.value = Float(clamped)
        sizeValueLabel.text = "\(Int(round(clamped))) pt"

        if let index = colors.firstIndex(where: { $0.withAlphaComponent(1) == initialColor.withAlphaComponent(1) }),
           index < colorStack.arrangedSubviews.count,
           let button = colorStack.arrangedSubviews[index] as? UIButton {
            updateSelectedIndicator(button)
        }
    }
}

// MARK: - Private: Layout only
private extension TextStylePanelView {
    func configureUI() {
        backgroundColor = .white
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 6)

        let sizeRow = UIStackView(arrangedSubviews: [titleLabel, sizeValueLabel])
        sizeRow.axis = .horizontal
        sizeRow.alignment = .center
        sizeRow.distribution = .fill

        let rootStackView = UIStackView(arrangedSubviews: [sizeRow, sizeSlider, colorScroll])
        rootStackView.axis = .vertical
        rootStackView.spacing = 12
        rootStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(rootStackView)
        colorScroll.addSubview(colorStack)

        colorStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            rootStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            rootStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            rootStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),

            heightAnchor.constraint(greaterThanOrEqualToConstant: 110),

            colorScroll.heightAnchor.constraint(equalToConstant: 28),

            colorStack.leadingAnchor.constraint(equalTo: colorScroll.contentLayoutGuide.leadingAnchor),
            colorStack.trailingAnchor.constraint(equalTo: colorScroll.contentLayoutGuide.trailingAnchor),
            colorStack.topAnchor.constraint(equalTo: colorScroll.contentLayoutGuide.topAnchor),
            colorStack.bottomAnchor.constraint(equalTo: colorScroll.contentLayoutGuide.bottomAnchor),
            colorStack.heightAnchor.constraint(equalTo: colorScroll.frameLayoutGuide.heightAnchor)
        ])
    }

    func setColorStack() {
        colors.forEach { color in
            let button = makeColorButton(color)
            colorStack.addArrangedSubview(button)
        }
    }
    
    func makeColorButton(_ color: UIColor) -> UIButton {
        let butten = UIButton(type: .system)
        butten.backgroundColor = color
        butten.layer.cornerRadius = 14
        butten.layer.borderWidth = 1
        butten.layer.borderColor = UIColor(white: 0, alpha: 0.08).cgColor
        butten.translatesAutoresizingMaskIntoConstraints = false
        butten.addTarget(self, action: #selector(colorTap(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            butten.widthAnchor.constraint(equalToConstant: 28),
            butten.heightAnchor.constraint(equalToConstant: 28)
        ])
        return butten
    }

    func updateSelectedIndicator(_ button: UIButton) {
        selectedColorButton?.layer.borderColor = UIColor(white: 0, alpha: 0.08).cgColor
        selectedColorButton?.layer.borderWidth = 1
        selectedColorButton = button
        button.layer.borderColor = UIColor.label.withAlphaComponent(0.85).cgColor
        button.layer.borderWidth = 2
    }
}

// MARK: - Actions
private extension TextStylePanelView {
    @objc func sizeChanged(_ slider: UISlider) {
        let value = CGFloat(round(slider.value))
        sizeValueLabel.text = "\(Int(value)) pt"
        delegate?.didChangeSize(self, size: value)
    }
    
    @objc func colorTap(_ sender: UIButton) {
        guard let color = sender.backgroundColor else { return }
        updateSelectedIndicator(sender)
        delegate?.didSelectColor(self, color: color)
    }
}

