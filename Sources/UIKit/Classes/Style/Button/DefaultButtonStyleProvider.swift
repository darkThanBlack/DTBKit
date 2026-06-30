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
        
        private let mapper: [String: DTB.ButtonStyle]
        
        public func query(_ key: String) -> DTB.ButtonStyle? {
            return mapper[key]
        }
        
        public init?(json url: URL? = nil) {
            guard let fileUrl = url ?? Bundle.main.url(forResource: "button_style", withExtension: "json") else {
                console.error("button_style: json file not found")
                return nil
            }
            guard let data = try? Data(contentsOf: fileUrl),
                  let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: [String: Any]] else {
                console.error("button_style: json parse failed")
                return nil
            }
            
            self.mapper = {
                var result: [String: DTB.ButtonStyle] = [:]
                dict.forEach { key, value in
                    guard let style = ButtonStyle(dict: value) else {
                        console.error("button_style: invalid value for key=\(key)")
                        return
                    }
                    result[key] = style
                }
                return result
            }()
        }
    }
}
