//
//  WebViewCacheProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/6/30
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit
import WebKit

extension DTB {
    
    /// 缓存管理: WKWebView
    public class WebViewCacheProvider: DTB.Providers.CacheProvider {
        
        /// 允许业务直接调用
        public static func clear(types: Set<String>, completed: (() -> ())?) {
            WKWebsiteDataStore.default().removeData(
                ofTypes: types,
                modifiedSince: Date(timeIntervalSince1970: 0)
            ) {
                completed?()
            }
        }
        
        public init() {}
        
        public var primaryKey: String {
            return "wkwebview_cache"
        }
        
        public func calculateDiskSize(_ completed: ((Result<Int64, any Error>) -> ())?) {
            // 难以计算
            completed?(.success(0))
        }
        
        public func clearDisk(_ completed: ((Result<Void, any Error>) -> ())?) {
            Self.clear(types: WKWebsiteDataStore.allWebsiteDataTypes()) {
                completed?(.success(()))
            }
        }
        
    }
    
}
