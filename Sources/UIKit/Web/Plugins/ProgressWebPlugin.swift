//
//  WebViewProgressPlugin.swift
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
    
    public final class ProgressWebPlugin: NSObject, WebViewPlugin {
        
        // TODO: 替换为项目需要的进度输出方式
        // public let progressRelay = BehaviorRelay<Double>(value: 0)
        public func estimatedProgressChanged(_ progress: Double, in webView: WKWebView) {
            // TODO: 转发进度
            // progressRelay.accept(progress)
        }
        public func didFinishNavigation(in webView: WKWebView) {
            // TODO: 重置
            // progressRelay.accept(0)
        }
        public func didFailNavigation(_ error: Error, in webView: WKWebView) {
            // TODO: 重置
            // progressRelay.accept(0)
        }
        public func didFailProvisionalNavigation(_ error: Error, in webView: WKWebView) {
            // TODO: 重置
            // progressRelay.accept(0)
        }
        
    }

}
