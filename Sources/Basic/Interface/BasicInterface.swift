//
//  BasicInterface.swift
//  DTBKit
//
//  Created by moonShadow on 2025/7/23
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

public protocol ProviderRegister {
    
    static func registerProvider<T>(_ value: T?, key: DTB.ConstKey<T>)
    
    static func unregisterProvider<T>(_ key: DTB.ConstKey<T>)
}

extension ProviderRegister {
    
    public static func registerProvider<T>(_ value: T?, key: DTB.ConstKey<T>) {
        DTB.app.set(value, key: key)
    }
    
    public static func unregisterProvider<T>(_ key: DTB.ConstKey<T>) {
        DTB.app.set(nil, key: key)
    }
}

extension DTB {
    
    public enum BasicInterface: ProviderRegister {
        
        public static let stringKey = DTB.ConstKey<any StringProvider>("basic.service.string")
        
        public static let colorKey = DTB.ConstKey<any ColorProvider>("basic.service.color")
        
        public static let fontKey = DTB.ConstKey<any FontProvider>("basic.service.font")
        
        public static let windowKey = DTB.ConstKey<any WindowProvider>("basic.service.window")
        
        @available(iOS 13.0, *)
        public static let sceneKey = DTB.ConstKey<(any SceneProvider)>("basic.service.scene")
        
        public static let toastKey = DTB.ConstKey<(any ToastProvider)>("basic.service.toast")
        
        public static let hudKey = DTB.ConstKey<any HUDProvider>("basic.service.hud")
        
        public static let alertKey = DTB.ConstKey<any AlertProvider>("basic.service.alert")
    }
}
