//
//  SystemAlertWebPlugin.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/20
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import WebKit

extension DTB {
    
    /// 响应 JS alert / confirm / prompt，使用系统 UIAlertController
    public final class SystemAlertWebPlugin: NSObject, WebViewPlugin {
        
        public func alertPanel(message: String,
                               frame: WKFrameInfo,
                               in webView: WKWebView,
                               completion: @escaping () -> Void) -> Bool {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
                completion()
            })
            UIViewController.dtb.topMost()?.present(alert, animated: true)
            return true
        }
        
        public func confirmPanel(message: String,
                                 frame: WKFrameInfo,
                                 in webView: WKWebView,
                                 completion: @escaping (Bool) -> Void) -> Bool {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in
                completion(false)
            })
            alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
                completion(true)
            })
            UIViewController.dtb.topMost()?.present(alert, animated: true)
            return true
        }
        
        public func textInputPanel(prompt: String,
                                   defaultText: String?,
                                   frame: WKFrameInfo,
                                   in webView: WKWebView,
                                   completion: @escaping (String?) -> Void) -> Bool {
            let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
            alert.addTextField { $0.text = defaultText }
            alert.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in
                completion(nil)
            })
            alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
                completion(alert.textFields?.first?.text)
            })
            UIViewController.dtb.topMost()?.present(alert, animated: true)
            return true
        }
        
    }
    
}
