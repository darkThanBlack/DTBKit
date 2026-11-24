//
//  ConsoleProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/11/5
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import Foundation

extension DTB.Providers {
    
    public static let consoleKey = DTB.ConstKey<any ConsoleProvider>("dtb.providers.console")
    
    public protocol ConsoleProvider: AnyObject {
        
        func log(_ item: Any, file: String, line: Int, function: String)
        
        func error(_ item: Any?, file: String, line: Int, function: String)
        
        func assert(_ item: Any?, file: String, line: Int, function: String)
    }
}
