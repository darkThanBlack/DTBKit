//
//  FileCacheProvider.swift
//  XMBundleL1
//
//  Created by moonShadow on 2025/7/18
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// 缓存管理: 指定目录
    public class FileCacheProvider: DTB.Providers.CacheProvider {
        
        public static let shared = FileCacheProvider()
        private init() {
            registerFileUrls(defUrls)
        }
        
        private var urls = Set<URL>()
        
        public let defUrls: [URL] = [
            // ``/library/Caches``
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
            // ``/tmp``
            FileManager.default.temporaryDirectory
        ].compactMap({ $0 })
        
        ///
        public func registerFileUrls(_ list: [URL]) {
            urls.formUnion(Set(list))
        }
        
        ///
        public func unregisterFileUrls(_ list: [URL]) {
            urls.subtract(Set(list))
        }
        
        public var primaryKey: String {
            return "file_cache"
        }
        
        public func calculateDiskSize(_ completed: ((Result<Int64, any Error>) -> ())?) {
            DispatchQueue.global().async {
                let totalSize: Int64 = self.urls.reduce(0) { res, next in
                    return res + DTB.DiskCacheManager.shared.querySize(next)
                }
                DispatchQueue.main.async {
                    completed?(.success(totalSize))
                }
            }
        }
        
        public func clearDisk(_ completed: ((Result<Void, any Error>) -> ())?) {
            DispatchQueue.global().async {
                self.urls.forEach { url in
                    if FileManager.default.fileExists(atPath: url.path) {
                        try? FileManager.default.removeItem(at: url)
                    }
                }
                DispatchQueue.main.async {
                    completed?(.success(()))
                }
            }
        }
        
    }
    
}
