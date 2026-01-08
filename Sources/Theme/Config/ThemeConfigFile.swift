//
//  ThemeConfigFileModel.swift
//  DTBKit
//
//  Created by moonShadow on 2025/9/29
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// 整合配置文件对象
public protocol ThemeConfigFile: Codable {
    
    var key: String? { get }
    
    var name: String? { get }
    
    var type: String? { get }
    
    var path: String? { get }
}

public struct ThemeConfigFileModel: ThemeConfigFile {
    
    public var key: String?
    
    public var name: String?
    
    public var type: String?
    
    public var path: String?
    
    public init(key: String? = nil, name: String? = nil, type: String? = nil, path: String? = nil) {
        self.key = key
        self.name = name
        self.type = type
        self.path = path
    }
}
