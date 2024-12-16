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

/// Json
public extension DTBKitWrapper where Base == Data {
    
    /// Encoding to ``String``
    @inline(__always)
    func string(_ encoding: String.Encoding = .utf8) -> DTBKitWrapper<String>? {
        return String(data: me, encoding: encoding)?.dtb
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    @inline(__always)
    func json<T>() -> T? {
        return (try? JSONSerialization.jsonObject(with: me, options: JSONSerialization.ReadingOptions.allowFragments)) as? T
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    @inline(__always)
    func jsonDict() -> [String: Any]? {
        return json()
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    @inline(__always)
    func jsonArray() -> [Any]? {
        return json()
    }
}

public extension DTBKitWrapper where Base == Int16 {
    
    func bytes() -> [UInt8] {
        return [
            UInt8(truncatingIfNeeded: (me >> 8)) & 0xFF,
            UInt8(truncatingIfNeeded: (me >> 0)) & 0xFF
        ]
    }
}

public extension DTBKitWrapper where Base == Int32 {
    
    func bytes() -> [UInt8] {
        return [
            UInt8(truncatingIfNeeded: (me >> 24)) & 0xFF,
            UInt8(truncatingIfNeeded: (me >> 16)) & 0xFF,
            UInt8(truncatingIfNeeded: (me >> 8)) & 0xFF,
            UInt8(truncatingIfNeeded: (me >> 0)) & 0xFF
        ]
    }
}

public extension DTBKitWrapper where Base == Int64 {
    
    func bytes() -> [UInt8] {
        return [
            UInt8(truncatingIfNeeded: (me >> 56)) & 0xFF,
            UInt8(truncatingIfNeeded: (me >> 48)) & 0xFF,
            UInt8(truncatingIfNeeded: (me >> 40)) & 0xFF,
            UInt8(truncatingIfNeeded: (me >> 32)) & 0xFF,
            UInt8(truncatingIfNeeded: (me >> 24)) & 0xFF,
            UInt8(truncatingIfNeeded: (me >> 16)) & 0xFF,
            UInt8(truncatingIfNeeded: (me >> 8)) & 0xFF,
            UInt8(truncatingIfNeeded: (me >> 0)) & 0xFF
        ]
    }
}

/// Bytes
public extension DTBKitWrapper where Base == [UInt8] {
    
    func int(length: Int, offset: Int = 0) -> Int64? {
        guard (offset + (length - 1)) < me.count else {
            return nil
        }
        
        if length == 1 {
            return 0 +
            (Int64(me[offset + 0]) << 8) +
            (Int64(me[offset + 1]) << 0)
        }
        
        if length == 3 {
            return 0 +
            (Int64(me[offset + 0]) << 16) +
            (Int64(me[offset + 1]) << 8) +
            (Int64(me[offset + 2]) << 0)
        }
        
        if length == 4 {
            return 0 +
            (Int64(me[offset + 0]) << 24) +
            (Int64(me[offset + 1]) << 16) +
            (Int64(me[offset + 2]) << 8) +
            (Int64(me[offset + 3]) << 0)
        }
        
        if length == 8 {
            var result: Int64 = 0
            var high: Int64 = 0 +
            (Int64(me[offset + 0]) << 24) +
            (Int64(me[offset + 1]) << 16) +
            (Int64(me[offset + 2]) << 8) +
            (Int64(me[offset + 3]) << 0)
            
            var low: Int64 = 0 +
            (Int64(me[offset + 4]) << 24) +
            (Int64(me[offset + 5]) << 16) +
            (Int64(me[offset + 6]) << 8) +
            (Int64(me[offset + 7]) << 0)
            
            result = high * Int64(0xFFFFFFFF + 1) + low
            return result
        }
        
        return nil
    }
    
    func int16(offset: Int = 0) -> Int16? {
        guard (offset + 1) < me.count else {
            return nil
        }
        return 0
        + (Int16(me[offset + 0]) << 8)
        + (Int16(me[offset + 1]) << 0)
    }
    
    func int32(offset: Int = 0) -> Int32? {
        guard (offset + 3) < me.count else {
            return nil
        }
        return (Int32(me[offset + 0]) << 24)
        + (Int32(me[offset + 1]) << 16)
        + (Int32(me[offset + 2]) << 8)
        + (Int32(me[offset + 3]) << 0)
    }
    
    func int64(offset: Int = 0) -> Int64? {
        guard (offset + 7) < me.count else {
            return nil
        }
        var result: Int64 = 0
        let high: Int64 = 0 +
        (Int64(me[offset + 0]) << 24) +
        (Int64(me[offset + 1]) << 16) +
        (Int64(me[offset + 2]) << 8) +
        (Int64(me[offset + 3]) << 0)
        
        let low: Int64 = 0 +
        (Int64(me[offset + 4]) << 24) +
        (Int64(me[offset + 5]) << 16) +
        (Int64(me[offset + 6]) << 8) +
        (Int64(me[offset + 7]) << 0)
        
        result = high * Int64(0xFFFFFFFF + 1) + low
        return result
    }
}

