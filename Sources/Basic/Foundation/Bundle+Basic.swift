//
//  UIBundle+DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/5
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension StaticWrapper where T: Bundle {
    
    /// Will enumerator .app path. | 在 .app 下预先全量搜索一次，不用再考虑代码/资源位置。
    ///
    /// - 如果传入 AnyClass, 直接通过 Bundle(for:) 创建
    ///
    /// - 如果传入 String, 认为是 *.bundle 的文件名
    ///
    /// - 如果传入 URL，认为是 *.bundle 的 path url
    public func create(_ param: Any?) -> Bundle? {
        
        /// 搜索 app 内所有的 Bundle
        ///
        /// - .app/*.bundle
        /// - .app/Frameworks/*.framework/*.bundle
        ///
        /// 其他路径下的 bundle 视为非法
        func searchAllBundles() -> [URL] {
            let fm = FileManager.default
            guard let rootContents = try? fm.contentsOfDirectory(
                at: Bundle.main.bundleURL,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: .skipsHiddenFiles
            ) else {
                return []
            }
            var results: [URL] = []
            for url in rootContents {
                guard let isDir = try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory, isDir else {
                    continue
                }
                // find: .app/*.bundle
                if url.pathExtension == "bundle" {
                    results.append(url)
                    continue
                }
                // enter: .app/Frameworks
                guard url.lastPathComponent == "Frameworks" else {
                    continue
                }
                guard let frameworks = try? fm.contentsOfDirectory(
                    at: url,
                    includingPropertiesForKeys: [.isDirectoryKey],
                    options: .skipsHiddenFiles
                ) else {
                    continue
                }
                // find: .app/Frameworks/*.framework/*.bundle
                for fw in frameworks {
                    guard let isDir = try? fw.resourceValues(forKeys: [.isDirectoryKey]).isDirectory,
                          isDir,
                          fw.pathExtension == "framework" else {
                        continue
                    }
                    if let inner = try? fm.contentsOfDirectory(
                        at: fw,
                        includingPropertiesForKeys: nil,
                        options: .skipsHiddenFiles
                    ) {
                        for innerURL in inner where innerURL.pathExtension == "bundle" {
                            results.append(innerURL)
                        }
                    }
                }
            }
            return results
        }
        
        if let c = param as? AnyClass {
            return Bundle(for: c)
        }
        
        let urlList: [URL] = {
            let urlsKey = DTB.ConstKey<[URL]>("dtb.all.bundles.url")
            if let cached = DTB.app.get(urlsKey), cached.isEmpty == false {
                return cached
            }
            let result = searchAllBundles()
            DTB.app.set(result, key: urlsKey)
            return result
        }()
        
        if let name = param as? String,
           let url = urlList.first(where: {
               $0.deletingPathExtension().lastPathComponent == name
           }) {
            return Bundle(url: url)
        }
        
        if let url = param as? URL,
           urlList.contains(where: { $0 == url }) {
            return Bundle(url: url)
        }
        
        return nil
    }
}
