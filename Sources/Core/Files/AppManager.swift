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
    
    /// 应用级数据 / 内存处理 / 其他
    public static let app = AppManager.shared
}

/// 应用级数据 / 内存处理 / 其他
///
/// Memory dict / App data / etc.
public class AppManager {
    
    public static let shared = AppManager()
    private init() {}
    
    /// 持有在内存中
    private var memory: [String: Any] = [:]
    
    /// 持有在内存中，但是弱引用
    private var weakMemory: [String: DTB.Weaker<AnyObject>] = [:]
    
    private let mLock = NSLock()
    
    private let wLock = NSLock()
    
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
    
    /// 向一个被单例持有的字典中清除数据，已加锁。
    public func clearMemory<T>(_ key: DTB.ConstKey<T>) {
        writeMemory(nil, key: key)
    }
    
    /// 从一个被单例持有的字典中读取弱引用对象，已加锁。
    public func readWeak<T: AnyObject>(_ key: DTB.ConstKey<T>) -> T? {
        wLock.lock()
        defer { wLock.unlock() }
        
        if let result = weakMemory[key.key_]?.me as? T {
            return result
        } else {
            weakMemory[key.key_] = nil
            return nil
        }
    }
    
    /// 向一个被单例持有的字典中写入弱引用对象，已加锁。
    public func writeWeak<T: AnyObject>(_ value: T?, key: DTB.ConstKey<T>) {
        wLock.lock()
        defer { wLock.unlock() }
        
        weakMemory[key.key_] = DTB.Weaker(value)
    }
    
    /// 在手机桌面上显示的应用名称
    ///
    /// App name on iPhone desktop. ``CFBundleDisplayName``.
    public func displayName() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? ""
    }
    
    /// 版本号
    ///
    /// ``CFBundleShortVersionString``
    public func version() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
    }
    
    /// 构建号
    ///
    /// ``CFBundleVersion``
    public func build() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? ""
    }
}
