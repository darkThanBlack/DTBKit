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
            code: 0,
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
