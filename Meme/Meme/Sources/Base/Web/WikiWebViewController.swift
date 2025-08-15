//
//  WikiWebViewController.swift
//  Meme-release
//
//  Created by 제나 on 7/26/25.
//

import WebKit

class WikiWebViewController: UIViewController {

    private let url: URL
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(wikiScriptMessageHandler, name: "wikiHandler")
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.bounces = true
        webView.scrollView.alwaysBounceVertical = true
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        return webView
    }()
    private var wikiScriptMessageHandler: WikiScriptMessageHandler {
        WikiScriptMessageHandler(viewController: self)
    }

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray10
        setupWebView()
        webView.load(URLRequest(url: url))
    }

    private func setupWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           webView.notifyClientReady()
       }
}

extension WikiWebViewController: WKNavigationDelegate, WKUIDelegate {}

extension WKWebView {
    func notifyClientReady() {
        guard
            let javascript = CallbackJavaScript(data: ["type": "CLIENT_IOS", "data": "ready"])?.toScript()
        else {
            Log.error("Failed to create callback javascript", .networking)
            return
        }
        self.evaluateJavaScript(javascript) { result, error in
            if let error = error {
                Log.error("notifyClientReady() error: \(error)", .networking)
            } else {
                Log.error("notifyClientReady() success: \(String(describing: result))", .networking)
            }
        }
    }
}
