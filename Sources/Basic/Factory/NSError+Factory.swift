//
//  Error+Factory.swift
//  DTBKit
//
//  Created by moonShadow on 2025/11/7
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB.StaticWrapper where T == NSError {

    public func create(_ message: String?, code: Int = -1) -> NSError {
        guard let str = message, str.isEmpty == false else {
            return NSError(
                domain: "dtb.error",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: " is nil"]
            )
        }
        return NSError(
            domain: "dtb.error",
            code: code,
            userInfo: [NSLocalizedDescriptionKey: str]
        )
    }

    public func ignore() -> NSError {
        return NSError(
            domain: "dtb.error",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: ""]
        )
    }
}
