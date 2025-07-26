//
//  WikiWebViewController.swift
//  Meme-release
//
//  Created by 제나 on 7/26/25.
//

import WebKit

class WikiWebViewController: UIViewController {
    let url: URL
    var webViews = [WKWebView]()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    private func setupWebView() {
        let webView = createWebView(frame: view.frame, configuration: configuration)
        load(url, in: webView)
    }
    private func load(_ url: URL, in webView: WKWebView) {
        webView.load(URLRequest(url: url))
    }
}

extension WikiWebViewController: WKUIDelegate, WKNavigationDelegate {
    private func createWebView(frame: CGRect, configuration: WKWebViewConfiguration) -> WKWebView {
        let webView = WKWebView(frame: frame, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        webViews.append(webView)
        return webView
    }
    private var configuration: WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.allowsAirPlayForMediaPlayback = true
        return configuration
    }
    private var userContentController: WKUserContentController {
        let contentController = WKUserContentController()
        contentController.add(wikiScriptMessageHandler, contentWorld: .page, name: "MemeWiki")
        return contentController
    }
    private var wikiScriptMessageHandler: WKScriptMessageHandler {
        return WikiScriptMessageHandler()
    }
}
