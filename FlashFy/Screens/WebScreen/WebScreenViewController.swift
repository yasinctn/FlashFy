//
//  WebScreenViewController.swift
//  FlashFy
//
//  Created by Yasin Cetin on 14.08.2023.
//

import UIKit
import WebKit

protocol WebScreenInput: AnyObject {
    
}

final class WebScreenViewController: UIViewController {

    var selectedNewsUrl: URL?
    private var viewModel: WebViewOutput?
    @IBOutlet private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = WebViewModel(view: self, networkService: NetworkService())
        prepareWebView()
        presentWebPage()
        
    }
}


extension WebScreenViewController: WKNavigationDelegate {
    
}

// MARK: - Web Screen Input
extension WebScreenViewController: WebScreenInput {
    
}
  
// MARK: - Private Methods
private extension WebScreenViewController {
    
    func prepareWebView() {
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func presentWebPage() {
        if let request = viewModel?.getRequest(url: selectedNewsUrl) {
            webView.load(request)
        }
    }
}
