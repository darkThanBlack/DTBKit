//
//  WebViewPlugin.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/20
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import WebKit

extension DTB {
    
    /// 统一插件协议
    public protocol WebViewPlugin: AnyObject {
        
        /// 唯一标识（用于去重、移除）
        var identifier: String { get }
        
        /// 优先级，越小越靠前（decidePolicy / alert 等需要链式消费的场景用到）
        var priority: Int { get }
        
        // --- UIView
        
        ///
        func didMoveToSuperview(in webView: WKWebView)
        ///
        func didMoveToWindow(in webView: WKWebView)
        ///
        func willMoveToSuperview(_ newSuperview: UIView?, in webView: WKWebView)
        
        // --- WKNavigationDelegate
        
        /// decidePolicyFor navigationAction — 返回 false 终止加载
        func shouldAllowNavigation(_ action: WKNavigationAction, in webView: WKWebView) -> Bool
        
        /// decidePolicyFor navigationResponse — 返回 false 终止加载
        func shouldAllowNavigationResponse(_ response: WKNavigationResponse, in webView: WKWebView) -> Bool
        
        func didStartProvisionalNavigation(in webView: WKWebView)
        func didReceiveServerRedirect(in webView: WKWebView)
        func didCommitNavigation(in webView: WKWebView)
        func didFinishNavigation(in webView: WKWebView)
        func didFailNavigation(_ error: Error, in webView: WKWebView)
        func didFailProvisionalNavigation(_ error: Error, in webView: WKWebView)
        
        func authenticationChallenge(_ challenge: URLAuthenticationChallenge,
                                     in webView: WKWebView,
                                     completion: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Bool
        
        func webContentProcessDidTerminate(in webView: WKWebView)
        
        // --- WKUIDelegate
        
        func webViewDidClose(in webView: WKWebView)
        
        /// 返回 true 表示已处理，链终止
        func alertPanel(message: String, frame: WKFrameInfo, in webView: WKWebView, completion: @escaping () -> Void) -> Bool
        
        /// 返回 true 表示已处理，链终止
        func confirmPanel(message: String, frame: WKFrameInfo, in webView: WKWebView, completion: @escaping (Bool) -> Void) -> Bool
        
        /// 返回 true 表示已处理，链终止
        func textInputPanel(prompt: String, defaultText: String?, frame: WKFrameInfo, in webView: WKWebView, completion: @escaping (String?) -> Void) -> Bool
        
        // --- KVO
        
        func estimatedProgressChanged(_ progress: Double, in webView: WKWebView)
        func isLoadingChanged(_ loading: Bool, in webView: WKWebView)
        func titleChanged(_ title: String?, in webView: WKWebView)
        func urlChanged(_ url: URL?, in webView: WKWebView)
    }
}

/// 默认空实现（每个 Plugin 只 override 自己关心的）
public extension DTB.WebViewPlugin {
    
    var identifier: String { return String(describing: self) }
    
    var priority: Int { 500 }
    
    // --- UIView
    
    ///
    func didMoveToSuperview(in webView: WKWebView) {}
    ///
    func didMoveToWindow(in webView: WKWebView) {}
    ///
    func willMoveToSuperview(_ newSuperview: UIView?, in webView: WKWebView) {}
    
    // --- WKNavigationDelegate
    
    func shouldAllowNavigation(_ action: WKNavigationAction, in webView: WKWebView) -> Bool { true }
    func shouldAllowNavigationResponse(_ response: WKNavigationResponse, in webView: WKWebView) -> Bool { true }
    func didStartProvisionalNavigation(in webView: WKWebView) {}
    func didReceiveServerRedirect(in webView: WKWebView) {}
    func didCommitNavigation(in webView: WKWebView) {}
    func didFinishNavigation(in webView: WKWebView) {}
    func didFailNavigation(_ error: Error, in webView: WKWebView) {}
    func didFailProvisionalNavigation(_ error: Error, in webView: WKWebView) {}
    func authenticationChallenge(_ challenge: URLAuthenticationChallenge,
                                 in webView: WKWebView,
                                 completion: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Bool { false }
    func webContentProcessDidTerminate(in webView: WKWebView) {}
    
    // --- WKUIDelegate
    
    func webViewDidClose(in webView: WKWebView) {}
    func alertPanel(message: String, frame: WKFrameInfo, in webView: WKWebView, completion: @escaping () -> Void) -> Bool { false }
    func confirmPanel(message: String, frame: WKFrameInfo, in webView: WKWebView, completion: @escaping (Bool) -> Void) -> Bool { false }
    func textInputPanel(prompt: String, defaultText: String?, frame: WKFrameInfo, in webView: WKWebView, completion: @escaping (String?) -> Void) -> Bool { false }
    
    // --- KVO
    
    func estimatedProgressChanged(_ progress: Double, in webView: WKWebView) {}
    func isLoadingChanged(_ loading: Bool, in webView: WKWebView) {}
    func titleChanged(_ title: String?, in webView: WKWebView) {}
    func urlChanged(_ url: URL?, in webView: WKWebView) {}
}
