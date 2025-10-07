//
//  BaseViewController.swift
//  Meme-release
//
//  Created by 임현규 on 8/3/25.
//

import UIKit
import Combine

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CustomColor.gray(.gray10).color
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        configureUI()
        bind()
        configureGesture()
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
    }
    
    @objc func handleBackgroundTap() {
        view.endEditing(true)
    }
}

private extension BaseViewController {
    func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
}
