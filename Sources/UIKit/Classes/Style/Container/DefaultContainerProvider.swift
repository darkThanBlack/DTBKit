//
//  DefaultContainerProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/30
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.DefaultContainerStyleProvider: DTB.Providers.ContainerStyleProvider {
    
    @inline(__always)
    public func create(_ param: Any?) -> DTB.ContainerStyle? {
        if let key = param as? String {
            return query(key)
        }
        return nil
    }
}
extension DTB {
    
    public final class DefaultContainerStyleProvider {
        
        private let mapper: [String: DTB.ContainerStyle]
        
        public func query(_ key: String) -> DTB.ContainerStyle? {
            return mapper[key]
        }
        
        public init?(json url: URL? = nil) {
            guard let fileUrl = url ?? Bundle.main.url(forResource: "container_style", withExtension: "json") else {
                console.error("container_style: json file not found")
                return nil
            }
            guard let data = try? Data(contentsOf: fileUrl),
                  let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: [String: Any]] else {
                console.error("container_style: json parse failed")
                return nil
            }
            
            self.mapper = {
                var result: [String: DTB.ContainerStyle] = [:]
                dict.forEach { key, value in
                    guard let style = ContainerStyle(dict: value) else {
                        console.error("container_style: invalid value for key=\(key)")
                        return
                    }
                    result[key] = style
                }
                return result
            }()
        }
    }
}
