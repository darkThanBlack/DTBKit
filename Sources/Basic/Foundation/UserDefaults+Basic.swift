//
//  UserDefaults+DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/11
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension StaticWrapper where T: UserDefaults {
    
    ///
    public func clear<Value>(_ key: DTB.ConstKey<Value>) {
        UserDefaults.standard.removeObject(forKey: key.key_)
    }
    
    // MARK: - Original
    
    /// Check is storable value
    public func isVaild<Value>(_ key: DTB.ConstKey<Value>) -> Bool {
        return (Value.self is String.Type)
        || (Value.self is Bool.Type)
        || (Value.self is Int.Type)
        || (Value.self is Int64.Type)
        || (Value.self is Float.Type)
        || (Value.self is Double.Type)
        || (Value.self is Date.Type)
        || (Value.self is Data.Type)
    }
    
    ///
    public func read<Value>(_ key: DTB.ConstKey<Value>) -> Value? {
        return UserDefaults.standard.object(forKey: key.key_) as? Value
    }
    
    ///
    public func write<Value>(_ value: Value?, key: DTB.ConstKey<Value>) {
        UserDefaults.standard.set(value, forKey: key.key_)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Codable
    
    public func read<Value: Codable>(codable key: DTB.ConstKey<Value>) -> Value? {
        if let data = UserDefaults.standard.data(forKey: key.key_),
           let result = try? JSONDecoder().decode(Value.self, from: data) {
            return result
        }
        return nil
    }
    
    ///
    public func write<Value: Codable>(codable: Value, key: DTB.ConstKey<Value>) {
        if let data = try? JSONEncoder().encode(codable) {
            UserDefaults.standard.set(data, forKey: key.key_)
            UserDefaults.standard.synchronize()
        }
    }
}
