//
//  WebViewAutoTitlePlugin.swift
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
    
    public final class TitleWebPlugin: NSObject, WebViewPlugin {
        
        // TODO: handle vc
        public var onTitleChanged: ((String?) -> Void)?
        
        public func titleChanged(_ title: String?, in webView: WKWebView) {
            onTitleChanged?(title)
        }
        
    }
    
}
