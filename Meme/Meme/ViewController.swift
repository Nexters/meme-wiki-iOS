//
//  ViewController.swift
//  Meme
//
//  Created by 임현규 on 7/15/25.
//

import UIKit
import Alamofire
import Moya

class ViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        let labelText = Bundle.main.object(forInfoDictionaryKey: "APP_LABEL_TEXT") as? String
        label.text = labelText
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(label)
        view.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

