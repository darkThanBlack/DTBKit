//
//  DefaultTextStyleProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB.DefaultTextStyleProvider: DTB.Providers.TextStyleProvider {
    
    @inline(__always)
    public func create(_ param: Any?) -> DTB.TextStyle? {
        if let key = param as? String {
            return query(key)
        }
        return nil
    }
}

extension DTB {
    
    public final class DefaultTextStyleProvider {
        
        private var mapper: [String: DTB.TextStyle] = [:]
        
        /// 根据 key 获取 TextStyle
        public func query(_ key: String) -> DTB.TextStyle? {
            return mapper[key]
        }
        
        public init?(json url: URL? = nil) {
            guard let fileUrl = url ?? Bundle.main.url(forResource: "text_style", withExtension: "json") else {
                console.error("text_style: json file not found")
                return nil
            }
            guard let data = try? Data(contentsOf: fileUrl),
                  let rawDict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
                console.error("text_style: json parse failed")
                return nil
            }
            
            rawDict.forEach { key, value in
                guard let dict = value as? [String: Any],
                      let font = dict["font"],
                      let textColor = dict["textColor"] else {
                    console.error("text_style: invalid value, key=\(key)")
                    return
                }
                let style = TextStyle(
                    font: .dtb.create(font),
                    textColor: .dtb.create(textColor)
                )
                self.mapper[key] = style
            }
        }
        
    }
    
}
