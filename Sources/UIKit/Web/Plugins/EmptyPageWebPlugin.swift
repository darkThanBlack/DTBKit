//
//  WebViewEmptyPagePlugin.swift
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
    
    ///
    public final class EmptyPageWebPlugin: NSObject, WebViewPlugin {
        
        public func didFinishNavigation(in webView: WKWebView) {
            // TODO: 隐藏空白页
            // (webView as? SportWebView)?.hideEmptyView()
        }
        
        public func didFailNavigation(_ error: Error, in webView: WKWebView) {
            // TODO: 显示空白页
            // (webView as? SportWebView)?.showEmptyView()
        }
        
        public func didFailProvisionalNavigation(_ error: Error, in webView: WKWebView) {
            // TODO: 显示空白页
            // (webView as? SportWebView)?.showEmptyView()
        }
    }
    
}
