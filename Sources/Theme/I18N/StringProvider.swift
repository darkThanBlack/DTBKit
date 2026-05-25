//
//  DTBKitString.swift
//  DTBKit
//
//  Created by moonShadow on 2023/12/28
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import Foundation

extension DTB.Providers {
    
    public static let stringKey = DTB.ConstKey<any StringProvider>("dtb.providers.string")
    
    public protocol StringProvider {
        
        func create(_ param: Any?) -> String
        
        func create(format key: String, _ args: [String]) -> String
    }
}
