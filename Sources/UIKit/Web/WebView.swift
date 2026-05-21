//
//  WebView.swift
//  XMKit
//
//  Created by HuChangChang on 2024/1/19.
//

import Foundation
import WebKit
//import MJRefresh

extension DTB {
    
    /// Plugin regist mode
    public class WebView: WKWebView {
        
        private var _plugins: [WebViewPlugin] = []
        
        public var plugins: [WebViewPlugin] { _plugins }
        
        private var kvoTokens: [NSKeyValueObservation] = []
        
        public static func `default`() -> WebView {
            let config = WKWebViewConfiguration()
            config.allowsInlineMediaPlayback = true
            config.mediaTypesRequiringUserActionForPlayback = .all
            let wv = WebView(frame: .zero, configuration: config)
            wv.backgroundColor = .white
            wv.scrollView.contentInsetAdjustmentBehavior = .never
            return wv
        }
        
        public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
            super.init(frame: frame, configuration: configuration)
            navigationDelegate = self
            uiDelegate = self
            _startKVO()
        }
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        deinit {
            kvoTokens.removeAll()
        }
        
        public func register(_ plugin: WebViewPlugin) {
            remove(identifier: plugin.identifier)
            _plugins.append(plugin)
            _plugins.sort { $0.priority < $1.priority }
        }
        
        public func remove(identifier: String) {
            _plugins.removeAll { $0.identifier == identifier }
        }
        
        private func _startKVO() {
            kvoTokens = [
                observe(\.estimatedProgress, options: [.new]) { [weak self] wv, _ in
                    self?._plugins.forEach { $0.estimatedProgressChanged(wv.estimatedProgress, in: wv) }
                },
                observe(\.isLoading, options: [.new]) { [weak self] wv, _ in
                    self?._plugins.forEach { $0.isLoadingChanged(wv.isLoading, in: wv) }
                },
                observe(\.title, options: [.new]) { [weak self] wv, _ in
                    self?._plugins.forEach { $0.titleChanged(wv.title, in: wv) }
                },
                observe(\.url, options: [.new]) { [weak self] wv, _ in
                    self?._plugins.forEach { $0.urlChanged(wv.url, in: wv) }
                },
            ]
        }
        
        public override func didMoveToSuperview() {
            super.didMoveToSuperview()
            _plugins.forEach { $0.didMoveToSuperview(in: self) }
        }
        public override func didMoveToWindow() {
            super.didMoveToWindow()
            _plugins.forEach { $0.didMoveToWindow(in: self) }
        }
        public override func willMove(toSuperview newSuperview: UIView?) {
            super.willMove(toSuperview: newSuperview)
            _plugins.forEach { $0.willMoveToSuperview(newSuperview, in: self) }
        }
        
    }
    
}

extension DTB.WebView: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        for p in _plugins {
            guard p.shouldAllowNavigation(navigationAction, in: webView) else {
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    @available(iOS 13.0, *)
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        preferences: WKWebpagePreferences,
                        decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        for p in _plugins {
            guard p.shouldAllowNavigation(navigationAction, in: webView) else {
                decisionHandler(.cancel, preferences)
                return
            }
        }
        decisionHandler(.allow, preferences)
    }
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationResponse: WKNavigationResponse,
                        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        for p in _plugins {
            guard p.shouldAllowNavigationResponse(navigationResponse, in: webView) else {
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        _plugins.forEach { $0.didStartProvisionalNavigation(in: webView) }
    }
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        _plugins.forEach { $0.didReceiveServerRedirect(in: webView) }
    }
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        _plugins.forEach { $0.didCommitNavigation(in: webView) }
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        _plugins.forEach { $0.didFinishNavigation(in: webView) }
    }
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        _plugins.forEach { $0.didFailNavigation(error, in: webView) }
    }
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        _plugins.forEach { $0.didFailProvisionalNavigation(error, in: webView) }
    }
    public func webView(_ webView: WKWebView,
                        didReceive challenge: URLAuthenticationChallenge,
                        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        for p in _plugins {
            if p.authenticationChallenge(challenge, in: webView, completion: { disposition, credential in
                completionHandler(disposition, credential)
            }) {
                return
            }
        }
        completionHandler(.performDefaultHandling, nil)
    }
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        _plugins.forEach { $0.webContentProcessDidTerminate(in: webView) }
    }
}

extension DTB.WebView: WKUIDelegate {
    public func webViewDidClose(_ webView: WKWebView) {
        _plugins.forEach { $0.webViewDidClose(in: webView) }
    }
    public func webView(_ webView: WKWebView,
                        runJavaScriptAlertPanelWithMessage message: String,
                        initiatedByFrame frame: WKFrameInfo,
                        completionHandler: @escaping () -> Void) {
        for p in _plugins {
            if p.alertPanel(message: message, frame: frame, in: webView, completion: completionHandler) {
                return
            }
        }
        completionHandler()
    }
    public func webView(_ webView: WKWebView,
                        runJavaScriptConfirmPanelWithMessage message: String,
                        initiatedByFrame frame: WKFrameInfo,
                        completionHandler: @escaping (Bool) -> Void) {
        for p in _plugins {
            if p.confirmPanel(message: message, frame: frame, in: webView, completion: completionHandler) {
                return
            }
        }
        completionHandler(false)
    }
    public func webView(_ webView: WKWebView,
                        runJavaScriptTextInputPanelWithPrompt prompt: String,
                        defaultText: String?,
                        initiatedByFrame frame: WKFrameInfo,
                        completionHandler: @escaping (String?) -> Void) {
        for p in _plugins {
            if p.textInputPanel(prompt: prompt, defaultText: defaultText, frame: frame, in: webView, completion: completionHandler) {
                return
            }
        }
        completionHandler(nil)
    }
}
