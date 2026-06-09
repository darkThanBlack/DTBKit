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
        
        public var shape: DTB.ShapeStyle?
        
        // --- raw
        
        public var colors: [CGColor]?
        
        public var locations: [NSNumber]?
        
        public var startPoint: CGPoint?
        
        public var endPoint: CGPoint?
        
        public var type: CAGradientLayerType?
        
        public init(
            shape: DTB.ShapeStyle? = nil,
            colors: [CGColor]? = nil,
            locations: [NSNumber]? = nil,
            startPoint: CGPoint? = nil,
            endPoint: CGPoint? = nil,
            type: CAGradientLayerType? = nil
        ) {
            self.shape = shape
            self.colors = colors
            self.locations = locations
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.type = type
        }
    }
}
