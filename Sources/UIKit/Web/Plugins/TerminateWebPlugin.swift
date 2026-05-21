//
//  WebViewProcessTerminatePlugin.swift
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
    
    /// WebContent Process crash
    ///
    /// refer: https://www.jianshu.com/p/85f1710c3b32
    /// refer: https://juejin.cn/post/7103463814246760485
    /// refer: https://www.twblogs.net/a/5cfe4bdfbd9eee14644ebba1/?lang=zh-cn
    public final class TerminateWebPlugin: NSObject, WebViewPlugin {
        
        /// 防止频繁刷新
//        private var reloadCount = 0
//        private let maxReload = 2
        
        public func webContentProcessDidTerminate(in webView: WKWebView) {
//            guard reloadCount < maxReload else { return }
//            reloadCount += 1
            // 次数可能很多，不要随便限制
            webView.reload()
            // TODO: 页面崩溃统计
            // Analytics.track("webview_terminate", params: ["url": webView.url?.absoluteString ?? ""])
        }
        
        public func didFinishNavigation(in webView: WKWebView) {
//            reloadCount = 0
        }
        
    }
    
}
