//
//  UIBundle+XMKit.swift
//  XMKit
//
//  Created by moonShadow on 2024/1/5
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTBKitStaticWrapper where T: Bundle {
    
    /// Will enumerator main path.
    ///
    /// 在 main bundle 下的全路径中搜索并创建 bundle.
    ///
    /// - Parameters:
    ///   - name: bundle name.
    ///   - cacheable: use ``bundleIdentifier`` to cache.
    /// - Returns: Bundle
    public func create(_ name: String, cacheable: Bool = true) -> Bundle? {
        
        let key = DTB.ConstKey<[String: String]>("DTBKitLoadedBundles")
        
        if cacheable,
           let identifier = DTB.app.readMemory(key)?[name],
           let result = Bundle(identifier: identifier) {
            return result
        }
        
        func storeCache(_ bundle: Bundle) {
            if let identifier = bundle.bundleIdentifier, identifier.isEmpty == false {
                var dict = DTB.app.readMemory(key) ?? [:]
                dict[name] = identifier
                DTB.app.writeMemory(dict, key: key)
            }
        }
        
        // main/*.bundle
        if let path = Bundle.main.path(forResource: name, ofType: "bundle"),
           let result = Bundle(path: path) {
            storeCache(result)
            return result
        }
        
        // main/**/*.bundle
        if let mainPath = Bundle.main.resourcePath,
           let dirEnum = FileManager.default.enumerator(atPath: mainPath) {
            while let file = dirEnum.nextObject() as? String {
                if file.hasSuffix(".bundle"),
                   let result = Bundle(path: "\(mainPath)/\(file)") {
                    storeCache(result)
                    return result
                }
            }
        }
        
        return nil
    }
}
