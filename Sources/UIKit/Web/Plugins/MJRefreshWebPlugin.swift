//
//  WebViewMJRefreshPlugin.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/21
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

import WebKit

extension DTB {
    
    /// 下拉刷新
    public final class MJRefreshWebPlugin: NSObject, WebViewPlugin {
        
        public func didMoveToSuperview(in webView: WKWebView) {
            // TODO: 替换为项目的刷新库
            // webView.scrollView.mj_header = MJRefreshHeader { [weak webView] in
            //     webView?.reload()
            // }
        }
        public func willMoveToSuperview(_ newSuperview: UIView?, in webView: WKWebView) {
            // TODO: webView.scrollView.mj_header = nil
        }
        // MARK: - 结束刷新
        public func didFinishNavigation(in webView: WKWebView) {
            // TODO: webView.scrollView.mj_header?.endRefreshing()
        }
        public func didFailNavigation(_ error: Error, in webView: WKWebView) {
            // TODO: webView.scrollView.mj_header?.endRefreshing()
        }
        public func didFailProvisionalNavigation(_ error: Error, in webView: WKWebView) {
            // TODO: webView.scrollView.mj_header?.endRefreshing()
        }
        
    }
    
}
