//
//  DefaultGradientStyleProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/11
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.DefaultGradientStyleProvider: DTB.Providers.GradientStyleProvider {
    @inline(__always)
    public func create(_ param: Any?) -> DTB.GradientStyle? {
        if let key = param as? String {
            return query(key)
        }
        return nil
    }
}
extension DTB {
    
    public final class DefaultGradientStyleProvider {
        
        private let mapper: [String: DTB.GradientStyle]
        
        public func query(_ key: String) -> DTB.GradientStyle? {
            return mapper[key]
        }
        
        public init?(json url: URL? = nil) {
            guard let fileUrl = url ?? Bundle.main.url(forResource: "gradient_style", withExtension: "json") else {
                console.error("gradient_style: json file not found")
                return nil
            }
            guard let data = try? Data(contentsOf: fileUrl),
                  let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: [String: Any]] else {
                console.error("gradient_style: json parse failed")
                return nil
            }
            
            self.mapper = {
                var result: [String: DTB.GradientStyle] = [:]
                dict.forEach { key, value in
                    guard let style = GradientStyle(dict: value) else {
                        console.error("gradient_style: invalid value for key=\(key)")
                        return
                    }
                    result[key] = style
                }
                return result
            }()
        }
    }
}
