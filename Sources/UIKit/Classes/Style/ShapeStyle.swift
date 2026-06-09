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
    }
}
