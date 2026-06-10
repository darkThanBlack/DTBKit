//
//  DefaultButtonStyleProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/10
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.DefaultButtonStyleProvider: DTB.Providers.ButtonStyleProvider {
    
    @inline(__always)
    public func create(_ param: Any?) -> DTB.ButtonStyle? {
        if let key = param as? String {
            return query(key)
        }
        return nil
    }
}

extension DTB {
    
    public final class DefaultButtonStyleProvider {
        
        public static let shared = DefaultButtonStyleProvider()
        
        private var mapper: [String: DTB.ButtonStyle] = [:]
        
        private init() {
            parseButtonStyleJSON()
        }
        
        public func query(_ key: String) -> DTB.ButtonStyle? {
            return mapper[key]
        }
        
        private func parseButtonStyleJSON() {
            guard let filePath = Bundle.main.path(forResource: "button_style", ofType: "json") else {
                console.error("button_style.json not found")
                return
            }
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                  let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: [String: Any]] else {
                console.error("button_style.json parse fail")
                return
            }
            
            dict.forEach { key, value in
                guard let style = ButtonStyle(dict: value) else {
                    console.error("button_style: invalid value for key=\(key)")
                    return
                }
                self.mapper[key] = style
            }
        }
    }
}
