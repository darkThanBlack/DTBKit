//
//  WebViewSystemHUDPlugin.swift
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
    
    public final class SystemHUDWebPlugin: NSObject, WebViewPlugin {
        
        public func didStartProvisionalNavigation(in webView: WKWebView) {
            // TODO: 显示 HUD — 替换为项目 HUD 库
            // xm.showHUD()
        }
        
        public func didFinishNavigation(in webView: WKWebView) {
            // TODO: 隐藏 HUD
            // xm.hideHUD()
        }
        
        public func didFailNavigation(_ error: Error, in webView: WKWebView) {
            // TODO: 隐藏 HUD
            // xm.hideHUD()
        }
        
        public func didFailProvisionalNavigation(_ error: Error, in webView: WKWebView) {
            // TODO: 隐藏 HUD
            // xm.hideHUD()
        }
        
    }
    
}
