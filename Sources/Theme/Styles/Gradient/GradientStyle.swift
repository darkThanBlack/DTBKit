//
//  GradientStyle.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/9
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// CAGradientLayer
    public struct GradientStyle: Equatable {
        
        // --- mask
        
        public var shapeMask: DTB.ShapeStyle?
        
        // --- raw
        
        public var colors: [CGColor]?
        
        public var locations: [NSNumber]?
        
        public var startPoint: CGPoint?
        
        public var endPoint: CGPoint?
        
        public var type: CAGradientLayerType?
        
        public init(
            shapeMask: DTB.ShapeStyle? = nil,
            colors: [CGColor]? = nil,
            locations: [NSNumber]? = nil,
            startPoint: CGPoint? = nil,
            endPoint: CGPoint? = nil,
            type: CAGradientLayerType? = nil
        ) {
            self.shapeMask = shapeMask
            self.colors = colors
            self.locations = locations
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.type = type
        }
        
        /// Simple replacement for .dtb.create
        public static func style(_ param: Any?) -> DTB.GradientStyle? {
            if let p = DTB.app.get(DTB.Providers.stylesKey), let style = p.createGradientStyle(param) {
                return style
            }
            if let dict = param as? [String: Any], let style = DTB.GradientStyle(dict: dict) {
                return style
            }
            return nil
        }
        
        public init?(dict: [String: Any]?) {
            guard let dict = dict else { return nil }
            
            self.shapeMask = .style(dict["shapeMask"])
            
            self.colors = {
                if let list = dict["colors"] as? [Any] {
                    return list.compactMap({ UIColor.dtb.create(nullable: $0)?.cgColor })
                }
                return nil
            }()
            
            self.locations = dict["locations"] as? [NSNumber]
            
            if let spDict = dict["startPoint"] as? [String: CGFloat],
               let x = spDict["x"], let y = spDict["y"] {
                self.startPoint = CGPoint(x: x, y: y)
            }
            if let epDict = dict["endPoint"] as? [String: CGFloat],
               let x = epDict["x"], let y = epDict["y"] {
                self.endPoint = CGPoint(x: x, y: y)
            }
            
            if let raw = dict["type"] as? String {
                self.type = Self.parseLayerType(raw)
            }
        }
        
        private static func parseLayerType(_ raw: String?) -> CAGradientLayerType? {
            switch raw?.lowercased() ?? "" {
            case "axial": return .axial
            case "radial": return .radial
            case "conic": return .conic
            default: return nil
            }
        }
        
    }
}
