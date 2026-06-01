//
//  DiskCacheManager.swift
//  XMKit
//
//  Created by moonShadow on 2025/6/27
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    
import Foundation
import UIKit

extension DTB.Providers {
    
    /// 业务协议
    public protocol CacheProvider {
        /// 唯一标识符
        var primaryKey: String { get }
        
        /// 计算缓存大小, 单位为 Bytes
        func calculateDiskSize(_ completed: ((Result<Int64, Error>) -> ())?)
        
        /// 清理缓存
        func clearDisk(_ completed: ((Result<Void, Error>) -> ())?)
    }
}

extension DTB {
    
    /// 存储空间信息管理器
    ///
    /// 所有方法必须在主线程调用
    public class DiskCacheManager {
        
        public static let shared = DiskCacheManager()
        private init() {}
        
        private var locker: [String: Bool] = [:]
        
        private var providers: [String: Providers.CacheProvider] = [:]
        
        ///
        public func registerDiskProviders(_ list: [Providers.CacheProvider]) {
            list.forEach({
                providers[$0.primaryKey] = $0
            })
        }
        
        ///
        public func unregisterDiskProviders(_ keys: [String]) {
            keys.forEach({
                providers.removeValue(forKey: $0)
            })
        }
        
        /// 文本转换
        public func formatFileSize(_ bytes: Int64) -> String {
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = [.useKB, .useMB, .useGB]
            formatter.countStyle = .file
            return formatter.string(fromByteCount: bytes)
        }
        
        /// 手机磁盘用量
        public struct PhoneInfo: Codable {
            /// 总容量
            public let total: Int64
            
            /// 可用容量
            public let free: Int64
            
            /// 总已用(估算)
            public var totalUsed: Int64 {
                return total - free
            }
        }
        
        /// 手机占用
        public func calculatePhoneDiskInfo(completed: ((PhoneInfo?) -> ())?) -> Void {
            let key = "calculatePhoneDiskInfo"
            guard locker[key] != true else {
                return
            }
            locker[key] = true
            
            DispatchQueue.global().async {
                let result: PhoneInfo? = {
                    if let values = try? URL(fileURLWithPath: NSHomeDirectory()).resourceValues(forKeys: [
                        .volumeTotalCapacityKey,
                        .volumeAvailableCapacityKey
                    ]),
                       let total = values.volumeTotalCapacity,
                       let free = values.volumeAvailableCapacity {
                        // 不使用 volumeAvailableCapacityForImportantUsage, 因为实测无效
                        return PhoneInfo(total: Int64(total), free: Int64(free))
                    }
                    return nil
                }()
                DispatchQueue.main.async {
                    self.locker[key] = false
                    completed?(result)
                }
            }
        }
        
        /// APP 总占用
        public func calculateAppDiskUsage(completed: ((Int64) -> ())?) -> Void {
            let key = "calculateAppDiskUsage"
            guard locker[key] != true else {
                return
            }
            locker[key] = true
            
            DispatchQueue.global().async {
                let urls: [URL] = [
                    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                    FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first,
                    FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
                    FileManager.default.temporaryDirectory
                ].compactMap({ item in
                    if let url = item, FileManager.default.fileExists(atPath: url.path) {
                        return item
                    }
                    return nil
                })
                
                let totalSize: Int64 = urls.reduce(0) { res, next in
                    return res + self.querySize(next)
                }
                
                DispatchQueue.main.async {
                    self.locker[key] = false
                    completed?(totalSize)
                }
            }
        }
        
        /// [递归] 计算指定目录大小
        ///
        /// 在当前线程直接执行
        public func querySize(_ url: URL) -> Int64 {
            var totalSize: Int64 = 0
            
            // 获取目录内容
            guard let contents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) else {
                return totalSize
            }
            
            // 遍历所有内容
            for fileURL in contents {
                var isDirectory: ObjCBool = false
                if FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDirectory) {
                    if isDirectory.boolValue {
                        // 递归计算子目录大小
                        totalSize += querySize(fileURL)
                    } else {
                        // 获取文件大小
                        if let attributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
                           let size = attributes[.size] as? Int64 {
                            totalSize += size
                        }
                    }
                }
            }
            return totalSize
        }
        
        /// 计算自定义缓存大小
        ///
        /// - Parameters:
        ///   - keys: nil 时，对所有注册的 providers 执行操作
        ///   - completed: 主线程回调
        public func calculateDiskSizes(
            by keys: [String]? = nil,
            completed: (([String: Int64]) -> Void)?
        ) {
            let key = "calculateDiskSizes"
            guard locker[key] != true else {
                return
            }
            locker[key] = true
            
            let group = DispatchGroup()
            var results: [String: Int64] = [:]
            
            let list = keys?.compactMap({ providers[$0] }) ?? providers.compactMap({ $0.value })
            
            for provider in list {
                group.enter()
                provider.calculateDiskSize { result in
                    switch result {
                    case .success(let size):
                        results[provider.primaryKey] = size
                    case .failure:
                        results[provider.primaryKey] = 0
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.locker[key] = false
                completed?(results)
            }
        }
        
        /// 清理自定义缓存
        ///
        /// - Parameters:
        ///   - keys: nil 时，对所有注册的 providers 执行操作
        ///   - completed: 主线程回调
        public func clearDisks(
            by keys: [String]? = nil,
            completed: (([String: Bool]) -> ())?
        ) {
            let key = "clearDisks"
            guard locker[key] != true else {
                return
            }
            locker[key] = true
            
            let group = DispatchGroup()
            var results: [String: Bool] = [:]
            
            let list = keys?.compactMap({ providers[$0] }) ?? providers.compactMap({ $0.value })
            
            for provider in list {
                group.enter()
                provider.clearDisk { result in
                    switch result {
                    case .success:
                        results[provider.primaryKey] = true
                    case .failure:
                        results[provider.primaryKey] = false
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.locker[key] = false
                completed?(results)
            }
        }
    }

}
