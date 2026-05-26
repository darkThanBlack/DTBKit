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
    
    /// Mirror params for CAShapeLayer
    public struct ShapeStyle: ShapeUI {
        
        public var corners: UIRectCorner?
        
        public var radii: CGFloat?
        
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
            corners: UIRectCorner? = [.allCorners],
            radii: CGFloat? = 8.0,
            fillColor: UIColor? = .white,
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
            self.corners = corners
            self.radii = radii
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
        
        public mutating func update(_ ui: ShapeUI?) {
            guard let ui = ui else { return }
            self.corners =          ui.corners
            self.radii =            ui.radii
            self.fillColor =        ui.fillColor
            self.strokeColor =      ui.strokeColor
            self.strokeStart =      ui.strokeStart
            self.strokeEnd =        ui.strokeEnd
            self.lineWidth =        ui.lineWidth
            self.miterLimit =       ui.miterLimit
            self.fillRule =         ui.fillRule
            self.lineCap =          ui.lineCap
            self.lineJoin =         ui.lineJoin
            self.lineDashPhase =    ui.lineDashPhase
            self.lineDashPattern =  ui.lineDashPattern
        }
    }
}
