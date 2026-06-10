//
//  ShapeStyle.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/26
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// CAShapeLayer
    public struct ShapeStyle: Equatable {
        
        // --- round corner
        
        /// 圆角
        public var corners: UIRectCorner?
        
        /// 对称型圆角
        public var radius: CornerRadiusStyle?
        
        // --- raw
        
        public var path: CGPath?
        
        public var fillColor: UIColor?
        
        public var strokeColor: UIColor?
        
        public var strokeStart: CGFloat?
        
        public var strokeEnd: CGFloat?
        
        public var lineWidth: CGFloat?
        
        public var miterLimit: CGFloat?
        
        public var fillRule: CAShapeLayerFillRule?
        
        public var lineCap: CAShapeLayerLineCap?
        
        public var lineJoin: CAShapeLayerLineJoin?
        
        public var lineDashPhase: CGFloat?
        
        public var lineDashPattern: [NSNumber]?
        
        public init(
            corners: UIRectCorner? = nil,
            radius: CornerRadiusStyle? = nil,
            path: CGPath? = nil,
            fillColor: UIColor? = nil,
            strokeColor: UIColor? = nil,
            strokeStart: CGFloat? = nil,
            strokeEnd: CGFloat? = nil,
            lineWidth: CGFloat? = nil,
            miterLimit: CGFloat? = nil,
            fillRule: CAShapeLayerFillRule? = nil,
            lineCap: CAShapeLayerLineCap? = nil,
            lineJoin: CAShapeLayerLineJoin? = nil,
            lineDashPhase: CGFloat? = nil,
            lineDashPattern: [NSNumber]? = nil
        ) {
            self.corners = corners
            self.radius = radius
            self.path = path
            self.fillColor = fillColor
            self.strokeColor = strokeColor
            self.strokeStart = strokeStart
            self.strokeEnd = strokeEnd
            self.lineWidth = lineWidth
            self.miterLimit = miterLimit
            self.fillRule = fillRule
            self.lineCap = lineCap
            self.lineJoin = lineJoin
            self.lineDashPhase = lineDashPhase
            self.lineDashPattern = lineDashPattern
        }
        
        /// 从字典创建形状样式
        /// 支持键：
        /// - "radius"   : CornerRadiusStyle 的解析格式 (纯数字 or {"fixed":..., "scaledToWidth":..., "scaledToHeight":...})
        /// - "corners"  : 字符串数组如 ["topLeft", "topRight"]，缺省为 .allCorners
        /// - "fillColor"  : hex 字符串
        /// - "strokeColor": hex 字符串
        /// - "lineWidth"  : 数字
        /// - "strokeStart", "strokeEnd", "miterLimit", "lineDashPhase" 等数字
        /// - "lineCap", "lineJoin", "fillRule" 等字符串
        /// - "path" 预留，暂不解析
        public init?(dict: [String: Any]?) {
            guard let dict = dict else { return nil }
            
            // CGPath 通常不从 JSON 构建，置 nil
            self.path = nil
            
            // 圆角
            self.radius = DTB.CornerRadiusStyle(param: dict["radius"])
            
            // 圆角位置
            self.corners = {
                if let cornersRaw = dict["corners"] as? [String] {
                    return Self.parseCorners(cornersRaw)
                }
                return nil
            }()
            
            // 填充色
            self.fillColor = .dtb.create(dict["fillColor"])
            
            // 描边色
            self.strokeColor = .dtb.create(dict["strokeColor"])
            
            // 线宽
            self.lineWidth = dict["lineWidth"] as? CGFloat
            
            // 其他 CAShapeLayer 属性
            self.strokeStart = dict["strokeStart"] as? CGFloat
            self.strokeEnd = dict["strokeEnd"] as? CGFloat
            self.miterLimit = dict["miterLimit"] as? CGFloat
            self.lineDashPhase = dict["lineDashPhase"] as? CGFloat
            self.lineDashPattern = (dict["lineDashPattern"] as? [NSNumber])
            
            // 枚举类型
            self.fillRule = Self.parseFillRule(dict["fillRule"] as? String)
            self.lineCap = Self.parseLineCap(dict["lineCap"] as? String)
            self.lineJoin = Self.parseLineJoin(dict["lineJoin"] as? String)
        }
        
        
        private static func parseCorners(_ strings: [String]) -> UIRectCorner {
            var corners: UIRectCorner = []
            for s in strings {
                switch s.lowercased() {
                case "topleft":      corners.insert(.topLeft)
                case "topright":     corners.insert(.topRight)
                case "bottomleft":   corners.insert(.bottomLeft)
                case "bottomright":  corners.insert(.bottomRight)
                case "all":          return .allCorners
                case "allcorners":   return .allCorners
                default: break
                }
            }
            return corners.isEmpty ? .allCorners : corners
        }
        
        private static func parseFillRule(_ raw: String?) -> CAShapeLayerFillRule? {
            switch raw?.lowercased() ?? "" {
            case "nonzero": return .nonZero
            case "evenodd": return .evenOdd
            default: return nil
            }
        }
        
        private static func parseLineCap(_ raw: String?) -> CAShapeLayerLineCap? {
            switch raw?.lowercased() ?? "" {
            case "butt":   return .butt
            case "round":  return .round
            case "square": return .square
            default: return nil
            }
        }
        
        private static func parseLineJoin(_ raw: String?) -> CAShapeLayerLineJoin? {
            switch raw?.lowercased() ?? "" {
            case "miter": return .miter
            case "round": return .round
            case "bevel": return .bevel
            default: return nil
            }
        }
        
    }
}
