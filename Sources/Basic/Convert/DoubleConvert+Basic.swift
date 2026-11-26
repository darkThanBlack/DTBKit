//
//  DoubleConvert+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/18
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB.Wrapper where Base: BinaryFloatingPoint {
    
    // MARK: -
    
    @inline(__always)
    public func doubleValue() -> Double {
        return Double(me)
    }
    
    // MARK: - Force convert
    
    /// Force convert with ``Int(me)``.
    @inline(__always)
    public func int() -> DTB.Wrapper<Int> {
        return Int(doubleValue()).dtb
    }
    
    /// Force convert with ``Int64(me)``.
    @inline(__always)
    public func int64() -> DTB.Wrapper<Int64> {
        return Int64(doubleValue()).dtb
    }
    
    @inline(__always)
    public func nsNumber() -> DTB.Wrapper<NSNumber> {
        return NSNumber(value: doubleValue()).dtb
    }
    
    @inline(__always)
    public func nsDecimal() -> DTB.Wrapper<NSDecimalNumber> {
        return NSDecimalNumber(value: doubleValue()).dtb
    }
    
    /// ``"\(me)"``
    @inline(__always)
    public func string() -> DTB.Wrapper<String> {
        return "\(me)".dtb
    }
    
    // MARK: - Date
    
    /// From 's' timeStamp (length == 10) | 从 10 位秒级时间戳生成
    @inline(__always)
    public func sDate() -> DTB.Wrapper<Date> {
        return Date.dtb(s: me).dtb
    }
    
    /// From 'ms' timeStamp (length == 13) | 从 13 位毫秒级时间戳生成
    @inline(__always)
    public func msDate() -> DTB.Wrapper<Date> {
        return Date.dtb(ms: me).dtb
    }
    
    /// s -> ms, me * 1000
    @inline(__always)
    public func sToMS() -> DTB.Wrapper<Double> {
        return (Double(me) * 1000).dtb
    }
    
    /// ms -> s, me / 1000
    @inline(__always)
    public func msToS() -> DTB.Wrapper<Double> {
        return (Double(me) / 1000).dtb
    }
    
}
