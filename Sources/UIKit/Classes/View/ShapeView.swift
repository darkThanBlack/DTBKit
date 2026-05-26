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
    
    /// view with simple CAShapeLayer
    @objc(DTBShapeView)
    public final class ShapeView: BaseView {
        
        private var config: ShapeUI? = nil
        
        public func update(_ value: ShapeUI?) {
            guard let ui = value else {
                shape.isHidden = true
                return
            }
            self.config = ui
            shape.isHidden = false
            
            shape.fillColor =       ui.fillColor?.cgColor
            shape.fillRule =        ui.fillRule
            shape.strokeColor =     ui.strokeColor?.cgColor
            shape.strokeStart =     ui.strokeStart
            shape.strokeEnd =       ui.strokeEnd
            shape.lineWidth =       ui.lineWidth
            shape.miterLimit =      ui.miterLimit
            shape.lineCap =         ui.lineCap
            shape.lineJoin =        ui.lineJoin
            shape.lineDashPhase =   ui.lineDashPhase
            shape.lineDashPattern = ui.lineDashPattern
            
            lazyFire(.onLayoutSubviews) { v in
                guard let me = v as? Self else { return }
                let path: UIBezierPath? = {
                    if let corners = ui.corners, let radii = ui.radii {
                        return UIBezierPath(
                            roundedRect: me.bounds,
                            byRoundingCorners: corners,
                            cornerRadii: CGSize(
                                width: radii,
                                height: radii
                            )
                        )
                    }
                    return nil
                }()
                me.shape.path = path?.cgPath
            }
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
    }
    
}
