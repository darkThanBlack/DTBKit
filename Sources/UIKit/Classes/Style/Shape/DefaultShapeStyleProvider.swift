//
//  DefaultShapeStyleProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/11
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB.DefaultShapeStyleProvider: DTB.Providers.ShapeStyleProvider {
    
    @inline(__always)
    public func create(_ param: Any?) -> DTB.ShapeStyle? {
        if let key = param as? String {
            return query(key)
        }
        return nil
    }
}

extension DTB {
    
    public final class DefaultShapeStyleProvider {
        
        private let mapper: [String: DTB.ShapeStyle]
        
        public func query(_ key: String) -> DTB.ShapeStyle? {
            return mapper[key]
        }
        
        public init?(json url: URL? = nil) {
            guard let fileUrl = url ?? Bundle.main.url(forResource: "shape_style", withExtension: "json") else {
                console.error("shape_style: json file not found")
                return nil
            }
            guard let data = try? Data(contentsOf: fileUrl),
                  let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: [String: Any]] else {
                console.error("shape_style: json parse failed")
                return nil
            }
            
            self.mapper = {
                var result: [String: DTB.ShapeStyle] = [:]
                dict.forEach { key, value in
                    guard let style = ShapeStyle(dict: value) else {
                        console.error("shape_style: invalid value for key=\(key)")
                        return
                    }
                    result[key] = style
                }
                return result
            }()
        }
        
    }
}
