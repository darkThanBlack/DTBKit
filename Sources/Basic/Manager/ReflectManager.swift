//
//  ChainManager.swift
//  DTBKit_Basic
//
//  Created by moonShadow on 2026/1/7
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

public class ReflectManager {
    
    public static let shared = ReflectManager()
    private init() {}
    
    public func mirror(_ object: NSObject) -> [String: Any] {
        
        /// 递归
        func toValue(_ value: Any, visited: inout Set<ObjectIdentifier>) -> Any {
            let mirror = Mirror(reflecting: value)
            
            // 基础类型直接返回
            guard !mirror.children.isEmpty else {
                return value
            }
            
            let objectRef = value as AnyObject
            let objectId = ObjectIdentifier(objectRef)
            
            // 检查循环引用（只对引用类型）
            if visited.contains(objectId) {
                return "[循环引用: \(type(of: value))]"  // 👈 返回提示而不是崩溃
            }
            visited.insert(objectId)
            
            // 处理数组
            if let array = value as? [Any] {
                let result = array.map { toValue($0, visited: &visited) }
                // 移除访问记录（允许在不同路径中重复）
                visited.remove(ObjectIdentifier(objectRef))
                return result
            }
            
            // 处理自定义对象
            var nestedDict: [String: Any] = [:]
            for child in mirror.children {
                if let childKey = child.label {
                    nestedDict[childKey] = toValue(child.value, visited: &visited)
                }
            }
            
            // 处理完后移除访问记录
            visited.remove(ObjectIdentifier(objectRef))
            
            return nestedDict
        }
        
        var visitedObjects = Set<ObjectIdentifier>()
        let mirror = Mirror(reflecting: object)
        var dict: [String: Any] = [:]
        for child in mirror.children {
            if let key = child.label {
                dict[key] = toValue(child.value, visited: &visitedObjects)
            }
        }
        return dict
    }
}
