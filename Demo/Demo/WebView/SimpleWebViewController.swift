//
//  SimpleWebViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/23
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import WebKit

///SimpleWeb
class SimpleWebViewController: UIViewController {
    
    //MARK: Interface
    
    //private let viewModel = SimpleWebViewModel()
    //private let request = SimpleWebRequests()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews(in: view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.webView.load(URLRequest(url: URL(string: "https://www.yuque.com/schoolpal-wiki/manual/wrs3s8")!))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.webView.load(URLRequest(url: URL(string: "yuque://")!))
            }
        }
    }
    
    //MARK: View
    
    override func viewDidLayoutSubviews() {
        webView.frame = view.bounds
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(webView)
    }
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .white
//        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()
}

extension SimpleWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let sc = navigationAction.request.url?.absoluteString
        print(sc)
        if sc?.contains("unilinks.yuque.com") == true {
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
}
