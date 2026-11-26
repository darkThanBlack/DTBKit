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

extension DTB.Wrapper where Base == String {
    
    /// Encoding to ``Data``
    @inline(__always)
    public func data(_ encoding: String.Encoding = .utf8, lossy: Bool = true) -> DTB.Wrapper<Data>? {
        return toData(encoding, lossy: lossy)?.dtb
    }
    
    /// Encoding to ``Data``
    @inline(__always)
    public func toData(_ encoding: String.Encoding = .utf8, lossy: Bool = true) -> Data? {
        return me.data(using: encoding, allowLossyConversion: lossy)
    }
}

public extension DTB.Wrapper where Base == Data {
    
    /// Convert to ``NSData``.
    @inline(__always)
    func ns() -> DTB.Wrapper<NSData> {
        return NSData(data: me).dtb
    }
    
    /// Encoding to ``String``
    @inline(__always)
    func string(_ encoding: String.Encoding = .utf8) -> DTB.Wrapper<String>? {
        return toString(encoding)?.dtb
    }
    
    /// Encoding to ``String``
    @inline(__always)
    func toString(_ encoding: String.Encoding = .utf8) -> String? {
        return String(data: me, encoding: encoding)
    }
}
