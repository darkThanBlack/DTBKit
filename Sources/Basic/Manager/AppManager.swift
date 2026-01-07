//
//  AppManager.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/11
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// Memory dict / App data / etc.
    public final class AppManager {
        
        public static let shared = AppManager()
        private init() {}
        
        ///
        private var memory: [String: Any] = [:]
        
        ///
        private var weakMemory: [String: DTB.Weaker<AnyObject>] = [:]
        
        ///
        private let mLock = NSLock()
        
        ///
        private let wLock = NSLock()
        
        /// 从一个被单例持有的字典中读取数据，是否加锁取决于 ``key.useLock`` 参数。
        ///
        /// Read data from a dictionary owned by a singleton, do lock when ``key.useLock``.
        @inline(__always)
        public func get<Value>(_ key: DTB.ConstKey<Value>) -> Value? {
            guard key.useLock_ else {
                return memory[key.key_] as? Value
            }
            mLock.lock()
            defer { mLock.unlock() }
            return memory[key.key_] as? Value
        }
        
        /// 向一个被单例持有的字典中写入数据，是否加锁取决于 ``key.useLock`` 参数。
        ///
        /// Write data from a dictionary owned by a singleton, do lock when ``key.useLock``.
        @inline(__always)
        public func set<Value>(_ value: Value?, key: DTB.ConstKey<Value>) {
            guard key.useLock_ else {
                memory[key.key_] = value
                return
            }
            mLock.lock()
            defer { mLock.unlock() }
            memory[key.key_] = value
        }
        
        /// 从一个被单例持有的字典中读取弱引用对象，是否加锁取决于 ``key.useLock`` 参数。
        ///
        /// Read weak wrapped data from a dictionary owned by a singleton, do lock when ``key.useLock``.
        @inline(__always)
        public func getWeak<Value: AnyObject>(_ key: DTB.ConstKey<Value>) -> Value? {
            guard key.useLock_ else {
                if let result = weakMemory[key.key_]?.value as? Value {
                    return result
                } else {
                    weakMemory[key.key_] = nil
                    return nil
                }
            }
            wLock.lock()
            defer { wLock.unlock() }
            if let result = weakMemory[key.key_]?.value as? Value {
                return result
            } else {
                weakMemory[key.key_] = nil
                return nil
            }
        }
        
        /// 向一个被单例持有的字典中写入弱引用对象，是否加锁取决于 ``key.useLock`` 参数。
        ///
        /// Write weak wrapped data from a dictionary owned by a singleton, do lock when ``key.useLock``.
        @inline(__always)
        public func setWeak<Value: AnyObject>(_ value: Value?, key: DTB.ConstKey<Value>) {
            guard key.useLock_ else {
                weakMemory[key.key_] = DTB.Weaker(value)
                return
            }
            wLock.lock()
            defer { wLock.unlock() }
            weakMemory[key.key_] = DTB.Weaker(value)
        }
        
        //MARK: - 
        
        public func isDebug() -> Bool {
#if DEBUG
            return true
#else
            return false
#endif
        }
        
        //MARK: - Info.plist: https://developer.apple.com/documentation/bundleresources/information-property-list
        
        /// 在手机桌面上显示的应用名称
        ///
        /// App name on iPhone desktop. ``CFBundleDisplayName``.
        public var displayName: String {
            return (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? ""
        }
        
        /// 版本号
        ///
        /// ``CFBundleShortVersionString``
        public var version: String {
            return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
        }
        
        /// 构建号
        ///
        /// ``CFBundleVersion``
        public var build: String {
            return (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? ""
        }
    }
}
