//
//  SDCacheProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/6/30
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit
import SDWebImage

extension DTB {
    
    public class SDCacheProvider: Providers.CacheProvider {
        
        public init() {}
        
        public var primaryKey: String {
            return "sdwebimage_cache"
        }
        
        public func calculateDiskSize(_ completed: ((Result<Int64, any Error>) -> ())?) {
            SDImageCache.shared.calculateSize { fileCount, totalSize in
                // totalSize 单位是字节，UInt -> Int64
                completed?(.success(Int64(totalSize)))
            }
        }
        
        public func clearDisk(_ completed: ((Result<Void, any Error>) -> ())?) {
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk {
                completed?(.success(()))
            }
        }
    }
}
