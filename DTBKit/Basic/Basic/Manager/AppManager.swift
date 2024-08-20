//
//  AppManager.swift
//  XMKit
//
//  Created by moonShadow on 2024/1/11
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// 用于声明带类型推断的静态常量。
    ///
    /// Represents a `Key` with an associated generic value type.
    ///
    /// Example:
    /// ```
    ///     let key = DTB.ConstKey<[String: Any]>("myUserDefaultsKey")
    /// ```
    public struct ConstKey<ValueType> {
        
        internal let key_: String
        
        public init(_ key: String) {
            self.key_ = key
        }
    }
}

extension DTB {
    
    /// 应用级数据 / 内存处理 / 其他
    public static let app = AppManager.shared
}

/// 应用级数据 / 内存处理 / 其他
///
/// Memory dict / App data / etc.
public final class AppManager {
    
    public static let shared = AppManager()
    private init() {}
    
    /// 持有在内存中
    private var memory: [String: Any] = [:]
    
    private let mLock = NSLock()
    
    /// 从一个被单例持有的字典中读取数据，已加锁。
    public func readMemory<Value>(_ key: DTB.ConstKey<Value>) -> Value? {
        mLock.lock()
        defer { mLock.unlock() }
        
        return memory[key.key_] as? Value
    }
    
    /// 向一个被单例持有的字典中写入数据，已加锁。
    public func writeMemory<Value>(_ value: Value?, key: DTB.ConstKey<Value>) {
        mLock.lock()
        defer { mLock.unlock() }
        
        memory[key.key_] = value
    }
    
    public func clearMemory<T>(_ key: DTB.ConstKey<T>) {
        writeMemory(nil, key: key)
    }
    
    /// 弱引用字典包装器
    private class Weaker {
        weak var me: AnyObject?
        
        init(_ me: AnyObject? = nil) {
            self.me = me
        }
    }
    
    /// 持有在内存中，但是弱引用
    private var weakMemory: [String: Weaker] = [:]
    
    private let wLock = NSLock()
    
    /// 从一个被单例持有的字典中读取弱引用对象，已加锁。
    public func readWeak<Value: AnyObject>(_ key: DTB.ConstKey<Value>) -> Value? {
        wLock.lock()
        defer { wLock.unlock() }
        
        if let result = weakMemory[key.key_]?.me {
            return result as? Value
        } else {
            weakMemory[key.key_] = nil
            return nil
        }
    }
    
    /// 向一个被单例持有的字典中写入弱引用对象，已加锁。
    public func writeWeak<Value: AnyObject>(_ value: Value?, key: DTB.ConstKey<Value>) {
        wLock.lock()
        defer { wLock.unlock() }
        
        weakMemory[key.key_] = Weaker(value)
    }
    
    /// 在手机桌面上显示的应用名称
    ///
    /// App name on iPhone desktop. ``CFBundleDisplayName``.
    public let displayName: String = {
        if let result = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) {
            return result
        }
        return ""
    }()
    
    /// 版本号
    ///
    /// ``CFBundleShortVersionString``
    public let version: String = {
        if let result = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) {
            return result
        }
        return ""
    }()
    
    /// 构建号
    ///
    /// ``CFBundleVersion``
    public let build: String = {
        if let result = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) {
            return result
        }
        return ""
    }()
}
