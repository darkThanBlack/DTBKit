//
//  Error+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/11/7
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension StaticWrapper where T == NSError {
    
    /// 快速创建 NSError 对象
    ///
    /// - Parameters:
    ///   - message: 展示给用户看的信息, localizedDescription | NSLocalizedDescriptionKey
    ///   - code: -1
    ///   - reason: 记录在日志 / 给开发者看的信息, localizedFailureReason | NSLocalizedFailureReasonErrorKey
    ///
    /// - Returns: NSError
    public func create(_ message: String?, code: Int = -1) -> NSError {
        guard let str = message, str.isEmpty == false else {
            return empty()
        }
        var userInfo: [String: Any] = [NSLocalizedDescriptionKey: str]
//        if let str = reason, str.isEmpty == false {
//            userInfo[NSLocalizedFailureReasonErrorKey] = str
//        }
        return NSError(
            domain: "dtb.error",
            code: code,
            userInfo: userInfo
        )
    }
    
    public func ignore() -> NSError {
        return NSError(
            domain: "dtb.error",
            code: 0,
            userInfo: [
                NSLocalizedDescriptionKey: ""
            ]
        )
    }
    
    public func empty(_ name: String? = nil) -> NSError {
        return NSError(
            domain: "dtb.error",
            code: -1,
            userInfo: [
                NSLocalizedDescriptionKey: "\(name ?? "") is nil"
            ]
        )
    }
    
    public func isEmpty(_ name: String? = nil) -> NSError {
        return NSError(
            domain: "dtb.error",
            code: -1,
            userInfo: [
                NSLocalizedDescriptionKey: "\(name ?? "") is nil"
            ]
        )
    }
    
    public func reason(_ value: String?) -> NSError {
        return NSError(
            domain: "dtb.error",
            code: -1,
            userInfo: [
                NSLocalizedDescriptionKey: value ?? ""
            ]
        )
    }
}
