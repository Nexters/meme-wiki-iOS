//
//  DebounceTextField.swift
//  Meme
//
//  Created by 임현규 on 8/6/25.
//

import UIKit
import Combine

class DebounceTextField: UITextField {
    private let subject = PassthroughSubject<String, Never>()
    
    var textChangePublisher: AnyPublisher<String, Never> {
        subject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTarget()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTarget()
    }

    private func configureTarget() {
        addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
    }

    @objc private func textDidChanged() {
        subject.send(text ?? "")
    }
}
