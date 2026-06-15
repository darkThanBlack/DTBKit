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

extension DTB.TextStyleManager: DTB.Providers.TextStyleProvider {
    
    @inline(__always)
    public func create(_ param: Any?) -> DTB.TextStyle? {
        if let key = param as? String {
            return query(key)
        }
        return nil
    }
}

extension DTB {
    
    public final class TextStyleManager {
        
        public static let shared = TextStyleManager()
        
        private var mapper: [String: DTB.TextStyle] = [:]
        
        private init() {
            parseTextStyleJSON()
        }
        
        /// 根据 key 获取 TextStyle
        public func query(_ key: String) -> DTB.TextStyle? {
            return mapper[key]
        }
        
        // MARK: - JSON Parser
        
        private func parseTextStyleJSON() {
            guard let filePath = Bundle.main.path(forResource: "text_style", ofType: "json") else {
                console.error("text_style.json not found")
                return
            }
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                  let rawDict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
                console.error("text_style.json parse fail")
                return
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
