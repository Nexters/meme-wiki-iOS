//
//  BaseViewController.swift
//  Meme-release
//
//  Created by 임현규 on 8/3/25.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CustomColor.gray(.gray10).color
        configureUI()
        bind()
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
    }
}
