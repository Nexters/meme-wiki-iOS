//
//  ViewController.swift
//  Meme
//
//  Created by 임현규 on 7/15/25.
//

import UIKit
import Combine
import Alamofire
import Moya
import Kingfisher

class ViewController: UIViewController {
    
    private let subscrpitions = Set<AnyCancellable>()
    
    private let label: UILabel = {
        let label = UILabel()
        let labelText = Bundle.main.object(forInfoDictionaryKey: "APP_LABEL_TEXT") as? String
        label.text = labelText
        return label
    }()
    
    private let testWebViewButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("open webView", for: .normal)
        return button
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
        
        view.addSubview(testWebViewButton)
        testWebViewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testWebViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testWebViewButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10)
        ])
        setupButton()
    }
    
    private func setupButton() {
        let action = UIAction { [weak self] _ in
            self?.openWebView()
        }
        testWebViewButton.addAction(action, for: .touchUpInside)
    }
    private func openWebView() {
        guard let url = URL(string: "https://google.com") else { return }
        let webViewController = WikiWebViewController(url: url)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}

