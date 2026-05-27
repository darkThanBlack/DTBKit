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
        
        /// view.height * [0, 1]
        public var radiusHeightPrecent: CGFloat?
        
        public var corners: UIRectCorner?
        
        public var radius: CGFloat?
        
        public var fillColor: UIColor?
        
        public var strokeColor: UIColor?
        
        public var strokeStart: CGFloat = 0.0
        
        public var strokeEnd: CGFloat = 1.0
        
        public var lineWidth: CGFloat = 0.0
        
        public var miterLimit: CGFloat = 10.0
        
        public var fillRule: CAShapeLayerFillRule = .nonZero
        
        public var lineCap: CAShapeLayerLineCap = .round
        
        public var lineJoin: CAShapeLayerLineJoin = .round
        
        public var lineDashPhase: CGFloat = 0.0
        
        public var lineDashPattern: [NSNumber]? = nil
        
        public init(
            radiusHeightPrecent: CGFloat? = nil,
            corners: UIRectCorner? = nil,
            radius: CGFloat? = nil,
            fillColor: UIColor? = nil,
            strokeColor: UIColor? = nil,
            strokeStart: CGFloat = 0.0,
            strokeEnd: CGFloat = 1.0,
            lineWidth: CGFloat = 0.0,
            miterLimit: CGFloat = 10.0,
            fillRule: CAShapeLayerFillRule = .nonZero,
            lineCap: CAShapeLayerLineCap = .round,
            lineJoin: CAShapeLayerLineJoin = .round,
            lineDashPhase: CGFloat = 0.0,
            lineDashPattern: [NSNumber]? = nil
        ) {
            self.radiusHeightPrecent = radiusHeightPrecent
            self.corners = corners
            self.radius = radius
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
