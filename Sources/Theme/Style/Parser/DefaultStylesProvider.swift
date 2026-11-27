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
        
        /// { "json_file_name": { "key": "value" } }（示例/调试器可直接读取解析后的 style）
        private(set) var mapper: [String: [String: Any]] = [:]
        
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

        public func createLabelStyle(_ param: Any?) -> DTB.LabelStyle? {
            guard let key = param as? String else { return nil }
            return mapper["label_style"]?[key] as? DTB.LabelStyle
        }

        public func reloadData() {
            // style 之间有依赖，注意解析顺序
            [
                "shape_style",
                "gradient_style",
                "container_style",
                "text_style",
                "button_style",
                "label_style"
            ].forEach { fileName in
                // 尾→头遍历：默认主题包先填，业务 bundle 覆盖
                var merged: [String: [String: Any]] = [:]
                for bundle in ThemeManager.shared.bundles.reversed() {
                    guard let fileUrl = bundle.url(forResource: fileName, withExtension: "json") else {
                        continue
                    }
                    guard let data = try? Data(contentsOf: fileUrl),
                          let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: [String: Any]] else {
                        console.error("\(fileName): json parse failed")
                        continue
                    }
                    merged.merge(dict) { _, new in new }
                }

                switch fileName {
                case "shape_style":
                    mapper[fileName] = merged.compactMapValues({ DTB.ShapeStyle.style($0) })
                case "gradient_style":
                    mapper[fileName] = merged.compactMapValues({ DTB.GradientStyle.style($0) })
                case "container_style":
                    mapper[fileName] = merged.compactMapValues({ DTB.ContainerStyle.style($0) })
                case "text_style":
                    mapper[fileName] = merged.compactMapValues({ DTB.TextStyle.style($0) })
                case "button_style":
                    mapper[fileName] = merged.compactMapValues({ DTB.ButtonStyle.style($0) })
                case "label_style":
                    mapper[fileName] = merged.compactMapValues({ DTB.LabelStyle.style($0) })
                default:
                    console.error("\(fileName): json mapper not handle")
                }
            }
        }
    }
}

extension DTB.ShapeStyle {

    public static func style(_ param: Any?) -> DTB.ShapeStyle? {
        if let style = param as? DTB.ShapeStyle {
            return style
        }
        if let result = DTB.app.get(DTB.Providers.stylesKey)?.createShapeStyle(param) {
            return result
        }
        guard let dict = param as? [String: Any] else { return nil }
        return DTB.ShapeStyle(
            corners: DTB.any.rectCorner(dict["corners"]),
            radius: DTB.CornerRadiusStyle.parse(dict["radius"]),
            fillColor: UIColor.dtb.create(nullable: dict["fillColor"]),
            strokeColor: UIColor.dtb.create(nullable: dict["strokeColor"]),
            strokeStart: DTB.any.cgFloat(dict["strokeStart"]),
            strokeEnd: DTB.any.cgFloat(dict["strokeEnd"]),
            lineWidth: DTB.any.cgFloat(dict["lineWidth"]),
            miterLimit: DTB.any.cgFloat(dict["miterLimit"]),
            fillRule: DTB.any.fillRule(dict["fillRule"]),
            lineCap: DTB.any.lineCap(dict["lineCap"]),
            lineJoin: DTB.any.lineJoin(dict["lineJoin"]),
            lineDashPhase: DTB.any.cgFloat(dict["lineDashPhase"]),
            lineDashPattern: dict["lineDashPattern"] as? [NSNumber]
        )
    }
}

extension DTB.GradientStyle {

    public static func style(_ param: Any?) -> DTB.GradientStyle? {
        if let style = param as? DTB.GradientStyle {
            return style
        }
        if let result = DTB.app.get(DTB.Providers.stylesKey)?.createGradientStyle(param) {
            return result
        }
        guard let dict = param as? [String: Any] else { return nil }
        var startPoint: CGPoint?
        if let value = dict["startPoint"] as? [String: Any],
           let x = DTB.any.double(value["x"]),
           let y = DTB.any.double(value["y"]) {
            startPoint = CGPoint(x: x, y: y)
        }
        var endPoint: CGPoint?
        if let value = dict["endPoint"] as? [String: Any],
           let x = DTB.any.double(value["x"]),
           let y = DTB.any.double(value["y"]) {
            endPoint = CGPoint(x: x, y: y)
        }
        return DTB.GradientStyle(
            shapeMask: DTB.ShapeStyle.style(dict["shapeMask"]),
            colors: (dict["colors"] as? [Any])?.compactMap({ UIColor.dtb.create(nullable: $0)?.cgColor }),
            locations: dict["locations"] as? [NSNumber],
            startPoint: startPoint,
            endPoint: endPoint,
            type: DTB.any.gradientLayerType(dict["type"])
        )
    }
}

extension DTB.TextStyle {

    public static func style(_ param: Any?) -> DTB.TextStyle? {
        if let style = param as? DTB.TextStyle {
            return style
        }
        if let result = DTB.app.get(DTB.Providers.stylesKey)?.createTextStyle(param) {
            return result
        }
        guard let dict = param as? [String: Any] else { return nil }
        return DTB.TextStyle(
            font: UIFont.dtb.create(dict["font"]),
            textColor: UIColor.dtb.create(dict["textColor"])
        )
    }
}

extension DTB.ContainerStyle {

    public static func style(_ param: Any?) -> DTB.ContainerStyle? {
        if let style = param as? DTB.ContainerStyle {
            return style
        }
        if let result = DTB.app.get(DTB.Providers.stylesKey)?.createContainerStyle(param) {
            return result
        }
        guard let dict = param as? [String: Any] else { return nil }
        return DTB.ContainerStyle(
            margin: DTB.any.uiEdgeInsets(dict["margin"]),
            padding: DTB.any.uiEdgeInsets(dict["padding"]),
            backgroundColor: UIColor.dtb.create(nullable: dict["backgroundColor"]),
            shape: DTB.ShapeStyle.style(dict["shape"]),
            gradient: DTB.GradientStyle.style(dict["gradient"])
        )
    }
}

extension DTB.ButtonStyle {

    public static func style(_ param: Any?) -> DTB.ButtonStyle? {
        if let style = param as? DTB.ButtonStyle {
            return style
        }
        if let result = DTB.app.get(DTB.Providers.stylesKey)?.createButtonStyle(param) {
            return result
        }
        guard let dict = param as? [String: Any] else { return nil }
        return DTB.ButtonStyle(
            backgroundColor: UIColor.dtb.create(nullable: dict["backgroundColor"]),
            contentEdgeInsets: parseEdgeInsets(dict, keys: ["contentEdgeInsets", "padding"]),
            title: dict["title"] as? String,
            textColor: dict["textColor"] == nil ? nil : UIColor.dtb.create(dict["textColor"]),
            font: dict["font"] == nil ? nil : UIFont.dtb.create(dict["font"]),
            attributedText: nil,
            image: UIImage.dtb.create(dict["image"]),
            tintColor: UIColor.dtb.create(nullable: dict["tintColor"]),
            imageSize: DTB.any.cgSize(dict["imageSize"]),
            imageDirection: DTB.FourDirection(rawValue: (dict["imageDirection"] as? String) ?? ""),
            imageOffset: DTB.any.cgVector(dict["imageOffset"]),
            shape: DTB.ShapeStyle.style(dict["shape"]),
            gradient: DTB.GradientStyle.style(dict["gradient"])
        )
    }
}

extension DTB.LabelStyle {

    public static func style(_ param: Any?) -> DTB.LabelStyle? {
        if let style = param as? DTB.LabelStyle {
            return style
        }
        if let result = DTB.app.get(DTB.Providers.stylesKey)?.createLabelStyle(param) {
            return result
        }
        guard let dict = param as? [String: Any] else { return nil }
        return DTB.LabelStyle(
            backgroundColor: UIColor.dtb.create(nullable: dict["backgroundColor"]),
            contentEdgeInsets: parseEdgeInsets(dict, keys: ["contentEdgeInsets", "padding"]),
            textColor: dict["textColor"] == nil ? nil : UIColor.dtb.create(dict["textColor"]),
            font: dict["font"] == nil ? nil : UIFont.dtb.create(dict["font"]),
            numberOfLines: DTB.any.int(dict["numberOfLines"]),
            textAlignment: DTB.any.textAlignment(dict["textAlignment"]),
            shape: DTB.ShapeStyle.style(dict["shape"]),
            gradient: DTB.GradientStyle.style(dict["gradient"])
        )
    }
}

extension DTB.CornerRadiusStyle {

    static func parse(_ value: Any?) -> DTB.CornerRadiusStyle? {
        if let value = value as? DTB.CornerRadiusStyle {
            return value
        }
        if let number = DTB.any.cgFloat(value) {
            return .fixed(number)
        }
        guard let dict = value as? [String: Any] else { return nil }
        if let fixed = DTB.any.cgFloat(dict["fixed"]) {
            return .fixed(fixed)
        }
        if let widthPercent = DTB.any.cgFloat(dict["widthPercent"]) {
            return .widthPercent(widthPercent)
        }
        if let heightPercent = DTB.any.cgFloat(dict["heightPercent"]) {
            return .heightPercent(heightPercent)
        }
        return nil
    }
}

private func parseEdgeInsets(_ dict: [String: Any], keys: [String]) -> UIEdgeInsets? {
    return keys.compactMap({ DTB.any.uiEdgeInsets(dict[$0]) }).first
}
