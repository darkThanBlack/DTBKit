//
//  DefaultStylesProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/8/8
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// 偏业务的 style 放在一起
    public final class DefaultStylesProvider: DTB.Providers.StylesProvider {
        
        public static let shared = DefaultStylesProvider()
        
        private init() {}
        
        /// { "json_file_name": { "key": "value" } }
        private var mapper: [String: [String: Any]] = [:]
        
        public func createShapeStyle(_ param: Any?) -> DTB.ShapeStyle? {
            guard let key = param as? String else { return nil }
            return mapper["shape_style"]?[key] as? DTB.ShapeStyle
        }
        
        public func createGradientStyle(_ param: Any?) -> DTB.GradientStyle? {
            guard let key = param as? String else { return nil }
            return mapper["gradient_style"]?[key] as? DTB.GradientStyle
        }
        
        public func createTextStyle(_ param: Any?) -> DTB.TextStyle? {
            guard let key = param as? String else { return nil }
            return mapper["text_style"]?[key] as? DTB.TextStyle
        }
        
        public func createContainerStyle(_ param: Any?) -> DTB.ContainerStyle? {
            guard let key = param as? String else { return nil }
            return mapper["container_style"]?[key] as? DTB.ContainerStyle
        }
        
        public func createButtonStyle(_ param: Any?) -> DTB.ButtonStyle? {
            guard let key = param as? String else { return nil }
            return mapper["button_style"]?[key] as? DTB.ButtonStyle
        }
        
        public func reloadData() {
            // style 之间有依赖，注意解析顺序
            [
                "shape_style",
                "gradient_style",
                "container_style",
                "text_style",
                "button_style"
            ].forEach { fileName in
                guard let fileUrl = ThemeManager.shared.currentBundle.url(forResource: fileName, withExtension: "json") else {
                    console.error("\(fileName): json file not found")
                    return
                }
                guard let data = try? Data(contentsOf: fileUrl),
                      let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: [String: Any]] else {
                    console.error("\(fileName): json parse failed")
                    return
                }
                
                switch fileName {
                case "shape_style":
                    mapper[fileName] = dict.compactMapValues({ ShapeStyle(dict: $0) })
                case "gradient_style":
                    mapper[fileName] = dict.compactMapValues({ GradientStyle(dict: $0) })
                case "container_style":
                    mapper[fileName] = dict.compactMapValues({ ContainerStyle(dict: $0) })
                case "text_style":
                    mapper[fileName] = dict.compactMapValues({ TextStyle(dict: $0) })
                case "button_style":
                    mapper[fileName] = dict.compactMapValues({ ButtonStyle(dict: $0) })
                default:
                    console.error("\(fileName): json mapper not handle")
                }
            }
        }
    }
    
}
