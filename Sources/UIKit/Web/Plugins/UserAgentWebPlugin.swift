//
//  WebViewUserAgentPlugin.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/21
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import WebKit

extension DTB {
    
    /// UserAgent 注入
    public final class UserAgentWebPlugin: NSObject, WebViewPlugin {
        
        private let customAgent: String
        public init(customAgent: String = "sport_ios") {
            self.customAgent = customAgent
        }
        /// loadURL 前调用（iOS 16 及以下）
        public func injectIfNeeded(in webView: WKWebView, completion: (() -> Void)?) {
            // TODO: 替换为项目 UA 拼接方式
            webView.evaluateJavaScript("navigator.userAgent") { [weak self] (result, erorr) in
                guard var userAgent = result as? String, erorr == nil else {
                    completion?()
                    return
                }
                if !userAgent.contains(self?.customAgent ?? "") {
                    userAgent = "\(userAgent) \(self?.customAgent ?? "")"
                }
                UserDefaults.standard.register(defaults: ["UserAgent": userAgent])
                webView.customUserAgent = userAgent
                completion?()
            }
        }
        
        /// iOS 17+ 在 didFinish 中补注
        public func didFinishNavigation(in webView: WKWebView) {
            if #available(iOS 17.0, *) {
                injectIfNeeded(in: webView, completion: nil)
            }
        }
    }

}

