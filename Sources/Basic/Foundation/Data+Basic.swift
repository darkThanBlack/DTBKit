//
//  Data+DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2024/10/22
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension Wrapper where Base == String {
    
    /// Encoding to ``Data``
    @inline(__always)
    public func data(_ encoding: String.Encoding = .utf8, lossy: Bool = true) -> Wrapper<Data>? {
        return me.data(using: encoding, allowLossyConversion: lossy)?.dtb
    }
}

public extension Wrapper where Base == Data {
    
    /// Convert to ``NSData``.
    @inline(__always)
    func ns() -> Wrapper<NSData> {
        return NSData(data: me).dtb
    }
    
    /// Encoding to ``String``
    @inline(__always)
    func string(_ encoding: String.Encoding = .utf8) -> Wrapper<String>? {
        return String(data: me, encoding: encoding)?.dtb
    }
}
