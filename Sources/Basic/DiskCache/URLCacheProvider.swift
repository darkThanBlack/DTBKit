//
//  URLCacheProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/6/30
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// 缓存管理: 原生请求
    public class URLCacheProvider: DTB.Providers.CacheProvider {
        
        /// 允许业务直接调用
        public static func clear(completed: (() -> ())?) {
            // 确保用户设置不会被更改
            let originalDiskCapacity = URLCache.shared.diskCapacity
            let originalMemoryCapacity = URLCache.shared.memoryCapacity
            
            // 暂时将容量设置为0以确保完全清除
            URLCache.shared.diskCapacity = 0
            URLCache.shared.memoryCapacity = 0
            
            URLCache.shared.removeAllCachedResponses()
            
            // 使用短暂延迟确保清理操作完成
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                URLCache.shared.diskCapacity = originalDiskCapacity
                URLCache.shared.memoryCapacity = originalMemoryCapacity
                
                completed?()
            }
        }
        
        public init() {}
        
        public var primaryKey: String {
            return "url_cache"
        }
        
        public func calculateDiskSize(_ completed: ((Result<Int64, any Error>) -> ())?) {
            // 难以计算: 使用 usage 作为近似值
            completed?(.success(Int64(URLCache.shared.currentDiskUsage)))
        }
        
        public func clearDisk(_ completed: ((Result<Void, any Error>) -> ())?) {
            Self.clear {
                completed?(.success(()))
            }
        }
    }
}
