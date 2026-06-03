//
//  KFCacheProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/6/30
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit
import Kingfisher

extension DTB {
    
    public class KFCacheProvider: Providers.CacheProvider {
        
        public init() {}
        
        public var primaryKey: String {
            return "kingfisher_cache"
        }
        
        public func calculateDiskSize(_ completed: ((Result<Int64, any Error>) -> ())?) {
            Kingfisher.ImageCache.default.calculateDiskStorageSize { result in
                switch result {
                case .success(let size):
                    completed?(.success(Int64(size)))
                case .failure(let error):
                    completed?(.failure(error))
                }
            }
        }
        
        public func clearDisk(_ completed: ((Result<Void, any Error>) -> ())?) {
            Kingfisher.ImageCache.default.clearDiskCache {
                Kingfisher.ImageCache.default.clearMemoryCache()
                completed?(.success(()))
            }
        }
    }
    
}
