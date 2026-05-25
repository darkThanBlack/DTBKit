//
//  ShapeView.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    public protocol ShapeUI {
        
        var corners: UIRectCorner? { get }
        
        var radii: CGFloat? { get }
        
        var fillColor: UIColor? { get }
        
        var strokeColor: UIColor? { get }
        
        var strokeStart: CGFloat { get }
        
        var strokeEnd: CGFloat  { get }
        
        var lineWidth: CGFloat  { get }
        
        var miterLimit: CGFloat  { get }
        
        var fillRule: CAShapeLayerFillRule { get }
        
        var lineCap: CAShapeLayerLineCap { get }
        
        var lineJoin: CAShapeLayerLineJoin { get }
        
        var lineDashPhase: CGFloat { get }
        
        var lineDashPattern: [NSNumber]? { get }
    }
    
    ///
    public struct ShapeConfig: ShapeUI {
        
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
        
        public init(ui: ShapeUI) {
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
        
        public init(
            corners: UIRectCorner? = nil,
            radii: CGFloat? = nil,
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
    }
    
    /// view with simple CAShapeLayer
    @objc(DTBShapeView)
    public final class ShapeView: BaseView {
        
        private var config: ShapeUI? = nil
        
        public func update(_ value: ShapeUI?) {
            guard let v = value else {
                shape.isHidden = true
                return
            }
            self.config = v
            shape.isHidden = false
            
            shape.fillColor = v.fillColor?.cgColor
            shape.fillRule = v.fillRule
            shape.strokeColor = v.strokeColor?.cgColor
            shape.strokeStart = v.strokeStart
            shape.strokeEnd = v.strokeEnd
            shape.lineWidth = v.lineWidth
            shape.miterLimit = v.miterLimit
            shape.lineCap = v.lineCap
            shape.lineJoin = v.lineJoin
            shape.lineDashPhase = v.lineDashPhase
            shape.lineDashPattern = v.lineDashPattern
            
            setNeedsLayout()
        }
        
        ///
        private lazy var shape: CAShapeLayer = {
            let shape = CAShapeLayer()
            shape.isHidden = true
            return shape
        }()
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            layer.addSublayer(shape)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            guard bounds.isEmpty == false else {
                return
            }
            guard shape.isHidden == false else {
                return
            }
            
            if let corners = config?.corners, let radii = config?.radii {
                let path = UIBezierPath(
                    roundedRect: bounds,
                    byRoundingCorners: corners,
                    cornerRadii: CGSize(
                        width: radii,
                        height: radii
                    )
                )
                shape.path = path.cgPath
            }
        }
    }
    
}
